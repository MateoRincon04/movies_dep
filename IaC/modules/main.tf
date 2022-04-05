terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5.0"
    }
  }

  required_version = ">= 1.0.2"
}

provider "aws" {
  region = "us-west-1"
  profile = "default"
}

# Get Local Public IP
data "external" "findmyip" {
  program = ["/bin/bash" , "${path.module}/findmyip.sh"]
}

# VPC
data "aws_vpc" "ramp_up_training_vpc" {
  id = "vpc-0d2831659ef89870c"
}

# Subnet public 1
data "aws_subnet" "ramp_up_training-public-1" {
  id = "subnet-055c41fce697f9cca"
}

# Subnet private 0
data "aws_subnet" "ramp_up_training-private-0" {
  id = "subnet-0d74b59773148d704"
}

# Subnet private 1
data "aws_subnet" "ramp_up_training-private-1" {
  id = "subnet-038fa9d9a69d6561e"
}

resource "tls_private_key" "key" {
 algorithm = "RSA"
 rsa_bits  = 4096
}

# Key pair
resource "aws_key_pair" "mateorincona" {
  key_name = "mateo.rincona"
  public_key = tls_private_key.key.public_key_openssh
}

# 
resource "local_file" "private_key" {
  sensitive_content = tls_private_key.key.private_key_pem
  filename          = format("%s/%s/%s", abspath(path.root), ".ssh", "mateo.rincona.pem")
  file_permission   = "0600"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl", {
      ip          = aws_instance.bastion.public_ip,
      ssh_keyfile = local_file.private_key.filename
  })
  filename = format("%s/%s", abspath(path.root), "inventory.yaml")
}
