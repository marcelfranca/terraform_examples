locals {
  peer_map = { for peer, att in var.peers : att.name => att }
}

resource "google_compute_network_peering" "peering" {
  for_each                            = local.peer_map
  name                                = each.value.name
  network                             = each.value.orig_network
  peer_network                        = each.value.peer_network
  export_custom_routes                = true
  import_custom_routes                = true
  export_subnet_routes_with_public_ip = true
  import_subnet_routes_with_public_ip = true
}
