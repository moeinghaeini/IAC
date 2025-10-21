# =============================================================================
# 🧪 DEVELOPMENT ENVIRONMENT CONFIGURATION 🧪
# =============================================================================
# This file configures the development environment for learning and testing!

# Project Configuration
project_name = "terraform-learning-dev"
environment  = "dev"
owner        = "little-cloud-architect"

# AWS Configuration
aws_region = "us-west-2"

# Network Configuration
vpc_cidr                = "10.0.0.0/16"
availability_zones      = ["us-west-2a", "us-west-2b"]
public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs   = ["10.0.10.0/24", "10.0.20.0/24"]

# Compute Configuration (Free Tier)
instance_type = "t3.micro"
key_pair_name = ""

# Database Configuration (Free Tier)
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_name             = "learningdb"
db_username         = "admin"
db_password         = ""

# Storage Configuration
s3_bucket_name = ""

# Security Configuration
create_default_security_group = true
allowed_http_cidrs           = ["0.0.0.0/0"]
allowed_https_cidrs          = ["0.0.0.0/0"]
allowed_ssh_cidrs            = []

# Monitoring Configuration
enable_cloudwatch_logging = true
log_retention_days       = 7
enable_backup            = false

# Additional Tags
additional_tags = {
  Environment = "dev"
  Purpose     = "learning"
  CostCenter  = "education"
}
