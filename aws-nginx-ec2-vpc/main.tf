provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "dev"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.dev_vpc.id
}

resource "aws_route_table" "dev_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags =  {
    Name = "dev"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id =  aws_subnet.subnet-1.id
  route_table_id = aws_route_table.dev_route_table.id
}

resource "aws_security_group" "https" {
  name = "allow_https"
  description = "Allow https inbound traffic"
  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
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
    Name = "webserver"
  }
}

resource "aws_network_interface" "webserver_nic" {
  subnet_id = aws_subnet.subnet-1.id
  private_ips = ["10.0.1.20"]
  security_groups = [aws_security_group.https.id]
}

resource "aws_eip" "one" {
  vpc = true
  network_interface = aws_network_interface.webserver_nic.id
  associate_with_private_ip = "10.0.1.20"
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_instance" "webserver_ec2" {
  ami = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "terraform-us"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.webserver_nic.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl start nginx
              EOF

  tags = {
    Name = "webserver"
  }
}
