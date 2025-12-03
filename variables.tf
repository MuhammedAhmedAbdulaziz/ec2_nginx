variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "eu-west-1"
}

variable "availability_zone" {
  description = "AZ for public subnet"
  type        = string
  default     = "eu-west-1a"
}

variable "name_prefix" {
  description = "Prefix for all AWS resources"
  type        = string
  default     = "main-server"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "192.168.0.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "192.168.0.0/28"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ubuntu_ssm_path" {
  description = "SSM path for Ubuntu 22.04 AMI"
  type        = string
  default     = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}
