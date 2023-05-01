terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.41.0"
    }
  }
}

provider "yandex" {
  folder_id = var.folder_id
  cloud_id = var.cloud_id
  token = var.oauth_token
}

resource "yandex_vpc_network" "vpc" {
  name = "my-vpc"
}

resource "yandex_vpc_subnet" "subnet_1" {
  name = "subnet-1"
  network_id = yandex_vpc_network.vpc.id
  zone = "ru-central1-a"
  cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet_2" {
  name = "subnet-2"
  network_id = yandex_vpc_network.vpc.id
  zone = "ru-central1-b"
  cidr_blocks = ["10.0.1.0/24"]
}
