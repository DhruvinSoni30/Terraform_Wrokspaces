provider "aws" {
  region = var.region
}
resource "aws_instance" "demo_server" {
  ami           = var.ami
  instance_type = var.size
  tags = {
    Name = "demo-server"
  }
}