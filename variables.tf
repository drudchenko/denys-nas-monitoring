variable "zone" {
  description = "The GCP zone for the resources."
  type        = string
}

variable "source_ranges" {
  description = "The source ranges for the firewall rule."
  type        = list(string)
}

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "Region where the monitoring VM will be deployed"
  type        = string
}
