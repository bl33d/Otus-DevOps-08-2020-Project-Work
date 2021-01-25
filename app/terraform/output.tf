data "yandex_compute_instance" "monitoring_instance" {
  name = "monitoring"
}

resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
  {
    instance_app_ip = yandex_compute_instance.app_instance[*].network_interface.0.nat_ip_address,
    instance_monitoring_ip = data.yandex_compute_instance.monitoring_instance[*].network_interface.0.nat_ip_address
  }
  )
  filename = "../ansible/environments/prod/inventory"
  directory_permission = "0755"
  file_permission = "0644"
}
