resource "aws_vpc_peering_connection" "default" {
  count = var.is_peering_required ? 1 : 0 # Only create if peering is required
  peer_vpc_id   = data.aws_vpc.default.id # accepter vpc which is default here
  vpc_id        = aws_vpc.main.id # requester vpc 

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

 auto_accept = true

tags = merge(
    var.vpc_peering_tags, # by giving this command users can provide their own tags for the peering connection
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-default" # peering connection name ex: roboshop1-dev-peering-connection
    }
  )

}
# This code belongs to peering connection creation
# It creates a peering connection between the requester VPC and the accepter VPC.
resource "aws_route" "public_peering" {
    count = var.is_peering_required ? 1 : 0 # Only create if peering is required 
  route_table_id = aws_route_table.public.id # this is the route table for the public subnet
  destination_cidr_block = data.aws_vpc.default.cidr_block # this allows traffic to the accepter VPC
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id # this associates the route with the peering connection 
}

resource "aws_route" "private_peering" {
    count = var.is_peering_required ? 1 : 0 # Only create if peering is required 
  route_table_id = aws_route_table.private.id # this is the route table for the public subnet
  destination_cidr_block = data.aws_vpc.default.cidr_block # this allows traffic to the accepter VPC
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id # this associates the route with the peering connection 
}

resource "aws_route" "database_peering" {
    count = var.is_peering_required ? 1 : 0 # Only create if peering is required 
  route_table_id = aws_route_table.database.id # this is the route table for the public subnet
  destination_cidr_block = data.aws_vpc.default.cidr_block # this allows traffic to the accepter VPC
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id # this associates the route with the peering connection 
}

# we should add peering connection in  default vpc main route table too

resource "aws_route" "dafault_peering" {
    count = var.is_peering_required ? 1 : 0 # Only create if peering is required 
  route_table_id = data.aws_route_table.main.id # this is the route table for the public subnet
  destination_cidr_block = var.cidr_blocks# this allows traffic to the accepter VPC
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}