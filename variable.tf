
variable "project" {
  description = "Name of the project"
 type = string
  
}
variable "environment" {
  description = "Environment for the VPC (e.g., dev, prod)"
  type        = string
  
}


variable "cidr_blocks" {
  description = "List of CIDR blocks to allow access"
  default     = "10.0.0.0/16" # default value is given to make it optional, if user does not provide any value, it will take this default value
  
}
 variable "vpc_tags" {  #users can provide their own tags
  description = "Tags to apply to the VPC"
  type        = map(string)
  default     = {} # by giving default , it becomes as an optional, if user does not provide any tags, it will take default value as empty map
   
 }
 variable "igw_tags" {  #users can provide their own tags
  description = "Tags to apply to the Internet Gateway"
  type        = map(string)
  default     = {} # by giving default , it becomes as an optional, if user does not provide any tags, it will take default value as empty map
   
 }


variable "public_subnet_cidr" {
  type = list(string)
    description = "List of CIDR blocks for public subnets"
}

variable "public_subnet_tags" {
  type = map(string)
  description = "Tags to apply to public subnets"
  default     = {} # by giving default , it becomes as an optional, if user does not provide any tags, it will take default value as empty map
  
}

variable "private_subnet_cidr" {
  type = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "private_subnet_tags" {
  type = map(string)
  description = "Tags to apply to private subnets"
  default     = {} # by giving default , it becomes as an optional, if user does not provide any tags, it will take default value as empty map
  
}

variable "database_subnet_cidr" {
  type = list(string)
  description = "List of CIDR blocks for database subnets"
  
}

variable "database_subnet_tags" {
  type = map(string)
  description = "Tags to apply to database subnets"
  default     = {} # by giving default , it becomes as an optional, if user does not provide any tags, it will take default value as empty map
  
}

variable"eip_tags" {
  type = map(string)
  description = "Tags to apply to the EIP"
  default     = {} # by giving default , it becomes as an optional, if user does not provide any tags, it will take default value as empty map
  
}

variable "nat_gateway_tags" {
  type = map(string)
  description = "Tags to apply to the NAT Gateway"
  default     = {} # by giving default , it becomes as an optional, if user does not provide any tags, it will take default value as empty map
  
}

  variable "public_route_table_tags" {
    type = map(string)
    description = "Tags to apply to the public route table"
    default     = {} # by giving default , it becomes as an optional, if user does
  }

    variable "private_route_table_tags" {
        type = map(string)
        description = "Tags to apply to the private route table"
        default     = {} # by giving default , it becomes as an optional, if user does not provide any tags, it will take default value as empty map
        
    }

variable "database_route_table_tags" {
  type = map(string) 
    description = "Tags to apply to the database route table"
    default     = {} # by giving default , it becomes as an optional, if user does not provide any tags, it will take default value as empty map
}

variable "is_peering_required" {
  default = false
}

variable "vpc_peering_tags" {
  type = map(string)
  default ={}
}