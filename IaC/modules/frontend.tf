# SG for Front instances
resource "aws_security_group" "SG-Frontend-movie-analyst" {
  name = "SG-Frontend-movie-analyst"
  description = "Allow Frontend Auto Scaling Instances inbound traffic"
  vpc_id = data.aws_vpc.ramp_up_training_vpc.id

# Allow access from Frontend-LB
  ingress {
    description = "Allow access from ALB-Frontend"
    from_port = 3030
    to_port = 3030
    protocol = "tcp"
    security_groups = [aws_security_group.SG-Frontend-LB.id]
  }

  # Allow access from Bastion through 3030
  ingress {
    description = "Allow access from Bastion through port 3030"
    from_port = 3030
    to_port = 3030
    protocol = "tcp"
    security_groups = [aws_security_group.SG-Bastion-movie-analyst.id]
  }

  # Allow access from Bastion through SSH
  ingress {
    description = "Allow access from Bastion through SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.SG-Bastion-movie-analyst.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Frontend-movie-analyst"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

output "back_host" {
  value = aws_lb.ALB-Backend.dns_name
}

# Launch template
resource "aws_launch_template" "Template-Frontend" {
  name          = "Template-Frontend"
  description   = "Template for auto scaling group for frontend movie-analyst-ui"
  instance_initiated_shutdown_behavior = "terminate"
  key_name = aws_key_pair.mateorincona.key_name
  image_id      = "ami-009726b835c24a3aa"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SG-Frontend-movie-analyst.id]
  # user_data = filebase64("~/movies_dep/backend-cloud.sh")
  # user_data = data.template_file.backend_user_data.rendered
  user_data = base64encode(templatefile("~/movies_dep/frontend-cloud.sh", { BACK_HOST = aws_lb.ALB-Backend.dns_name }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Frontend"
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

variable "extra_tags_front" {
  default = [
    {
      key                 = "Name"
      value               = "Frontend-movie-analyst"
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
resource "aws_autoscaling_group" "AS-Frontend" {
  name = "AS-Frontend"
  target_group_arns = [aws_lb_target_group.TG-Frontend.arn]
  vpc_zone_identifier = [data.aws_subnet.ramp_up_training-public-1.id]
  launch_template {
    id = aws_launch_template.Template-Frontend.id
    version = "$Latest"
  }
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tags = var.extra_tags_front
}
