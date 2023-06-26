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
            }
        }

        stage('Stop and Remove Containers and Images') {
            steps {
                // delete from Jenkins server
                echo "Stopping and removing containers and images on Jenkins server..."
                sh "docker stop \$(docker ps -aq) || true"
                sh "docker rm \$(docker ps -aq) || true"
                sh "docker rmi $(docker images -q gihan4/myimage) || true"

                
                // delete from AWS instance
                echo "Stopping and removing containers and images on AWS instance..."
                sh """
                    ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/.ssh/Gihan4.pem ec2-user@${testip} '
                    docker stop \$(docker ps -aq) || true &&
                    docker rm \$(docker ps -aq) || true &&
                    docker rmi $(docker images -q gihan4/myimage) || true'
                """
            }
        }


        stage('Install Docker on AWS Instance') {
            steps {
                echo "Installing Docker on AWS instance..."
                sh """
                ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/.ssh/Gihan4.pem ec2-user@${testip} '
                    sudo yum update -y &&
                    sudo yum install -y docker &&
                    sudo service docker start &&
                    sudo usermod -aG docker ec2-user
                '
                """
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

        stage('Deploy on Test server') {
            steps {
                echo "Deploying and testing on AWS test instance..."
                    // pulls the Docker image gihan4/myimage:1.0 onto the EC2 instance.
                    sh "ssh -o StrictHostKeyChecking=no -i $HOME/.ssh/Gihan4.pem ec2-user@${testip} 'docker pull gihan4/myimage:1.0'"
                    // execute the docker on port 5000. 
                    sh "ssh -o StrictHostKeyChecking=no -i $HOME/.ssh/Gihan4.pem ec2-user@${testip} 'docker run -d -p 5000:5000 gihan4/myimage:1.0'"
            }
        }

        stage('Check Flask API') {
            steps {
                echo "Checking Flask API..."
    
                // Make an HTTP request to the Flask API endpoint
                script {
                    def response = sh script: "curl -s -o /dev/null -w '%{http_code}' http://${testip}:5000/api/endpoint", returnStdout: true
                    def statusCode = response.trim()
                    
                    if (statusCode == '200') {
                        echo "Flask API is running successfully. Response code: ${statusCode}"
                    } else {
                        error "Flask API is not running. Response code: ${statusCode}"
                    }
                }
            }
        }

    }
}
