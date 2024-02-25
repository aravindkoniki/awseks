
## https://docs.aws.amazon.com/eks/latest/userguide/security-iam-awsmanpol.html
resource "aws_iam_role" "cluster_role" {
  name                  = "${upper(var.cluster_name)}_SERVICE_ROLE"
  path                  = "/"
  description           = "IAM role for the EKS Cluster"
  assume_role_policy    = data.aws_iam_policy_document.cluster_assume_role_policy.json
  force_detach_policies = true
  tags                  = local.tags
}

#  Before creating a cluster, you must have a cluster IAM role with this policy attached. Kubernetes clusters that are managed by Amazon EKS make calls to other AWS services on your behalf
#  More details here https://docs.aws.amazon.com/eks/latest/userguide/security-iam-awsmanpol.html
resource "aws_iam_role_policy_attachment" "cluster_role_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.id
}

#  If you're using security groups for Pods, you must attach this policy to your Amazon EKS cluster IAM role to perform actions on your behalf.
#  More details here https://docs.aws.amazon.com/eks/latest/userguide/security-iam-awsmanpol.html
resource "aws_iam_role_policy_attachment" "cluster_role_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster_role.id
}

resource "aws_iam_policy" "cluster_encryption" {
  count = var.attach_cluster_encryption_policy && local.enable_cluster_encryption_config ? 1 : 0

  name        = "${upper(var.cluster_name)}_CLUSTER_ENCRYPTION_ROLE"
  description = "IAM Role for cluster encryption"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ListGrants",
          "kms:DescribeKey",
        ]
        Effect   = "Allow"
        Resource = var.cluster_encryption_config.provider_key_arn
      },
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "cluster_encryption" {
  # Encryption config not available on Outposts
  count = var.attach_cluster_encryption_policy && local.enable_cluster_encryption_config ? 1 : 0

  policy_arn = aws_iam_policy.cluster_encryption[0].arn
  role       = aws_iam_role.cluster_role.id
}

# this will add additional EKS cluster control plane policy
resource "aws_iam_role_policy_attachment" "additonal_cluster_policy" {
  count      = length(var.additional_cluster_policy_arns)
  role       = aws_iam_role.cluster_role.id
  policy_arn = var.additional_cluster_policy_arns[count.index]
}