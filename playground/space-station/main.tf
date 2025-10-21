# =============================================================================
# 🚀 SPACE STATION - ADVANCED TERRAFORM EXAMPLE! 🚀
# =============================================================================
# This file demonstrates advanced Terraform features for experienced learners!

terraform {
  required_version = ">= 1.9"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Configure AWS provider
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "Space-Station"
      Environment = "learning"
      ManagedBy   = "Terraform"
      Owner       = "Space-Architect"
    }
  }
}

# =============================================================================
# 📋 DATA SOURCES
# =============================================================================

# Find the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get available AZs in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# =============================================================================
# 🌌 LOCAL VALUES (ADVANCED FEATURE!)
# =============================================================================
# Locals help us create complex expressions and reuse them

locals {
  # Create a map of space station modules
  space_modules = {
    "command-center" = {
      instance_type = "t3.small"
      port          = 8080
      description   = "Main command and control center"
    }
    "life-support" = {
      instance_type = "t3.micro"
      port          = 8081
      description   = "Life support systems monitoring"
    }
    "navigation" = {
      instance_type = "t3.micro"
      port          = 8082
      description   = "Navigation and guidance systems"
    }
    "communications" = {
      instance_type = "t3.micro"
      port          = 8083
      description   = "Communication systems"
    }
  }
  
  # Create a list of all module names
  module_names = keys(local.space_modules)
  
  # Common tags for all resources
  common_tags = {
    Project     = "Space-Station"
    Environment = "learning"
    ManagedBy   = "Terraform"
    Owner       = "Space-Architect"
  }
}

# =============================================================================
# 🌐 VPC AND NETWORKING
# =============================================================================

# Create VPC for our space station
resource "aws_vpc" "space_station" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "Space-Station-VPC"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "space_station" {
  vpc_id = aws_vpc.space_station.id

  tags = merge(local.common_tags, {
    Name = "Space-Station-IGW"
  })
}

# Public Subnets (using for_each - advanced feature!)
resource "aws_subnet" "public" {
  for_each = toset(data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.space_station.id
  cidr_block              = "10.0.${index(data.aws_availability_zones.available.names, each.key) + 1}.0/24"
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "Space-Station-Public-${each.key}"
    Type = "Public"
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = toset(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.space_station.id
  cidr_block        = "10.0.${index(data.aws_availability_zones.available.names, each.key) + 10}.0/24"
  availability_zone = each.key

  tags = merge(local.common_tags, {
    Name = "Space-Station-Private-${each.key}"
    Type = "Private"
  })
}

# =============================================================================
# 🔒 SECURITY GROUPS (DYNAMIC BLOCKS!)
# =============================================================================

# Security group for space station modules
resource "aws_security_group" "space_station" {
  name_prefix = "space-station-"
  description = "Security group for space station modules"
  vpc_id      = aws_vpc.space_station.id

  # Dynamic ingress blocks for each module port
  dynamic "ingress" {
    for_each = local.space_modules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow access to ${ingress.key} module"
    }
  }

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(local.common_tags, {
    Name = "Space-Station-SG"
  })
}

# =============================================================================
# 🚀 SPACE STATION MODULES (FOR_EACH LOOP!)
# =============================================================================

# Create EC2 instances for each space station module
resource "aws_instance" "space_modules" {
  for_each = local.space_modules

  ami           = data.aws_ami.amazon_linux.id
  instance_type = each.value.instance_type
  subnet_id     = values(aws_subnet.public)[0].id  # Use first public subnet

  vpc_security_group_ids = [aws_security_group.space_station.id]

  # User data script for each module
  user_data = base64encode(templatefile("${path.module}/user_data/${each.key}.sh", {
    module_name = each.key
    port        = each.value.port
    description = each.value.description
  }))

  tags = merge(local.common_tags, {
    Name        = "Space-Station-${title(each.key)}"
    Module      = each.key
    Port        = each.value.port
    Description = each.value.description
  })
}

# =============================================================================
# 🗄️ DATABASE FOR SPACE STATION DATA
# =============================================================================

# RDS Subnet Group
resource "aws_db_subnet_group" "space_station" {
  name       = "space-station-db-subnet-group"
  subnet_ids = values(aws_subnet.private)[*].id

  tags = merge(local.common_tags, {
    Name = "Space-Station-DB-Subnet-Group"
  })
}

# RDS Instance
resource "aws_db_instance" "space_station" {
  identifier = "space-station-db"
  
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true
  
  db_name  = "spacestation"
  username = "spaceadmin"
  password = random_password.db_password.result
  
  vpc_security_group_ids = [aws_security_group.space_station.id]
  db_subnet_group_name   = aws_db_subnet_group.space_station.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
  deletion_protection = false

  tags = merge(local.common_tags, {
    Name = "Space-Station-Database"
  })
}

# =============================================================================
# 🔐 SECURITY AND RANDOM VALUES
# =============================================================================

# Generate random password for database
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# =============================================================================
# 📊 CLOUDWATCH MONITORING
# =============================================================================

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "space_station" {
  name              = "/aws/space-station/application"
  retention_in_days = 14

  tags = local.common_tags
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "space_station" {
  dashboard_name = "Space-Station-Dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            for module_name in local.module_names : [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              aws_instance.space_modules[module_name].id
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Space Station Module CPU Usage"
        }
      }
    ]
  })
}

# =============================================================================
# 📤 OUTPUTS
# =============================================================================

# Output information about our space station
output "space_station_info" {
  description = "Information about the space station modules"
  value = {
    vpc_id = aws_vpc.space_station.id
    modules = {
      for name, instance in aws_instance.space_modules : name => {
        instance_id = instance.id
        public_ip   = instance.public_ip
        private_ip  = instance.private_ip
        port        = local.space_modules[name].port
        description = local.space_modules[name].description
      }
    }
    database_endpoint = aws_db_instance.space_station.endpoint
    dashboard_url     = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.space_station.dashboard_name}"
  }
}

# Output the space station access URLs
output "space_station_urls" {
  description = "URLs to access space station modules"
  value = {
    for name, instance in aws_instance.space_modules : name => "http://${instance.public_ip}:${local.space_modules[name].port}"
  }
}
