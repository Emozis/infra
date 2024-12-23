resource "aws_iam_instance_profile" "ec2_profile" {
 name = "${var.project_name}-ec2-profile"
 role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
 name = "${var.project_name}-ec2-role"

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
    Name = "${var.project_name}-ec2-role"
    Instance = "${var.project_name}-ec2-app"
  }
}

resource "aws_iam_role_policy" "secrets_policy" {
 name = "${var.project_name}-ec2-secrets-policy"
 role = aws_iam_role.ec2_role.id

 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Effect = "Allow"
       Action = [
         "secretsmanager:GetSecretValue"
       ]
       Resource = "arn:aws:secretsmanager:ap-northeast-2:774305610767:secret:/emogi/env-variables*"
     }
   ]
 })
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "${var.project_name}-ec2-s3-policy"
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

resource "aws_iam_role_policy" "ssm_policy" {
  name = "${var.project_name}-ec2-ssm-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = [
          "arn:aws:ssm:ap-northeast-2:774305610767:parameter/emogi/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}