# Pipeline Project: Flask API Deployment
This project aims to automate the deployment process of a Flask API that provides cryptocurrency prices. It utilizes Jenkins, Docker, and AWS to deliver the API as a Docker container to an AWS instance.

Overview
The pipeline project utilizes a Jenkinsfile, a Groovy-based script, to define and execute the stages of the deployment process. The pipeline performs the following key tasks:

**Cleanup**: Removes any existing artifacts from previous deployments.
**Clone**: Clones the repository containing the Flask API source code.
**Build**: Packages the Flask API source code into a Docker container.
Upload to S3: Copies the Docker container image to an AWS S3 bucket for storage.
Pull from S3 and Push to EC2: Retrieves the Docker container image from the S3 bucket and pushes it to an AWS EC2 instance.
Testing: Executes tests on the deployed Flask API on the EC2 instance.
Deployment: Deploys the Flask API on the production AWS instance.
Prerequisites
Before running the pipeline, ensure the following prerequisites are met:

Jenkins is installed and configured with necessary plugins.
An AWS account is set up with appropriate permissions for S3 and EC2.
An AWS EC2 instance is available for deployment.
Docker is installed on the Jenkins server and the EC2 instance.
Setup Instructions
Follow these steps to set up and run the pipeline:

Configure AWS credentials on the Jenkins server, providing access to the S3 bucket and EC2 instance.
Create a Jenkins pipeline job and specify the Jenkinsfile location.
Set up a webhook or trigger the pipeline manually to initiate the deployment process.
Customization
To customize the pipeline for your specific needs, consider the following:

Modify the git clone command in the "Clone" stage to point to your Flask API repository.
Adjust the AWS region and any other AWS-related configurations as per your setup.
Customize the deployment scripts (deploy.sh, test.sh) to match your Flask API deployment requirements.
Troubleshooting
If you encounter any issues during the deployment process, consider the following troubleshooting steps:

Verify that the necessary AWS credentials are correctly configured on the Jenkins server.
Ensure that the Docker daemon is running on the Jenkins server and the EC2 instance.
Check the S3 bucket and EC2 instance configurations for any misconfigurations or permission issues.
Conclusion
By implementing this Jenkins pipeline project, you can automate the deployment of your Flask API for cryptocurrency prices to an AWS EC2 instance. This improves the efficiency and consistency of your deployment process, allowing you to deliver your API in a containerized and scalable manner.

