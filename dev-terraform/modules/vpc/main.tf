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
#public subnet in "us-west-2a"
resource "aws_subnet" "apiAppEKS-publicSubnet-2a" {
  vpc_id = aws_vpc.api-app-eks-vpc.id
  cidr_block = var.public_cidr_2a
  availability_zone = var.availability_zone_2a
  tags = {
    Name = "apiAppEKS-publicSubnet-2a"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb" = "1"
  }
}
#public subnet in "us-west-2b"
resource "aws_subnet" "apiAppEKS-publicSubnet-2b" {
  vpc_id = aws_vpc.api-app-eks-vpc.id
  cidr_block = var.public_cidr_2b
  availability_zone = var.availability_zone_2b
  tags = {
    Name = "apiAppEKS-publicSubnet"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb" = "1"
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
#private subnet in "us-west-2a"
resource "aws_subnet" "apiAppEKS-privateSubnet-2a" {
  vpc_id = aws_vpc.api-app-eks-vpc.id
  cidr_block = var.private_cidr_2a
  availability_zone = var.availability_zone_2a
  tags = {
    Name = "apiAppEKS-privateSubnet-2a"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}
#private subnet in "us-west-2b"
resource "aws_subnet" "apiAppEKS-privateSubnet-2b" {
  vpc_id = aws_vpc.api-app-eks-vpc.id
  cidr_block = var.private_cidr_2b
  availability_zone = var.availability_zone_2b
  tags = {
    Name = "apiAppEKS-privateSubnet-2b"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

#Route Tables
#for public subnet 2a & 2b
resource "aws_route_table" "apiAppEKS-publicSubnet-Route" {
  vpc_id = aws_vpc.api-app-eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.apiAppEKS-publicSubnet-IG.id
  }
}

#for private subnet 2a & 2b
resource "aws_route_table" "apiAppEKS-privateSubnet-Route" {
  vpc_id = aws_vpc.api-app-eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ApiAppEKS-NAT.id
  }
}


#Route Table Associations to subnets
resource "aws_route_table_association" "apiAppEKS-publicSubnet-2a-Route-Association" {
  subnet_id = aws_subnet.apiAppEKS-publicSubnet-2a.id
  route_table_id = aws_route_table.apiAppEKS-publicSubnet-Route.id
}
resource "aws_route_table_association" "apiAppEKS-publicSubnet-2b-Route-Association" {
  subnet_id = aws_subnet.apiAppEKS-publicSubnet-2b.id
  route_table_id = aws_route_table.apiAppEKS-publicSubnet-Route.id
}
resource "aws_route_table_association" "apiAppEKS-privateSubnet-2a-Route-Association" {
  subnet_id = aws_subnet.apiAppEKS-privateSubnet-2a.id
  route_table_id = aws_route_table.apiAppEKS-privateSubnet-Route.id
}

resource "aws_route_table_association" "apiAppEKS-privateSubnet-2b-Route-Association" {
  subnet_id = aws_subnet.apiAppEKS-privateSubnet-2b.id
  route_table_id = aws_route_table.apiAppEKS-privateSubnet-Route.id
}