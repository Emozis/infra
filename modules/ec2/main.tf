resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = file("${var.user_data_path}")

  tags = {
    Name = var.instance_name
  }
}

data "aws_eip" "ec2_eip" {
  tags = {
    Name = "permanent-emogi-eip"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.app.id
  allocation_id = data.aws_eip.ec2_eip.id
}
