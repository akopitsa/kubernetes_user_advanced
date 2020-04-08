<#
 .SYNOPSIS
    Deploys a template to Azure

 .DESCRIPTION
    Deploys an Azure Resource Manager template

 .PARAMETER subscriptionId
    The subscription id where the template will be deployed.

 .PARAMETER resourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER resourceGroupLocation
    Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.  

 .PARAMETER deploymentName
    The deployment name.

 .PARAMETER templateFilePath
    Optional, path to the template file. Defaults to template.json.

 .PARAMETER parameterFilePath
    Optional, path to the parameter file. Defaults to parameter.json. If file is not found, will prompt for parameter values based on template.
#>

param(
    [Parameter(Mandatory = $False)]
    [string]
    $subscriptionId = '562e1333-535e-453c-8266-ae70b5c527d3',
 
    [Parameter(Mandatory = $False)]
    [string]
    $tenantId = '8ac76c91-e7f1-41ff-a89c-3553b2da2c17',
	
	[string] [Parameter(Mandatory=$True)] 
	[ValidateSet('dev','int','qa', 'stage', 'perf', 'k8s')] 
    $env,

    [Parameter(Mandatory=$False)] 
    [string]
    $resourceGroupLocation = 'eastus2',

    [Parameter(Mandatory = $false)]
    [string]
    $resourceGroupName = 'rg-wkh-ps-'+ $env + '-' + $resourceGroupLocation.ToLower(),

    [Parameter(Mandatory = $False)]
    [string]
    $deploymentName = "singleDeployment",

    [string]
    $loginUN = '',

    [string]
    $loginPW = '',

    [string]
    $templateFilePath = "master.json",

    [string]
    $parameterFilePath = "master.parameter.json",
    [switch] $ValidateOnly,
    [string] [Parameter(Mandatory = $False)] $keyVaultName = 'kv-ps-' + $env,
    [string] [Parameter(Mandatory = $False)] $jobName = 'CertificateAdding',


    [string] [Parameter(Mandatory = $False)] $backupName = 'devasfrainier',
    [string] [Parameter(Mandatory = $False)] $backupPath = '..\..\..\AzureCerts\' + $backupName,
    [string] [Parameter(Mandatory = $False)] $certName = 'devasfrainier',
    [string] [Parameter(Mandatory = $False)] $vaultId = '/subscriptions/' + $subscriptionId + '/resourceGroups/' + $ResourceGroupName + '/providers/Microsoft.KeyVault/vaults/' + $keyVaultName
    <#  HACK : Needs to add secretValue in background

    [string] $secretNameForCouchBasePassword = 'couchBasePassword',

    [String] [Parameter(Mandatory = $true)] $secretForCouchBase #>
)

<#
.SYNOPSIS
    Registers RPs
#>
Function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Host "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzureRmResourceProvider -ProviderNamespace $ResourceProviderNamespace ;
}

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

Write-Host "::::parameters to the script::::"
Write-Host "subscriptionId = $subscriptionId"
Write-Host "tenantId = $tenantId"
Write-Host "resourceGroupName = $resourceGroupName"
Write-Host "resourceGroupLocation = $resourceGroupLocation"
Write-Host "deploymentName = $deploymentName"
#Write-Host "loginUN = $loginUN"
#Write-Host "loginPW = $loginPW"
Write-Host "templateFilePath = $templateFilePath"
Write-Host "parameterFilePath = $parameterFilePath"

# sign in
#$accountName =$loginUN
#$password = ConvertTo-SecureString $loginPW -AsPlainText -Force
#$credential = New-Object System.Management.Automation.PSCredential($accountName, $password)
$loginRequired = Get-AzContext | Select-Object -ExpandProperty Account
if ($loginRequired -eq $null) {
    Write-Host "Logging in..." -ForegroundColor Yellow;
    Connect-AzAccount;
}
else {
    Write-Host "Already logged in. Continuing..." -ForegroundColor Green;
}

