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

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }


  network_interface {
    network = "default"
  }
} 
