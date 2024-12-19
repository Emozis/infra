module "vpc" {
  source   = "./modules/vpc"
  project_name = var.project_name
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = [
    module.vpc.public_subnet_1_id,
    module.vpc.public_subnet_2_id
  ]
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = local.env_vars["BUCKET_NAME"]
}

module "cloudfront" {
  source                          = "./modules/cloudfront"
  bucket_name                     = module.s3.bucket_id
  bucket_regional_domain_name     = module.s3.bucket_regional_domain_name
  cloudfront_access_identity_path = module.s3.cloudfront_access_identity_path
}

module "emogi_app" {
  source          = "./modules/ec2"
  instance_name   = "emogi-ec2-app"
  ami_id          = "ami-0f1e61a80c7ab943e"
  instance_type   = "t3.micro"
  user_data_path  = "script/initail_server_setting.sh"
  vpc_id          = module.vpc.vpc_id
  subnet_id       = module.vpc.public_subnet_1_id
  bucket_name = local.env_vars["BUCKET_NAME"]
  key_name = "emogi-keypair"

  target_group_arn = module.alb.target_group_arn
  alb_security_group_id = module.alb.security_group_id
}

module "rds" {
  source = "./modules/rds"

  env         = "prod"
  db_name     = "emogi"
  db_username = local.env_vars["DB_USERNAME"]
  db_password = local.env_vars["DB_PASSWORD"]
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [
    module.vpc.private_subnet_1_id,
    module.vpc.private_subnet_2_id
  ]
  
  allowed_security_groups = [module.emogi_app.security_group_id]
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
    "/emogi/ec2/env-variables" = {
      description = "Emogi Environment Variables"
      type        = "SecureString"
      value       = file("${path.module}/.env.prod")
      environment = "prod"
    }
  }
}
