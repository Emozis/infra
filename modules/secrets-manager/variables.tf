variable "secret_name" {
  description = "Name of the secret in AWS Secrets Manager"
  type        = string
}

variable "description" {
  description = "Description of the secret"
  type        = string
  default     = "Environment variables for application"
}

variable "environment" {
  description = "Environment (e.g., prod, dev, staging)"
  type        = string
  default     = "prod"
}

variable "secret_value" {
  description = "Secret value to store (content of .env file)"
  type        = string
  sensitive   = true
}