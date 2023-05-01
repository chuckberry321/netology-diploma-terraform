terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.14"
}

provider "yandex" {
  token     =  var.yc_token
  cloud_id  =  var.yc_cloud_id
}

resource "yandex_resourcemanager_folder" "mysite" {
  cloud_id = var.yandex_cloud_id
  name        = "mysite"
  description = "folder to mysite"
}

resource "yandex_iam_service_account" "admin" {
  name        = "admin"
  description = "service account to manage mysite"
  folder_id   = "${yandex_resourcemanager_folder.mysite.id}"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = "${yandex_resourcemanager_folder.mysite.id}"
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.admin.id}",
  ]
}
