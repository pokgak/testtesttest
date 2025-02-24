module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  authentication_mode                      = "API"
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_private_access          = true
  cluster_endpoint_public_access           = true
  enable_irsa                              = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["system"]
  }

  cluster_security_group_additional_rules = {
    default-sg = {
      description              = "Allow all traffic from test VPC"
      type                     = "ingress"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      source_security_group_id = data.aws_security_group.this.id
    }
  }

  vpc_id     = data.aws_vpc.this.id
  subnet_ids = data.aws_subnets.private.ids

  create_cloudwatch_log_group = false
  cluster_enabled_log_types   = []
}
