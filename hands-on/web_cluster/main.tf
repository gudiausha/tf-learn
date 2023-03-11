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

resource "google_compute_instance_template" "instance_template"{
  name_prefix = "instance-template-"
  machine_type = "f1-micro"
  instance_description = "This is an alternative of launch_configuration in aws"
  tags = ["terraform-web-cluster","http-server","https-server"]
  metadata_startup_script = "${file("startup_script.sh")}"

  disk {
    source_image = "debian-cloud/debian-10"
    auto_delete = true
  }

  network_interface {
    network = "default"

        access_config {
      // Allocate a ephemeral external IP
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/healthz"
    port         = "8080"
  }
}

resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "instance-group-manager"
  base_instance_name = "instance-group-manager"
  zone               = var.zone
  target_size        = "3"

  version {
    instance_template = google_compute_instance_template.instance_template.self_link
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }

  update_policy {
    type                           = "PROACTIVE"
    minimal_action                 = "REPLACE"
    most_disruptive_allowed_action = "REPLACE"
    max_surge_fixed = 3
    max_unavailable_fixed          = 2
    replacement_method             = "SUBSTITUTE"
  }
}

resource "google_compute_firewall" "allow-http" {
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
  name    = "allow-egress"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [var.http_server_port, var.https_server_port]
  }

  direction = "EGRESS"
  target_tags = ["terraform-web-cluster"]
}
