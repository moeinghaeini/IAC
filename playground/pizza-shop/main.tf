# =============================================================================
# 🍕 TONY'S PIZZA SHOP - SIMPLE WEBSITE FOR KIDS! 🍕
# =============================================================================
# This file creates a simple pizza shop website that kids can understand!

# First, we need to tell Terraform what tools to use
terraform {
  required_version = ">= 1.9"
  
  required_providers {
    # AWS is like a giant computer playground in the cloud!
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
    # Random provider for creating unique names
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Configure AWS (our cloud playground)
provider "aws" {
  region = "us-west-2"  # This is like choosing which playground to use
  
  # These tags are like name tags on your toys
  default_tags {
    tags = {
      Project     = "Tonys-Pizza-Shop"
      Environment = "learning"
      ManagedBy   = "Terraform"
      Owner       = "Little-Chef"
    }
  }
}

# =============================================================================
# 📋 DATA SOURCES (FINDING EXISTING THINGS) 📋
# =============================================================================
# Data sources help us find existing AWS resources instead of hardcoding them

# Find the latest Amazon Linux 2 AMI
# This is like asking "What's the newest version of Amazon Linux?"
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

# =============================================================================
# 🌐 CREATE A SIMPLE WEBSITE (S3 BUCKET) 🌐
# =============================================================================
# S3 is like a giant filing cabinet in the cloud where we can store our website files

resource "aws_s3_bucket" "pizza_website" {
  # This creates a unique name for our pizza shop website
  bucket = "tonys-pizza-shop-${random_id.bucket_suffix.hex}"
  
  tags = {
    Name        = "Tony's Pizza Shop Website"
    Description = "A fun pizza shop website for learning!"
  }
}

# This creates a random suffix to make our bucket name unique
# It's like adding your initials to your school supplies!
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Make our website accessible to everyone on the internet
# This is like putting a "Welcome" sign outside our pizza shop!
resource "aws_s3_bucket_public_access_block" "pizza_website" {
  bucket = aws_s3_bucket.pizza_website.id

  block_public_acls       = false  # Allow people to see our website
  block_public_policy     = false  # Allow public access
  ignore_public_acls      = false  # Don't ignore public settings
  restrict_public_buckets = false  # Don't restrict public access
}

# Create a policy that allows everyone to read our website
# This is like saying "Everyone is welcome to visit our pizza shop!"
resource "aws_s3_bucket_policy" "pizza_website" {
  bucket = aws_s3_bucket.pizza_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"  # This means "everyone"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.pizza_website.arn}/*"
      }
    ]
  })
}

# Configure our website to show an index.html file
# This is like putting a "Welcome" sign at the front door!
resource "aws_s3_bucket_website_configuration" "pizza_website" {
  bucket = aws_s3_bucket.pizza_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# =============================================================================
# 🖥️ CREATE A SIMPLE COMPUTER (EC2 INSTANCE) 🖥️
# =============================================================================
# EC2 is like renting a computer in the cloud to run our pizza shop app

# First, we need to create a security group (like a bouncer at a club!)
# It decides who can talk to our computer and who can't
resource "aws_security_group" "pizza_server" {
  name_prefix = "pizza-server-"
  description = "Security group for Tony's Pizza Shop server"

  # Allow people to visit our website (port 80 is for websites)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # This means "everyone on the internet"
    description = "Allow HTTP traffic to our pizza website"
  }

  # Allow secure website traffic (port 443 is for secure websites)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic to our pizza website"
  }

  # Allow our computer to talk to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # This means "all protocols"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "Tony's Pizza Shop Security Group"
  }
}

# Create our pizza shop computer
resource "aws_instance" "pizza_server" {
  # Use a free tier eligible instance (t3.micro is free for new AWS accounts!)
  ami           = data.aws_ami.amazon_linux.id  # This automatically finds the latest Amazon Linux
  instance_type = "t3.micro"                    # This is like choosing how powerful the computer is

  # Attach our security group
  vpc_security_group_ids = [aws_security_group.pizza_server.id]

  # Add some tags to identify our computer
  tags = {
    Name        = "Tony's Pizza Shop Server"
    Description = "The computer that runs our pizza shop website"
  }

  # This script runs when the computer starts up
  # It's like giving the computer instructions on what to do when it wakes up!
  user_data = <<-EOF
              #!/bin/bash
              # Update the system
              yum update -y
              
              # Install a web server (Apache)
              yum install -y httpd
              
              # Start the web server
              systemctl start httpd
              systemctl enable httpd
              
              # Create a simple pizza shop webpage
              cat > /var/www/html/index.html << 'EOL'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>🍕 Tony's Pizza Shop 🍕</title>
                  <style>
                      body { 
                          font-family: Arial, sans-serif; 
                          text-align: center; 
                          background-color: #ffeb3b; 
                          color: #d32f2f;
                      }
                      .pizza { font-size: 4em; }
                      .menu { 
                          background-color: white; 
                          padding: 20px; 
                          margin: 20px; 
                          border-radius: 10px;
                          box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                      }
                  </style>
              </head>
              <body>
                  <h1 class="pizza">🍕</h1>
                  <h1>Welcome to Tony's Pizza Shop!</h1>
                  <p>We make the best pizza in town! 🍕</p>
                  
                  <div class="menu">
                      <h2>Our Menu:</h2>
                      <p>🍕 Margherita Pizza - $12.99</p>
                      <p>🍕 Pepperoni Pizza - $14.99</p>
                      <p>🍕 Veggie Supreme - $16.99</p>
                      <p>🍕 Meat Lovers - $18.99</p>
                  </div>
                  
                  <div class="menu">
                      <h2>Call us to order!</h2>
                      <p>📞 (555) PIZZA-1</p>
                      <p>🚚 Free delivery within 5 miles!</p>
                  </div>
                  
                  <p><em>Built with Terraform by a little cloud architect! 🌟</em></p>
              </body>
              </html>
              EOL
              EOF
}
