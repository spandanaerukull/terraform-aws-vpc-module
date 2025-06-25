#step1-vpc creation
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_blocks
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = merge(
    var.vpc_tags,
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}"  # vpc name ex: roboshop1-dev
    }
  )
    
  }

#step2-creating internet gateway
#this code belongs to internetgateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id #associating the internet gateway with the VPC

  tags = merge(
    var.igw_tags, # by giving this command users can provide their own tags for the internet gateway
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}"  # internet gateway name ex: roboshop1-dev-igw
    }
  )
}

#step3-creating public subnet 
#this code belongs to subnet creation
resource "aws_subnet" "public" {
    count      = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id   # associating the subnet with the VPC                

  cidr_block = var.public_subnet_cidr[count.index] 

    availability_zone = local.az_names[count.index] #by using.Names we get all the availability zones in the region
      #slice function is used to get the first two availability zones, and count.index is used to iterate through the list of public subnets
    map_public_ip_on_launch = true # this will automatically assign a public IP to instances launched in this subnet

  tags = merge(
    var.public_subnet_tags, # by giving this command users can provide their own tags for the public subnet
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}" # subnet name ex: roboshop1-dev-public-1
    }
  )
    
}

# outpu of this code should be roboshop-dev-usa-1a

#step4-creating private subnet
resource "aws_subnet" "private" {
    count      = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id   
  cidr_block = var.private_subnet_cidr[count.index] 

    availability_zone = local.az_names[count.index] 
    

  tags = merge(
    var.private_subnet_tags, # by giving his command users can provide their own tags for the private subnet
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}" # subnet name ex: roboshop1-dev-public-1
    }
  )
    
}

#step5-creating database subnet
resource "aws_subnet" "database" {
    count      = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.main.id   
  cidr_block = var.database_subnet_cidr[count.index] 

    availability_zone = local.az_names[count.index] 
    

  tags = merge(  # this code belongs to database subnet creation   ex: roboshop1-dev-database-1
    var.database_subnet_tags, # by giving this command users can provide their own tags for the database subnet
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}" # subnet name ex: roboshop1-dev-database-1
    }
  )
    
}

#step6-creating NAT Gateway
# this code belongs to NAT Gateway creation
resource "aws_eip" "NAT" {
  domain  = "vpc"

  tags = merge(
    var.eip_tags, # by giving this command users can provide their own tags for the EIP
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}" # eip name ex: roboshop1-dev-nat-eip
    }
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.NAT.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.nat_gateway_tags, # by giving this command users can provide their own tags for the NAT Gateway
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-nat-gateway"  # nat gateway name ex: roboshop1-dev-nat-gateway
    }

  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main] # this ensures that the NAT Gateway is created after the Internet Gateway
}


#step7-creating route table
# this code belongs to route table creation
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  

  tags = merge(
    var.public_route_table_tags, # by giving this command users can provide their own tags for the route table
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-public"# route table name ex: roboshop1-dev-public-route-table
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.private_route_table_tags, # by giving this command users can provide their own tags for the route table
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-private"# route table name ex: roboshop1-dev-public-route-table
    }
  )
}


resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.database_route_table_tags, # by giving this command users can provide their own tags for the route table
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-database"# route table name ex: roboshop1-dev-public-route-table
    }
  )
}


#step8-creating route
# this code belongs to route creation
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id # this is the route table for the public subnet
  destination_cidr_block = "0.0.0.0/0" # this allows all traffic to the internet
  gateway_id = aws_internet_gateway.main.id # this associates the route with the Internet Gateway
  }

  resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id # this is the route table for the private subnet
  destination_cidr_block = "0.0.0.0/0" # this allows all traffic to the internet
  nat_gateway_id = aws_nat_gateway.main.id # this associates the route with the NAT Gateway
  }

  resource "aws_route" "database" {
  route_table_id         = aws_route_table.database.id # this is the route table for the database subnet
  destination_cidr_block = "0.0.0.0/0" # this allows all traffic to the internet
  nat_gateway_id = aws_nat_gateway.main.id # this associates the route with the NAT Gateway
  }


  resource "aws_route_table_association" "public" { # this code associates the public route table with the public subnets
  count          = length(var.public_subnet_cidr) # this associates the route table with all public subnets
  subnet_id      = aws_subnet.public[count.index].id # this is the subnet ID for the public subnet
  route_table_id = aws_route_table.public.id # this is the route table ID for the public route table
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr) # this associates the route table with all public subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count          = length(var.database_subnet_cidr) # this associates the route table with all public subnets
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}