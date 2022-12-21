terraform {
  backend "s3" {
    bucket = "dhsoni-tf"
    region = "us-east-2"
    key    = "terraform.tfstate"
  }
}
