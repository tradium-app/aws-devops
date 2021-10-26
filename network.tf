resource "aws_eip" "nat" {
  count = 2
  vpc   = true
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tradium-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  enable_vpn_gateway     = true
  reuse_nat_ips          = true             # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids    = aws_eip.nat.*.id # <= IPs specified here as input to the module

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
