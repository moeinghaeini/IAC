# =============================================================================
# 🎨 DIGITAL ART GALLERY - OUTPUTS (WHAT WE CREATED!) 🎨
# =============================================================================
# These outputs show us what we built and how to access it!

# Show the gallery website URL
output "gallery_website_url" {
  description = "🌐 The URL where you can visit the Digital Art Gallery!"
  value       = "http://${aws_s3_bucket.art_gallery.website_endpoint}"
}

# Show the gallery bucket name
output "gallery_bucket_name" {
  description = "🗄️ The name of our art gallery website storage bucket"
  value       = aws_s3_bucket.art_gallery.bucket
}

# Show the artwork storage bucket name
output "artwork_storage_bucket" {
  description = "🖼️ The name of our artwork storage bucket"
  value       = aws_s3_bucket.artwork_storage.bucket
}

# Show the server's public IP address
output "gallery_server_ip" {
  description = "🖥️ The IP address of our art gallery computer server"
  value       = aws_instance.gallery_server.public_ip
}

# Show the server's public DNS name
output "gallery_server_dns" {
  description = "🌐 The web address of our art gallery computer server"
  value       = aws_instance.gallery_server.public_dns
}

# Show how to visit the server website
output "gallery_server_website" {
  description = "🎨 Visit this URL to see the Digital Art Gallery running on our server!"
  value       = "http://${aws_instance.gallery_server.public_ip}"
}

# Show what we learned
output "what_we_built" {
  description = "🎓 What we learned by building the Digital Art Gallery!"
  value = {
    "Gallery Website" = "We created an S3 bucket to host our beautiful art gallery"
    "Artwork Storage" = "We created a separate storage area for artwork images"
    "Gallery Server"  = "We created an EC2 instance to run our gallery application"
    "Security"        = "We created security groups to keep everything safe"
    "Web Design"      = "We learned how to create beautiful, colorful websites"
  }
}

# Fun message for kids
output "congratulations" {
  description = "🎉 Congratulations message for our little cloud architect!"
  value       = "🎉 Congratulations! You just built a beautiful digital art gallery! You're becoming a great cloud architect! 🌟"
}

# Gallery information
output "gallery_info" {
  description = "🎨 Information about your new art gallery!"
  value = {
    "Gallery Name"    = "Digital Art Gallery"
    "Location"        = "Cloud Gallery"
    "Hours"          = "Always Open (24/7)"
    "Admission"      = "Free for Everyone!"
    "Featured Art"   = "Sunset Dreams, Garden of Colors, Butterfly Dance, Rainbow Bridge"
  }
}
