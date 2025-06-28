output "vpc_id" { # Exports the VPC ID created by the module
    description = "The ID of the VPC created by the module"
  value = aws_vpc.main.id 
  
}

output "public_subnet_ids" { # Exports the IDs of the public subnets created by the module
    description = "The IDs of the public subnets created by the module"
  value = aws_subnet.public[*].id # List of all public subnet IDs
}

output "private_subnet_ids" { # Exports the IDs of the private subnets created by the module
    description = "The IDs of the private subnets created by the module"
  value = aws_subnet.private[*].id # List of all private subnet IDs
}
 