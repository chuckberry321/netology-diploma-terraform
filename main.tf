resource "yandex_vpc" "my_vpc" {
  name        = "my-vpc"
  description = "VPC created with Terraform"
  zone        = "ru-central1-a"
  subnet_ids  = yandex_vpc_subnet.subnet.*.id

  dynamic_subnet_ids = [
    yandex_vpc_subnet.dynamic_subnet.id
  ]

  type = "ROUTED"
  default_security_group_id = yandex_vpc_network_security_group.my_security_group.id

  route_table_ids = [
    yandex_vpc_route_table.route_table.id
  ]
  
  nat = [
    {
      name          = "my-nat"
      subnet_id     = yandex_vpc_subnet.subnet.0.id
      ip_version    = "ipv4"
      ip_address    = yandex_vpc_address.nat_address.ip_address
      ip_permission = "ALLOW_ALL"
      tags = {
        env = "prod"
      }
    }
  ]

  dhcp_options_name = yandex_vpc_dhcp_options.dhcp_options.name
  
  labels = {
    env = "prod"
  }
}
