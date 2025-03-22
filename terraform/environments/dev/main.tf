terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.26.0"
    }
  }
}

provider "google" {
  project = "dev-github-environment-sample"
  region  = "us-central1"
}

module "workload_identity" {
  source      = "../../modules/workload_identity"
  project     = "dev-github-environment-sample"
  environment = "dev"
}
