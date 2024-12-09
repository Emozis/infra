module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "emogi-vpc"
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
  }
}