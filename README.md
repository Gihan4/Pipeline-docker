# Flask Pipeline Project
Crypto site to watch crypto currencys value.

The project incorporates a CI/CD pipeline to automate the deployment process, ensuring efficient and consistent delivery of updates.
The pipeline is implemented using Jenkins and is triggered on each commit to the repository.
Ansible files are set to run the flask as a service. 

The pipeline performs the following stages:

1. **Cleanup**: Cleans up the workspace by removing unnecessary files.

2. **Clone**: Clones the repository to the Jenkins workspace.

3. **Build**: Builds the project by packaging the necessary files.

4. **Upload to S3**: Uploads the packaged files to an Amazon S3 bucket.

5. **Pull gzip from S3 and push to EC2**: Copies the packaged files from S3 to an EC2 instance.

6. **Testing**: Executes tests and verifies the application on the EC2 instance.

## Contributing

Contributions to the Flask Pipeline Project are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## Contact

For any inquiries or questions, please contact [Roey Gihan] at [gihanroey@gmail.com].

