touch /root/.rnd
openssl genrsa -out andrey.pem 4096

openssl req -new -key andrey.pem -out andrey-csr.pem -subj "/CN=andrey/O=epam/"


openssl x509 -req -in andrey-csr.pem -CA /etc/kubernetes/ssl/ca.crt -CAkey /etc/kubernetes/ssl/ca.key -CAcreateserial -out andrey.crt -days 11000



kubectl config set-credentials andrey --client-certificate=andrey.crt --client-key=andrey.pem

 kubectl config set-context andrey --cluster=k8s.24may.link --user andrey

kubectl config set-context andrey --cluster=k8s.24may.link --user andrey

kubectl config get-contexts
kubectl config set-context andrey --cluster=cluster.local --user andrey


 kubectl config use-context andrey@k8s.24may.link



 



