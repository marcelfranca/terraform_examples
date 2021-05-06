# VPC
resource "google_compute_network" "vpc" {
  name                            = var.vpc_name
  description                     = "Google vpc"
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = var.delete_default_route
}

locals {
  subnets_map = { for subnet, att in var.subnets : att.name => att }
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  for_each      = local.subnets_map
  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr
  region        = each.value.region
  network       = google_compute_network.vpc.id

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_range
    content {
      range_name    = secondary_ip_range.value["range_name"]
      ip_cidr_range = secondary_ip_range.value["ip_cidr_range"]
    }
  }
}