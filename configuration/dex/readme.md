# helm install cert-manager --namespace kube-system jetstack/cert-manager --version v0.14.2

kubectl create secret tls dex.k8s.24may.link.tls --cert=ssl/cert.pem --key=ssl/key.pem

Client ID
    999944081532c6091333

Client Secret
    c2ba071bf5f92c1958253ce27509dd2a9c7c0ff2



kubectl create secret \
    generic github-client \
    --from-literal=client-id=$GITHUB_CLIENT_ID \
    --from-literal=client-secret=$GITHUB_CLIENT_SECRET



    ./bin/example-app --issuer https://dex.k8s.24may.link:32000 --issuer-root-ca ssl/ca.pem









kubectl config set-credentials andrey \
   --auth-provider=oidc \
   --auth-provider-arg=idp-issuer-url=https://dex.k8s.24may.link:32000/ \
   --auth-provider-arg=client-id=example-app \
   --auth-provider-arg=client-secret=c2ba071bf5f92c1958253ce27509dd2a9c7c0ff2 \
   --auth-provider-arg=refresh-token=Chl2d3VtNG9rN3Nva3M1a3U3YnpwYzZpY2RiEhlob25oczZqdnNpYTRqbTRiazVja25uaWRi \
   --auth-provider-arg=idp-certificate-authority=/home/wksearch/ssl/ca.pem \
   --auth-provider-arg=id-token=eyJhbGciOiJSUzI1NiIsImtpZCI6ImEwODQ1ZWY1OGQ0OGE2ZjIxYmU1NWMzZmUzMjkyOGQ5MTA2NjRjOWYifQ.eyJpc3MiOiJodHRwczovL2RleC5rOHMuMjRtYXkubGluazozMjAwMCIsInN1YiI6IkNnYzVOalU0TmpFNUVnWm5hWFJvZFdJIiwiYXVkIjoiZXhhbXBsZS1hcHAiLCJleHAiOjE1ODc1Nzk4OTEsImlhdCI6MTU4NzQ5MzQ5MSwiYXRfaGFzaCI6IjFUdnI3ZER1UkVGZlpBSnpwX3ExcmciLCJlbWFpbCI6ImFuZHJleS5rb3BpdHNhQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoiQW5kcmV5IEtvcGl0c2EifQ.AClEierE5wHg7U1Sr0NfKf7t32RzIDT5jgAReLGT0ieYjKOF5ny4LYzK_R-VwSDE4AHgcMFXCREEX8c8izOcxYY9xOVfjPT6ZC5CJzhO169Dtch3SzGVSgwUYa0PaoBQ81dli_MRNFPkEFKs_emSDMHZO_DzQQgiCfpPDxxFv_EHovJgc8hbQ9OsDxc87IuJA27Fr2uFhMixOxZ2sJEXdgb82CRSkne6jEc5eXIQ3eFshvjuOzj-5GmSGIDxM1rXSWHIz4XYPKxLFqN1UylqYIfBrGgqZsB6eujyKof8O-l78Ng7SSAuYcjT5UW8t3e-CrzMQWCIAAf25lBhRJ22fQ