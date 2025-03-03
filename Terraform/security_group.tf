# Security Groups

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

resource "yandex_vpc_security_group" "ssh-from-basion" {
  name        = "ssh-from-basion"
  network_id  = yandex_vpc_network.net-1.id
  
  ingress {
    protocol       = "TCP"
    description    = "ssh-from-bastion"
    security_group_id = yandex_vpc_security_group.sg-bastion.id
    port           = 22
  }

  ingress {
    protocol       = "ICMP"
    description    = "Ping from internal net"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }
}

resource "yandex_vpc_security_group" "sg-balancer" {
  name        = "sg-balancer"
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
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol          = "TCP"
    description       = "healthchecks"
    predefined_target = "loadbalancer_healthchecks"
    port              = 30080
  }
}

resource "yandex_vpc_security_group" "sg-webservers" {
  name        = "sg-webservers"
  network_id  = yandex_vpc_network.net-1.id

  egress {
    protocol           = "ANY"
    description        = "any"
    v4_cidr_blocks     = ["0.0.0.0/0"]
    from_port          = 1
    to_port            = 65535
  }

  ingress {
    protocol           = "TCP"
    description        = "balancer"
    security_group_id  = yandex_vpc_security_group.sg-balancer.id
    port               = 80
  }
}

resource "yandex_vpc_security_group" "sg-elastic" {
  name                 = "sg-elastic-agent"
  network_id           = yandex_vpc_network.net-1.id
  
  ingress {
    protocol           = "TCP"
    description        = "elastic-ingress"
    v4_cidr_blocks     = ["192.168.10.0/24", "192.168.20.0/24"]
    port               = 9200
  }
  
  egress {
    protocol           = "TCP"
    description        = "elastic-egress-to-kibana"
    v4_cidr_blocks     = ["192.168.10.0/24", "192.168.20.0/24"]
    port               = 5601
  }
}

resource "yandex_vpc_security_group" "sg-kibana" {
  name             = "kibana-sg"
  network_id       = yandex_vpc_network.net-1.id
  
  ingress {
    protocol       = "TCP"
    description    = "kibana-ingress"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 5601
  }

  egress {
    protocol       = "TCP"
    description    = "kibana-egress-to-elsatic"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
    port           = 9200
  }

  egress {
    protocol       = "ANY"
    description    = "any to install all the things"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 1
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "sg-filebeat" {
  name        = "filebeat-sg"
  network_id  = yandex_vpc_network.net-1.id
  
  ingress {
    protocol       = "TCP"
    description    = "filebeat-ingress"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
    port           = 5044
  }

  egress {
    protocol       = "TCP"
    description    = "filebeat-egress-to-logstash"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
    port           = 5044
  }

  egress {
    protocol       = "TCP"
    description    = "filebeat-egress-to-elastic"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
    port           = 9200
  }

  egress {
    protocol       = "TCP"
    description    = "filebeat-egress-to-kibana"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
    port           = 5601
  }
}

resource "yandex_vpc_security_group" "sg-zabbix-server" {
  name        = "sg-zabbix-server"
  network_id  = yandex_vpc_network.net-1.id
  
  ingress {
    protocol       = "TCP"
    description    = "zabbix-server-ingress"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
    port           = 10051
  }

  egress {
    protocol       = "TCP"
    description    = "zabbix-server-egress"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
    port           = 10050
  }
  
  ingress {
    protocol       = "TCP"
    description    = "zabbix-server-webinterface-ingress"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8080
  }
}

resource "yandex_vpc_security_group" "sg-zabbix-agent" {
  name        = "sg-zabbix-agent"
  network_id  = yandex_vpc_network.net-1.id
  
  ingress {
    protocol       = "TCP"
    description    = "zabbix-agent-ingress"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
    port           = 10050
  }

  egress {
    protocol       = "TCP"
    description    = "zabbix-agent-egress"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
    port           = 10051
  }
}