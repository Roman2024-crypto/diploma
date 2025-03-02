output "bastion_status" {
  value       = yandex_compute_instance.bastion.status
  description = "Статус виртуальной машины Bastion"
}

output "bastion_IP" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

# Статусы виртуальных машин в группе Web Servers
output "webservers_statuses" {
  value       = join(", ", yandex_compute_instance_group.webservers.instances[*].status)
  description = "Статусы виртуальных машин в группе Web Servers"
}