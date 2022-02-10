terraform {
    backend "s3" {
        bucket = "jj-dcs-mwaa-devops-tfstate"
        key = "mwaa.tfstate"
        region = "us-east-1"
        encrypt = true
        dynamodb_table = "dcs-mwaa-devops-tf-state-lock"
    }
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "3.36.0"
        }
    }

    #required_version = ">= 0.14.0, < 0.15.0"
}

provider "aws" {
    region = "us-east-1"
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  tags = {
    Author = "Terraform"
  }
}

# resource "kubernetes_namespace" "coredata-airflow" {
#   metadata {
#     annotations = {
#       name = "example-annotation"
#     }

#     labels = {
#       mylabel = "label-value"
#     }

#     name = "terraform-example-namespace"
#   }
# }
