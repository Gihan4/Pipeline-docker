pipeline {
    agent any

    //triggers {
        // The pipeline is triggered every minute to check for changes in the git
        // pollSCM('*/1 * * * *')
    //}

    environment {
        testip = sh(
            script: "aws ec2 describe-instances --region eu-central-1 --filters 'Name=tag:Environment,Values=Test1' --query 'Reservations[].Instances[].PublicIpAddress' --output text",
            returnStdout: true
        ).trim()
    }

    stages {
        stage('Cleanup') {
            steps {
                echo "Cleaning up..."
                sh 'rm -rf *'
            }
        }

        stage('Clone') {
            steps {
                echo "Cloning repository..."
                sh 'git clone https://github.com/Gihan4/Pipeline-docker.git'
                sh 'ls'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                dir('Pipeline-docker') {
                    sh 'docker build -t gihan4/myimage:1.0 .'
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                sh 'docker push gihan4/myimage:1.0'
            }
        }

        stage('Deploy and Test on AWS') {
            steps {
                echo "Deploying and testing on AWS test instance..."
                    sh "scp -o StrictHostKeyChecking=no -i $HOME/.ssh/Gihan4.pem ~/.docker/config.json ec2-user@${testip}:~/.docker/config.json"
                    sh "scp -o StrictHostKeyChecking=no -i $HOME/.ssh/Gihan4.pem -r Pipeline-docker ec2-user@${testip}:~/Pipeline-docker"
                    sh "ssh -o StrictHostKeyChecking=no -i $HOME/.ssh/Gihan4.pem ec2-user@${testip} 'docker login && docker pull gihan4/myimage:1.0'"
                    sh "ssh -o StrictHostKeyChecking=no -i $HOME/.ssh/Gihan4.pem ec2-user@${testip} 'docker run -d -p 80:80 gihan4/myimage:1.0'"
            }
        }

    }
}
