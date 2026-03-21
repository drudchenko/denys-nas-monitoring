# 1. Enable Necessary Google Cloud APIs
resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "monitoring_api" {
  service            = "monitoring.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "prometheus_api" {
  service            = "opsconfigmonitoring.googleapis.com"
  disable_on_destroy = false
}

# 2. Networking: Static IP for your Grafana dashboard
resource "google_compute_address" "static_ip" {
  name   = "grafana-static-ip"
  region = "europe-west3"

  # Ensures the API is fully active before creating the address
  depends_on = [google_project_service.compute_api]
}

# 3. Firewall: Open Port 3000 for Grafana
resource "google_compute_firewall" "allow_grafana" {
  name    = "allow-grafana-port"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = var.source_ranges # Open to all; could be restricted to home IP for extra security.
  target_tags   = ["grafana"]

  # Ensures the API is fully active before creating the firewall rule
  depends_on = [google_project_service.compute_api]
}

# 4. The Monitoring Host (e2-micro VM)
resource "google_compute_instance" "monitoring_server" {
  name         = "nas-monitoring-host"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["grafana"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 10
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  # This allows the VM to use Google's monitoring APIs without a JSON key file
  service_account {
    scopes = ["https://www.googleapis.com/auth/monitoring.read", "https://www.googleapis.com/auth/logging.write"]
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    # Deploy Grafana; set to auto-restart if the VM reboots
    sudo docker run -d -p 3000:3000 --name=grafana --restart=always grafana/grafana-oss
  EOF

  depends_on = [google_project_service.compute_api]
}

# 5. Permissions: Let the VM read Monitoring data
resource "google_project_iam_member" "grafana_monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_compute_instance.monitoring_server.service_account[0].email}"
}

# 6. Output: The URL you will use to access your dashboard
output "grafana_url" {
  value = "http://${google_compute_address.static_ip.address}:3000"
}