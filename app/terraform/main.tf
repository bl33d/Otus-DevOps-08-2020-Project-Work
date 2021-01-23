provider "yandex" {
    service_account_key_file = pathexpand("~/yandex-cloud/terraform-bot-key.json")
    cloud_id = var.cloud_id
    folder_id = var.folder_id
    zone = var.zone
}

resource "yandex_compute_instance" "app_instance" {
    name = "app"

    resources {
    cores  = 2
    memory = 4
    }

    metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
    }

    boot_disk {
        initialize_params {
        image_id = var.image_id
        size = 50
        }
    }

    network_interface {
        subnet_id = var.subnet_id
        nat       = true
    }
}
