provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment = local.env
    }
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

terraform {
  backend "remote" {
    organization = "els-test"

    workspaces {
      name = "els_test_stg_network"
    }
  }
}

