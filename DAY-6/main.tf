provider "aws" {
  region = "us-east-1"
}

variable "ami" {
  description = "enter ami"
}

variable "instance_type" {
  description = "enter type"
  default     = "t3.micro"

}

variable "tag" {
  description = "enter tag"
  type        = map(map(string))

  default = {
    "dev" = {
      Name        = "Dev-Server"
      Environment = "Dev"
      Owner       = "Madhan"
    }
    "stage" = {
      Name        = "stage-Server"
      Environment = "stage"
      Owner       = "Madhan"
    }
    "prod" = {
      Name        = "prod-Server"
      Environment = "prod"
      Owner       = "Madhan"
    }
  }

}

module "ec2-instnace" {
  source        = "./Module/ec2"
  ami           = var.ami
  instance_type = var.instance_type
  tag           = lookup(var.tag, terraform.workspace, {})
}
