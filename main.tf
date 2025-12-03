#################################
# Provider
#################################
provider "aws" {
  region = var.region
}

#################################
# VPC
#################################
resource "aws_vpc" "main_server_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

#################################
# Public Subnet
#################################
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_server_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "${var.name_prefix}-public-subnet"
  }
}

#################################
# Internet Gateway
#################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_server_vpc.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

#################################
# Public Route Table
#################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_server_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#################################
# Security Group
#################################
resource "aws_security_group" "main_server_sg" {
  name        = "${var.name_prefix}-sg"
  description = "Allow SSH, HTTP"
  vpc_id      = aws_vpc.main_server_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg"
  }
}

#################################
# Ubuntu AMI
#################################
data "aws_ssm_parameter" "ubuntu_ami" {
  name = var.ubuntu_ssm_path
}

#################################
# EC2 Web Server
#################################
resource "aws_instance" "web_server" {
  ami                         = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.main_server_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
apt update -y
apt install -y nginx

PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<HTML > /var/www/html/index.html
<html>
  <head><title>Azoz Nginx Server</title></head>
  <body style="font-family: Arial; text-align: center; margin-top: 50px;">
    <h1>Hello From Azoz Server through Jenkins Pipeline</h1>
    <h2>Private IP: $PRIVATE_IP</h2>
  </body>
</html>
HTML

systemctl restart nginx
systemctl enable nginx
EOF

  tags = {
    Name = "${var.name_prefix}-web-server"
  }
}
