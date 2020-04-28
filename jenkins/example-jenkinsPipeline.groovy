podTemplate(
    name: 'test-pod',
    label: 'test-pod',
    containers: [
        containerTemplate(name: 'golang', image: 'golang:1.9.4-alpine3.7'),
        containerTemplate(name: 'gcloud', image:'gcr.io/cloud-builders/gcloud'),
    ],
    {
        //node = the pod label
        node('test-pod'){
            //container = the container label
            stage('Build'){
                container('golang'){
                    // This is where we build our code.
                }
            }
            stage('Build Docker Image'){
                container('gcloud'){
                    //This is where we build and push our Docker image.
                }
            }
        }
    }))





podTemplate(
    name: 'test-pod',
    label: 'test-pod',
    containers: [
        containerTemplate(name: 'busybox', image: 'ubuntu:latest')
    ],
    volumes: [
        hostPathVolume(mountPath: '/var/run/docker.sock',
        hostPath: '/var/run/docker.sock'),
    ],
    {    
  node('test-pod') {
    stage('Run shell') {
      container('busybox') {
        sh 'echo hello world'
      }
    }
  }
})


#!/usr/bin/groovy

podTemplate(name: 'test-pod', label: 'test-pod', 
  containers: [
    containerTemplate(
      name: 'jnlp',
      image: 'jenkinsci/jnlp-slave:3.10-1-alpine',
      args: '${computer.jnlpmac} ${computer.name}'
    ),
    containerTemplate(
      name: 'alpine',
      image: 'twistian/alpine:latest',
      command: 'cat',
      ttyEnabled: true
    ),
  ],
  volumes: [ 
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), 
  ]
)
{
  node ('test-pod') {

    stage ('Pull image') { 
      container('alpine') {
        sh 'curl --unix-socket /var/run/docker.sock -X POST "http:/v1.24/images/create?fromImage=nginx:stable-alpine"'
      }
    }


  }
}



#!/usr/bin/groovy

podTemplate(label: 'twistlock-example-builder', // See 1
  containers: [
    containerTemplate(
      name: 'jnlp',
      image: 'jenkinsci/jnlp-slave:3.10-1-alpine',
      args: '${computer.jnlpmac} ${computer.name}'
    ),
    containerTemplate(
      name: 'alpine',
      image: 'twistian/alpine:latest',
      command: 'cat',
      ttyEnabled: true
    ),
  ],
  volumes: [ // See 2
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), // See 3
  ]
)
{
  node ('twistlock-example-builder') {

    stage ('Pull image') { // See 4
      container('alpine') {
        sh """
        curl --unix-socket /var/run/docker.sock \ // See 5
             -X POST "http:/v1.24/images/create?fromImage=nginx:stable-alpine"
        """
      }
    }

    stage ('Prisma Cloud scan') { // See 6
        twistlockScan ca: '',
                    cert: '',
                    compliancePolicy: 'critical',
                    dockerAddress: 'unix:///var/run/docker.sock',
                    gracePeriodDays: 0,
                    ignoreImageBuildTime: true,
                    image: 'nginx:stable-alpine',
                    key: '',
                    logLevel: 'true',
                    policy: 'warn',
                    requirePackageUpdate: false,
                    timeout: 10
    }

    stage ('Prisma Cloud publish') {
        twistlockPublish ca: '',
                    cert: '',
                    dockerAddress: 'unix:///var/run/docker.sock',
                    ignoreImageBuildTime: true,
                    image: 'nginx:stable-alpine',
                    key: '',
                    logLevel: 'true',
                    timeout: 10
    }
  }
}



podTemplate(
    name: 'test-pod',
    label: 'test-pod',
    containers: [
        containerTemplate(name: 'golang', image: 'golang:1.9.4-alpine3.7'),
        containerTemplate(name: 'docker', image:'trion/jenkins-docker-client'),
    ],
    volumes: [
        hostPathVolume(mountPath: '/var/run/docker.sock',
        hostPath: '/var/run/docker.sock'),
    ],
    {
        //node = the pod label
        node('jenkins-slave'){
            //container = the container label
            stage('Build'){
                container('golang'){
                    // This is where we build our code.
                    sh 'echo "Golang"'
                }
            }
            stage('Build Docker Image'){
                container('docker'){
                    // This is where we build the Docker image
                     sh 'echo "Docker"'
                }
            }
            stage('JNLP'){
                container('jnlp'){
                    // This is where we build our code.
                    sh 'echo "jnlp"'
                }
            }
        }
    })


    podTemplate(
    name: 'jenkinsSlave',
    label: 'slave',
    containers: [
        containerTemplate(name: 'golang', image: 'golang:1.9.4-alpine3.7')
    ],
    volumes: [
        hostPathVolume(mountPath: '/var/run/docker.sock',
        hostPath: '/var/run/docker.sock'),
    ],
    {    
  node('jenkins-slave') {
    stage('Run shell') {
      container('jnlp') {
        sh 'hostname'
      }
    }
    stage('Run shell') {
      container(name: 'golang') {
        sh 'hostname'
      }
    }
  }
})


#!/usr/bin/groovy

podTemplate(name: 'test-pod', label: 'test-pod', 
  containers: [
    containerTemplate(
      name: 'jnlp',
      image: 'jenkinsci/jnlp-slave:3.10-1-alpine',
      args: '${computer.jnlpmac} ${computer.name}'
    ),
    containerTemplate(
      name: 'alpine',
      image: 'twistian/alpine:latest',
      command: 'cat',
      ttyEnabled: true
    ),
  ],
  volumes: [ 
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), 
  ]
)
{
  node ('test-pod') {

    stage ('Pull image') { 
      container('alpine') {
        sh 'curl --unix-socket /var/run/docker.sock -X POST "http:/v1.24/images/create?fromImage=nginx:stable-alpine"'
      }
    }


  }
}