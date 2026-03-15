# 🛰️ Hybrid NAS Observability Stack

A professional-grade monitoring solution bridging a local Ubuntu-based NAS with **Google Cloud Platform (GCP)**. This project demonstrates modern DevOps practices, including Infrastructure as Code (IaC), secure keyless authentication, and hybrid-cloud observability.

## 🏗️ Architecture
* **Edge:** Ubuntu Server (Dell OptiPlex 3050) running `node_exporter` and Google Cloud Ops Agent.
* **Cloud (GCP):** Google Managed Service for Prometheus (GMP) for long-term metric ingestion and storage.
* **Visualization:** Grafana hosted on a GCP Free Tier `e2-micro` instance.

## 🛠️ Tech Stack
* **Infrastructure:** Terraform
* **Security:** Workload Identity Federation (OIDC)
* **Cloud:** Google Cloud Platform (GCP)
* **Monitoring:** Prometheus & Grafana

## 🛡️ Security & Best Practices
* **Keyless Authentication:** This project uses **Workload Identity Federation (WIF)**. No long-lived GCP Service Account keys (JSON) are stored in GitHub Secrets. Instead, automation authenticates via temporary OIDC tokens.
* **Remote State Management:** Terraform state is stored in a versioned, private Google Cloud Storage (GCS) bucket with **Public Access Prevention** enforced.
* **Deterministic Builds:** A `.terraform.lock.hcl` is maintained to ensure consistent provider versions between local WSL development and CI/CD environments.
* **Least Privilege:** The Service Account is scoped specifically to the minimum required permissions (`roles/monitoring.metricWriter` and `roles/compute.admin`).

## 📈 Monitoring Objectives
The primary goal of this stack is to monitor high-level NAS operations:
* **Storage Health:** Real-time tracking of a `mergerfs` pool consisting of internal SSD and external HDD storage.
* **Data Pipeline:** Monitoring throughput and success rates of hourly `rclone` synchronization tasks to Google Drive.
* **Resource Pressure:** Visualizing CPU and Memory usage during heavy photo processing workflows and automated backups.

## 🚀 Deployment
1.  **Infrastructure:** Changes to `.tf` files in the `main` branch trigger an automated process that authenticates via WIF and applies changes to GCP.
2.  **Edge Agent:** The local NAS runs the Google Ops Agent, configured to scrape local Prometheus metrics and "remote-write" them to the GCP endpoint.

---
*Developed by Denys as a demonstration of Hybrid-Cloud Infrastructure and Observability.*
