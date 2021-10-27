

resource "aws_instance" "tradium_alerts_web" {
  ami           = "ami-074cce78125f09d61"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnets[0]

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "tradium_alerts_web"
  }
}
