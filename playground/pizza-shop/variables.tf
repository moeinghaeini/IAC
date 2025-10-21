# =============================================================================
# 🍕 TONY'S PIZZA SHOP - VARIABLES (SETTINGS WE CAN CHANGE!) 🍕
# =============================================================================
# These variables let us customize our pizza shop without changing the main code!

variable "pizza_shop_name" {
  description = "🍕 The name of our pizza shop (you can change this!)"
  type        = string
  default     = "Tonys-Pizza-Shop"
  
  # This is like naming your LEGO creation!
}

variable "pizza_shop_owner" {
  description = "👨‍🍳 Who owns this pizza shop?"
  type        = string
  default     = "Little-Chef"
  
  # Put your name here!
}

variable "aws_region" {
  description = "🌍 Which AWS region should we build our pizza shop in?"
  type        = string
  default     = "us-west-2"
  
  # Different regions are like different cities where AWS has data centers
  # us-west-2 is Oregon, us-east-1 is Virginia, eu-west-1 is Ireland
}

variable "instance_type" {
  description = "🖥️ How powerful should our pizza shop computer be?"
  type        = string
  default     = "t2.micro"
  
  # t2.micro is free for new AWS accounts!
  # Other options: t2.small, t2.medium, t2.large (but these cost money!)
}

variable "pizza_shop_phone" {
  description = "📞 What's the phone number for our pizza shop?"
  type        = string
  default     = "(555) PIZZA-1"
  
  # You can change this to your own phone number!
}

variable "delivery_radius" {
  description = "🚚 How far do we deliver pizzas (in miles)?"
  type        = number
  default     = 5
  
  # You can change this number to make delivery area bigger or smaller!
}

variable "pizza_prices" {
  description = "💰 How much do our pizzas cost?"
  type        = map(string)
  default = {
    "Margherita"  = "$12.99"
    "Pepperoni"   = "$14.99"
    "Veggie"      = "$16.99"
    "Meat Lovers" = "$18.99"
  }
  
  # You can change these prices to whatever you want!
}

variable "additional_tags" {
  description = "🏷️ Any extra tags you want to add to your pizza shop resources"
  type        = map(string)
  default     = {}
  
  # Tags are like name tags on your toys - they help you organize things!
}
