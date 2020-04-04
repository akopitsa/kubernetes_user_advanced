**Install**

brew update && brew install kubectl && brew cask install docker virtualbox && brew install minikube && brew install docker-machine

minikube start
minikube start --driver=virtualbox
minikube start --driver=hyperv
minikube addons enable dashboard
minikube addons enable ingress


minikube service nginx-svc --url





kubectl get deployments nginx-deployment
kubectl describe deployments nginx-deployment

kubectl expose deployment nginx-deployment --target-port=80 --type=NodePort
