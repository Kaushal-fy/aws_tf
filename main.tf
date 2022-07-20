resource "aws_vpc" "my_vpc" {
  cidr_block       = var.main_vpc_cidr
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "my_public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnet_cidr
}

resource "aws_subnet" "my_private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidr
}

resource "aws_route_table" "my_public_route" {
  vpc_id = aws_vpc.my_vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table" "my_private_route" {
  vpc_id = aws_vpc.my_vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.my_ngw.id
  }
}

resource "aws_nat_gateway" "my_ngw" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.my_public_subnet.id
}

resource "aws_eip" "my_eip" {
  vpc = true
}

resource "aws_security_group" "my_web_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "my_ec2" {
  ami           = "ami-c998b6b2"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.my_web_sg.id
  ]
  subnet_id = aws_subnet.my_public_subnet.id
}

resource "aws_route_table_association" "my_public_route_association" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_public_route.id
}

resource "aws_route_table_association" "my_rivate_route_association" {
  subnet_id      = aws_subnet.my_private_subnet.id
  route_table_id = aws_route_table.my_private_route.id
}
