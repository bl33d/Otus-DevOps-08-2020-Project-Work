provider "yandex" {
    service_account_key_file = pathexpand("~/yandex-cloud/terraform-bot-key.json")
    cloud_id = var.cloud_id
    folder_id = var.folder_id
    zone = var.zone
}

resource "yandex_compute_instance" "gitlab_instance" {
    name = "gitlab"
    allow_stopping_for_update = true

    resources {
    cores  = 4
    memory = 8
    }

    metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
    }

    boot_disk {
        initialize_params {
        image_id = var.image_id
        size = 50
        type = "network-ssd"
        }
    }

    network_interface {
        subnet_id = var.subnet_id
        nat       = true
    }
}

resource "yandex_compute_instance" "monitoring_instance" {
    name = "monitoring"

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
        type = "network-ssd"
        }
    }

    network_interface {
        subnet_id = var.subnet_id
        nat       = true
    }
}
