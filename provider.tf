terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Using the latest stable major version for 2026
    }
  }
}

provider "google" {
  project = "integral-sol-320907"
  region  = "europe-west3" # Frankfurt (Closest to Berlin)
}
