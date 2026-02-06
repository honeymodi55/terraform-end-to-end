variable "vpc_cidr" {
  description = "cidr block for vpc"
  type = string
}

variable "public_cidr" {
  description = "cidr block for public subnet"
  type = string
}

variable "private_cidr_2a" {
  description = "cidr block for private subnet 2a"
  type = string
}

variable "private_cidr_2b" {
  description = "cidr block for private subnet 2b"
  type = string
}
variable "availability_zone_2a" {
  description = "us-west-2a AZ for public and private subnets"
  type = string
}

variable "availability_zone_2b" {
  description = "us-west-2b AZ for public and private subnets"
  type = string
}