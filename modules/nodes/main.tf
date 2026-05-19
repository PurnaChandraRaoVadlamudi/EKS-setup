# Public Node Group
resource "aws_eks_node_group" "public" {
  cluster_name    = var.cluster_name
  node_group_name = "public-ng"
  node_role_arn   = var.node_role_arn

  subnet_ids = var.public_subnet_ids

  capacity_type  = "ON_DEMAND"
  instance_types = var.node_group_instance_types

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  labels = {
    role = "public"
  }

  tags = {
    Name = "public-node-group"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# Private Node Group
resource "aws_eks_node_group" "private" {
  cluster_name    = var.cluster_name
  node_group_name = "private-ng"
  node_role_arn   = var.node_role_arn

  subnet_ids = var.private_subnet_ids

  capacity_type  = "ON_DEMAND"
  instance_types = var.node_group_instance_types

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  labels = {
    role = "private"
  }

  tags = {
    Name = "private-node-group"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

