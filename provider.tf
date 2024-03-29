

provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "grig-terraform-s3bucket"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}