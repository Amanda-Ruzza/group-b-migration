# --- root/providers.tf --
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 0.12"
    }
  }
}

provider "aws" {
  region = var.aws_region
}