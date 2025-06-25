data "aws_availability_zones" "available" {  
  state = "available"
}

data "aws_vpc" "default" { # this is used to get the default VPC in the region this is used when am doing peering with default VPC
  default = true
}

# output "azs_info" {
#   value = data.aws_availability_zones.available
# }  # this i wrote for testing purpose


data "aws_route_table" "main" {  # this is used to get the main route table of the default VPC
  vpc_id = data.aws_vpc.default.id # this is used to get the default VPC id
  # We are using the default VPC id to get the main route table of the default
  filter{
    name   = "association.main"
    values = ["true"]
  }
}
  