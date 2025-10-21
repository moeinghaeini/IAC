# =============================================================================
# 🚀 SPACE STATION OUTPUTS
# =============================================================================

output "s3_bucket_name" {
  description = "Name of the S3 bucket for the space station website"
  value       = aws_s3_bucket.space_station.bucket
}

output "website_url" {
  description = "URL of the space station website"
  value       = "http://${aws_s3_bucket.space_station.bucket}.s3-website-us-west-2.amazonaws.com"
}

output "ec2_instance_id" {
  description = "ID of the space station server"
  value       = aws_instance.space_station.id
}

output "ec2_public_ip" {
  description = "Public IP of the space station server"
  value       = aws_instance.space_station.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the space station server"
  value       = aws_instance.space_station.public_dns
}