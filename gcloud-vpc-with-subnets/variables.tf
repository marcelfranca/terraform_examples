// REQUIRED

variable "vpc_name" {
  type        = string
  description = "Vpc Name"
}


variable "routing_mode" {
  type        = string
  description = "How subnets will be distributed can be only REGIONAL or GLOBAL"

  validation {
    condition     = can(regex("^REGIONAL", var.routing_mode)) || can(regex("^GLOBAL", var.routing_mode))
    error_message = "The routing mode can only be REGIONAL or GLOBAL uppercase."
  }
}

// Subnet

variable "subnets" {
  # Array of objects
  type = list(object({
    name    = string
    ip_cidr = string
    region  = string
    secondary_ip_range = list(object({
      range_name    = string
      ip_cidr_range = string
    }))
  }))
  description = "Define the subnets"
}

//OPTIONAL

// VPC
variable "auto_create_subnetworks" {
  type        = bool
  description = "If Gcloud will create all subnetworks automatically"
  default     = false
}

variable "delete_default_route" {
  type        = bool
  description = "If Gcloud will delete egress default route after creation"
  default     = false
}
