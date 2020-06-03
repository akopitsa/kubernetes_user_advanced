### Enable CNI on Minikube

minikube start --memory 4096 --network-plugin=cni --extra-config=kubelet.network-plugin=cni --extra-config=kubelet.pod-cidr=192.168.0.0/16 --extra-config=controller-manager.allocate-node-cidrs=true --extra-config=controller-manager.cluster-cidr=192.168.0.0/16 --host-only-cidr=172.17.17.1/24

curl -O -L https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml
sed -i -e '/nodeSelector/d' calico.yaml
sed -i -e '/node-role.kubernetes.io\/master: ""/d' calico.yaml
kubectl apply -f calico.yaml

kubectl -n kube-system set env daemonset/calico-node FELIX_IGNORELOOSERPF=true  



kubectl create secret generic mysql-secrets --from-literal=rootpw=secretpw

apply other yaml files

