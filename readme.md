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

### VAGRANT KUBESPRAY ###

cp inventory/sample/artifacts/admin.conf ~/.kube/config

kubectl create -f contrib/misc/clusteradmin-rbac.yml
kubectl -n kube-system describe secret kubernetes-dashboard-token | grep 'token:' | grep -o '[^ ]\+$'

kubectl proxy
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login

### HELM ### 


helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo wordpress

helm repo update

helm install cdp-wordpress bitnami/wordpress
helm install cdp-wordpress --set serviceType=NodePort bitnami/wordpress
helm install --set serviceType=NodePort --name wp-k8s stable/wordpress

helm fetch bitnami/wordpress --untar
helm inspect values bitnami/wordpress > wordpress.yaml

kubectl create namespace wordpress
helm install wordpress --namespace wordpress bitnami/wordpress -f wordpress.yaml