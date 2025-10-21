# 🚀 Space Station - Advanced Terraform Example 🚀

Welcome to the most advanced example in our Terraform learning adventure! This space station demonstrates cutting-edge Terraform features and AWS best practices.

## 🌟 What You'll Learn

This example teaches you about:

- **Advanced Terraform Features**:
  - `for_each` loops for dynamic resource creation
  - `dynamic` blocks for flexible configurations
  - `locals` for complex expressions and reusability
  - `templatefile()` for dynamic user data scripts
  - `data` sources for finding existing resources

- **AWS Best Practices**:
  - Multi-AZ deployments for high availability
  - Proper VPC and subnet design
  - Security groups with dynamic rules
  - RDS with encryption and backups
  - CloudWatch monitoring and dashboards

- **Infrastructure Patterns**:
  - Modular architecture with multiple services
  - Database integration
  - Monitoring and observability
  - Secure networking

## 🏗️ Architecture

The space station consists of:

1. **Command Center** - Main control hub (t3.small)
2. **Life Support** - Environmental monitoring (t3.micro)
3. **Navigation** - Guidance systems (t3.micro)
4. **Communications** - Inter-station comms (t3.micro)
5. **Database** - MySQL RDS for data storage
6. **Monitoring** - CloudWatch dashboard

## 🚀 Getting Started

### Prerequisites

- Terraform >= 1.9
- AWS CLI configured
- Basic understanding of Terraform concepts

### Deployment

```bash
# Navigate to the space station directory
cd playground/space-station/

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Deploy the space station
terraform apply
```

### Accessing Your Space Station

After deployment, you'll get URLs for each module:
- Command Center: `http://<ip>:8080`
- Life Support: `http://<ip>:8081`
- Navigation: `http://<ip>:8082`
- Communications: `http://<ip>:8083`

## 🔧 Advanced Features Demonstrated

### 1. Dynamic Resource Creation with `for_each`

```hcl
resource "aws_instance" "space_modules" {
  for_each = local.space_modules
  
  ami           = data.aws_ami.amazon_linux.id
  instance_type = each.value.instance_type
  # ... other configuration
}
```

### 2. Dynamic Security Group Rules

```hcl
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
```

### 3. Complex Local Values

```hcl
locals {
  space_modules = {
    "command-center" = {
      instance_type = "t3.small"
      port          = 8080
      description   = "Main command and control center"
    }
    # ... more modules
  }
}
```

## 💰 Cost Considerations

This example creates:
- 4 EC2 instances (1 t3.small, 3 t3.micro)
- 1 RDS MySQL instance (db.t3.micro)
- VPC, subnets, security groups
- CloudWatch resources

**Estimated monthly cost**: $15-25 (depending on usage)

## 🧹 Cleanup

When you're done exploring:

```bash
terraform destroy
```

This will remove all resources and stop any costs.

## 🎓 Learning Objectives

After completing this example, you should understand:

1. How to use `for_each` for dynamic resource creation
2. How to create flexible configurations with `dynamic` blocks
3. How to organize complex configurations with `locals`
4. How to integrate multiple AWS services
5. How to implement monitoring and observability
6. How to follow AWS best practices for security and reliability

## 🚀 Next Steps

- Try modifying the `space_modules` local to add new modules
- Experiment with different instance types
- Add more monitoring and alerting
- Create your own advanced Terraform project!

Happy building, Space Architect! 🌟
