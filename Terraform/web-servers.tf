#Group the Web Servers

resource "yandex_compute_instance_group" "webservers" {
	name                               = "webservers"
	service_account_id                 = var.yc_service_account_id

	instance_template {
	    platform_id                    = "standard-v2"
	    service_account_id             = var.yc_service_account_id
	    name                           = "webserver-{instance.index}"
	    hostname                       = "webserver-{instance.index}"

	    resources {
	        cores                      = 2
	        memory                     = 2
	        core_fraction              = 5
	    }

	    boot_disk {
	        mode = "READ_WRITE"
	        initialize_params {
	            size                   = 10
                image_id               = "fd84d8ve4g091jun43if"
                type                   = "network-hdd"
	        }
	    }

        network_interface {
            network_id                 = yandex_vpc_network.net-1.id
            subnet_ids                 = [yandex_vpc_subnet.net-1.id,yandex_vpc_subnet.net-2.id]
            nat                        = false
            security_group_ids = [yandex_vpc_security_group.sg-webservers.id, 
                            yandex_vpc_security_group.ssh-from-basion.id,
                            yandex_vpc_security_group.sg-filebeat.id,
                            yandex_vpc_security_group.sg-zabbix-agent.id]
        }

        metadata = {
  			user-data          		   = file("./metafiles/web-meta.yml")
  			ssh-keys           		   = "user:${var.ssh_public_key}"
  			serial-port-enable 		   = 1
		}

	}

	scale_policy {
        fixed_scale {
            size                       = 2
        }
    }

    allocation_policy {
        zones = ["ru-central1-a", "ru-central1-b"]
    }

    deploy_policy {
        max_unavailable                = 1
        max_expansion                  = 0
    }

    application_load_balancer {
        target_group_name = "tg-balancer"
    }

    
}


