# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids  # 프라이빗 서브넷 ID 목록

  tags = {
    Name = "${var.env}-${var.db_name}-subnet-group"
  }
}

# RDS Security Group
resource "aws_security_group" "rds" {
  name        = "${var.env}-${var.db_name}-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  # EC2에서의 접근만 허용
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }

  tags = {
    Name = "${var.env}-${var.db_name}-sg"
  }
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier = "${var.env}-${var.db_name}"
  
  # 엔진 설정
  engine               = "postgres"
  engine_version       = "16.4"
  instance_class      = "db.t3.micro"
  
  # 스토리지 설정
  allocated_storage    = 20
  storage_type         = "gp2"
  
  # 데이터베이스 설정
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  port                = 5432
  
  # 네트워크 설정
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false  # 프라이빗 서브넷이므로 false
  
  # 백업 설정
  backup_retention_period = 7  # 7일간 백업 보관
  backup_window          = "03:00-04:00"  # UTC 기준
  maintenance_window     = "Mon:04:00-Mon:05:00"  # UTC 기준
  
  # 기타 설정
  auto_minor_version_upgrade = false  # 자동 업데이트 비활성화
  multi_az             = false  # 프리티어는 단일 AZ만 가능
  skip_final_snapshot  = true   # 테스트 환경이므로 true로 설정
  
  tags = {
    Name = "${var.env}-${var.db_name}"
  }
}