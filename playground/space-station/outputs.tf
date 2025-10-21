# =============================================================================
# 🚀 SPACE STATION OUTPUTS
# =============================================================================

output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.space_station.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the load balancer"
  value       = aws_lb.space_station.zone_id
}

output "website_url" {
  description = "URL of the space station website"
  value       = "http://${aws_lb.space_station.dns_name}"
}

output "database_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.space_station.endpoint
  sensitive   = true
}

output "database_port" {
  description = "RDS instance port"
  value       = aws_db_instance.space_station.port
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for data storage"
  value       = aws_s3_bucket.space_station_data.bucket
}

output "dashboard_url" {
  description = "URL of the CloudWatch dashboard"
  value       = "https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#dashboards:name=${aws_cloudwatch_dashboard.space_station.dashboard_name}"
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.space_station.id
}

output "auto_scaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.space_station.name
}