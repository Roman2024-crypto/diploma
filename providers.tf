# providers.tf
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file = var.yc_sak
  cloud_id  = var.yc_id
  folder_id = var.yc_folder_id
  zone = var.yc_zone
  
}
