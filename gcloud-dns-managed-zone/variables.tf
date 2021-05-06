// REQUIRED
variable "zone_name" {
  type = string
}

variable "dns_name" {
  type        = string
  description = "Full domain name to be set" # Eg. veganhive.net.

  validation {
    condition = (
      length(var.dns_name) > 4 &&
    substr(var.dns_name, -1, -1) == ".")
    error_message = "Must finish with a dot."
  }
}

variable "records" {
  type = list(object({
    record = string
    record_type = string
    record_ttl = number
    rrdata = list(string)
  }))
  description = "Define the DNS records"
}

variable "visibility" {
  type        = string
  description = "Set if the Zone will be private or public"

  validation {
    condition     = can(regex("^private", var.visibility)) || can(regex("^public", var.visibility))
    error_message = "Value can only be: private or public."
  }
}

// REQUIRED IF VISIBILITY IS PRIVATE
variable "vpcs" {
  type = list(string)
  description = "Define the subnets. Formatted as projects/{project}/global/networks/{network}"
}

// OPTIONAL
variable "dns_description" {
  type        = string
  description = "Brief description for zone"
  default = "VeganHive Zone"
}
