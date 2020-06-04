1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=prometheus-mysql-exporter,release=prometheus-mysql-exporter-1591214684" -o jsonpath="{.items[0].metadata.name}")
  kubectl port-forward $POD_NAME 8080:9104
  echo "Visit http://127.0.0.1:8080 to use your application"