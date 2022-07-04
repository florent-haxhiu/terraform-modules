resource "aws_elb" "eng114_florent_lb" {
  name               = "${var.infra_env}-app-lb"
  internal           = false
  security_groups    = [module.sec_groups.allow_node, module.sec_groups.allow_nginx, module.sec_groups.allow_ssh]
  subnets            = [
    "${subnet.public.id}",
    "${subnet.public2.id}"
  ]
  
cross_zone_load_balancing   = true

health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }

listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}

resource "aws_launch_configuration" "eng114_florent_lc" {
  name_prefix = "eng114-florent-lc"
  image_id = var.node_ami_id
  instance_type = "t2.micro"
  key_name = var.aws_key
  security_groups = [sec_groups.allow_mongodb]
  associate_public_ip_address = true

lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eng114_florent_asg" {
  name = "${var.infra_env}-asg"
  min_size             = 2
  desired_capacity     = 2
  max_size             = 3

  health_check_type    = "EC2"
  load_balancers = [
    "${aws_elb.eng114_florent_lb.id}"
  ]

launch_configuration = "${aws_launch_configuration.eng114_florent_lc.name}"
enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
metrics_granularity = "1Minute"
vpc_zone_identifier  = [
    "${subnet.public.id}",
  ]
# Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

tag {
    key                 = "Name"
    value               = "${var.infra_env}-app"
    propagate_at_launch = true
  }
}