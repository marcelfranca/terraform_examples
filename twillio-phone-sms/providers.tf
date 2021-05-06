terraform {
  required_providers {
    twilio = {
      source  = "RJPearson94/twilio"
      version = ">= 0.2.1"
    }
  }
}

provider "twilio" {}