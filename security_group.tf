resource "yandex_vpc_security_group" "sg-bastion" {
  name        = "sg-bastion"
  network_id  = yandex_vpc_network.net-1.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 1
    to_port        = 65535
  }
  
  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "ICMP"
    description    = "Echo responds from hosts"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }
}
