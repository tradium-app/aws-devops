resource "aws_instance" "tradium_alerts_web" {
  ami                         = "ami-074cce78125f09d61"
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  monitoring                  = true
  associate_public_ip_address = false
  security_groups             = [aws_security_group.allow_tls_in_lb.id]

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "tradium_alerts_web"
  }
}
