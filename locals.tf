locals {   # Local variables for the VPC module
  # These variables are used to define the project, environment, and availability zones
  common_tags = {
     project     = var.project
     environment = var.environment
     terraform = "true"

  }
  az_names = slice(data.aws_availability_zones.available.names, 0, 2)  # Get the first two availability zones from the available zones in the region
  # This will be used to create subnets in the first two availability zones
    
  
}