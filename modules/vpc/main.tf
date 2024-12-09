resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"
  
  # Gateway type endpoint for S3
  vpc_endpoint_type = "Gateway"
  
  route_table_ids = [aws_route_table.public.id]
  
  tags = {
    Name = "${var.project_name}-vpce-s3"
  }
}