output "alb_dns_name" {
  value = aws_lb.emogi_alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.emogi_tg.arn
}

output "security_group_id" {
  value = aws_security_group.alb_sg.id
}
