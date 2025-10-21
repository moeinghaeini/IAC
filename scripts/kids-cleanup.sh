#!/bin/bash

# =============================================================================
# 🧹 KIDS CLEANUP SCRIPT 🧹
# =============================================================================
# This script helps kids clean up their Terraform resources safely!

echo "🧹 Time to Clean Up! 🧹"
echo ""
echo "Hi there, little cloud architect! 👋"
echo "This script will help you clean up your cloud resources safely!"
echo ""

# Check if we're in a Terraform directory
if [ ! -f "main.tf" ] && [ ! -f "terraform.tf" ]; then
    echo "❌ We're not in a Terraform project directory!"
    echo "Please navigate to a Terraform project directory first."
    echo ""
    echo "For example:"
    echo "  cd playground/pizza-shop/"
    echo "  or"
    echo "  cd playground/art-gallery/"
    exit 1
fi

echo "🔍 Checking what we're about to clean up..."
echo ""

# Show what will be destroyed
echo "📋 Let's see what we're going to remove:"
terraform plan -destroy

echo ""
echo "⚠️  IMPORTANT SAFETY CHECK! ⚠️"
echo ""
echo "The above shows what will be removed. Make sure:"
echo "   ✅ You're done with this project"
echo "   ✅ You don't need any of these resources anymore"
echo "   ✅ You understand this will delete everything we built"
echo ""

read -p "Are you sure you want to clean up everything? (yes/no): " cleanup_confirm

if [ "$cleanup_confirm" != "yes" ]; then
    echo ""
    echo "🛑 Cleanup cancelled. Your resources are safe!"
    echo "You can run this script again when you're ready to clean up."
    exit 0
fi

echo ""
echo "🧹 Starting cleanup... This might take a few minutes!"
echo ""

# Destroy the infrastructure
terraform destroy -auto-approve

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Cleanup Complete! 🎉"
    echo ""
    echo "✅ All your cloud resources have been removed"
    echo "✅ No more costs will be charged"
    echo "✅ Everything is cleaned up and safe"
    echo ""
    echo "🌟 Great job being responsible and cleaning up after yourself!"
    echo "This is exactly what good cloud architects do!"
    echo ""
    echo "🎮 Ready to build something new? Try another example from the playground!"
else
    echo ""
    echo "❌ Something went wrong during cleanup."
    echo "Please check the error messages above."
    echo ""
    echo "🆘 If you need help:"
    echo "   - Check the error messages"
    echo "   - Ask a grown-up for help"
    echo "   - Try running 'terraform destroy' manually"
fi

echo ""
echo "📚 What you learned about cleanup:"
echo "   ✅ Always clean up when you're done"
echo "   ✅ This stops any costs from continuing"
echo "   ✅ It's important to be responsible with cloud resources"
echo "   ✅ Good cloud architects always clean up after themselves"
echo ""
echo "🌟 You're becoming a great cloud architect! 🌟"
