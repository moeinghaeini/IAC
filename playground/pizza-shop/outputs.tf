# =============================================================================
# 🍕 TONY'S PIZZA SHOP - OUTPUTS (WHAT WE CREATED!) 🍕
# =============================================================================
# These outputs show us what we built and how to access it!

# Show the website URL
output "pizza_website_url" {
  description = "🌐 The URL where you can visit Tony's Pizza Shop website!"
  value       = "http://${aws_s3_bucket.pizza_website.website_endpoint}"
}

# Show the S3 bucket name
output "pizza_website_bucket_name" {
  description = "🗄️ The name of our pizza shop website storage bucket"
  value       = aws_s3_bucket.pizza_website.bucket
}

# Show the server's public IP address
output "pizza_server_ip" {
  description = "🖥️ The IP address of our pizza shop computer server"
  value       = aws_instance.pizza_server.public_ip
}

# Show the server's public DNS name
output "pizza_server_dns" {
  description = "🌐 The web address of our pizza shop computer server"
  value       = aws_instance.pizza_server.public_dns
}

# Show how to visit the server website
output "pizza_server_website" {
  description = "🍕 Visit this URL to see Tony's Pizza Shop running on our server!"
  value       = "http://${aws_instance.pizza_server.public_ip}"
}

# Show what we learned
output "what_we_built" {
  description = "🎓 What we learned by building Tony's Pizza Shop!"
  value = {
    "Website Storage" = "We created an S3 bucket to store our website files"
    "Computer Server" = "We created an EC2 instance to run our pizza shop app"
    "Security"        = "We created security groups to keep everything safe"
    "Networking"      = "We learned how computers talk to each other"
  }
}

# Fun message for kids
output "congratulations" {
  description = "🎉 Congratulations message for our little cloud architect!"
  value       = "🎉 Congratulations! You just built your first cloud infrastructure! You're now a little cloud architect! 🌟"
}
