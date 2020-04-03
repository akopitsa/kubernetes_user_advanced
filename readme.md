**Install**

brew update && brew install kubectl && brew cask install docker virtualbox && brew install minikube && brew install docker-machine

minikube start
minikube start --driver=virtualbox
minikube start --driver=hyperv


kubectl get deployments nginx-deployment
kubectl describe deployments nginx-deployment

kubectl delete deployment hello-world