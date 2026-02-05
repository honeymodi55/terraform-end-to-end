variable "vpc_cidr" {
  description = "cidr block for vpc"
  type = string
}

variable "public_cidr" {
  description = "cidr block for public subnet"
  type = string
}

variable "private_cidr" {
  description = "cidr block for private subnet"
  type = string
}

variable "availability-zone" {
  description = "AZ for public and private subnets"
  type = string
}