variable "project_name" {
  type        = string
  default     = "emogi"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "emogi-bucket-2024"
}

variable "db_password" {
  type        = string
  default     = "test1234"
}