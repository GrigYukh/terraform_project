# Создание AWS launcher config 

resource "aws_launch_configuration" "grig_launch_config" {
  name          = "grig-launch-config"
  image_id      = "ami-0b8b44ec9a8f90422"  # UBUNTU LINUX
  instance_type = "t2.micro"
}

# Создание aws_autoscaling_group

resource "aws_autoscaling_group" "grig_auto_scaling_group" {
  name                 = "grig-auto-scaling-group"
  launch_configuration = aws_launch_configuration.grig_launch_config.name
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.grig_subnet_a.id]
}