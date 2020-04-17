### kubectl Cheat Sheet
https://kubernetes.io/docs/reference/kubectl/cheatsheet/


openssl genrsa -out andrey.pem 2048
openssl req -new -key andrey.pem -out andrey-csr.pem -subj "/CN=andrey/O=myteam/"
openssl x509 -req -in andrey-csr.pem -CA /etc/kubernetes/ssl/ca.crt -CAkey /etc/kubernetes/ssl/ca.key -CAcreateserial -out andrey.crt -days 10000

kubectl config set-credentials andrey --client-certificate=andrey.crt --client-key=andrey.pem
kubectl config set-context andrey --cluster=cluster.local --user andrey

kubectl config get-contexts


kubectl config view
kubectl --kubeconfig ...................
kubectl config use-context

kubectl config current-context                       # display the current-context
kubectl config use-context my-cluster-name           # set the default context to my-cluster-name

# add a new cluster to your kubeconf that supports basic auth
kubectl config set-credentials kubeuser/foo.kubernetes.com --username=kubeuser --password=kubepassword

delete user foo

kubectl config unset users.foo


kubectl create serviceaccount example-sa --namespace mynamespace

https://kubernetes.io/docs/reference/access-authn-authz/rbac/
https://kubernetes.io/blog/2017/10/using-rbac-generally-available-18/


kubectl auth can-i create pods
kubectl auth can-i create pods --as=me

### PSP 


