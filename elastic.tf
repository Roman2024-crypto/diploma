# Kibana

resource "yandex_compute_instance" "elastic" {
  zone                = var.yc_zone
  name                   = "elastic"
  hostname               = "elastic"
  platform_id            = "standard-v2"
  
  resources {
    cores                = 2
    memory               = 8
    core_fraction        = 20
  }

  boot_disk {
    initialize_params {
      size               = 10
      image_id           = "fd84d8ve4g091jun43if"
      type               = "network-hdd"
    }
  }

  scheduling_policy {
    preemptible = false
  }

  network_interface {
    subnet_id             = yandex_vpc_subnet.net-1.id
    security_group_ids    = [yandex_vpc_security_group.sg-elastic.id,
                            yandex_vpc_security_group.sg-zabbix-agent.id, 
                            yandex_vpc_security_group.ssh-from-basion.id]
    ip_address            = "192.168.10.50"                      
    nat                   = false
  }

  metadata = {
    user-data             = "${file("./metafiles/meta.yml")}"
    serial-port-enable    = 1
  }
}