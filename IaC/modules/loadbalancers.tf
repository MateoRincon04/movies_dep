# Target group for Backend LB
resource "aws_lb_target_group" "TG-Backend" {
   name     = "TG-Backend"
   port     = 3000
   protocol = "HTTP"
   vpc_id   = data.aws_vpc.ramp_up_training_vpc.id
   tags = {
       project = "ramp-up-devops"
       responsible = "mateo.rincona"
    }
}

# Application Load Balancer Back
resource "aws_lb" "ALB-Backend" {
  name               = "ALB-Backend"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG-Backend-LB.id]
  subnets            = [data.aws_subnet.ramp_up_training-private-0.id, data.aws_subnet.ramp_up_training-private-1.id]
  ip_address_type = "ipv4"
  tags = {
      project = "ramp-up-devops"
      responsible = "mateo.rincona"
    }
}

# Conectar el TG al LB Back
resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.ALB-Backend.arn
  port              = "3000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG-Backend.arn
  }
  tags = {
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

resource "aws_security_group" "SG-Backend-LB" {
  name = "SG-Backend-LB"
  description = "Allow traffic from frontend instances"
  vpc_id = data.aws_vpc.ramp_up_training_vpc.id

  # Allow access from frontend
  ingress {
    description = "Allow access from frontend security group"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    security_groups = [aws_security_group.SG-Frontend-movie-analyst.id]
  }

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

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Backend-LB"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

# Target group for Frontend LB
resource "aws_lb_target_group" "TG-Frontend" {
   name     = "TG-Frontend"
   port     = 3030
   protocol = "HTTP"
   vpc_id   = data.aws_vpc.ramp_up_training_vpc.id
   tags = {
        project = "ramp-up-devops"
        responsible = "mateo.rincona"
    }
}

# Application Load Balancer Front
resource "aws_lb" "ALB-Frontend" {
  name               = "ALB-Frontend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG-Frontend-LB.id]
  subnets            = [data.aws_subnet.ramp_up_training-private-0.id, data.aws_subnet.ramp_up_training-public-1.id]
  ip_address_type = "ipv4"
  tags = {
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

# Conectar el TG al LB Front
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.ALB-Frontend.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG-Frontend.arn
  }
  tags = {
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

resource "aws_security_group" "SG-Frontend-LB" {
  name = "SG-Frontend-LB"
  description = "Allow traffic from http"
  vpc_id = data.aws_vpc.ramp_up_training_vpc.id

  # Allow access from everywhere
  ingress {
    description = "Allow access from everywhere using http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Frontend-LB"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}