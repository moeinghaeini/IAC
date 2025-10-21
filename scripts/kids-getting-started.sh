#!/bin/bash

# =============================================================================
# 🚀 KIDS GETTING STARTED SCRIPT 🚀
# =============================================================================
# This script helps kids get started with their Terraform adventure!

echo "🎉 Welcome to your Terraform Adventure! 🎉"
echo ""
echo "Hi there, little cloud architect! 👋"
echo "This script will help you get started with building amazing things in the cloud!"
echo ""

# Check if Terraform is installed
echo "🔍 Checking if Terraform is installed..."
if command -v terraform &> /dev/null; then
    echo "✅ Great! Terraform is installed!"
    terraform version
else
    echo "❌ Terraform is not installed yet."
    echo ""
    echo "📥 Let's install Terraform first!"
    echo ""
    echo "For Mac users, run:"
    echo "  brew install terraform"
    echo ""
    echo "For Windows users:"
    echo "  1. Go to https://terraform.io/downloads.html"
    echo "  2. Download the Windows version"
    echo "  3. Follow the installation instructions"
    echo ""
    echo "For Linux users, run:"
    echo "  wget https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip"
    echo "  unzip terraform_1.9.0_linux_amd64.zip"
    echo "  sudo mv terraform /usr/local/bin/"
    echo ""
    echo "After installing Terraform, run this script again!"
    exit 1
fi

echo ""
echo "🎮 Now let's choose your first adventure!"
echo ""
echo "What would you like to build first?"
echo ""
echo "1. 🍕 Pizza Shop (Easiest - Great for beginners!)"
echo "2. 🎨 Art Gallery (Medium - Beautiful and fun!)"
echo "3. 🎪 Virtual Circus (Advanced - For when you're ready for a challenge!)"
echo "4. 🚀 Space Station (Expert - Multi-service architecture!)"
echo ""

read -p "Enter your choice (1, 2, 3, or 4): " choice

case $choice in
    1)
        echo ""
        echo "🍕 Great choice! Let's build Tony's Pizza Shop! 🍕"
        echo ""
        cd playground/pizza-shop/
        echo "📁 We're now in the pizza shop directory!"
        ;;
    2)
        echo ""
        echo "🎨 Excellent! Let's create a beautiful Art Gallery! 🎨"
        echo ""
        cd playground/art-gallery/
        echo "📁 We're now in the art gallery directory!"
        ;;
    3)
        echo ""
        echo "🎪 Awesome! Let's build a Virtual Circus! 🎪"
        echo ""
        cd playground/circus/
        echo "📁 We're now in the circus directory!"
        ;;
    4)
        echo ""
        echo "🚀 Excellent! Let's build a Space Station! 🚀"
        echo ""
        cd playground/space-station/
        echo "📁 We're now in the space station directory!"
        ;;
    *)
        echo ""
        echo "❌ That's not a valid choice. Let's try again!"
        echo "Please run this script again and choose 1, 2, 3, or 4."
        exit 1
        ;;
esac

echo ""
echo "🛡️ IMPORTANT SAFETY REMINDER! 🛡️"
echo ""
echo "⚠️  Before we continue, make sure you have:"
echo "   ✅ Asked a grown-up for permission"
echo "   ✅ Set up an AWS account (with grown-up help)"
echo "   ✅ Understood that this might cost money"
echo "   ✅ Learned how to run 'terraform destroy' to clean up"
echo ""

read -p "Have you done all of the above? (yes/no): " safety_check

if [ "$safety_check" != "yes" ]; then
    echo ""
    echo "🛑 Please make sure you have grown-up permission and understand the safety rules!"
    echo "Come back when you're ready to continue safely."
    exit 1
fi

echo ""
echo "🚀 Perfect! Let's start building!"
echo ""

# Initialize Terraform
echo "🧙‍♂️ Step 1: Casting your first spell (terraform init)..."
terraform init

if [ $? -eq 0 ]; then
    echo "✅ Great! Terraform is ready to go!"
else
    echo "❌ Something went wrong. Please check the error messages above."
    exit 1
fi

echo ""
echo "📋 Step 2: Planning your creation (terraform plan)..."
echo "This will show you what we're about to build!"
echo ""

read -p "Ready to see the plan? (yes/no): " plan_ready

if [ "$plan_ready" = "yes" ]; then
    terraform plan
    echo ""
    echo "📋 That's what we're going to build! Pretty cool, right?"
else
    echo "No problem! You can run 'terraform plan' anytime to see what we'll build."
fi

echo ""
echo "🏗️ Step 3: Building your creation (terraform apply)..."
echo "This is where the magic happens!"
echo ""

read -p "Ready to build it? (yes/no): " build_ready

if [ "$build_ready" = "yes" ]; then
    echo "🏗️ Building your creation... This might take a few minutes!"
    terraform apply -auto-approve
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🎉 CONGRATULATIONS! 🎉"
        echo "You just built your first cloud infrastructure!"
        echo "You're now a little cloud architect! 🌟"
        echo ""
        echo "📤 Let's see what you created:"
        terraform output
        echo ""
        echo "🛡️ IMPORTANT: When you're done playing, run 'terraform destroy' to clean up!"
        echo "This will remove everything and stop any costs."
    else
        echo "❌ Something went wrong during the build. Please check the error messages above."
    fi
else
    echo "No problem! You can run 'terraform apply' anytime when you're ready to build."
fi

echo ""
echo "🎓 What you learned today:"
echo "   ✅ How to use Terraform to build cloud infrastructure"
echo "   ✅ How to plan before building"
echo "   ✅ How to create websites and servers"
echo "   ✅ How to keep things safe and secure"
echo ""
echo "🌟 You're doing amazing! Keep learning and building! 🌟"
echo ""
echo "📚 Next steps:"
echo "   - Try changing some variables and see what happens"
echo "   - Build another example from the playground"
echo "   - Create your own custom project"
echo "   - Share what you built with others!"
echo ""
echo "Happy building, little cloud architect! 🚀"
