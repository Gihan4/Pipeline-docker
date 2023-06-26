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
                // removes all files and directories in the current working directory 
                sh 'rm -rf *'

                echo "Removing Docker image..."
                script {
                    // checks if the image exists
                    def imageExists = sh(
                        script: "docker images -q gihan4/myimage:1.0",
                        returnStdout: true
                    ).trim()
                    // deletes the image if exists
                    if (!imageExists.empty) {
                        sh 'docker rmi gihan4/myimage:1.0'
                    } else {
                        echo "Image not found. Skipping removal."
                    }
                }
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
                    // securely copy the json file from the Jenkins machine to the AWS EC2 instance.
                    sh "scp -o StrictHostKeyChecking=no -i $HOME/.ssh/Gihan4.pem ~/.docker/config.json ec2-user@${testip}:~/.docker/config.json"
                    // copies the entire Pipeline-docker directory from the Jenkins machine to the AWS EC2 instance using the scp.
                    sh "scp -o StrictHostKeyChecking=no -i $HOME/.ssh/Gihan4.pem -r Pipeline-docker ec2-user@${testip}:~/Pipeline-docker"
                    // authenticate with Docker Hub and then pulls the Docker image gihan4/myimage:1.0 onto the EC2 instance.
                    sh "ssh -o StrictHostKeyChecking=no -i $HOME/.ssh/Gihan4.pem ec2-user@${testip} 'docker login && docker pull gihan4/myimage:1.0'"
                    // execute the docker on port 5000. 
                    sh "ssh -o StrictHostKeyChecking=no -i $HOME/.ssh/Gihan4.pem ec2-user@${testip} 'docker run -d -p 5000:5000 gihan4/myimage:1.0'"
            }
        }

    }
}
