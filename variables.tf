variable "yc_sak" {
  description = "Path to the service account key file"
  type        = string
  sensitive   = true
}

variable "yc_service_account_id" {
  description = "Yandex Cloud Service Account ID"
  type        = string
  sensitive   = true
}

variable "yc_id" {
  description = "Yandex Cloud ID"
  type        = string
  sensitive   = true
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  sensitive   = true
}

variable "yc_zone" {
  description = "Yandex Cloud Zone"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_public_key" {
  description = "public SSH key for VM access"
  type        = string
  sensitive   = true
}