resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
  {
    instance_ip_gitlab = yandex_compute_instance.gitlab_instance[*].network_interface.0.nat_ip_address,
    instance_ip_monitoring = yandex_compute_instance.monitoring_instance[*].network_interface.0.nat_ip_address,
  }
  )
  filename = "../ansible/environments/prod/inventory"
  directory_permission = "0755"
  file_permission = "0644"
}
