output "bastion_status" {
  value       = yandex_compute_instance.bastion.status
  description = "Статус виртуальной машины Bastion"
}

output "bastion_IP" {
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
  description = "Публичный IP-адрес виртуальной машины Bastion"
}

# Статусы виртуальных машин в группе Web Servers
output "webservers_statuses" {
  value       = join(", ", yandex_compute_instance_group.webservers.instances[*].status)
  description = "Статусы виртуальных машин в группе Web Servers"
}

# Статус виртуальной машины Elastic
output "elastic_status" {
  value       = yandex_compute_instance.elastic.status
  description = "Статус виртуальной машины Elastic"
}

# Статус виртуальной машины Kibana
output "kibana_status" {
  value       = yandex_compute_instance.kibana.status
  description = "Статус виртуальной машины Kibana"
}

# Статус виртуальной машины Zabbix
output "zabbix_status" {
  value       = yandex_compute_instance.zabbix.status
  description = "Статус виртуальной машины Zabbix"
}

output "snapshot_schedule_status" {
  value       = yandex_compute_snapshot_schedule.snapshot.status
  description = "Статус расписания снапшотов"
}

output "backup_disk_ids" {
  value       = toset(yandex_compute_snapshot_schedule.snapshot.disk_ids)
  description = "Список ID дисков, включенных в расписание снапшотов"
}