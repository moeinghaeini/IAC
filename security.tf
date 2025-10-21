# =============================================================================
# SECURITY BEST PRACTICES
# =============================================================================
# This file contains security configurations and best practices for the project

# =============================================================================
# S3 BUCKET SECURITY
# =============================================================================

# Enable S3 bucket versioning for data protection
resource "aws_s3_bucket_versioning" "main" {
  count  = var.enable_s3_versioning ? 1 : 0
  bucket = aws_s3_bucket.main[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable S3 bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  count  = var.enable_s3_encryption ? 1 : 0
  bucket = aws_s3_bucket.main[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# =============================================================================
# SECURITY GROUP IMPROVEMENTS
# =============================================================================

# Default security group with restrictive rules
resource "aws_security_group" "default" {
  count       = var.create_default_security_group ? 1 : 0
  name_prefix = "${var.project_name}-default-"
  description = "Default security group with restrictive rules"
  vpc_id      = var.vpc_id

  # Allow HTTP traffic (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidrs
    description = "HTTP traffic"
  }

  # Allow HTTPS traffic (port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_https_cidrs
    description = "HTTPS traffic"
  }

  # Allow SSH access (port 22) - restrict to specific IPs
  dynamic "ingress" {
    for_each = var.allowed_ssh_cidrs
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "SSH access"
    }
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.additional_tags, {
    Name = "${var.project_name}-default-sg"
  })
}

# =============================================================================
# IAM ROLES AND POLICIES
# =============================================================================

# IAM role for EC2 instances with minimal permissions
resource "aws_iam_role" "ec2_role" {
  count = var.create_ec2_role ? 1 : 0
  name  = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.additional_tags, {
    Name = "${var.project_name}-ec2-role"
  })
}

# IAM instance profile for EC2 instances
resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.create_ec2_role ? 1 : 0
  name  = "${var.project_name}-ec2-profile"
  role  = aws_iam_role.ec2_role[0].name

  tags = merge(var.additional_tags, {
    Name = "${var.project_name}-ec2-profile"
  })
}

# IAM policy for S3 read-only access
resource "aws_iam_policy" "s3_readonly" {
  count = var.create_s3_readonly_policy ? 1 : 0
  name  = "${var.project_name}-s3-readonly"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.project_name}-*",
          "arn:aws:s3:::${var.project_name}-*/*"
        ]
      }
    ]
  })

  tags = merge(var.additional_tags, {
    Name = "${var.project_name}-s3-readonly-policy"
  })
}

# Attach S3 read-only policy to EC2 role
resource "aws_iam_role_policy_attachment" "ec2_s3_readonly" {
  count      = var.create_ec2_role && var.create_s3_readonly_policy ? 1 : 0
  role       = aws_iam_role.ec2_role[0].name
  policy_arn = aws_iam_policy.s3_readonly[0].arn
}

# =============================================================================
# CLOUDWATCH LOGGING
# =============================================================================

# CloudWatch log group for application logs
resource "aws_cloudwatch_log_group" "main" {
  count             = var.enable_cloudwatch_logging ? 1 : 0
  name              = "/aws/${var.project_name}/application"
  retention_in_days = var.log_retention_days

  tags = merge(var.additional_tags, {
    Name = "${var.project_name}-log-group"
  })
}

# =============================================================================
# BACKUP AND DISASTER RECOVERY
# =============================================================================

# S3 bucket for backups
resource "aws_s3_bucket" "backup" {
  count  = var.enable_backup ? 1 : 0
  bucket = "${var.project_name}-backup-${random_id.backup_suffix[0].hex}"

  tags = merge(var.additional_tags, {
    Name        = "${var.project_name}-backup"
    Purpose     = "Backup"
    Environment = var.environment
  })
}

# Random ID for backup bucket suffix
resource "random_id" "backup_suffix" {
  count       = var.enable_backup ? 1 : 0
  byte_length = 4
}

# S3 bucket lifecycle configuration for backups
resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  count  = var.enable_backup ? 1 : 0
  bucket = aws_s3_bucket.backup[0].id

  rule {
    id     = "backup_lifecycle"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    transition {
      days          = 365
      storage_class = "DEEP_ARCHIVE"
    }
  }
}
