terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.2"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.20"
    }
  }
}
