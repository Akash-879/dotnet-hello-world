pipeline {
    agent any

    environment {
        // Define Docker Hub and AWS credentials as global variables in Jenkins
        DOCKER_HUB_CREDENTIALS = credentials('docker-credentials')
        AWS_CREDENTIALS = credentials('aws-credentials')
        // Use environment-specific EC2 details
        EC2_IP_UAT = "uat-instance-ip"
        EC2_IP_PROD = "prod-instance-ip"
        DOCKER_IMAGE = "akash879/hello-world-api"
    }

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['UAT', 'PRODUCTION'], description: 'Choose deployment environment')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/Akash-879/dotnet-hello-world', branch: 'master'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${params.ENVIRONMENT.toLowerCase()}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', "${DOCKER_HUB_CREDENTIALS}") {
                        docker.image("${DOCKER_IMAGE}:${params.ENVIRONMENT.toLowerCase()}").push()
                    }
                }
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                script {
                    def ec2Ip = params.ENVIRONMENT == 'UAT' ? EC2_IP_UAT : EC2_IP_PROD
                    sh """
                    ssh -o StrictHostKeyChecking=no -i /path/to/your/aws-key.pem ubuntu@${ec2Ip} << EOF
                        docker pull ${DOCKER_IMAGE}:${params.ENVIRONMENT.toLowerCase()}
                        docker run -d -p 80:80 ${DOCKER_IMAGE}:${params.ENVIRONMENT.toLowerCase()}
                    EOF
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
