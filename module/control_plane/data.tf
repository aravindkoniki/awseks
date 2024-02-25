data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.${local.dns_suffix}"]
    }
  }
}

data "tls_certificate" "tls" {
  count = var.enable_irsa ? 1 : 0
  url   = aws_eks_cluster.control_plane.identity[0].oidc[0].issuer
}
