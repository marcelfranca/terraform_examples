// REQUIRED
variable "name" {
  type = string
}

variable "instance_type" {
  type        = string
  description = "GCP instance type"
}

variable "os_image_name" {
  type        = string
  description = "Operational System image for the instance. You can get a list with gcloud compute images list"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC to deploy the instance"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnetwork to deploy the instance"
}


// OPTIONAL
variable "zone" {
  type        = string
  description = "GCP zone where to deploy the instance"
  default     = "us-east1"
}

variable "scratch_disk" {
  type        = string
  description = "Type of disk interface to be used. Can only be SCSI or NVME"

  validation {
    condition     = can(regex("^SCSI", var.scratch_disk)) || can(regex("^NVME", var.scratch_disk))
    error_message = "Value can only be: SCSI or NVME."
  }
  default = "SCSI"
}

variable "preferred_ip" {
  type        = string
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned."
  default     = ""
}

variable "external_ip" {
  type        = string
  description = "The public IP address to assign to the instance. If empty, the address will be automatically assigned."
  default     = ""
}

variable "root_disk_size" {
  type        = string
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image."
  default     = "10"
}

variable "tags" {
  type    = list(string)
  default = [""]
}
