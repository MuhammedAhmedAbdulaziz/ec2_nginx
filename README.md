# 🚀 EC2 Nginx Deployment Using Terraform & Jenkins CI/CD

This project demonstrates a complete **Infrastructure-as-Code (IaC)** and **CI/CD automation pipeline** for deploying an **Nginx web server on AWS EC2**.

Using **Terraform**, we provision all AWS infrastructure components.
Using **Jenkins**, we automate the full deployment pipeline (clone → init → validate → plan → apply).

This project is ideal to showcase DevOps skills for recruiters and interviews.

---

## 📘 Table of Contents

* [Project Overview](#-project-overview)
* [AWS Architecture](#-aws-architecture)
* [Terraform Resources](#-terraform-resources)
* [Jenkins Pipeline Workflow](#-jenkins-pipeline-workflow)
* [Repository Structure](#-repository-structure)
* [Manual Deployment Steps](#-manual-deployment-steps)
* [Accessing the Web Server](#-accessing-the-web-server)
* [Destroying the Infrastructure](#-destroying-the-infrastructure)
* [Key DevOps Concepts Demonstrated](#-key-devops-concepts-demonstrated)
* [Future Enhancements](#-future-enhancements)
* [Official Documentation References](#-official-documentation-references)

---

## 🚀 Project Overview

This project provisions the following AWS services through Terraform:

* Custom VPC
* Public Subnet
* Internet Gateway & Route Table
* Security Group (SSH + HTTP)
* EC2 Instance (Ubuntu 22.04)
* Nginx auto-installation via User Data
* Custom HTML page showing EC2 private IP

A Jenkins pipeline automates the deployment lifecycle from pulling the repo to provisioning infrastructure.

---

## 🏗 AWS Architecture

Terraform builds a complete public environment:

* **VPC:** `192.168.0.0/24`
* **Public Subnet:** `192.168.0.0/28`
* **Internet Gateway:** Enables external connectivity
* **Route Table:** Routes 0.0.0.0/0 through IGW
* **Security Group:**

  * Allow SSH (22)
  * Allow HTTP (80)
* **EC2 Instance:**

  * Ubuntu AMI retrieved through AWS SSM
  * Nginx installed via user-data
  * HTML file showing private IP

---

## 📦 Terraform Resources

### Networking

* `aws_vpc`
* `aws_subnet`
* `aws_internet_gateway`
* `aws_route_table`
* `aws_route_table_association`

### Security

* `aws_security_group`

### AMI Lookup

* `aws_ssm_parameter`

### Compute

* `aws_instance` with automated Nginx setup

---

## 🔄 Jenkins Pipeline Workflow

The Jenkinsfile includes:

| Stage                  | Purpose                                |
| ---------------------- | -------------------------------------- |
| **Clone Repository**   | Fetch latest code                      |
| **Terraform Init**     | Initialize Terraform                   |
| **Terraform Destroy**  | Removes previous infra for consistency |
| **Terraform Validate** | Checks syntax and structure            |
| **Terraform Plan**     | Previews infra changes                 |
| **Terraform Apply**    | Deploys resources                      |

Jenkins authenticates using:

```
withAWS(credentials: 'aws-credi', region: 'eu-west-1')
```

---

## 📂 Repository Structure

```
ec2_nginx/
├── main.tf                  # Main Terraform configuration
├── variables.tf             # Terraform variables
├── outputs.tf               # Terraform outputs
├── Jenkinsfile              # CI/CD pipeline
├── .terraform.lock.hcl      # Provider lock file
└── .gitignore
```

---

## 🛠 Manual Deployment Steps (Without Jenkins)

### 1. Clone the repository

```bash
git clone https://github.com/MuhammedAhmedAbdulaziz/ec2_nginx.git
cd ec2_nginx
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Validate configuration

```bash
terraform validate
```

### 4. Create execution plan

```bash
terraform plan
```

### 5. Apply infrastructure

```bash
terraform apply -auto-approve
```

---

## 🌐 Accessing the Web Server

After Terraform completes, the output will show:

```
web_server_public_ip = 54.xxx.xxx.xxx
```

Open the browser:

```
http://<public-ip>
```

You should see:

```
Hello From Azoz Server through Jenkins Pipeline
Private IP: <dynamic-private-ip>
```

---

## 🧹 Destroying the Infrastructure

To remove everything:

```bash
terraform destroy -auto-approve
```

---

## 🎯 Key DevOps Concepts Demonstrated

* Infrastructure as Code (Terraform)
* AWS Networking (VPC, Subnets, Route Tables, IGW)
* Automated EC2 provisioning with User Data
* Using AWS SSM Parameter Store for AMI lookup
* Secure Terraform variable and output management
* Jenkins CI/CD automation
* End-to-end infrastructure lifecycle automation

---

## 🚀 Future Enhancements

* Add Application Load Balancer (ALB)
* Add Auto Scaling Group
* Add Terraform remote backend (S3 + DynamoDB)
* Add staging & production environments
* Add CloudWatch monitoring & alarms
* Add SSL/TLS using AWS Certificate Manager (ACM)

---

## 🧩 Applying This Project in Jenkins

Below are the exact steps required to run this Terraform project through Jenkins using your GUI configuration (Pipeline script from SCM):

### **1️⃣ Create a New Pipeline Job**

1. Open Jenkins → **New Item**
2. Select **Pipeline** → name it `nginx-iac-pipeline`
3. Click **OK**

---

### **2️⃣ Configure Source Code Management (SCM)**

Inside the job configuration:

#### **SCM: Git**

* **Repository URL:**

  ```
  https://github.com/MuhammedAhmedAbdulaziz/ec2_nginx.git
  ```
* **Credentials:**

  * Choose **your GitHub token credentials** (or leave empty if repo is public)
* **Branch Specifier:**

  ```
  */master
  ```

---

### **3️⃣ Pipeline Script Path**

Since the Jenkinsfile exists in the root of your repo:

```
Script Path: Jenkinsfile
```

Jenkins will automatically fetch and execute the pipeline stages from that file.

---

### **4️⃣ Required Jenkins Plugins**

Ensure the following plugins are installed:

* **Pipeline Plugin** (built-in on modern Jenkins)
* **AWS Credentials Plugin** → required for `withAWS {}`
* **Git Plugin**

---

### **5️⃣ Configure AWS Credentials in Jenkins**

1. Open **Jenkins → Manage Jenkins → Credentials → Global**
2. Add a new credential:

   * **Kind:** AWS Credentials
   * **ID:** `aws-credi` (must match Jenkinsfile)
   * **AWS Access Key** + **Secret Key**

Your Jenkinsfile references it here:

```groovy
withAWS(credentials: 'aws-credi', region: 'eu-west-1')
```

---

### **6️⃣ Run the Pipeline**

Click **Build Now**.

The stages executed will be:

1. Clone Repository
2. Terraform Init
3. Terraform Destroy (optional cleanup)
4. Terraform Validate
5. Terraform Plan
6. Terraform Apply

If successful, Jenkins prints your EC2 public IP in the console output.

---

### **7️⃣ Access Your Web Server**

Grab the output:

```
web_server_public_ip = X.X.X.X
```

Open in browser:

```
http://X.X.X.X
```

You will see the Nginx welcome message from your user-data script.

---


