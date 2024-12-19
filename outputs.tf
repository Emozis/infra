output "app_public_ip" {
  value = module.emogi_app.instance_public_ip
}

output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_domain_name
  description = "The domain name of the CloudFront distribution"
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
  description = "The DNS name of the Application Load Balancer"
}