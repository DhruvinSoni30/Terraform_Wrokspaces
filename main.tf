provider "aws" {
  region = var.region
}

locals {
  instance_types = {
    dev   = "t2.micro"
    stg = "t2.small"
    prod  = "m4.large"
  }
}

resource "aws_instance" "demo_server" {
  ami           = var.ami
  instance_type = local.instance_types[terraform.workspace]
  tags = {
    Name = "example-server-${terraform.workspace}"
  }
}