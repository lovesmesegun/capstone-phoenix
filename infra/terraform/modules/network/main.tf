#vpc 

resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  enable_dns_support = true

  enable_dns_hostnames = true

  tags = {
    Name = "phoenix-vpc"
  }

}
#Internet Gateway 

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

}

#Public Subnet
resource "aws_subnet" "public" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_cidr

  availability_zone = var.availability_zone

  map_public_ip_on_launch = true

  tags = {
    Name = "phoenix-public-subnet"
  }

}
#Route Table

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "phoenix-public-rt"
  }

}

#Internet Route

resource "aws_route" "internet" {

  route_table_id = aws_route_table.public.id

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.igw.id

}
#Associate Route 

resource "aws_route_table_association" "public" {

  subnet_id = aws_subnet.public.id

  route_table_id = aws_route_table.public.id

}