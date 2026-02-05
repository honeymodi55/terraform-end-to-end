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


/*module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_value = "ami-00a8151272c45cd8e"
  instance_type_value = "t2.micro"
}*/

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  public_cidr = "10.0.1.0/24"
  private_cidr = "10.0.2.0/24"
  availability-zone = "us-west-2a"
}