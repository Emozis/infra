output "parameter_arns" {
  description = "ARNs of created SSM parameters"
  value = {
    for name, param in aws_ssm_parameter.parameter : name => param.arn
  }
}

output "parameter_versions" {
  description = "Versions of created SSM parameters"
  value = {
    for name, param in aws_ssm_parameter.parameter : name => param.version
  }
}