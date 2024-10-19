output "SG-ec2-sg-ssh-http-id" {
  value = aws_security_group.ec2_sg_ssh_http.id
}

output "SG-EC2-Jenkins-port-8080" {
  value = aws_security_group.ec2_jenkins_port_8080.id
}