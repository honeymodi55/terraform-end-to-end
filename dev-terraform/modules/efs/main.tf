resource "aws_efs_file_system" "this" {
  creation_token = "eks-efs"
  encrypted      = true
  tags           = { Name = "eks-shared-storage" }
}

resource "aws_security_group" "efs" {
  name        = "efs-mount-target-sg"
  description = "Allow inbound NFS traffic from EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [var.eks_node_security_group_id]
  }
}

resource "aws_efs_mount_target" "this" {
  count           = length(var.private_subnet_ids)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.private_subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}

output "efs_id" {
  value = aws_efs_file_system.this.id
}