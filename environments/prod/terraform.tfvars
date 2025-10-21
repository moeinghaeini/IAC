# =============================================================================
# 🚀 PRODUCTION ENVIRONMENT CONFIGURATION 🚀
# =============================================================================
# This file configures the production environment for real-world use!

# Project Configuration
project_name = "terraform-learning-prod"
environment  = "prod"
owner        = "senior-cloud-architect"

# AWS Configuration
aws_region = "us-west-2"

# Network Configuration
vpc_cidr                = "10.2.0.0/16"
availability_zones      = ["us-west-2a", "us-west-2b", "us-west-2c"]
public_subnet_cidrs    = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
private_subnet_cidrs   = ["10.2.10.0/24", "10.2.20.0/24", "10.2.30.0/24"]

# Compute Configuration (Production instances)
instance_type = "t3.medium"
key_pair_name = "prod-key"

# Database Configuration
db_instance_class    = "db.t3.medium"
db_allocated_storage = 100
db_name             = "proddb"
db_username         = "admin"
db_password         = ""

# Storage Configuration
s3_bucket_name = ""

# Security Configuration (Strict security for production)
create_default_security_group = true
allowed_http_cidrs           = ["0.0.0.0/0"]
allowed_https_cidrs          = ["0.0.0.0/0"]
allowed_ssh_cidrs            = ["203.0.113.0/24"]  # Restrict SSH to specific IP range

# Monitoring Configuration
enable_cloudwatch_logging = true
log_retention_days       = 90
enable_backup            = true

# Additional Tags
additional_tags = {
  Environment = "prod"
  Purpose     = "production"
  CostCenter  = "operations"
  Compliance  = "required"
}
