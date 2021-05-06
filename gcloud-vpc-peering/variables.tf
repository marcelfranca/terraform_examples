// REQUIRED
variable "peers" {
  type = list(object({
    name         = string
    orig_network = string
    peer_network = string
  }))
  description = "Vpcs to be peered"
}