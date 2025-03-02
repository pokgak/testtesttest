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

data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "../terraform.tfstate"
  }
}