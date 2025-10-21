# =============================================================================
# 🚀 SPACE STATION - SIMPLE WEBSITE FOR KIDS! 🚀
# =============================================================================
# This creates a fun space station website that kids can understand!

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

provider "aws" {
  region = "us-west-2"
  
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
# 🌌 CREATE A SPACE STATION WEBSITE (S3 BUCKET)
# =============================================================================

resource "aws_s3_bucket" "space_station" {
  bucket = "space-station-${random_id.bucket_suffix.hex}"
  
  tags = {
    Name = "Space Station Website"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Make our space station accessible to everyone
resource "aws_s3_bucket_public_access_block" "space_station" {
  bucket = aws_s3_bucket.space_station.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Allow everyone to visit our space station
resource "aws_s3_bucket_policy" "space_station" {
  bucket = aws_s3_bucket.space_station.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.space_station.arn}/*"
      }
    ]
  })
}

# Configure our space station website
resource "aws_s3_bucket_website_configuration" "space_station" {
  bucket = aws_s3_bucket.space_station.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# =============================================================================
# 🖥️ CREATE A SPACE STATION COMPUTER (EC2 INSTANCE)
# =============================================================================

# Security group for our space station
resource "aws_security_group" "space_station" {
  name_prefix = "space-station-"
  description = "Security group for Space Station server"

  # Allow people to visit our space station (port 80 is for websites)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic to our space station"
  }

  # Allow secure website traffic (port 443 is for secure websites)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic to our space station"
  }

  # Allow our computer to talk to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "Space Station Security Group"
  }
}

# Create our space station computer
resource "aws_instance" "space_station" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.space_station.id]

  tags = {
    Name = "Space Station Server"
  }

  # This script runs when the computer starts up
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              
              # Create space station webpage
              cat > /var/www/html/index.html << 'EOL'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>🚀 Space Station Control Center 🚀</title>
                  <style>
                      body { 
                          font-family: 'Courier New', monospace; 
                          text-align: center; 
                          background: linear-gradient(45deg, #0a0a0a, #1a1a2e, #16213e);
                          color: #00ffff;
                          margin: 0;
                          padding: 20px;
                      }
                      .container {
                          max-width: 1200px;
                          margin: 0 auto;
                          background: rgba(0,0,0,0.8);
                          padding: 30px;
                          border-radius: 15px;
                          border: 2px solid #00ffff;
                      }
                      .header { font-size: 3em; margin-bottom: 20px; }
                      .status { 
                          background: rgba(0,255,255,0.1); 
                          padding: 15px; 
                          margin: 10px; 
                          border-radius: 10px;
                          border: 1px solid #00ffff;
                      }
                      .system { color: #00ff00; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1 class="header">🚀 Space Station Control Center 🚀</h1>
                      
                      <div class="status">
                          <h2>🌌 Station Status</h2>
                          <p class="system">✅ Life Support Systems: OPERATIONAL</p>
                          <p class="system">✅ Navigation Systems: OPERATIONAL</p>
                          <p class="system">✅ Communication Array: OPERATIONAL</p>
                          <p class="system">✅ Power Grid: OPERATIONAL</p>
                      </div>
                      
                      <div class="status">
                          <h2>👨‍🚀 Crew Status</h2>
                          <p class="system">👨‍🚀 Captain: On Duty</p>
                          <p class="system">👩‍🚀 Engineer: Monitoring Systems</p>
                          <p class="system">👨‍🚀 Navigator: Charting Course</p>
                      </div>
                      
                      <div class="status">
                          <h2>🛰️ Mission Status</h2>
                          <p class="system">🎯 Current Mission: Deep Space Exploration</p>
                          <p class="system">📍 Location: Alpha Centauri System</p>
                          <p class="system">⏰ Mission Duration: 2.5 years</p>
                      </div>
                      
                      <p><em>Built with Terraform by a space architect! 🌟</em></p>
                  </div>
              </body>
              </html>
              EOL
              EOF
}

# =============================================================================
# 📋 DATA SOURCES
# =============================================================================

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