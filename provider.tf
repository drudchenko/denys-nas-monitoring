terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Using the latest stable major version for 2026
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
