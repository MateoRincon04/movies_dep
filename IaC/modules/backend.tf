# User-data for template, mixing both file and env variables that depend on another aws resource
#data "template_file" "backend_user_data" {
#  template = file("~/movies_dep/backend-cloud.sh")
#  vars = {
#    DB_HOST = aws_db_instance.RDS-movie-analyst.address
#  }
#}

# SG for Back instances
resource "aws_security_group" "SG-Backend-movie-analyst" {
  name = "SG-Backend-movie-analyst"
  description = "Allow inbound traffic from other sources"
  vpc_id = data.aws_vpc.ramp_up_training_vpc.id

  # Allow access from Bastion through SSH
  ingress {
    description = "Allow access from Bastion through SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.SG-Bastion-movie-analyst.id]
  }

  ingress {
    description = "Allow access from Bastion through port 3000"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    security_groups = [aws_security_group.SG-Bastion-movie-analyst.id]
  }

  # Allow access from LB-Backend to Backend instances through port 3000
  ingress {
    description     = "from LB-Backend to Backend instances"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.SG-Backend-LB.id]
  }

  # Allow access to RDS
  ingress {
    description = "Backend to RDS"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    self = true
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

output "rds" {
  value = aws_db_instance.RDS-movie-analyst.address
}

# Launch template
resource "aws_launch_template" "Template-Backend" {
  name          = "Template-Backend"
  description   = "Template for auto scaling group for backend movie-analyst-api"
  instance_initiated_shutdown_behavior = "terminate"
  key_name = aws_key_pair.mateorincona.key_name
  image_id      = "ami-009726b835c24a3aa"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SG-Backend-movie-analyst.id]
  # user_data = filebase64("~/movies_dep/backend-cloud.sh")
  # user_data = data.template_file.backend_user_data.rendered
  user_data = base64encode(templatefile("~/movies_dep/backend-cloud.sh", { DB_HOST = aws_db_instance.RDS-movie-analyst.address }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Backend"
      project = "ramp-up-devops"
      responsible = "mateo.rincona"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      project = "ramp-up-devops"
      responsible = "mateo.rincona"
    }
  }
}

variable "extra_tags_back" {
  default = [
    {
      key                 = "Name"
      value               = "Backend-movie-analyst"
      propagate_at_launch = true
    },
    {
      key                 = "project"
      value               = "ramp-up-devops"
      propagate_at_launch = true
    },
    {
      key                 = "responsible"
      value               = "mateo.rincona"
      propagate_at_launch = true
    }
  ]
}

# AutoScaling group for backend
resource "aws_autoscaling_group" "AS-Backend" {
  name = "AS-Backend"
  target_group_arns = [aws_lb_target_group.TG-Backend.arn]
  vpc_zone_identifier = [data.aws_subnet.ramp_up_training-private-0.id]
  launch_template {
    id = aws_launch_template.Template-Backend.id
    version = "$Latest"
  }
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tags = var.extra_tags_back
}
