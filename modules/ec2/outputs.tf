output "instance_public_ip" {
  value = aws_instance.app.public_ip
}

output "security_group_id" {
  value = aws_security_group.ec2_sg.id
}

output "public_ip" {
  value = data.aws_eip.ec2_eip.public_ip
}