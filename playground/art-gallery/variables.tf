# =============================================================================
# 🎨 DIGITAL ART GALLERY - VARIABLES (SETTINGS WE CAN CHANGE!) 🎨
# =============================================================================
# These variables let us customize our art gallery without changing the main code!

variable "gallery_name" {
  description = "🎨 The name of our art gallery (you can change this!)"
  type        = string
  default     = "Digital-Art-Gallery"
  
  # This is like naming your art gallery!
}

variable "gallery_owner" {
  description = "👨‍🎨 Who owns this art gallery?"
  type        = string
  default     = "Little-Artist"
  
  # Put your name here!
}

variable "aws_region" {
  description = "🌍 Which AWS region should we build our art gallery in?"
  type        = string
  default     = "us-west-2"
  
  # Different regions are like different cities where AWS has data centers
  # us-west-2 is Oregon, us-east-1 is Virginia, eu-west-1 is Ireland
}

variable "instance_type" {
  description = "🖥️ How powerful should our gallery computer be?"
  type        = string
  default     = "t2.micro"
  
  # t2.micro is free for new AWS accounts!
  # Other options: t2.small, t2.medium, t2.large (but these cost money!)
}

variable "gallery_hours" {
  description = "🕒 What are the gallery hours?"
  type        = string
  default     = "Always Open (24/7)"
  
  # You can change this to whatever hours you want!
}

variable "gallery_admission" {
  description = "🎫 How much does it cost to visit the gallery?"
  type        = string
  default     = "Free for Everyone!"
  
  # You can change this to charge admission if you want!
}

variable "featured_artworks" {
  description = "🖼️ What artworks should we feature in our gallery?"
  type        = list(string)
  default = [
    "Sunset Dreams",
    "Garden of Colors", 
    "Butterfly Dance",
    "Rainbow Bridge"
  ]
  
  # You can add your own artwork names here!
}

variable "gallery_colors" {
  description = "🎨 What colors should we use for our gallery theme?"
  type        = map(string)
  default = {
    "primary"   = "#667eea"
    "secondary" = "#764ba2"
    "accent"    = "#ffeb3b"
    "text"      = "white"
  }
  
  # You can change these colors to make your gallery unique!
}

variable "additional_tags" {
  description = "🏷️ Any extra tags you want to add to your gallery resources"
  type        = map(string)
  default     = {}
  
  # Tags are like name tags on your toys - they help you organize things!
}
