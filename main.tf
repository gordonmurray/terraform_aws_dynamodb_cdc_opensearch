terraform {

  required_version = "1.9.8"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.56.0"
    }
  }

}

provider "aws" {
  region                   = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "gordonmurray"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

