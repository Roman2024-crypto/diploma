locals {
  network_name = "net-1"
}

resource "yandex_vpc_network" "network-1" {
  name = local.network_name
}

resource "yandex_vpc_network" "net-1" {
  name = local.network_name
}

resource "yandex_vpc_subnet" "net-1" {
  name           = "lan10"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}