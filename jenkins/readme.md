


### Get SA Jenkins

kubectl get secret $(kubectl get sa jenkins -n jenkins -o jsonpath={.secrets[0].name}) -n jenkins -o jsonpath={.data.token} | base64 --decode


### Get CA cert
kubectl get secret $(kubectl get sa jenkins  -o jsonpath={.secrets[0].name})  -o jsonpath={.data.'ca\.crt'} | base64 --decode




kubectl auth can-i get cronjobs -n jenkins --as system:serviceaccount:jenkins:sa


kubectl auth can-i get pod -n jenkins --as system:serviceaccount:jenkins:jenkins




# Create a ServiceAccount named `jenkins-robot` in a given namespace.
$ kubectl -n jenkins create serviceaccount jenkins-robot

# The next line gives `jenkins-robot` administator permissions for this namespace.
# * You can make it an admin over all namespaces by creating a `ClusterRoleBinding` instead of a `RoleBinding`.
# * You can also give it different permissions by binding it to a different `(Cluster)Role`.
$ kubectl -n jenkins create clusterrolebinding  jenkins-robot-binding --clusterrole=cluster-admin --serviceaccount=jenkins:jenkins-robot

# Get the name of the token that was automatically generated for the ServiceAccount `jenkins-robot`.
$ kubectl -n jenkins get serviceaccount jenkins-robot -o go-template --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}'
jenkins-robot-token-d6d8z

# Retrieve the token and decode it using base64.
$ kubectl -n jenkins get secrets jenkins-robot-token-8hztd -o go-template --template '{{index .data "token"}}' | base64 -d


eyJhbGciOiJSUzI1NiIsImtpZCI6Ilh4MFlfdk1MYzBYejR4bjEtM2lSUWlISTliWUFKQVgzaFdrU2pocHZtMTAifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJqZW5raW5zIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtcm9ib3QtdG9rZW4tOGh6dGQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucy1yb2JvdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjUzNjE3Nzc2LTkwMDAtNGM0Yi05NzMwLWUzNzlhYmEyNmU2NyIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpqZW5raW5zOmplbmtpbnMtcm9ib3QifQ.W0sticbV_fQyNEv5Q8E2Q_Q0d_p8Qp4AzlOiv5JMzKmBgDN9LlJ70GvCgRKjT0TFOxuDxivH2-vdv1sqC7hWquF2v9LUNS5AdKBvPxBgChNS2J8WdM9yxE_whqJ-kXIDTeqzDl8ut5ASjI33g-UyCgJWIBc6kQgblyQDyIFNALwCl7S4_3V-JribUKPNfUJ3Me_0Qp1rV6u39eDUDzLadLCk2cf5ivPSCzx6jZ_bflTuGmaOP6kD8jUX3c_ODWoW5rK2Rvuy5goKARkV3JqpPCdayvU7QjhoNEJOsA25JUgx5UrdbUf87lXEWZ8GQKHMxn8HMI1iKb757guNp2Q2qg