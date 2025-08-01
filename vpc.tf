module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "golden-phoenix-vpc"
  cidr = "10.77.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  public_subnets  = ["10.77.0.0/24", "10.77.1.0/24", "10.77.2.0/24"]
  private_subnets = ["10.77.4.0/22", "10.77.8.0/22", "10.77.12.0/22"]

  enable_nat_gateway = true

  manage_default_security_group = false
  manage_default_route_table    = false
}
