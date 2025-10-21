# =============================================================================
# 📊 MONITORING MODULE VARIABLES
# =============================================================================

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID to monitor"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name to monitor"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
  default     = "/aws/application"
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 14
}

variable "alert_email" {
  description = "Email address for alerts (optional)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
