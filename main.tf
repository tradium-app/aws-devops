terraform {
  required_version = "1.0.9"

  backend "s3" {
    bucket = "tf-state-tradium"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

