# resource "aws_vpc" "byoi-vpc" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = "byoi-vpc"
#   }
# }

# resource "aws_subnet" "byoi-public-subnet-1" {
#   vpc_id                  = aws_vpc.byoi-vpc.id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "Public-Subnet-1"
#   }
# }

# resource "aws_subnet" "byoi-public-subnet-2" {
#   vpc_id                  = aws_vpc.byoi-vpc.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "Public-Subnet-2"
#   }
# }

# resource "aws_subnet" "byoi-private-subnet-1" {
#   vpc_id            = aws_vpc.byoi-vpc.id
#   cidr_block        = "10.0.3.0/24"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "Private-Subnet-1"
#   }
# }

# resource "aws_subnet" "byoi-private-subnet-2" {
#   vpc_id            = aws_vpc.byoi-vpc.id
#   cidr_block        = "10.0.4.0/24"
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "PrivateSubnet2"
#   }
# }

# # 2 database subnets
# resource "aws_subnet" "byoi-database-subnet-1" {
#   vpc_id            = aws_vpc.byoi-vpc.id
#   cidr_block        = "10.0.5.0/24"
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "database-subnet-1"
#   }
# }

# resource "aws_subnet" "byoi-database-subnet-2" {
#   vpc_id            = aws_vpc.byoi-vpc.id
#   cidr_block        = "10.0.6.0/24"
#   availability_zone = "us-east-1b"
#   tags = {
#     Name = "database-subnet-2"
#   }
# }



# # Internet Gateway
# resource "aws_internet_gateway" "byoi_igw" {
#   vpc_id = aws_vpc.byoi-vpc.id
#   tags = {
#     "Name" = "byoi-igw"
#   }
# }
# # Create Elastic IP for NAT Gateway
# resource "aws_eip" "nat_eip" {
#   vpc = true
# }

# # Nat Gateway
# resource "aws_nat_gateway" "byoi-nat-gw" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.byoi-public-subnet-1.id
#   tags = {
#     Name = "byoi-nat-gw"
#   }
#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.byoi_igw]
# }

# ######################################################
# # public route table
# # public subnets association into public route table
# # Add Internet Gateway into public route table
# ######################################################
# # public route table
# resource "aws_route_table" "byoi-public-rt" {
#   vpc_id = aws_vpc.byoi-vpc.id
#   tags = {
#     "Name" = "public-rt"
#   }
# }

# # Associate both public subnets with public route table
# resource "aws_route_table_association" "public_subnet_association-1" {
#   route_table_id = aws_route_table.byoi-public-rt.id
#   subnet_id      = aws_subnet.byoi-public-subnet-1.id
# }

# resource "aws_route_table_association" "public_subnet_association-2" {
#   route_table_id = aws_route_table.byoi-public-rt.id
#   subnet_id      = aws_subnet.byoi-public-subnet-2.id
# }

# # Add Internet Gateway into public route table
# resource "aws_route" "byoi-route-igw" {
#   route_table_id         = aws_route_table.byoi-public-rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.byoi_igw.id
# }


# ######################################################
# # private route table
# # private subnets association into private route table
# # Add Nat Gateway into private route table
# ######################################################
# # private route table
# resource "aws_route_table" "byoi-private-rt" {
#   vpc_id = aws_vpc.byoi-vpc.id
#   tags = {
#     "Name" = "private-rt"
#   }
# }

# # Associate both private subnets with private route table
# resource "aws_route_table_association" "private_subnet_association-1" {
#   route_table_id = aws_route_table.byoi-private-rt.id
#   subnet_id      = aws_subnet.byoi-private-subnet-1.id
# }

# resource "aws_route_table_association" "private_subnet_association-2" {
#   route_table_id = aws_route_table.byoi-private-rt.id
#   subnet_id      = aws_subnet.byoi-private-subnet-2.id
# }

# # Add Nat Gateway into private route table
# resource "aws_route" "byoi-route-nat-gw" {
#   route_table_id         = aws_route_table.byoi-private-rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.byoi-nat-gw.id
# }


# ######################################################
# # database route table
# # database subnets association into database route table
# ######################################################
# # database route table
# resource "aws_route_table" "byoi-database-rt" {
#   vpc_id = aws_vpc.byoi-vpc.id
#   tags = {
#     "Name" = "database-rt"
#   }
# }

# # Associate both database subnets with database route table
# resource "aws_route_table_association" "database_subnet_association-1" {
#   route_table_id = aws_route_table.byoi-database-rt.id
#   subnet_id      = aws_subnet.byoi-database-subnet-1.id
# }

# resource "aws_route_table_association" "database_subnet_association-2" {
#   route_table_id = aws_route_table.byoi-database-rt.id
#   subnet_id      = aws_subnet.byoi-database-subnet-2.id
# }