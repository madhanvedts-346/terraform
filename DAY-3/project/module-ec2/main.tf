provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "test" {
    ami = var.environment=="production"?"ami-0ced6a024bb18ff2e":"ami-02b8269d5e85954ef"
    instance_type = var.instance_type
  
}

