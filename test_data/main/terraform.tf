terraform {
  //noinspection HILUnresolvedReference
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.11"
    }
    github = {
      source  = "integrations/github"
      version = "6.10.1"
    }

  }
}
