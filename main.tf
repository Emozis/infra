module "vpc" {
  source   = "./modules/vpc"
  project_name = var.project_name
}

module "emogi_app" {
  source          = "./modules/ec2"
  instance_name   = "emogi-ec2-app"
  ami_id          = "ami-0f1e61a80c7ab943e"
  instance_type   = "t3.micro"
  user_data_path  = "script/initail_server_setting.sh"
  vpc_id          = module.vpc.vpc_id
  subnet_id       = module.vpc.public_subnet_id
  bucket_name = var.bucket_name
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "cloudfront" {
  source                          = "./modules/cloudfront"
  bucket_name                     = module.s3.bucket_id
  bucket_regional_domain_name     = module.s3.bucket_regional_domain_name
  cloudfront_access_identity_path = module.s3.cloudfront_access_identity_path
}

module "rds" {
  source = "./modules/rds"
  
  db_name     = "emogi"
  db_username = "emogi_admin"
  db_password = var.db_password
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [
    module.vpc.private_subnet_1_id,
    module.vpc.private_subnet_2_id
  ]
  
  allowed_security_groups = [module.emogi_app.security_group_id]  # EC2의 보안그룹 ID
}

module "env_secret" {
  source = "./modules/secrets-manager"
  
  secret_name  = "/emogi/env-variables"
  description  = "Environment variables for Emogi application"
  environment  = "prod"
  secret_value = file("${path.module}/.env.prod")
}

module "ssm_parameters" {
  source = "./modules/ssm"
  
  parameters = {
    "/emogi/s3/bucket_name" = {
      description = "Emogi S3 Bucket Name"
      type        = "String"
      value       = module.s3.bucket_id
      environment = "prod"
    }
    "/emogi/cloudfront/domain_name" = {
      description = "Emogi CloudFront Distribution Domain Name"
      type        = "String"
      value       = module.cloudfront.cloudfront_domain_name
      environment = "prod"
    }
    "/emogi/secrets/env_secret_name" = {
      description = "Emogi Environment Variables Secret Name"
      type        = "String"
      value       = module.env_secret.secret_id
      environment = "prod"
    }
  }
}