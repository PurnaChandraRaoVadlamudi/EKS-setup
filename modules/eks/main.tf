resource "aws_eks_cluster" "eks_cluster" {
    name     = var.cluster_name
    version = var.cluster_version
    role_arn = var.cluster_role_arn
    
    vpc_config {
        endpoint_private_access = true
        endpoint_public_access  = true

         # worker nodes will be launched in private subnets, so we need to specify the private subnet IDs here
        # subnet_ids is where our pods are creates
        subnet_ids = var.subnet_ids
    }

    access_config {
      authentication_mode = "API"
      bootstrap_cluster_creator_admin_permissions = true
    }
   
   # “First attach IAM policy, then create EKS cluster”

}


