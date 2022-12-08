# The API token
variable "do_token" {}


# set the default region to sfo3
variable "region" {
  type = string
  default = "sfo3"
}

variable "image_name" {
    type = string
    default = "ubuntu-minimal-1804-lts"
}