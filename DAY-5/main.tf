provider "aws" {
  region = "ap-south-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "new-key" {
  key_name = "new-key"
  public_key = file("/home/codespace/.ssh/id_rsa.pub")
}

resource "aws_vpc" "madhan-vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "pub-subnet" {
  vpc_id = aws_vpc.madhan-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "pub-sub-igw" {
  vpc_id = aws_vpc.madhan-vpc.id
}

resource "aws_route_table" "pub-sub-route" {
  vpc_id = aws_vpc.madhan-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pub-sub-igw.id
  }

}

resource "aws_route_table_association" "pub-sub-rote-ass" {
  route_table_id = aws_route_table.pub-sub-route.id
  subnet_id = aws_subnet.pub-subnet.id
}

resource "aws_security_group" "http-allow" {
  name = "allow-httpd"
  vpc_id = aws_vpc.madhan-vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
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

}

resource "aws_instance" "webserv" {
  ami = "ami-0ced6a024bb18ff2e"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.pub-subnet.id
  key_name = aws_key_pair.new-key.key_name
  vpc_security_group_ids = [aws_security_group.http-allow.id]

  tags = {
    name ="test"
  }

  connection {
    type     = "ssh"
    user = "ec2-user"
    private_key = file("/home/codespace/.ssh/id_rsa")
    host = self.public_ip

  }

    provisioner "file" {
    source = "index.html"
    destination = "/home/ec2-user/index.html"
    
  }

  provisioner "remote-exec" {
    inline = [ 
        "echo 'executing remote-exec'",
        "sudo yum install httpd -y",
        "sudo cp -v index.html /var/www/html/",
        "sudo systemctl enable --now httpd",
        "mkdir ~/test"

     ]
    
  }  
}

output "print-ip" {
  value = aws_instance.webserv.public_ip
}
