variable "project_name" {
  type        = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "user_data_path" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the EC2 instance"
  type        = string
}