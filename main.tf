# Compute instance with default network
resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}

# VPC Creation
resource "google_compute_network" "vpc" {
  name                    = "test-vpc-for-vm"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

# Create the public subnet
resource "google_compute_subnetwork" "test_public_subnet" {
  name          = "test-public-subnet-1"
  ip_cidr_range = "10.10.1.0/24"
  network       = google_compute_network.vpc.name
  region        = "europe-west1"
}

# Setting firewall rules
resource "google_compute_firewall" "allow-http" {
  name    = "test-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags   = ["http"]
  source_ranges = ["0.0.0.0/0"] # Allow traffic from any source
}

resource "google_compute_firewall" "allow-https" {
  name    = "test-fw-allow-https"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags   = ["https"]
  source_ranges = ["0.0.0.0/0"] # Allow traffic from any source
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.app_name}-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["ssh"]
  source_ranges = ["0.0.0.0/0"] # Allow traffic from any source
}

resource "google_compute_firewall" "allow-rdp" {
  name    = "${var.app_name}-fw-allow-rdp"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  target_tags   = ["rdp"]
  source_ranges = ["0.0.0.0/0"] # Allow traffic from any source
}

# Create VM #1 in the public subnet
resource "google_compute_instance" "test_vm_instance_public" {
  name         = "test-vm-instance"
  machine_type = "f1-micro"
  zone         = "europe-west4-a"
  hostname     = "testvm-${var.app_domain}"
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-9"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.test_public_subnet.name

    access_config {
      // Ephemeral IP
    }
  }
}
