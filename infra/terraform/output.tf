resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
  {
    instance_ip = yandex_compute_instance.gitlab_instance[*].network_interface.0.nat_ip_address,
  }
  )
  filename = "../ansible/environments/prod/inventory"
  directory_permission = "0755"
  file_permission = "0644"
}
