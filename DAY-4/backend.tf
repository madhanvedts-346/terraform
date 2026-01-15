terraform {
  backend "s3" {
    bucket = "madhan-backend-s3"
    key = "madhan/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    dynamodb_table = "terraform-lock"
  }
}
