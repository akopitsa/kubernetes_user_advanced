**Install**

brew update && brew install kubectl && brew cask install docker virtualbox && brew install minikube && brew install docker-machine

minikube start
minikube start --driver=virtualbox
minikube start --driver=hyperv
minikube addons enable dashboard
minikube addons enable ingress

kubectl -n kube-system get all -o wide

minikube service nginx-svc --url

kubectl get deployments nginx-deployment
kubectl describe deployments nginx-deployment

kubectl expose deployment nginx-deployment --target-port=80 --type=NodePort

kubectl create deployment nginx --image=nginx
kubectl create service nodeport nginx --tcp=80:80


### VAGRANT KUBESPRAY ###

cp inventory/sample/artifacts/admin.conf ~/.kube/config

kubectl create -f contrib/misc/clusteradmin-rbac.yml
kubectl -n kube-system describe secret kubernetes-dashboard-token | grep 'token:' | grep -o '[^ ]\+$'

kubectl proxy
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login

### HELM ### 


helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

helm search repo wordpress

helm repo update

helm install cdp-wordpress bitnami/wordpress
helm install cdp-wordpress --set serviceType=NodePort bitnami/wordpress
helm install --set serviceType=NodePort --name wp-k8s stable/wordpress

helm fetch bitnami/wordpress --untar
helm inspect values bitnami/wordpress > wordpress.yaml

kubectl create namespace wordpress
helm install wordpress --namespace wordpress bitnami/wordpress -f wordpress.yaml


kubectl get pod -w -o wide --namespace wordpress

kubectl scale --replicas 3 -n wordpress  deployment/wordpress


kubectl label nodes <your-node-name> disktype=ssd
kubectl label nodes k8s-2 nodename=two

### ChartMuseum

helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm install stable/chartmuseum

helm install mychartmuseum stable/chartmuseum

Get the ChartMuseum URL by running:

  export POD_NAME=$(kubectl get pods --namespace default -l "app=chartmuseum" -l "release=mychartmuseum" -o jsonpath="{.items[0].metadata.name}")
  echo http://127.0.0.1:8080/
  kubectl port-forward $POD_NAME 8080:8080 --namespace default

  helm repo add local http://127.0.0.1:8080/

  helm repo add chartmuseum http://localhost:8080

  helm install incubator/chartmuseum --set env.open.DISABLE_API=false
  
  ## Install Helm Push plugin 
helm plugin install https://github.com/chartmuseum/helm-push.git


  ### Create chart

  helm create mychart

  helm install --dry-run --debug good-puppy ./mychart
  helm install --dry-run --debug --set favoriteDrink=slurm good-puppy ./mychart


  helm repo update
  helm dependency update mymysql/
  helm dependency build petclinic/

  helm push petclinic/ chartmuseum
  