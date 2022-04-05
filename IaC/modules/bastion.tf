# Bastion instance
resource "aws_instance" "bastion" {
  ami = "ami-009726b835c24a3aa" #Ubuntu Server 18.04 LTS (HVM), SSD Volume Type, 64-bit x86
  instance_type = "t2.micro"

  associate_public_ip_address = "true"
  subnet_id = data.aws_subnet.ramp_up_training-public-1.id
  private_ip = "10.1.8.5"

  key_name = data.aws_key_pair.mateorincona.key_name
  security_groups = [aws_security_group.SG-Bastion-movie-analyst.id]

  tags = {
    Name = "Bastion"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }

  volume_tags = {
    Name = "Bastion"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}


# SG for Bastion instance
resource "aws_security_group" "SG-Bastion-movie-analyst" {
  name = "SG-Bastion-movie-analyst"
  description = "Allow Frontend Auto Scaling Instances inbound traffic"
  vpc_id = data.aws_vpc.ramp_up_training_vpc.id

  ingress {
    description = "Local to Bastion"
    from_port = 22
    to_port = 22
    protocol = "tcp"
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
