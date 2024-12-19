resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.make_keypair.key_name

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = file("${var.user_data_path}")

  tags = {
    Name = var.instance_name
  }
}

resource "tls_private_key" "make_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "make_keypair" {
  key_name   = "${var.instance_name}_key"
  public_key = tls_private_key.make_key.public_key_openssh
}

resource "local_file" "downloads_key" {
  filename = "${var.instance_name}_key.pem"
  content  = tls_private_key.make_key.private_key_pem
}

resource "aws_lb_target_group_attachment" "emogi_tg_attachment" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.app.id  # 생성된 EC2의 id
  port             = 80
}