# =============================================================================
# SPACE STATION OUTPUTS
# =============================================================================

output "space_station_summary" {
  description = "Summary of the space station deployment"
  value = <<-EOT
    🚀 SPACE STATION DEPLOYMENT COMPLETE! 🚀
    
    Your space station is now operational with the following modules:
    
    Command Center: Main control and monitoring hub
    Life Support: Environmental systems monitoring
    Navigation: Guidance and positioning systems
    Communications: Inter-station communication systems
    
    Access your space station modules at the URLs shown above.
    
    🌟 Congratulations, Space Architect! 🌟
  EOT
}
