################################# INTERNET GATEWAY
resource "aws_internet_gateway" "ig" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.infra_env}-igw"
    Environment = var.infra_env
  }
}

################################# ROUTE TABLE
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "${var.infra_env}-route-table"
    Environment = var.infra_env
  }
}

################################# ROUTE FROM (PUBLIC)
resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig.id
}

################################# SUBNET ASSOCIATIONS (PUBLIC)
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public-route-table.id
}