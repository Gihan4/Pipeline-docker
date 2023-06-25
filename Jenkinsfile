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
                sh 'git clone https://github.com/Gihan4/DevOps-Crypto.git'
                sh 'ls'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                dir('your-repo') {
                    sh 'docker build -t your-flask-image .'
                }
            }
        }

        stage('Upload to S3') {
            steps {
                echo "Copying to S3..."
                sh 'aws s3 cp project.tar.gz s3://gihansbucket'
            }
        }

        stage('Pull gzip from S3 and push to EC2') {
            steps {
                echo "Copying S3 object to EC2..."
                sh "ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/.ssh/Gihan4.pem ec2-user@${testip} 'aws s3 cp s3://gihansbucket/project.tar.gz .'"
            }
        }

        stage('Testing') {
            steps {
                echo "Testing on EC2..."
                sh """
                ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/.ssh/Gihan4.pem ec2-user@${testip} 'tar -xvf project.tar.gz && rm project.tar.gz && /bin/bash /home/ec2-user/deploy.sh && /bin/bash /home/ec2-user/test.sh'
                """
            }
        }
    }
}
