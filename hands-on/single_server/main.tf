# resource "<PROVIDER>_<TYPE>" "<NAME>" {
#  [CONFIG ...]
# }
# resource "google_project" "project" {
#   name            = var.project_name
#   project_id      = var.project_id
#   billing_account = var.billing_account_id

#   labels = {
#     environment = var.environment
#   }
# }

resource "google_project_service" "service_enabler" {
  service = "compute.googleapis.com"
}

resource "google_compute_instance" "default_instance" {
  depends_on = [
    google_project_service.service_enabler
  ]

  name         = "tf-test"
  machine_type = "f1-micro"
  zone = var.zone

  tags = ["terraform-example","http-server","https-server"]

  # metadata_startup_script = <<EOF
  #   #!/bin/bash
  #   echo "Hello, World" > /var/www/html/index.html
  #   nohup busybox httpd -f -p 8080 &
  # EOF

  metadata_startup_script = "${file("startup_script.sh")}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }


  network_interface {
    network = "default"

        access_config {
      // Allocate a ephemeral external IP
    }
  }

  
} 

resource "google_compute_firewall" "allow-http" {
  depends_on = [
    google_compute_instance.default_instance
  ]
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [var.http_server_port]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}

resource "google_compute_firewall" "allow-https" {
  depends_on = [
    google_compute_instance.default_instance
  ]
  name    = "allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [var.https_server_port]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["https-server"]
}

resource "google_compute_firewall" "allow-egress" {
  depends_on = [
    google_compute_instance.default_instance
  ]
  name    = "allow-egress"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [var.http_server_port, var.https_server_port]
  }

  direction = "EGRESS"
  target_tags = ["terraform-example"]
}