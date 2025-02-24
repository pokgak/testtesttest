locals {
  cluster_name = "test"
  cluster_version = "1.32"
  vpc_name     = "testVPC"
}

data "aws_vpc" "this" {
  id = "vpc-0ae2e388cbf64ffb9"
}

data "aws_security_group" "this" {
  vpc_id = data.aws_vpc.this.id

  filter {
    name   = "tag:Name"
    values = ["${data.aws_vpc.this.tags.Name}-default"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "tag:SubnetType"
    values = ["Private"]
  }
}
