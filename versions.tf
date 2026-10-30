terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # Deliberately left empty: bucket/key/region are supplied at `terraform init` time via -backend-config
  # (or a *.tfbackend file, never committed here), so this module can be pointed at any QA state bucket
  # without editing source — and so the real bucket name/key never needs to be hardcoded into a repo meant
  # to be imported as an arbitrary customer's Terraform Deployment source. See README.md for the exact
  # init command used to provision this module's own "real" state for the Terraform Deployments extraction
  # test (DuploCloud's Terraform Deployment import discovers environments via this backend block).
  backend "s3" {}
}

provider "aws" {
  region = var.region
}
