resource "aws_iam_instance_profile" "ec2_profile" {
 name = "${var.instance_name}_profile"
 role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
 name = "${var.instance_name}_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.instance_name}_role"
    Instance = var.instance_name
  }
}

resource "aws_iam_role_policy" "secrets_policy" {
 name = "${var.instance_name}_secrets_policy"
 role = aws_iam_role.ec2_role.id

 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Effect = "Allow"
       Action = [
         "secretsmanager:GetSecretValue"
       ]
       Resource = "arn:aws:secretsmanager:ap-northeast-2:774305610767:secret:/prod/emogi/env*"
     }
   ]
 })
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "${var.instance_name}_s3_policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}