resource "aws_security_group" "allow_http_to_web_server" {
  name        = "allow_http_to_web_server"
  description = "Allow TLS inbound traffic from public to load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      description      = "TLS from load balancer"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH from public"
      from_port        = 22
      to_port          = 22
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
    Name = "allow_http_to_web_server"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVULzOBRUEyVCEEpCjiheO+ryXkOeYsmoAQLiqttdax syuraj@gmail.com"
}

resource "aws_instance" "tradium_alerts_web" {
  ami                         = "ami-074cce78125f09d61"
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  monitoring                  = true
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_http_to_web_server.id]
  key_name                    = aws_key_pair.deployer.key_name

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "tradium_alerts_web"
  }
}
