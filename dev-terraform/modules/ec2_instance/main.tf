# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "ec2_1" {
  ami = var.ami_value
  instance_type = var.instance_type_value
  
  tags = {
    Name = "terraform-instance"
  }
}

