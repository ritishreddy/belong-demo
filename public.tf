resource "aws_subnet" "nat_gateway" {
  availability_zone       = var.availability_zones[count.index]
  cidr_block = "10.0.3.0/24"
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "DemoSubnetNAT"
  }
}

resource "aws_internet_gateway" "nat_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "DemoGateway"
  }
}

resource "aws_route_table" "nat_gateway" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "nat_gateway" {
  subnet_id = aws_subnet.nat_gateway.id
  route_table_id = aws_route_table.nat_gateway.id
}
