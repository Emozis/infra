output "app_public_ip" {
  value = module.emogi_app.instance_public_ip
}

output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_domain_name
  description = "The domain name of the CloudFront distribution"
}