# select subscription
Write-Host "Selecting subscription '$subscriptionId'";
Select-AzSubscription -SubscriptionID $subscriptionId -TenantId $tenantId;
$fileLocation = Get-Location
# Import-Module 

# Register RPs
# $resourceProviders = @("microsoft.compute", "microsoft.network", "microsoft.storage");
# if ($resourceProviders.length) {
    # Write-Host "Registering resource providers"
    # foreach ($resourceProvider in $resourceProviders) {
        # RegisterRP($resourceProvider);
    # }
# }

#Create or check for existing resource group
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue 
if (!$resourceGroup) {
    Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
    if (!$resourceGroupLocation) {
        $resourceGroupLocation = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$resourceGroupName' in location '$resourceGroupLocation'";
    New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
}
else {
    Write-Host "Using existing resource group '$resourceGroupName'";
}

$templatefilename = Split-Path -Path $templateFilePath -Leaf -Resolve
# Start the deployment
$deploymentNameTimestamp = $deploymentName + '-' + [IO.Path]::GetFileNameWithoutExtension($templatefilename) + '-' + (Get-Date).ToUniversalTime().ToString("yyyyMMddhhmm")
Write-Host "Starting deployment '$deploymentNameTimestamp'...";
try {
    if ($ValidateOnly) {
        $ErrorMessages = Format-ValidationOutput (Test-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                                                                                      -TemplateFile $templateFilePath `
                                                                                      -TemplateParameterFile $parameterFilePath `
                                                                                      @OptionalParameters)
        if ($ErrorMessages) {
            Write-Output '', 'Validation returned the following errors:', @($ErrorMessages), '', 'Template is invalid.'
        }
        else {
            Write-Output '', 'Template is valid.'
        }
    } else {
        if (Test-Path $parameterFilePath) {

            
            Enable-AzContextAutosave
            Start-Job -Name $jobName -ScriptBlock {
                param ($context, $keyVaultName, $certName, $backupPath, $vaultId, $ResourceGroupName, $fileLocation, $env)
                Set-Location $fileLocation
                $api = Get-AzResource -ResourceType "Microsoft.KeyVault/vaults" -ResourceGroupName $ResourceGroupName -ResourceName $keyVaultName  -AzContext $context -ErrorAction SilentlyContinue
                if ($api.Properties.provisioningState -eq 'Succeeded') {
                    if (Get-AzKeyVaultCertificate -VaultName $keyVaultName -Name $certName -AzContext $context) {
                        exit
                    }
                    else {
                        Restore-AzKeyVaultCertificate -VaultName $keyVaultName -InputFile $backupPath -AzContext $context
                    }
                }
                else {
                    while ($api.Properties.provisioningState -ne 'Succeeded') {
                        Start-Sleep 25
                        Write-Host "Certificate '$certName' is deploying"
                        $api = Get-AzResource -ResourceType "Microsoft.KeyVault/vaults" -ResourceGroupName $ResourceGroupName -ResourceName $keyVaultName -ErrorAction SilentlyContinue -AzContext $context
                    }
                    Restore-AzKeyVaultCertificate -VaultName $keyVaultName -InputFile $backupPath -AzContext $context
                }
            } -ArgumentList ((Get-AzContext), $keyVaultName, $certName, $backupPath, $vaultId, $ResourceGroupName, $fileLocation, $env)
            
            New-AzResourceGroupDeployment -Name $deploymentNameTimestamp -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parameterFilePath -Mode Incremental -DeploymentDebugLogLevel All -Verbose -ErrorAction Stop;
        }
        else {
            New-AzResourceGroupDeployment -Name $deploymentNameTimestamp -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -ErrorAction Stop;
        }
}
}
catch {
    write-host "Exception occured while Deploying ARM template" + $_.Exception.Message 
    write-host $_.Exception
    exit 1
}

receive-job $jobName
Start-Sleep 5
Stop-Job $jobName
Remove-Job $jobName
