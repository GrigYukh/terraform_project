# Создание vpc

resource "aws_vpc" "grig_vpc" {
  cidr_block = "10.20.20.0/24"
  tags = {
    Name = "grig-vpc"
  }

}
# Создание subnet

resource "aws_subnet" "grig_subnet_a" {
  vpc_id            = aws_vpc.grig_vpc.id
  cidr_block        = "10.20.20.0/26"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "grig_subnet_b" {
  vpc_id            = aws_vpc.grig_vpc.id
  cidr_block        = "10.20.20.64/26"
  availability_zone = "us-east-2b"
}

resource "aws_subnet" "grig_subnet_c" {
  vpc_id            = aws_vpc.grig_vpc.id
  cidr_block        = "10.20.20.128/26"
  availability_zone = "us-east-2c"
}



# Создание security_group

resource "aws_security_group" "grig_securegr" {
  name        = "grig_securegr"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.grig_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}