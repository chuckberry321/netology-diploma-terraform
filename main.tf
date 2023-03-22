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

resource "yandex_vpc_subnet" "subnet" {
  count         = 3
  name          = "my-subnet-${count.index+1}"
  description   = "My subnet"
  zone          = var.zones[count.index]
  network_id    = yandex_vpc_network.my_network.id
  v4_cidr_blocks = [format("10.%d.0.0/16", count.index+1)]
  labels        = attr_merge(yandex_vpc_network.my_network.labels, {
    "env" = "prod",
    "app" = "my-app",
    "subnet-number" = "${count.index}"
  })
}

resource "yandex_vpc_route_table" "route_table" {
  name = "my-route-table"
  description = "My VPC routes"
  labels = {
    env = "prod"
  }
}

resource "yandex_vpc_network_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "My security group"

  rules = [
    {
      direction = "INGRESS"
      description = "Allow SSH from all"
      ports = [
        {
          protocol = "TCP"
          port     = "22"
        }
      ]
      ip_version = "ipv4"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  labels = {
    env = "prod"
  }
}

resource "yandex_vpc_address" "nat_address" {
  subnet_id = yandex_vpc_subnet.subnet.0.id
  ip_version = "ipv4"
  name = "my-nat-address"
}

resource "yandex_vpc_dhcp_options" "dhcp_options" {
  name = "dhcp-options"
  domain_name_servers = ["10.0.0.2", "10.0.0.3"]
  netbios_node_type = "HNODE"
}
