# =============================================================================
# 🚀 SPACE STATION - ADVANCED MULTI-SERVICE ARCHITECTURE! 🚀
# =============================================================================
# This creates a complex space station with multiple services and load balancing!

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
# 🌌 VPC AND NETWORKING
# =============================================================================

# Create VPC for our space station
resource "aws_vpc" "space_station" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Space Station VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "space_station" {
  vpc_id = aws_vpc.space_station.id

  tags = {
    Name = "Space Station IGW"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count = 3

  vpc_id                  = aws_vpc.space_station.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Space Station Public Subnet ${count.index + 1}"
    Type = "Public"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = 3

  vpc_id            = aws_vpc.space_station.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Space Station Private Subnet ${count.index + 1}"
    Type = "Private"
  }
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# =============================================================================
# 🚀 LOAD BALANCER
# =============================================================================

# Application Load Balancer
resource "aws_lb" "space_station" {
  name               = "space-station-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = {
    Name = "Space Station Load Balancer"
  }
}

# Target Group for web servers
resource "aws_lb_target_group" "web_servers" {
  name     = "space-station-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.space_station.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Space Station Web Servers"
  }
}

# Load Balancer Listener
resource "aws_lb_listener" "space_station" {
  load_balancer_arn = aws_lb.space_station.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_servers.arn
  }
}

# =============================================================================
# 🛡️ SECURITY GROUPS
# =============================================================================

# ALB Security Group
resource "aws_security_group" "alb" {
  name_prefix = "space-station-alb-"
  vpc_id      = aws_vpc.space_station.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "Space Station ALB Security Group"
  }
}

# Web Server Security Group
resource "aws_security_group" "web_servers" {
  name_prefix = "space-station-web-"
  vpc_id      = aws_vpc.space_station.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "HTTP from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "Space Station Web Servers Security Group"
  }
}

# Database Security Group
resource "aws_security_group" "database" {
  name_prefix = "space-station-db-"
  vpc_id      = aws_vpc.space_station.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_servers.id]
    description     = "MySQL from web servers"
  }

  tags = {
    Name = "Space Station Database Security Group"
  }
}

# =============================================================================
# 🖥️ AUTO SCALING GROUP
# =============================================================================

# Launch Template
resource "aws_launch_template" "space_station" {
  name_prefix   = "space-station-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web_servers.id]

  user_data = base64encode(<<-EOF
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
                      .warning { color: #ffff00; }
                      .critical { color: #ff0000; }
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
                      
                      <div class="status">
                          <h2>🔬 Research Projects</h2>
                          <p class="system">🧪 Alien Life Forms: In Progress</p>
                          <p class="system">🌌 Dark Matter Study: Active</p>
                          <p class="system">🚀 Advanced Propulsion: Testing</p>
                      </div>
                      
                      <p><em>Built with Terraform by a space architect! 🌟</em></p>
                  </div>
              </body>
              </html>
              EOL
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Space Station Web Server"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "space_station" {
  name                = "space-station-asg"
  vpc_zone_identifier = aws_subnet.private[*].id
  target_group_arns   = [aws_lb_target_group.web_servers.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 300

  min_size         = 2
  max_size         = 6
  desired_capacity = 3

  launch_template {
    id      = aws_launch_template.space_station.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Space Station Web Server"
    propagate_at_launch = true
  }
}

# Auto Scaling Policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "space-station-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.space_station.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "space-station-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.space_station.name
}

# =============================================================================
# 🗄️ DATABASE
# =============================================================================

# RDS Subnet Group
resource "aws_db_subnet_group" "space_station" {
  name       = "space-station-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "Space Station DB Subnet Group"
  }
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
  
  db_name  = "spacestation"
  username = "admin"
  password = "SpaceStation2024!"
  
  vpc_security_group_ids = [aws_security_group.database.id]
  db_subnet_group_name   = aws_db_subnet_group.space_station.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
  
  tags = {
    Name = "Space Station Database"
  }
}

# =============================================================================
# 📊 MONITORING
# =============================================================================

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "space_station" {
  dashboard_name = "space-station-dashboard"

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
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.space_station.arn_suffix],
            [".", "RequestCount", ".", "."],
            [".", "HTTPCode_Target_2XX_Count", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = "us-west-2"
          title   = "🚀 Space Station Performance"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", aws_autoscaling_group.space_station.name],
            [".", "GroupInServiceInstances", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = "us-west-2"
          title   = "🔄 Auto Scaling Status"
          period  = 300
        }
      }
    ]
  })
}

# =============================================================================
# 📦 S3 BUCKET FOR DATA STORAGE
# =============================================================================

resource "aws_s3_bucket" "space_station_data" {
  bucket = "space-station-data-${random_id.bucket_suffix.hex}"

  tags = {
    Name = "Space Station Data Storage"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
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