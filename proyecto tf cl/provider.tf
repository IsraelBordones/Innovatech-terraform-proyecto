#_______________________________
#se da reconocimiento que el proveedor es AWS CLOUD y con la region de us-east-1 (norte de virginia)
#_______________________________
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# dea