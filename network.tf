# networks
locals {
  network_name = "net-1"
}

resource "yandex_vpc_network" "net-1" {
  name = local.network_name
}

resource "yandex_vpc_subnet" "net-1" {
  name           = "lan10"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
    route_table_id = yandex_vpc_route_table.route_table.id
}

resource "yandex_vpc_subnet" "net-2" {
  name           = "lan20"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.net-1.id
  v4_cidr_blocks = ["192.168.20.0/24"]
    route_table_id = yandex_vpc_route_table.route_table.id
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "route_table" {
  network_id = yandex_vpc_network.net-1.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}
