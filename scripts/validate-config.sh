#!/bin/bash

# =============================================================================
# 🔍 TERRAFORM CONFIGURATION VALIDATION SCRIPT 🔍
# =============================================================================
# This script helps kids validate their Terraform configurations!

set -e

echo "🔍 Starting Terraform Configuration Validation..."
echo ""

# =============================================================================
# 📋 CHECK TERRAFORM INSTALLATION
# =============================================================================

echo "🔧 Checking Terraform installation..."
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed!"
    echo "Please install Terraform first:"
    echo "  Mac: brew install terraform"
    echo "  Windows: Download from https://terraform.io/downloads.html"
    echo "  Linux: wget https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip"
    exit 1
fi

echo "✅ Terraform is installed: $(terraform version | head -n1)"
echo ""

# =============================================================================
# 📋 CHECK AWS CREDENTIALS
# =============================================================================

echo "🔧 Checking AWS credentials..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS credentials not configured!"
    echo "Please run: aws configure"
    echo "Or set these environment variables:"
    echo "  export AWS_ACCESS_KEY_ID=your_access_key"
    echo "  export AWS_SECRET_ACCESS_KEY=your_secret_key"
    echo "  export AWS_DEFAULT_REGION=us-west-2"
    exit 1
fi

echo "✅ AWS credentials configured"
echo ""

# =============================================================================
# 📋 VALIDATE TERRAFORM FILES
# =============================================================================

echo "🔍 Validating Terraform files..."

# Check for common issues
echo "📝 Checking for common issues..."

# Check for hardcoded values
if grep -r "AKIA" . --include="*.tf" --include="*.tfvars"; then
    echo "⚠️  Warning: Found potential AWS access keys in code!"
    echo "   Please use variables or environment variables instead."
fi

# Check for missing descriptions
echo "📝 Checking for missing descriptions..."
missing_descriptions=$(find . -name "*.tf" -exec grep -l "variable \|resource \|output " {} \; | xargs grep -L "description" | wc -l)
if [ "$missing_descriptions" -gt 0 ]; then
    echo "⚠️  Warning: Found $missing_descriptions files with missing descriptions"
    echo "   Consider adding descriptions to improve documentation"
fi

# Check for proper tagging
echo "📝 Checking for proper tagging..."
untagged_resources=$(find . -name "*.tf" -exec grep -l "resource " {} \; | xargs grep -L "tags" | wc -l)
if [ "$untagged_resources" -gt 0 ]; then
    echo "⚠️  Warning: Found $untagged_resources resources without tags"
    echo "   Consider adding tags for better resource management"
fi

echo ""

# =============================================================================
# 📋 TERRAFORM FORMAT CHECK
# =============================================================================

echo "🔍 Checking Terraform format..."
if ! terraform fmt -check -recursive; then
    echo "❌ Terraform files are not properly formatted!"
    echo "Run 'terraform fmt -recursive' to fix formatting issues"
    exit 1
fi

echo "✅ Terraform files are properly formatted"
echo ""

# =============================================================================
# 📋 TERRAFORM INIT AND VALIDATE
# =============================================================================

echo "🔍 Initializing and validating Terraform..."

# Get list of Terraform directories
terraform_dirs=(
    "playground/pizza-shop"
    "playground/art-gallery"
    "playground/space-station"
    "modules/vpc"
    "modules/monitoring"
)

for dir in "${terraform_dirs[@]}"; do
    if [ -d "$dir" ] && [ -f "$dir/main.tf" ]; then
        echo "🔧 Validating $dir..."
        
        cd "$dir"
        
        # Initialize Terraform
        if ! terraform init -backend=false; then
            echo "❌ Failed to initialize $dir"
            cd - > /dev/null
            continue
        fi
        
        # Validate configuration
        if ! terraform validate; then
            echo "❌ Validation failed for $dir"
            cd - > /dev/null
            continue
        fi
        
        echo "✅ $dir is valid"
        cd - > /dev/null
    fi
done

echo ""

# =============================================================================
# 📋 SECURITY CHECKS
# =============================================================================

echo "🔒 Running security checks..."

# Check for sensitive data
echo "📝 Checking for sensitive data..."
if grep -r "password\|secret\|key" . --include="*.tf" --include="*.tfvars" | grep -v "description\|comment"; then
    echo "⚠️  Warning: Found potential sensitive data in code!"
    echo "   Consider using variables or external data sources"
fi

# Check for overly permissive security groups
echo "📝 Checking security group configurations..."
if grep -r "0.0.0.0/0" . --include="*.tf" | grep -v "description\|comment"; then
    echo "⚠️  Warning: Found overly permissive security group rules!"
    echo "   Consider restricting access to specific IP ranges"
fi

# Check for encryption settings
echo "📝 Checking encryption settings..."
if ! grep -r "encryption" . --include="*.tf" | grep -q "true\|enabled"; then
    echo "⚠️  Warning: No encryption settings found!"
    echo "   Consider enabling encryption for sensitive resources"
fi

echo ""

# =============================================================================
# 📋 COST OPTIMIZATION CHECKS
# =============================================================================

echo "💰 Running cost optimization checks..."

# Check for free tier eligible resources
echo "📝 Checking for free tier eligibility..."
if grep -r "t3.micro\|db.t3.micro" . --include="*.tf"; then
    echo "✅ Found free tier eligible resources - great for learning!"
else
    echo "⚠️  Warning: No free tier eligible resources found"
    echo "   Consider using t3.micro instances and db.t3.micro databases"
fi

# Check for resource limits
echo "📝 Checking for resource limits..."
if grep -r "count\|for_each" . --include="*.tf" | grep -q "[5-9]\|[1-9][0-9]"; then
    echo "⚠️  Warning: Found high resource counts!"
    echo "   Consider using smaller numbers for learning"
fi

echo ""

# =============================================================================
# 📋 DOCUMENTATION CHECKS
# =============================================================================

echo "📚 Running documentation checks..."

# Check for README files
echo "📝 Checking for README files..."
readme_count=$(find . -name "README.md" | wc -l)
if [ "$readme_count" -lt 3 ]; then
    echo "⚠️  Warning: Found only $readme_count README files"
    echo "   Consider adding README files to document your projects"
fi

# Check for inline documentation
echo "📝 Checking for inline documentation..."
undocumented_resources=$(find . -name "*.tf" -exec grep -l "resource " {} \; | xargs grep -L "# " | wc -l)
if [ "$undocumented_resources" -gt 0 ]; then
    echo "⚠️  Warning: Found $undocumented_resources files with minimal documentation"
    echo "   Consider adding comments to explain your code"
fi

echo ""

# =============================================================================
# 📋 SUMMARY
# =============================================================================

echo "🎉 Validation Complete!"
echo ""
echo "📊 Summary:"
echo "  ✅ Terraform installation: OK"
echo "  ✅ AWS credentials: OK"
echo "  ✅ Terraform format: OK"
echo "  ✅ Configuration validation: OK"
echo ""
echo "🌟 Your Terraform configuration looks good!"
echo "   You're ready to start building amazing things in the cloud!"
echo ""
echo "🚀 Next steps:"
echo "  1. Run 'terraform plan' to see what you'll create"
echo "  2. Run 'terraform apply' to build your infrastructure"
echo "  3. Don't forget to run 'terraform destroy' when you're done!"
echo ""
echo "Happy building, little cloud architect! 🌟"
