# =============================================================================
# 🎭 STAGING ENVIRONMENT CONFIGURATION 🎭
# =============================================================================
# This file configures the staging environment for testing before production!

# Project Configuration
project_name = "terraform-learning-staging"
environment  = "staging"
owner        = "cloud-architect"

# AWS Configuration
aws_region = "us-west-2"

# Network Configuration
vpc_cidr                = "10.1.0.0/16"
availability_zones      = ["us-west-2a", "us-west-2b", "us-west-2c"]
public_subnet_cidrs    = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_subnet_cidrs   = ["10.1.10.0/24", "10.1.20.0/24", "10.1.30.0/24"]

# Compute Configuration (Small instances for testing)
instance_type = "t3.small"
key_pair_name = "staging-key"

# Database Configuration
db_instance_class    = "db.t3.small"
db_allocated_storage = 50
db_name             = "stagingdb"
db_username         = "admin"
db_password         = ""

# Storage Configuration
s3_bucket_name = ""

# Security Configuration
create_default_security_group = true
allowed_http_cidrs           = ["0.0.0.0/0"]
allowed_https_cidrs          = ["0.0.0.0/0"]
allowed_ssh_cidrs            = ["10.0.0.0/8"]  # Restrict SSH to internal networks

# Monitoring Configuration
enable_cloudwatch_logging = true
log_retention_days       = 30
enable_backup            = true

# Additional Tags
additional_tags = {
  Environment = "staging"
  Purpose     = "testing"
  CostCenter  = "development"
}
