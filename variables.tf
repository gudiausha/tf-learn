variable "project_name" {
  type        = string
  description = "The name of the GCP project to create."
}

variable "project_id" {
  type        = string
  description = "The unique identifier of the GCP project to create."
}

# variable "billing_account_id" {
#   type        = string
#   description = "The ID of the billing account to associate with the project."
# }

variable "region" {
  type        = string
  default     = "us-central1"
  description = "The default region to use for resources in the project."
}

variable "zone" {
  type        = string
  default     = "us-central1-c"
  description = "The default region to use for resources in the project."
}

variable "environment" {
  type        = string
  default     = "development"
  description = "The environment tag to assign to the project."
}
