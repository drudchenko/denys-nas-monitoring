terraform {
  backend "gcs" {
    bucket = "denys-nas-tf-state-monitoring"
    prefix = "terraform/state"
  }
}
