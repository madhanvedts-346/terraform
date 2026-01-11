provider "aws" {
    region = "ap-south-1"
  
}

module "demo" {
  source = "./module-ec2"
  environment = "production"
  instance_type = "t3.micro"
}

output "public-ip-print" {
  value = module.demo.public-ip
}
