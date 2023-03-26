terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.87.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "*****"
  cloud_id                 = "*****"
  folder_id                = "*****"
  zone                     = "ru-central1-b"
}

resource "yandex_compute_instance" "build" {
  name = "build"
  platform_id = "standard-v3"
  zone = "ru-central1-b"

resources {
    cores = 4
    memory = 4
    core_fraction = 50
  }

 scheduling_policy {
    preemptible = "true"
  }
 boot_disk {
    initialize_params {
        image_id = "fd8c3dv7t6prd7j4n162"
        size = 8
    }
  }

 network_interface {
    subnet_id = "e2ls0jo68rhkjcrtkntj"
    nat = "true"
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "*****"
  }
}

resource "yandex_compute_instance" "deploy" {
  name = "deploy"
  platform_id = "standard-v3"
  zone = "ru-central1-b"

  resources {
    cores = 2
    memory = 2
    core_fraction = 50
  }

   scheduling_policy {
    preemptible = "true"
  }

  boot_disk {
    initialize_params {
        image_id = "fd8c3dv7t6prd7j4n162"
        size = 8
    }
  }  
   network_interface {
    subnet_id = "e2ls0jo68rhkjcrtkntj"
    nat = "true"
  }

 metadata = {
    serial-port-enable = 1
    ssh-keys = "*****"
 }
}

resource "local_file" "external_ip_build_instance" {
    content  = yandex_compute_instance.build.network_interface.0.nat_ip_address
    filename = "build_ip.txt"
}


resource "local_file" "external_ip_deploy_instance" {
    content  = yandex_compute_instance.deploy.network_interface.0.nat_ip_address
    filename = "deploy_ip.txt"
}