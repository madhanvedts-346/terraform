provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "test" {
    ami = "ami-0ced6a024bb18ff2e"
    instance_type = "t3.micro"
    tags = {
      name="test-ec2"
      env="test"
    }
  
}

resource "aws_s3_bucket" "backend" {
  bucket = "madhan-backend-s3"
}

resource "aws_dynamodb_table" "terraform-lock" {
  name = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
