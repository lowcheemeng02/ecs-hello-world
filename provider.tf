terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "sctp-ce3-tfstate-bucket-1"
    key    = "terraform-ecs-hello-world.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

