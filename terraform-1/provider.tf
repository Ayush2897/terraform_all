terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  access_key = "AKIA6BGYQSZVU4VVNLY6"
  secret_key = "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"
  region = var.AWS_REGION
}