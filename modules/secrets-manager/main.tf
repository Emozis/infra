resource "aws_secretsmanager_secret" "env_secret" {
  name        = var.secret_name
  description = var.description
  
  tags = {
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "env_secret_version" {
  secret_id     = aws_secretsmanager_secret.env_secret.id
  secret_string = var.secret_value
}