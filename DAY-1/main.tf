provider "aws" {
    region = "ap-south-1"  
}

resource "aws_instance" "ec2-first" {
    ami = "ami-02b8269d5e85954ef"
    instance_type = "t3.micro"
     
}
