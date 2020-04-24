pipeline {
  agent {
    kubernetes {
      label 'promo-app'  // all your pods will be named with this prefix, followed by a unique id
yaml """
apiVersion: v1
kind: Pod
spec:
  containers:  # list of containers that you want present for your build, you can define a default container in the Jenkinsfile
    - name: maven
      image: maven:3.5.4-jdk-8-slim
      command: ["tail", "-f", "/dev/null"]  # this or any command that is bascially a noop is required, this is so that you don't overwrite the entrypoint of the base container
      imagePullPolicy: Always # use cache or pull image for agent
      resources:  # limits the resources your build contaienr
        requests:
          memory: "8Gi"
          cpu: "500m"
        limits:
          memory: "8Gi"
    - name: docker
      image: docker:18.06.1
      command: ["tail", "-f", "/dev/null"]
      imagePullPolicy: Always
      volumeMounts:
        - name: docker
          mountPath: /var/run/docker.sock # We use the k8s host docker engine
  volumes:
    - name: docker
      hostPath:
        path: /var/run/docker.sock
"""
      idleMinutes 5  // how long the pod will live after no jobs have run on it
//      yamlFile 'build-pod.yaml'  // path to the pod definition relative to the root of our project 
      defaultContainer 'maven'  // define a default container if more than a few stages use it, will default to jnlp container
    }
  }
  stages {
    stage('Build') {
      steps {  // no container directive is needed as the maven container is the default
        sh "mvn clean install"   
      }
    }
    stage('Build Docker Image') {
      steps {
        container('docker') {  
          sh "docker build -t vividseats/promo-app:dev ."  // when we run docker in this step, we're running it via a shell on the docker build-pod container, 
          sh "docker push vividseats/promo-app:dev"        // which is just connecting to the host docker deaemon
        }
      }
    }
  }
}
