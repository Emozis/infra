output "bucket_id" {
  value = aws_s3_bucket.main.id
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.main.bucket_regional_domain_name
}

output "bucket_arn" {
  value = aws_s3_bucket.main.arn
}

output "cloudfront_access_identity_path" {
  value = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
}