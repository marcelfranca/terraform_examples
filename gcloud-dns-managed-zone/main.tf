resource "google_dns_managed_zone" "zone" {
  name        = var.zone_name
  dns_name    = var.dns_name
  description = var.dns_description
  visibility  = var.visibility

  // It will be skipped if public visibility
  private_visibility_config {
    dynamic "networks" {
      for_each = var.vpcs
      content {
        network_url = networks.value
      }
    }
  }
}

//locals {
//  records_map = { for record, obj in var.records : obj.record => obj }
//}

resource "google_dns_record_set" "record" {
  for_each     = var.records
  name         = "${each.value.record}.${google_dns_managed_zone.zone.dns_name}"
  managed_zone = google_dns_managed_zone.zone.name
  type         = each.value.record_type
  ttl          = each.value.record_ttl
  rrdatas      = each.value.rrdata
}