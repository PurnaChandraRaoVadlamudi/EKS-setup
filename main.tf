module "vpc" {
  source                     = "./modules/vpc"
  region                     = var.region
  vpc_name                   = var.vpc_name
  vpc_cidr                   = var.vpc_cidr
  public_availability_zones  = var.public_availability_zones
  public_subnet_cidr         = var.public_subnet_cidr
  private_availability_zones = var.private_availability_zones
  private_subnet_cidr        = var.private_subnet_cidr
}

module "eks" {
  source           = "./modules/eks"
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  cluster_role_arn = module.iam.cluster_role_arn
  subnet_ids       = module.vpc.private_subnet_ids
}

module "iam" {
  source = "./modules/iam"
}

module "nodes" {
  source = "./modules/nodes"

  subnet_ids   = module.vpc.private_subnet_ids
  cluster_name = module.eks.cluster_name
  node_role_arn = module.iam.node_role_arn

  node_group_desired_size   = var.node_group_desired_size
  node_group_max_size       = var.node_group_max_size
  node_group_min_size       = var.node_group_min_size
  node_group_instance_types = var.node_group_instance_types

  depends_on = [module.eks]   # 
}

