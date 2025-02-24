module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "testVPC"
  cidr = "10.0.0.0/16"

  azs              = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets  = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21"]
  public_subnets   = ["10.0.48.0/21", "10.0.56.0/21", "10.0.64.0/21"]
  database_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  private_subnet_private_dns_hostname_type_on_launch = "resource-name"
  public_subnet_private_dns_hostname_type_on_launch = "resource-name"

  enable_ipv6                                   = false
  public_subnet_assign_ipv6_address_on_creation = false

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  default_security_group_ingress = [
    {
      description = "Allow all traffic within the VPC"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "10.0.0.0/16"
      self        = true
    },
  ]

  default_security_group_egress = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  default_security_group_tags = {
    "VPC" = "testVPC"
  }

  private_subnet_tags = {
    "VPC"                             = "testVPC"
    "SubnetType"                      = "Private"
    "kubernetes.io/role/internal-elb" = "1"
    "karpenter.sh/discovery"          = "test"
  }

  public_subnet_tags = {
    "VPC"                    = "testVPC"
    "SubnetType"             = "Public"
    "kubernetes.io/role/elb" = "1"
  }

  private_route_table_tags = {
    "VPC"            = "testVPC"
    "RouteTableType" = "Private"
  }

  database_subnet_tags = {
    "VPC"        = "testVPC"
    "SubnetType" = "Database"
  }

  database_route_table_tags = {
    "VPC"            = "testVPC"
    "RouteTableType" = "Database"
  }
}
