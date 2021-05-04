provider "aws" {
  export AWS_ACCESS_KEY_ID="anaccesskey"
  export AWS_SECRET_ACCESS_KEY="asecretkey"
  export AWS_DEFAULT_REGION="us-west-2"
} 

#create vpc

resource "aws_vpc" "digital-vpc" {
  cidr_block = "10.0.0.0/16"
  
  }

#creat IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.digital-vpc.id


#create route table 
resource "aws_route_table" "digital-route-table" {
  vpc_id = aws_vpc.digital-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.gw.id
  }

#creat subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.digital-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone="us-east-1a"
tags = {
    Name = "digital-subnet-1"
  }
resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.digital-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone="us-east-1b"
tags = {
    Name = "digital-subnet-2"  

}
#associate subnet with route table 
resource "aws_route_table_association" "a" {
 vpc_id     = aws_vpc.digital-vpc.id
  subnet_id      = aws _subnet.subnet-1.id
  route_table_id = aws_route_table.digital-route-table.id
}
resource "aws_route_table_association" "b" {
 vpc_id     = aws_vpc.digital-vpc.id
  subnet_id      = aws _subnet.subnet-2.id
  route_table_id = aws_route_table.digital-route-table.id
}

#create SG
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.digital-vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = "0.0.0.0/0"
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = "0.0.0.0/0"  
  }
  ingress {
   description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = "0.0.0.0/0"  
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}
#create Network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
  }

#assign elastic ip to the network interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id 
  associate_with_private_ip = "10.0.1.50"
  depends_on=[aws_internet_gateway.gw]
}
#create a linux server
resource "aws_instance" "web_server_instance" {
  ami           = "ami-048f6ed62451373d9"
  instance_type = "t2.micro"
  availability_zone="us-east-1a"
  key_name= "mykeypair-LA"
}
resource "aws_instance" "web_server_instance" {
  ami           = "ami-048f6ed62451373d9"
  instance_type = "t2.micro"
  availability_zone="us-east-1b"
  key_name= "mykeypair-LA"
}
  network_interface {
       device_index= 0
       network_interface_id=aws_network_interface.web-server-nic.id
  }

  user_data= <<-EOF
         #1/bin/bash



resource "aws_lb" "TFproject" {
  name               = "test-lb-tf
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public.*.id



resource "aws_"
resource "<provider>_<resource_type>" "name" {
    config options...
    key="value
    key2= "another value"
}

