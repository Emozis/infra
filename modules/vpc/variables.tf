variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  default     = "10.0.1.0/24"
}

variable "vpc_name" {
  description = "Name tag for VPC"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "ap-northeast-2"
}