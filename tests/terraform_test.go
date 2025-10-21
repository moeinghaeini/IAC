// =============================================================================
// 🧪 TERRAFORM TESTS FOR KIDS! 🧪
// =============================================================================
// This file contains tests to make sure our Terraform code works correctly!

package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/stretchr/testify/assert"
)

// =============================================================================
// 🍕 PIZZA SHOP TESTS
// =============================================================================

func TestPizzaShopInfrastructure(t *testing.T) {
	// Set up Terraform options
	terraformOptions := &terraform.Options{
		TerraformDir: "../playground/pizza-shop",
		Vars: map[string]interface{}{
			"project_name": "test-pizza-shop",
			"environment":  "test",
		},
		NoColor: true,
	}

	// Clean up resources after test
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply Terraform
	terraform.InitAndApply(t, terraformOptions)

	// =============================================================================
	// 🧪 TEST S3 BUCKET
	// =============================================================================
	
	bucketName := terraform.Output(t, terraformOptions, "s3_bucket_name")
	
	// Test that the bucket exists
	assert.NotEmpty(t, bucketName, "S3 bucket name should not be empty")
	
	// Test that the bucket is accessible
	aws.AssertS3BucketExists(t, "us-west-2", bucketName)
	
	// Test bucket public access
	bucketPublicAccess := aws.GetS3BucketPublicAccessBlock(t, "us-west-2", bucketName)
	assert.False(t, bucketPublicAccess.BlockPublicAcls, "Bucket should allow public ACLs")
	assert.False(t, bucketPublicAccess.BlockPublicPolicy, "Bucket should allow public policies")

	// =============================================================================
	// 🧪 TEST EC2 INSTANCE
	// =============================================================================
	
	instanceID := terraform.Output(t, terraformOptions, "ec2_instance_id")
	
	// Test that the instance exists
	assert.NotEmpty(t, instanceID, "EC2 instance ID should not be empty")
	
	// Test that the instance is running
	instance := aws.GetEc2Instance(t, "us-west-2", instanceID)
	assert.Equal(t, "running", instance.State.Name, "Instance should be running")
	
	// Test instance type
	assert.Equal(t, "t3.micro", instance.InstanceType, "Instance should be t3.micro")

	// =============================================================================
	// 🧪 TEST SECURITY GROUP
	// =============================================================================
	
	securityGroupID := terraform.Output(t, terraformOptions, "security_group_id")
	
	// Test that the security group exists
	assert.NotEmpty(t, securityGroupID, "Security group ID should not be empty")
	
	// Test security group rules
	securityGroup := aws.GetSecurityGroup(t, "us-west-2", securityGroupID)
	
	// Should have HTTP rule
	httpRule := aws.GetSecurityGroupRule(t, "us-west-2", securityGroupID, "ingress", "tcp", 80)
	assert.NotNil(t, httpRule, "Should have HTTP rule on port 80")
	
	// Should have HTTPS rule
	httpsRule := aws.GetSecurityGroupRule(t, "us-west-2", securityGroupID, "ingress", "tcp", 443)
	assert.NotNil(t, httpsRule, "Should have HTTPS rule on port 443")

	// =============================================================================
	// 🧪 TEST WEBSITE ACCESSIBILITY
	// =============================================================================
	
	websiteURL := terraform.Output(t, terraformOptions, "website_url")
	
	// Test that the website URL is not empty
	assert.NotEmpty(t, websiteURL, "Website URL should not be empty")
	
	// Test that the website is accessible (this would require additional setup)
	// For now, we'll just verify the URL format
	assert.Contains(t, websiteURL, "s3-website", "Website URL should be an S3 website URL")
}

// =============================================================================
// 🎨 ART GALLERY TESTS
// =============================================================================

func TestArtGalleryInfrastructure(t *testing.T) {
	// Set up Terraform options
	terraformOptions := &terraform.Options{
		TerraformDir: "../playground/art-gallery",
		Vars: map[string]interface{}{
			"project_name": "test-art-gallery",
			"environment":  "test",
		},
		NoColor: true,
	}

	// Clean up resources after test
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply Terraform
	terraform.InitAndApply(t, terraformOptions)

	// Test that the gallery bucket exists
	galleryBucketName := terraform.Output(t, terraformOptions, "gallery_bucket_name")
	assert.NotEmpty(t, galleryBucketName, "Gallery bucket name should not be empty")
	
	// Test bucket encryption
	bucketEncryption := aws.GetS3BucketEncryption(t, "us-west-2", galleryBucketName)
	assert.NotNil(t, bucketEncryption, "Bucket should have encryption enabled")
}

// =============================================================================
// 🧪 MODULE TESTS
// =============================================================================

func TestVPCModule(t *testing.T) {
	// Set up Terraform options for VPC module
	terraformOptions := &terraform.Options{
		TerraformDir: "../modules/vpc",
		Vars: map[string]interface{}{
			"name_prefix":            "test-vpc",
			"vpc_cidr":              "10.0.0.0/16",
			"availability_zones":    []string{"us-west-2a", "us-west-2b"},
			"public_subnet_cidrs":   []string{"10.0.1.0/24", "10.0.2.0/24"},
			"private_subnet_cidrs":  []string{"10.0.10.0/24", "10.0.20.0/24"},
			"tags": map[string]string{
				"Environment": "test",
				"Project":     "test-vpc",
			},
		},
		NoColor: true,
	}

	// Clean up resources after test
	defer terraform.Destroy(t, terraformOptions)

	// Initialize and apply Terraform
	terraform.InitAndApply(t, terraformOptions)

	// Test VPC outputs
	vpcID := terraform.Output(t, terraformOptions, "vpc_id")
	assert.NotEmpty(t, vpcID, "VPC ID should not be empty")
	
	// Test that VPC exists
	vpc := aws.GetVpcById(t, vpcID, "us-west-2")
	assert.Equal(t, "10.0.0.0/16", vpc.CidrBlock, "VPC CIDR should be 10.0.0.0/16")
}

// =============================================================================
// 🧪 SECURITY TESTS
// =============================================================================

func TestSecurityConfiguration(t *testing.T) {
	// Test that security best practices are followed
	terraformOptions := &terraform.Options{
		TerraformDir: "../playground/pizza-shop",
		Vars: map[string]interface{}{
			"project_name": "test-security",
			"environment":  "test",
		},
		NoColor: true,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Test that security group has restrictive rules
	securityGroupID := terraform.Output(t, terraformOptions, "security_group_id")
	securityGroup := aws.GetSecurityGroup(t, "us-west-2", securityGroupID)
	
	// Should not allow SSH from anywhere by default
	sshRules := aws.GetSecurityGroupRules(t, "us-west-2", securityGroupID, "ingress", "tcp", 22)
	assert.Empty(t, sshRules, "Should not have open SSH rules by default")
}

// =============================================================================
// 🧪 COST OPTIMIZATION TESTS
// =============================================================================

func TestCostOptimization(t *testing.T) {
	// Test that we're using cost-effective resources
	terraformOptions := &terraform.Options{
		TerraformDir: "../playground/pizza-shop",
		Vars: map[string]interface{}{
			"project_name": "test-cost",
			"environment":  "test",
		},
		NoColor: true,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Test that we're using free tier eligible instances
	instanceID := terraform.Output(t, terraformOptions, "ec2_instance_id")
	instance := aws.GetEc2Instance(t, "us-west-2", instanceID)
	
	// Should be using t3.micro (free tier eligible)
	assert.Equal(t, "t3.micro", instance.InstanceType, "Should use free tier eligible instance type")
}
