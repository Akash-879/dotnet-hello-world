pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO = 'akash879/hello-world-api'
        AWS_EC2_IP = "${params.UAT_EC2_IP}" 
        SSH_KEY = credentials('sss-credentials') 
        DOCKER_HUB_CREDENTIALS = credentials('docker-credentials')
        AWS_CREDENTIALS = credentials('aws-credentials') 
    }
    parameters {
        string(name: 'UAT_EC2_IP', defaultValue: '', description: 'UAT EC2 instance IP') 
    }
    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/akash-879/dotnet-hello-world', branch: 'master'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'DOCKER_HUB_CREDENTIALS') {
                        def appImage = docker.build("${env.DOCKER_HUB_REPO}:latest") 
                        appImage.push()
                    }
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                script {
                    sh """
                    ssh -i ${SSH_KEY} ubuntu@${AWS_EC2_IP} << EOF
                        docker pull ${env.DOCKER_HUB_REPO}:latest
                        docker run -d -p 5000:5000 --name hello-world-api ${env.DOCKER_HUB_REPO}:latest 
                    EOF     
                     """
                }
            }
        }
    }
    post {
        success {
            echo "Deployment successful!" 
        }
        failure {
            echo "Deployment failed!"
        }
    }
}