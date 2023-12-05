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
  region     = "ap-south-1"
  access_key = "AKIA6BGYQSZV64ITVVVY"
  secret_key = "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"

}

