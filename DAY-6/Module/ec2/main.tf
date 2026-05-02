provider "aws" {
  region = "us-east-1"
}

variable "ami" {
  description = "enter ami value"
}

variable "instance_type" {
  description = "enter the instance type"
}

variable "tag" {
  description = "EC2 tags"
  type        = map(string)
}

resource "aws_instance" "test" {
  ami           = var.ami
  instance_type = var.instance_type
  tags          = var.tag

}
