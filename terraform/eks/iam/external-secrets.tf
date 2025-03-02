module "external_secrets" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${data.terraform_remote_state.eks.outputs.eks.cluster_name}-external-secrets"
  oidc_providers = {
    production = {
      provider_arn               = data.terraform_remote_state.eks.outputs.eks.oidc_provider_arn
      namespace_service_accounts = ["external-secrets:external-secrets"]
    }
  }

    attach_external_secrets_policy = true
    
    role_policy_arns = {
      allow-external-secrets = aws_iam_policy.external_secrets_policy.arn
    }
}

data "aws_iam_policy_document" "external_secrets_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/allow-external-secrets"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "external_secrets_policy" {
  name   = "${data.terraform_remote_state.eks.outputs.eks.cluster_name}-external-secrets-policy"
  policy = data.aws_iam_policy_document.external_secrets_policy.json
}
