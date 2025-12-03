output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_server_vpc.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public_subnet.id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.main_server_sg.id
}

output "web_server_public_ip" {
  description = "Public IP of the EC2 web server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_private_ip" {
  description = "Private IP of the EC2 web server"
  value       = aws_instance.web_server.private_ip
}
