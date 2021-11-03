resource "aws_security_group" "sg_mongos" {
  name        = "sg_mongos"
  description = "Allow Mongo traffic to/from web servers"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      description      = "TLS from load balancer"
      from_port        = 27017
      to_port          = 27017
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.sg_web_server.id]
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
    Name = "sg_mongos"
  }
}

resource "aws_instance" "tradium_mongos" {
  ami                         = "ami-074cce78125f09d61"
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.private_subnets[0]
  monitoring                  = true
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg_mongos.id]
  key_name                    = aws_key_pair.deployer.key_name
  count                       = 2

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "tradium_mongo_${count.index}"
  }
}
