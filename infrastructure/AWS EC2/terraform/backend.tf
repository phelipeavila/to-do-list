provider "aws" {
  region = "us-west-2"
}

terraform {
  required_version = ">=1.5.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }

  backend "s3" {
    bucket = "tfbucket-zef8tk6nph"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}

resource "aws_s3_bucket" "tfbucket" {
  bucket = "tfbucket-zef8tk6nph"

  tags = {
    Name        = "tfbucket-zef8tk6nph"
    Environment = "test"
    Terraform   = true
  }

  lifecycle {
    prevent_destroy = true
  }
}