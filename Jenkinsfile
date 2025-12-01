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
                sh "terraform validate"
            }
        }

        stage('Terraform Plan') {
            steps {
                withAWS(credentials: 'aws-credi', region: 'eu-west-1') {
                    sh "terraform plan -out=tfplan"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withAWS(credentials: 'aws-credi', region: 'eu-west-1') {
                    sh "terraform apply -auto-approve tfplan"
                }
            }
        }
    }

    post {
        success {
            echo "Terraform deployment successful!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
