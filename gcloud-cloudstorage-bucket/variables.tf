variable "name" {
  type = string
  description = "Bucket name"
}

variable "cors" {
  type = list(object({
    name = string
    origin = list(string)
    method = list(string)
    response_header = list(string)
    max_age_seconds = number
  }))

  description = "Set CORS configuration"
  default = [
    {
      name = "cors"
      origin = [ ]
      method = [ ]
      response_header = [ ]
      max_age_seconds = 0
    }
  ]
}
