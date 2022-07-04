# launch a server on aws
module "auto_scaling" {
  source = "./modules/auto_scale"

  infra_env = var.infra_env
}

module "subnet" {
  source = "./modules/subnets"

  # infra_env = var.infra_env
  vpc_cidr = var.vpc_cidr
  vpc_id = module.vpc.vpc.id
}

module "vpc" {
  source = "./modules/vpc"

  # infra_env = var.infra_env
  # vpc_cidr = var.vpc_cidr
}

# who is the cloud provider AWS
provider "aws" {

# where do you want to create resources eu-west-1
  region = "eu-west-1"
}

## what type server - ubuntu 18.04 LTS ami
resource "aws_instance" "app_instance" {

# size of the server - t2.micro
#  for_each = aws_subnet.public
  ami = var.node_ami_id
  instance_type = "t2.micro"
  key_name = var.aws_key
# do we need it to have a public access
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_nginx.id, aws_security_group.allow_node.id, aws_security_group.allow_ssh.id]

# what do we want to name it
	tags = {
		Name = "eng114_florent_terraform_app"
	}
}

resource "aws_instance" "db_instance" {
  ami = var.db_ami_id
  instance_type = "t2.micro"
  key_name = var.aws_key
#  for_each = aws_security_group.allow_mongodb
  subnet_id = module.vpc_subnet.private.id
  vpc_security_group_ids = [aws_security_group.allow_mongodb.id, aws_security_group.allow_ssh.id]
  tags = {
    Name = "eng114_florent_terraform_db"
  }
}

resource "aws_instance" "controller" {
  ami = var.ubuntu_ami
  instance_type = "t2.micro"
  key_name = var.aws_key
  associate_public_ip_address = true
  subnet_id = module.vpc_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "eng114_florent_ansible_controller"
  }
}

# resource "aws_launch_template" "app_lt" {
#   name   = "florent_terraform_lt"
#   image_id      = aws_instance.app_instance.ami
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.allow_nginx.id, aws_security_group.allow_node.id, aws_security_group.allow_ssh.id]
# }

# resource "aws_autoscaling_group" "bar" {
#   name = "eng114_florent_terraform_app_asg"
#   desired_capacity   = 2
#   max_size           = 3
#   min_size           = 1
#   vpc_zone_identifier = [aws_subnet.public.id]
# #  load_balancers = [aws_lb.app-lb.id]
# #  vpc_zone_identifier = [aws_subnet.public.id]
#   tag {
#     key                 = "Name"
#     propagate_at_launch = false
#     value               = "eng114_florent_app"
#   }
#   launch_template {
#     id      = aws_launch_template.app_lt.id
#     version = "$Latest"
#   }
# }

# resource "aws_launch_template" "db_lt" {
#   name   = "florent_db_lt"
#   image_id      = aws_instance.db_instance.ami
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.allow_mongodb.id, aws_security_group.allow_ssh.id]
# }

# resource "aws_autoscaling_group" "db_asg" {
#   name = "eng114_florent_terraform_db_asg"
#   desired_capacity   = 2
#   max_size           = 3
#   min_size           = 1
#   vpc_zone_identifier = [aws_subnet.private.id]
# #  load_balancers = [aws_lb.app-lb.id]
# #  vpc_zone_identifier = [aws_subnet.public.id]
#   tag {
#     key                 = "Name"
#     propagate_at_launch = false
#     value               = "eng114_florent_db"
#   }
#   launch_template {
#     id      = aws_launch_template.db_lt.id
#     version = "$Latest"
#   }
# }

# resource "aws_lb" "app-lb" {
#   name = "app-lb"
#   internal = false
#   load_balancer_type = "application"
#   security_groups = [aws_security_group.allow_node.id, aws_security_group.allow_nginx.id, aws_security_group.allow_ssh.id]
#   subnets = [
#     aws_subnet.public2.id,
#     aws_subnet.public.id
#   ]

#   tags = {
#     Name = "eng114_florent_lb"
#   }
# }
# 