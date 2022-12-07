terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}


# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "trf_ssh_key" {
  name = "ansible_do"
}

data "digitalocean_project" "lab_project" {
  name = "4640_Labs"
}

# Create a new tag 
# Use tag to create load balancer
resource "digitalocean_tag" "instanceRole" {
  name = "A01062029"
}


resource "digitalocean_droplet" "application" {
  image    = var.image_name
  ip_range = "10.46.40.0/24"
  name     = "application_A01062029"
  region   = var.region
  size     = "s-1vcpu-512mb-10gb"
  tags     = [digitalocean_tag.instanceRole.id]
  ssh_keys = [data.digitalocean_ssh_key.trf_ssh_key.id]
  vpc_uuid = digitalocean_vpc.web_vpc.id

  # lifecycle
  # if terraform is unable to change existing resources or existing infrastructure it will destroy that infrastructure
  # and create a new one 
  lifecycle {
    create_before_destroy = true
  }
}


resource "digitalocean_droplet" "frontend" {
  image    = var.image_name
  ip_range = "10.46.40.0/24"
  name     = "frontend_A01062029"
  region   = var.region
  size     = "s-1vcpu-512mb-10gb"
  tags     = [digitalocean_tag.instanceRole.id]
  ssh_keys = [data.digitalocean_ssh_key.trf_ssh_key.id]
  vpc_uuid = digitalocean_vpc.web_vpc.id

  # lifecycle
  # if terraform is unable to change existing resources or existing infrastructure it will destroy that infrastructure
  # and create a new one 
  lifecycle {
    create_before_destroy = true
  }
}

output "server_ip" {
  value = digitalocean_droplet.application.*.ipv4_address
}

# Create a new VPC
resource "digitalocean_vpc" "web_vpc" {
  name   = "web"
  region = var.region
}