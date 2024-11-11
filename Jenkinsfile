pipeline {
    agent any
    environment {
        // Docker Hub and AWS credentials
        DOCKER_HUB_REPO = 'akash879/hello-world-api'
        AWS_EC2_IP = "${params.UAT_EC2_IP}" // Parameterized EC2 IP for UAT deployment
        SSH_KEY = credentials('sss-credentials') // SSH key credentials for EC2
        DOCKER_HUB_CREDENTIALS = credentials('docker-credentials') // Docker Hub credentials
        AWS_CREDENTIALS = credentials('aws-credentials') // AWS credentials (optional based on AWS CLI use)
    }
    parameters {
        string(name: 'UAT_EC2_IP', defaultValue: '', description: 'UAT EC2 instance IP') // Parameter for EC2 IP
    }
    stages {
        stage('Clone Repository') {
            steps {
                // Pulling the code from GitHub repository
                sh 'git clone https://github.com/akash-879/dotnet-hello-world'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build and push Docker image to Docker Hub
                    docker.withRegistry('', 'DOCKER_HUB_CREDENTIALS') {
                        def appImage = docker.build("${env.DOCKER_HUB_REPO}:latest") // Building the Docker image
                        appImage.push() // Pushing the image to Docker Hub
                    }
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                script {
                    // SSH to EC2 instance and run Docker commands to pull and run the image
                    sh """
                    ssh -i ${SSH_KEY} ubuntu@${AWS_EC2_IP} << EOF
                        docker pull ${env.DOCKER_HUB_REPO}:latest // Pull the latest image from Docker Hub
                        docker stop hello-world-api || true // Stop any running container with the same name
                        docker rm hello-world-api || true // Remove the container if it exists
                        docker run -d -p 80:80 --name hello-world-api ${env.DOCKER_HUB_REPO}:latest // Run the new container
                    EOF
                    """
                }
            }
        }
    }
    post {
        success {
            echo "Deployment successful!" // Print success message
        }
        failure {
            echo "Deployment failed!" // Print failure message if the build fails
        }
    }
}
