# Instance to practice Jenkins
resource "aws_instance" "instance_jenkins" {
  ami = "ami-009726b835c24a3aa" #Ubuntu Server 18.04 LTS (HVM), SSD Volume Type, 64-bit x86
  instance_type = "t2.micro"

  associate_public_ip_address = "true"
  subnet_id = data.aws_subnet.ramp_up_training-public-1.id

  key_name = data.aws_key_pair.mateorincona.key_name
  security_groups = [aws_security_group.SG-Jenkins-instance.id]


  tags = {
    Name = "instance_Jenkins"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }

  volume_tags = {
    Name = "instance_Jenkins"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }

}

resource "null_resource" "instance_jenkins" {
  provisioner "local-exec" {
    command = "sleep 30 && ./instance.sh ${aws_instance.instance_jenkins.public_ip}"
  }
}

# SG for instance
resource "aws_security_group" "SG-Jenkins-instance" {
  name = "SG-Jenkins-instance"
  description = "Allow inbound traffic from host"
  vpc_id = data.aws_vpc.ramp_up_training_vpc.id

  ingress {
    description = "Local to instance"
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
    Name = "SG-Jenkins-instance"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

output "instance_public_ip" {
  value = aws_instance.instance_jenkins.public_ip
}
