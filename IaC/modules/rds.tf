# RDS subnets group
resource "aws_db_subnet_group" "subnet-rds-movie-analyst" {
  name       = "subnet-rds-movie-analyst"
  subnet_ids = [data.aws_subnet.ramp_up_training-private-0.id, data.aws_subnet.ramp_up_training-private-1.id]

  tags = {
    Name = "SG-Backend-movie-analyst"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }
}

resource "aws_db_instance" "RDS-movie-analyst" {
  engine               = "mysql"
  engine_version       = "8.0.27"
  instance_class       = "db.t2.micro"
  name                 = "RdsMovieAnalyst"
  username             = "applicationuser"
  password             = "applicationuser"
  db_subnet_group_name = aws_db_subnet_group.subnet-rds-movie-analyst.name
  skip_final_snapshot  = true
  availability_zone = "us-west-1a"
  vpc_security_group_ids = [aws_security_group.SG-Backend-movie-analyst.id]
  allocated_storage    = 20
  max_allocated_storage = 1000

  tags = {
    Name = "SG-Backend-movie-analyst"
    project = "ramp-up-devops"
    responsible = "mateo.rincona"
  }

}
