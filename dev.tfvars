region                     = "ap-south-1"
vpc_name                   = "Eks-VPC"
vpc_cidr                   = "10.0.0.0/16"
public_availability_zones  = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidr         = ["10.0.1.0/24", "10.0.2.0/24"]
private_availability_zones = ["ap-south-1a", "ap-south-1b"]
private_subnet_cidr        = ["10.0.3.0/24", "10.0.4.0/24"]

cluster_name    = "Eks-Cluster"
cluster_version = "1.30"


node_group_desired_size   = 2
node_group_max_size       = 3
node_group_min_size       = 1
node_group_instance_types = ["t3.small", "t3.medium"]