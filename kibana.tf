# Elastic

resource "yandex_compute_instance" "kibana" {
  zone            = var.yc_zone
  name            = "kibana"
  hostname        = "kibana"
  platform_id     = "standard-v2"
  
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      size = 10
      image_id    = "fd84d8ve4g091jun43if"
      type = "network-hdd"
    }
  }

  scheduling_policy {
    preemptible = false
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.net-1.id
    security_group_ids = [yandex_vpc_security_group.sg-kibana.id,
                          yandex_vpc_security_group.sg-zabbix-agent.id, 
                          yandex_vpc_security_group.ssh-from-basion.id]
    ip_address         = "192.168.10.75" 
    nat       = true
  }

  metadata = {
    user-data = "${file("./metafiles/meta.yml")}"
    ssh-keys           = "user:${var.ssh_public_key}"
    serial-port-enable = 1
  }
}