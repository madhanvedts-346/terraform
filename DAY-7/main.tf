provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address          = "http://3.81.129.178:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "15da24f8-4bd5-0ec8-f3f9-8abb2da57fc8"
      secret_id = "294c281e-f73b-a78b-cc56-36c87744d437"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "madhan" // change it according to your mount
  name  = "demo"   // change it according to your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-091138d0f0d41ff90"
  instance_type = "t3.micro"

  tags = {
    Name   = "test"
    Secret = data.vault_kv_secret_v2.example.data["env"]
  }
}
