terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA6BGYQSZV6R7E3SO5"
  secret_key = "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"

  default_tags {
    tags = {
      Name        = "Provider Tag"
      Environment = "Test"
      Team        = "Team1"
      Created_for = "Terraform"
    }
  }
}