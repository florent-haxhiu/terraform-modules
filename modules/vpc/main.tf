################################# PUBLIC SUBNET
resource "aws_subnet" "public" {
  vpc_id = var.vpc.id
  availability_zone = "eu-west-1a"
  cidr_block = "10.0.142.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.infra_env}-public-subnet"
    Environment = var.infra_env
  }
}

resource "aws_subnet" "public2" {
  vpc_id = var.vpc.id
  availability_zone = "eu-west-1b"
  cidr_block = "10.0.142.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.infra_env}-public-subnet"
    Environment = var.infra_env
  }
}

################################# PRIVATE SUBNET
resource "aws_subnet" "private" {

  vpc_id = var.vpc.id
  availability_zone = "eu-west-1a"
  cidr_block = "10.0.141.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.infra_env}-private-subnet"
    Environment = var.infra_env
#    Subnet = "${each.key}-${each.value}"
  }
}