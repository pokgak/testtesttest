terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "pokgak-prod"
  default_tags {
    tags = {
      "Terraform" = "true"
      "Usage"     = "test"
      "Resource"  = "eks"
    }
  }
}