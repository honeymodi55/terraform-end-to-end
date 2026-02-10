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

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  public_cidr_2a = "10.0.1.0/24"
  public_cidr_2b = "10.0.2.0/24"
  private_cidr_2a = "10.0.10.0/24"
  private_cidr_2b = "10.0.11.0/24"
  availability_zone_2a = "us-west-2a"
  availability_zone_2b = "us-west-2b"
  cluster_name = "apiApp-cluster"
}

#using Official EKS module for creating cluster and its managed node pools
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name = "apiApp-cluster"
  kubernetes_version = "1.33"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  endpoint_public_access = true
  create_cloudwatch_log_group = true
  cloudwatch_log_group_retention_in_days = 7


  enable_cluster_creator_admin_permissions = true
  authentication_mode = "API_AND_CONFIG_MAP"

  vpc_id = module.vpc.vpc_id  
  subnet_ids = [ module.vpc.private_subnet_id_2a, module.vpc.private_subnet_id_2b ] #for worker nodes
  control_plane_subnet_ids = [ module.vpc.private_subnet_id_2a, module.vpc.private_subnet_id_2b ] #for control plane

  #EKS managed node groups
  eks_managed_node_groups = {
    api_node = {
      ami_type = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]
      min_size = 1
      max_size = 2
      desired_size = 1
    }
  }
  tags = {
    Name = "apiApp-cluster"
    Environment 