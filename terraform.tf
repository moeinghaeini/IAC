# =============================================================================
# TERRAFORM CONFIGURATION BLOCK
# =============================================================================
# This block defines the Terraform version requirements and provider dependencies.
# It's essential for ensuring consistent deployments across different environments.

terraform {
  # Specify the minimum Terraform version required
  # This ensures everyone uses a compatible version
  required_version = ">= 1.9"
  
  # Define required providers and their versions
  # Using version constraints helps maintain stability
  required_providers {
    # AWS Provider - manages AWS resources
    aws = {
      source  = "hashicorp/aws"  # Official HashiCorp AWS provider
      version = "~> 5.80"        # Use version 5.80+ (allows patch updates)
    }
    
    # Random Provider - generates random values
    # Useful for creating unique resource names or passwords
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"         # Use version 3.6+ (latest stable)
    }
  }
}

# =============================================================================
# AWS PROVIDER CONFIGURATION
# =============================================================================
# This configures how Terraform interacts with AWS services

provider "aws" {
  # AWS region where resources will be created
  # Can be overridden with environment variables or CLI flags
  region = var.aws_region
  
  # Default tags applied to ALL resources created by this provider
  # This is a best practice for resource management and cost tracking
  default_tags {
    tags = {
      Project     = var.project_name    # Identifies which project owns the resource
      Environment = var.environment     # Distinguishes between dev/staging/prod
      ManagedBy   = "Terraform"         # Indicates infrastructure as code
      Owner       = var.owner           # Who is responsible for the resource
    }
  }
}
