resource "aws_ssm_parameter" "parameter" {
  for_each = var.parameters

  name        = each.key
  description = each.value.description
  type        = each.value.type
  value       = each.value.value
  tier        = lookup(each.value, "tier", "Standard")
  
  tags = {
    Environment = lookup(each.value, "environment", "dev")
    Managed_by  = "terraform"
  }
}