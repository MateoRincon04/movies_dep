#MODULE ????


# Get Local Public IP
data "external" "findmyip" {
  program = ["/bin/bash" , "${path.module}/findmyip.sh"]
}

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

# VPC
resource "aws_vpc" "ramp_up_training_vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "ramp_up_training"
  }
}

# Subnet public 1
resource "aws_subnet" "ramp_up_training-public-1" {
  vpc_id = aws_vpc.ramp_up_training_vpc.id
  cidr_block = "10.1.8.0/21"
  availability_zone = "us-west-1c"

  tags = {
    Name = "ramp_up_training-public-1"
  }
}

# Key pair
resource "aws_key_pair" "mateorincona" {
  key_name = "mateo.rincona"
  public_key = "AKIA57XXQ6GYVJECTXZG"

  tags = {
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

# Target groups for LB's
resource "aws_lb_target_group" "TG-Backend" {
  name     = "TG-Backend"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.ramp_up_training_vpc.id

    tags = {
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

resource "aws_lb_target_group" "TG-Frontend" {
  name     = "TG-Frontend"
  port     = 3030
  protocol = "HTTP"
  vpc_id   = aws_vpc.ramp_up_training_vpc.id

  tags = {
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

# Bastion instance
resource "aws_instance" "bastion" {
  ami = "ami-009726b835c24a3aa" #Ubuntu Server 18.04 LTS (HVM), SSD Volume Type, 64-bit x86
  instance_type = "t2.micro"

  associate_public_ip_address = "true"
  subnet_id = "subnet-055c41fce697f9cca"

  key_name = "mateo.rincona"
  security_groups = ["SG-Backend-movie-analyst"]

  tags = {
    Name = "Bastion"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
 }




# SG for Bastion instance
resource "aws_security_group" "SG-Bastion-movie-analyst" {
  name = "SG-Bastion-movie-analyst"
  description = "Allow Frontend Auto Scaling Instances inbound traffic"
  vpc_id = aws_vpc.ramp_up_training_vpc.id

  ingress {
    description = "Local to Bastion"
    from_port = 22
    to_port = 22
    protocol = "ssh"
    cidr_blocks = [format("%s/%s",data.external.findmyip.result["internet_ip"],32)]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SG-Bastion-movie-analyst"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

# SG for Back instances
resource "aws_security_group" "SG-Backend-movie-analyst" {
  name = "SG-Backend-movie-analyst"
  description = "Allow Frontend Auto Scaling Instances inbound traffic"
  vpc_id = aws_vpc.ramp_up_training_vpc.id

# Allow access from Bastion through SSH
  ingress {
    description = "Allow access from Bastion through SSH"
    from_port = 22
    to_port = 22
    protocol = "ssh"
    cidr_blocks = [aws_instance.bastion.private_dns]
  }

# Allow access from Frontend to LB-Backend through port 3000
  ingress {
    description = "Bastion and LB to Backend instances"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = [] # unir al security group del front
  }

# Allow access from itself ???
  ingress {
    description = "Bastion to Backend"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = []
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SG-Backend-movie-analyst"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

# SG for Front instances
resource "aws_security_group" "SG-Frontend-movie-analyst" {
  name = "SG-Frontend-movie-analyst"
  description = "Allow Frontend Auto Scaling Instances inbound traffic"
  vpc_id = aws_vpc.ramp_up_training_vpc.id

# Allow access from Bastion through SSH
  ingress {
    description = "Allow access from Bastion through SSH"
    from_port = 22
    to_port = 22
    protocol = "ssh"
    cidr_blocks = [aws_instance.bastion.private_dns]
  }

# Allow access from itself ???
  ingress {
    description = "LB to Frontend intances in the SG"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = []
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SG-Frontend-movie-analyst"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}



# Application Load Balancers
resource "aws_lb" "ALB-Backend" {
  name               = "ALB-Backend"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG-Backend-movie-analyst.id]
  subnets            = [aws_subnet.ramp_up_training-private-0.id]
  # Me falta conectar el Target Group del Back (Checked)
  enable_deletion_protection = true
  ip_address_type = "ipv4"

  tags = {
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

# Conectar el TG al LB del backend
resource "aws_lb_target_group_attachment" "TG-to-LB-Backend" {
  target_group_arn = aws_lb_target_group.TG-Backend.arn
  target_id        = aws_lb.ALB-Backend.arn
  port             = 3000
}

# Application Load Balancers
resource "aws_lb" "ALB-Frontend" {
  name               = "ALB-Frontend"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG-Frontend-movie-analyst.id]
  subnets            = [aws_subnet.ramp_up_training-private-1.id]
  # Me falta conectar el Target Group del Back (Checked)
  enable_deletion_protection = true
  ip_address_type = "ipv4"

  tags = {
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

# Conectar el TG al LB del frontend
resource "aws_lb_target_group_attachment" "TG-to-LB-Frontend" {
  target_group_arn = aws_lb_target_group.TG-Frontend.arn
  target_id        = aws_lb.ALB-Frontend.arn
  port             = 80
}