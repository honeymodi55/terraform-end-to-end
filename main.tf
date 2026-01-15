terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "pauls-exercise"
    region = "us-west-2"
    key = "terraform/statefile"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}


module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_value = "ami-00a8151272c45cd8e"
  instance_type_value = "t2.micro"
}