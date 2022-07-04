output "vpc_id" {
  value = module.vpc_subnet
}

output "vpc_cidr" {
  value = module.vpc_subnet
}

#output "vpc_public_subnets" {
#  value = {
#    for subnet in aws_subnet.public:
#      subnet.id => subnet.cidr_block
#  }
#}
#
#output "vpc_private_subnets" {
#  value = {
#    for subnet in aws_subnet.private:
#      subnet.id => subnet.cidr_block
#  }
#}