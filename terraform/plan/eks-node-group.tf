resource "aws_eks_node_group" "private" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "private-node-group-${var.env}"
  node_role_arn   = aws_iam_role.node-group.arn
  subnet_ids      = [aws_subnet.private["private-eks-1"].id, aws_subnet.private["private-eks-2"].id]

  labels          = {
    "type" = "private"
  }

  instance_types = ["t3.micro"]

  scaling_config {
    min_size     = 2
    desired_size = 2
    max_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly
  ]

  tags = {
    Environment = var.env
  }
}

resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "public-node-group-${var.env}"
  node_role_arn   = aws_iam_role.node-group.arn
  subnet_ids      = [aws_subnet.public["public-eks-1"].id, aws_subnet.public["public-eks-2"].id]

  labels          = {
    "type" = "public"
  }

  instance_types = ["t3.micro"]

  scaling_config {
    min_size     = 4
    desired_size = 4
    max_size     = 5
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Environment = var.env
  }
}