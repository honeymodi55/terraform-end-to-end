output "vpc_id" {
  value = aws_vpc.api-app-eks-vpc.id
}

output "public_subnet_id_2a" {
  value = aws_subnet.apiAppEKS-publicSubnet-2a.id
}
output "public_subnet_id_2b" {
  value = aws_subnet.apiAppEKS-publicSubnet-2b.id
}

output "private_subnet_id_2a" {
  value = aws_subnet.apiAppEKS-privateSubnet-2a.id
}
output "private_subnet_id_2b" {
  value = aws_subnet.apiAppEKS-privateSubnet-2b.id
}