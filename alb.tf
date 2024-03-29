
resource "aws_internet_gateway" "grig_internet_gateway" {
  vpc_id = aws_vpc.grig_vpc.id
}

resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_vpc.grig_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.grig_internet_gateway.id
}



resource "aws_lb" "grig_alb" {
  name               = "grig-application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.grig_securegr.id]
  subnets            = [aws_subnet.grig_subnet_a.id, aws_subnet.grig_subnet_b.id]
}

resource "aws_lb_target_group" "grig_target_group" {
  name        = "grig-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.grig_vpc.id
  target_type = "instance"
}

resource "aws_instance" "grig_instance_1" {
  ami           = "ami-0b8b44ec9a8f90422"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.grig_subnet_a.id
  associate_public_ip_address = true
  security_groups    = [aws_security_group.grig_securegr.id]
  user_data     = <<-EOF
    #!/bin/bash
    #Use this for your user data(script from top to bottom)
    #installing Nginx 
    apt update -y
    apt install -y nginx
    systemctl start nginx
    systemctl enamble nginx
    echo "<h1>My First Web Page $(hostname -f)<h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    Name = "grig-instance_1"
  }
}

resource "aws_instance" "grig_instance_2" {
  ami           = "ami-0b8b44ec9a8f90422"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.grig_subnet_b.id
  associate_public_ip_address = true
  security_groups    = [aws_security_group.grig_securegr.id]
  user_data     = <<-EOF
    #!/bin/bash
    #Use this for your user data(script from top to bottom)
    #installing Nginx 
    apt update -y
    apt install -y nginx
    systemctl start nginx
    systemctl enamble nginx
    echo "<h1>My First Web Page $(hostname -f)<h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    Name = "grig-instance_2"
  }
}

resource "aws_lb_target_group_attachment" "grig_attachment_1" {
  target_group_arn = aws_lb_target_group.grig_target_group.arn
  target_id        = aws_instance.grig_instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "grig_attachment_2" {
  target_group_arn = aws_lb_target_group.grig_target_group.arn
  target_id        = aws_instance.grig_instance_2.id
  port             = 80
}


resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.grig_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grig_target_group.arn
  }
}