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


# Key pair
data "aws_key_pair" "mateorincona" {
  key_name = "mateo.rincona"
}
