# =============================================================================
# 🎨 DIGITAL ART GALLERY - BEAUTIFUL WEBSITE FOR KIDS! 🎨
# =============================================================================
# This file creates a beautiful art gallery website that kids can understand!

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
      Project     = "Digital-Art-Gallery"
      Environment = "learning"
      ManagedBy   = "Terraform"
      Owner       = "Little-Artist"
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
# 🌐 CREATE A BEAUTIFUL ART GALLERY WEBSITE (S3 BUCKET) 🌐
# =============================================================================
# S3 is like a giant filing cabinet in the cloud where we can store our website files

resource "aws_s3_bucket" "art_gallery" {
  # This creates a unique name for our art gallery website
  bucket = "digital-art-gallery-${random_id.bucket_suffix.hex}"
  
  tags = {
    Name        = "Digital Art Gallery"
    Description = "A beautiful art gallery website for showcasing digital art!"
  }
}

# This creates a random suffix to make our bucket name unique
# It's like adding your initials to your school supplies!
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Make our art gallery accessible to everyone on the internet
# This is like putting a "Welcome" sign outside our gallery!
resource "aws_s3_bucket_public_access_block" "art_gallery" {
  bucket = aws_s3_bucket.art_gallery.id

  block_public_acls       = false  # Allow people to see our gallery
  block_public_policy     = false  # Allow public access
  ignore_public_acls      = false  # Don't ignore public settings
  restrict_public_buckets = false  # Don't restrict public access
}

# Create a policy that allows everyone to read our art gallery
# This is like saying "Everyone is welcome to visit our gallery!"
resource "aws_s3_bucket_policy" "art_gallery" {
  bucket = aws_s3_bucket.art_gallery.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"  # This means "everyone"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.art_gallery.arn}/*"
      }
    ]
  })
}

# Configure our website to show an index.html file
# This is like putting a "Welcome" sign at the front door!
resource "aws_s3_bucket_website_configuration" "art_gallery" {
  bucket = aws_s3_bucket.art_gallery.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# =============================================================================
# 🖼️ CREATE A PLACE TO STORE ARTWORK (S3 BUCKET FOR IMAGES) 🖼️
# =============================================================================
# This is a separate storage area just for artwork images

resource "aws_s3_bucket" "artwork_storage" {
  bucket = "artwork-storage-${random_id.bucket_suffix.hex}"
  
  tags = {
    Name        = "Artwork Storage"
    Description = "Where we store all the beautiful artwork!"
  }
}

# Make artwork storage accessible for viewing
resource "aws_s3_bucket_public_access_block" "artwork_storage" {
  bucket = aws_s3_bucket.artwork_storage.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Allow people to view the artwork
resource "aws_s3_bucket_policy" "artwork_storage" {
  bucket = aws_s3_bucket.artwork_storage.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.artwork_storage.arn}/*"
      }
    ]
  })
}

# =============================================================================
# 🖥️ CREATE A GALLERY SERVER (EC2 INSTANCE) 🖥️
# =============================================================================
# This computer will run our art gallery application

# Create a security group for our gallery server
resource "aws_security_group" "gallery_server" {
  name_prefix = "gallery-server-"
  description = "Security group for Digital Art Gallery server"

  # Allow people to visit our gallery website (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic to our art gallery"
  }

  # Allow secure website traffic (port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic to our art gallery"
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
    Name = "Art Gallery Security Group"
  }
}

# Create our art gallery computer
resource "aws_instance" "gallery_server" {
  # Use a free tier eligible instance
  ami           = data.aws_ami.amazon_linux.id  # Automatically find latest Amazon Linux
  instance_type = "t3.micro"

  # Attach our security group
  vpc_security_group_ids = [aws_security_group.gallery_server.id]

  # Add some tags to identify our computer
  tags = {
    Name        = "Digital Art Gallery Server"
    Description = "The computer that runs our beautiful art gallery"
  }

  # This script runs when the computer starts up
  # It creates a beautiful art gallery webpage!
  user_data = <<-EOF
              #!/bin/bash
              # Update the system
              yum update -y
              
              # Install a web server (Apache)
              yum install -y httpd
              
              # Start the web server
              systemctl start httpd
              systemctl enable httpd
              
              # Create a beautiful art gallery webpage
              cat > /var/www/html/index.html << 'EOL'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>🎨 Digital Art Gallery 🎨</title>
                  <style>
                      body { 
                          font-family: 'Arial', sans-serif; 
                          text-align: center; 
                          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                          color: white;
                          margin: 0;
                          padding: 20px;
                      }
                      .gallery { 
                          background-color: rgba(255,255,255,0.1); 
                          padding: 30px; 
                          margin: 20px; 
                          border-radius: 15px;
                          backdrop-filter: blur(10px);
                          box-shadow: 0 8px 32px rgba(0,0,0,0.1);
                      }
                      .art-piece {
                          background-color: rgba(255,255,255,0.2);
                          margin: 20px;
                          padding: 20px;
                          border-radius: 10px;
                          display: inline-block;
                          width: 200px;
                      }
                      .emoji { font-size: 3em; margin: 10px; }
                      h1 { font-size: 3em; margin-bottom: 20px; }
                      h2 { color: #ffeb3b; }
                  </style>
              </head>
              <body>
                  <h1>🎨 Digital Art Gallery 🎨</h1>
                  <p>Welcome to our beautiful collection of digital masterpieces!</p>
                  
                  <div class="gallery">
                      <h2>🌟 Featured Artwork 🌟</h2>
                      
                      <div class="art-piece">
                          <div class="emoji">🌅</div>
                          <h3>Sunset Dreams</h3>
                          <p>By: Little Artist</p>
                      </div>
                      
                      <div class="art-piece">
                          <div class="emoji">🌺</div>
                          <h3>Garden of Colors</h3>
                          <p>By: Little Artist</p>
                      </div>
                      
                      <div class="art-piece">
                          <div class="emoji">🦋</div>
                          <h3>Butterfly Dance</h3>
                          <p>By: Little Artist</p>
                      </div>
                      
                      <div class="art-piece">
                          <div class="emoji">🌈</div>
                          <h3>Rainbow Bridge</h3>
                          <p>By: Little Artist</p>
                      </div>
                  </div>
                  
                  <div class="gallery">
                      <h2>🎨 Gallery Information 🎨</h2>
                      <p>📍 Location: Cloud Gallery</p>
                      <p>🕒 Hours: Always Open (24/7)</p>
                      <p>🎫 Admission: Free for Everyone!</p>
                      <p>📧 Contact: gallery@cloud.com</p>
                  </div>
                  
                  <p><em>Built with Terraform by a little cloud architect! 🌟</em></p>
              </body>
              </html>
              EOL
              EOF
}
