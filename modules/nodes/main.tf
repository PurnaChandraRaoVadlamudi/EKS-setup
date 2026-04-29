resource "aws_eks_node_group" "general" {
  cluster_name    = var.cluster_name
  node_group_name = "general"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  capacity_type  = "ON_DEMAND"
  instance_types = var.node_group_instance_types

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  labels = {
    role = "general"
  }

  tags = {
    Name = "node-group"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}