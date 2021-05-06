locals {
  cors_map = {for cors, att in var.cors : att.name => att}
}

resource "google_storage_bucket" "bucket" {
  name = var.name
  location = "US"
  force_destroy = true

  uniform_bucket_level_access = false

  for_each = local.cors_map
  cors {
    origin = each.value.origin
    method = each.value.method
    response_header = each.value.response_header
    max_age_seconds = each.value.max_age_seconds
  }
}
