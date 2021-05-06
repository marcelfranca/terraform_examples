variable "account_sid" {
  type        = string
  description = "The account SID to associate the phone number with"
}

variable "phone_number" {
  type        = string
  description = "The phone number to purchase"
}

variable "friendly_name" {
  type = string
  description = "A name for the messaging service"
}