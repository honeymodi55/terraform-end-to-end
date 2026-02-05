resource "aws_vpc" "api-app-eks-vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "api-app-eks-vpc"
    }
}

#Internet Gateway for Inbound/Outbound traffic to public subnets
resource "aws_internet_gateway" "apiAppEKS-publicSubnet-IG" {
  vpc_id = aws_vpc.api-app-eks-vpc.id
  tags = {
    Name = "apiAppEKS-publicSubnet-IG"
  }
}

#Public Subnet (for Load Balancers)
resource "aws_subnet" "apiAppEKS-publicSubnet" {
  vpc_id = aws_vpc.api-app-eks-vpc.id
  cidr_block = var.public_cidr
  availability_zone = var.availability-zone
  tags = {
    Name = "apiAppEKS-publicSubnet"
  }
}

#NAT-Gateway for Outbound traffic from Private Subnet 
### Nat-Gateway requires an Eip first ###
resource "aws_eip" "apiAppElasticIP" {
  domain = "vpc"
  tags = {
    Name = "apiAppElasticIP"
  }
}
resource "aws_nat_gateway" "ApiAppEKS-NAT" {
  allocation_id = aws_eip.apiAppElasticIP.id
  subnet_id = aws_subnet.apiAppEKS-publicSubnet.id
  tags = {
    Name = "ApiAppEKS-NAT"
  }
}

#Private Subnet (for EKS Nodes)
resource "aws_subnet" "apiAppEKS-privateSubnet" {
  vpc_id = aws_vpc.api-app-eks-vpc.id
  cidr_block = var.private_cidr
  availability_zone = var.availability-zone
  tags = {
    Name = "apiAppEKS-privateSubnet"
  }
}

#Route Tables
resource "aws_route_table" "apiAppEKS-publicSubnet-Route" {
  vpc_id = aws_vpc.api-app-eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.apiAppEKS-publicSubnet-IG.id
  }
}
resource "aws_route_table" "apiAppEKS-privateSubnet-Route" {
  vpc_id = aws_vpc.api-app-eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ApiAppEKS-NAT.id
  }
}

#Route Table Associations to subnets
resource "aws_route_table_association" "apiAppEKS-publicSubnet-Route-Association" {
  subnet_id = aws_subnet.apiAppEKS-publicSubnet.id
  route_table_id = aws_route_table.apiAppEKS-publicSubnet-Route.id
}
resource "aws_route_table_association" "apiAppEKS-privateSubnet-Route-Association" {
  subnet_id = aws_subnet.apiAppEKS-privateSubnet.id
  route_table_id = aws_route_table.apiAppEKS-privateSubnet-Route.id
}