# =============================================================================
# GLOBAL PROJECT VARIABLES
# =============================================================================
# These variables define the overall project configuration and are used
# across multiple resources for consistency and maintainability.

variable "project_name" {
  description = "Name of the project - used for resource naming and tagging"
  type        = string
  default     = "terraform-learning"
  
  # Example usage: This will be used in resource names like "terraform-learning-vpc"
  # and in tags for cost tracking and resource organization
}

variable "environment" {
  description = "Environment name (dev, staging, prod) - determines resource sizing and configuration"
  type        = string
  default     = "dev"
  
  # Validation ensures only valid environments are used
  # This prevents typos and enforces naming conventions
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "aws_region" {
  description = "AWS region where all resources will be created"
  type        = string
  default     = "us-west-2"
  
  # Common regions: us-east-1 (N. Virginia), us-west-2 (Oregon), eu-west-1 (Ireland)
  # Choose based on latency requirements and data residency needs
}

variable "owner" {
  description = "Owner of the resources - used for tagging and contact information"
  type        = string
  default     = "terraform-learner"
  
  # This helps with cost allocation and incident response
}

# =============================================================================
# NETWORK CONFIGURATION VARIABLES
# =============================================================================
# These variables define the network architecture and IP addressing scheme

variable "vpc_cidr" {
  description = "CIDR block for the VPC - defines the overall network range"
  type        = string
  default     = "10.0.0.0/16"
  
  # This gives us 65,536 IP addresses (10.0.0.0 to 10.0.255.255)
  # Common private ranges: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
}

variable "availability_zones" {
  description = "List of availability zones for high availability"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
  
  # Using multiple AZs ensures fault tolerance
  # Each AZ is a separate data center with independent power/cooling
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets - resources with direct internet access"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  
  # Each /24 subnet provides 256 IP addresses (10.0.1.0 to 10.0.1.255)
  # Public subnets have routes to Internet Gateway
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets - resources without direct internet access"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
  
  # Private subnets use NAT Gateway for outbound internet access
  # This provides better security for databases and internal services
}

# =============================================================================
# COMPUTE CONFIGURATION VARIABLES
# =============================================================================
# These variables define the computing resources we'll create

variable "instance_type" {
  description = "EC2 instance type - determines how powerful our computers are"
  type        = string
  default     = "t3.micro"
  
  # t3.micro is free for new AWS accounts (great for learning!)
  # Other options: t3.small, t3.medium, t3.large (but these cost money)
}

variable "key_pair_name" {
  description = "Name of the AWS key pair for secure access to instances"
  type        = string
  default     = ""
  
  # Key pairs are like special keys that let you securely access your computers
  # Leave empty if you don't need SSH access
}

# =============================================================================
# DATABASE CONFIGURATION VARIABLES
# =============================================================================
# These variables define our database settings

variable "db_instance_class" {
  description = "RDS instance class - determines database performance"
  type        = string
  default     = "db.t3.micro"
  
  # db.t3.micro is free for new AWS accounts
  # Other options: db.t3.small, db.t3.medium (but these cost money)
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB - how much space for data"
  type        = number
  default     = 20
  
  # 20GB is the minimum and usually enough for learning
  # You can increase this if you need more storage
}

variable "db_name" {
  description = "Name of the database - like naming your filing cabinet"
  type        = string
  default     = "learningdb"
}

variable "db_username" {
  description = "Database username - like your login name"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password - keep this secret!"
  type        = string
  sensitive   = true
  default     = ""
  
  # This is marked as sensitive so it won't show in logs
  # Always use strong passwords for databases!
}

# =============================================================================
# STORAGE CONFIGURATION VARIABLES
# =============================================================================
# These variables define our storage settings

variable "s3_bucket_name" {
  description = "Name of the S3 bucket - like naming your storage box"
  type        = string
  default     = ""
  
  # S3 bucket names must be globally unique
  # If empty, we'll generate a unique name automatically
}

# =============================================================================
# TAGGING CONFIGURATION
# =============================================================================
# Tags help organize and track your resources

variable "additional_tags" {
  description = "Additional tags to apply to resources - like extra name tags"
  type        = map(string)
  default     = {}
  
  # Tags are like name tags on your toys - they help you organize things
  # You can add custom tags like "Project", "Team", "CostCenter", etc.
}

# =============================================================================
# SECURITY CONFIGURATION VARIABLES
# =============================================================================
# These variables control security features and best practices

variable "enable_s3_versioning" {
  description = "Enable S3 bucket versioning for data protection"
  type        = bool
  default     = true
}

variable "enable_s3_encryption" {
  description = "Enable S3 bucket server-side encryption"
  type        = bool
  default     = true
}

variable "create_default_security_group" {
  description = "Create a default security group with restrictive rules"
  type        = bool
  default     = true
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed for HTTP traffic (port 80)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_https_cidrs" {
  description = "CIDR blocks allowed for HTTPS traffic (port 443)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed for SSH access (port 22)"
  type        = list(string)
  default     = []
}

variable "create_ec2_role" {
  description = "Create IAM role for EC2 instances"
  type        = bool
  default     = true
}

variable "create_s3_readonly_policy" {
  description = "Create S3 read-only IAM policy"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_logging" {
  description = "Enable CloudWatch logging for applications"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 14
}

variable "enable_backup" {
  description = "Enable backup functionality"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID for security group creation"
  type        = string
  default     = ""
}
