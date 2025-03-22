terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.26.0"
    }
  }
}

provider "google" {
  project = "prod-github-environment-sample"
  region  = "us-central1"
}

module "workload_identity" {
  source      = "../../modules/workload_identity"
  project     = "prod-github-environment-sample"
  environment = "prod"
}
