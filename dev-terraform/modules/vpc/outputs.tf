output "vpc_id" {
  value = aws_vpc.api-app-eks-vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.apiAppEKS-publicSubnet.id
}

output "private_subnet_id" {
  value = aws_subnet.apiAppEKS-privateSubnet.id
}