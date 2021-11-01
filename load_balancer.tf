resource "aws_security_group" "allow_tls_in_lb" {
  name        = "allow_tls_in_lb"
  description = "Allow TLS inbound traffic from public to load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      description      = "TLS from public"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "allow_tls_in_lb"
  }
}

resource "aws_lb" "tradium_alerts_web_lb" {
  name                       = "tradium-alerts-web-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.allow_tls_in_lb.id]
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.tradium_alerts_web_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tradium_target_group.arn
  }
}

resource "aws_lb_target_group" "tradium_target_group" {
  name     = "tradium-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled = true
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.tradium_target_group.arn
  target_id        = aws_instance.tradium_alerts_web.id
  port             = 80
}
