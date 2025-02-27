# Bastion

resource "yandex_compute_instance" "bastion" {
  zone            = var.yc_zone
  name            = "bastion"
  hostname        = "bastion"
  platform_id     = "standard-v2"

resources {
  cores           = 2
  memory          = 2
  core_fraction   = 5
}

boot_disk {
  initialize_params {
    size          = 10
    image_id      = "fd84d8ve4g091jun43if"
    type          = "network-hdd"
  }
}

scheduling_policy {
  preemptible     = false
}

network_interface {
  subnet_id = yandex_vpc_subnet.net-1.id
  security_group_ids = [yandex_vpc_security_group.sg-bastion.id]
  nat             = true
}

  metadata = {
    user-data = templatefile("${path.module}/metafiles/meta.yml", {
      ssh_public_key = var.ssh_public_key
    })
    serial-port-enable = 1
  }
}