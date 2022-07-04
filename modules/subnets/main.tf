################################# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name        = "${var.infra_env}-vpc"
    Environment = var.infra_env
  }
}

