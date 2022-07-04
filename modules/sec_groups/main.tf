
################################# SECURITY GROUP/S
resource "aws_security_group" "allow_nginx" {
  name = "allow_nginx"
  description = "Allow port 80"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_nginx"
  }
}

resource "aws_security_group" "allow_node" {
  name = "allow_node"
  description = "Allow port 3000"
  vpc_id = var.vpc_id

  ingress {
    from_port = 3000
    protocol  = "tcp"
    to_port   = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_node"
  }
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow port 22"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_mongodb" {
  name = "allow_mongodb"
  description = "Allow port 27017"
  vpc_id = var.vpc.id

#  for_each = aws_instance.app_instance

  ingress {
    from_port = 27017
    protocol  = "tcp"
    to_port   = 27017
    cidr_blocks = ["${aws_instance.app_instance.private_ip}/32"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_mongodb"
  }
}