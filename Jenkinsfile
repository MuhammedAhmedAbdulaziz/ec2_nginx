pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "eu-west-1"
        GIT_REPO = "https://github.com/MuhammedAhmedAbdulaziz/ec2_nginx.git"
    }

    stages {

        stage('Clone Repository') {
            steps {
                echo "Cloning GitHub repository..."
                git url: "${GIT_REPO}"
            }
        }

        stage('Terraform Init') {
            steps {
                echo "Running terraform init..."
                withAWS(credentials: 'aws-credi', region: 'eu-west-1') {
                    sh "terraform init"
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                echo "Validating Terraform code..."
                sh "terraform validate"
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Generating Terraform plan..."
                withAWS(credentials: 'aws-credi', region: 'eu-west-1') {
                    sh "terraform plan -out=tfplan"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "Applying Terraform changes..."
                withAWS(credentials: 'aws-credi', region: 'eu-west-1') {
                    sh "terraform apply -auto-approve tfplan"
                }
            }
        }
    }

    post {
        success {
            echo "Terraform infrastructure deployed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
