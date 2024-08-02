output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.control_plane.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.control_plane.certificate_authority[0].data
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = aws_eks_cluster.control_plane.endpoint
}

output "cluster_id" {
  description = "The ID of the EKS cluster. Note: currently a value is returned only for local EKS clusters created on Outposts"
  value       = aws_eks_cluster.control_plane.cluster_id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.control_plane.name
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.control_plane.identity[0].oidc[0].issuer
}

output "cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = aws_eks_cluster.control_plane.version
}

output "cluster_platform_version" {
  description = "Platform version for the cluster"
  value       = aws_eks_cluster.control_plane.platform_version
}

output "cluster_status" {
  description = "Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
  value       = aws_eks_cluster.control_plane.status
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = aws_eks_cluster.control_plane.vpc_config[0].cluster_security_group_id
}

output "cluster_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the cluster security group"
  value       = aws_eks_cluster.control_plane.arn
}

output "cluster_security_group_id" {
  description = "ID of the cluster security group"
  value       = aws_eks_cluster.control_plane.id
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = try(replace(aws_eks_cluster.control_plane.identity[0].oidc[0].issuer, "https://", ""), null)
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value       = try(aws_iam_openid_connect_provider.oidc_provider[0].arn, null)
}

output "cluster_tls_certificate_sha1_fingerprint" {
  description = "The SHA1 fingerprint of the public key of the cluster's certificate"
  value       = try(data.tls_certificate.tls[0].certificates[0].sha1_fingerprint, null)
}

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = try(aws_iam_role.cluster_role.name, null)
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = try(aws_iam_role.cluster_role.arn, null)
}

output "cluster_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = try(aws_iam_role.cluster_role.unique_id, null)
}

output "cluster_identity_providers" {
  description = "Map of attribute maps for all EKS identity providers enabled"
  value       = aws_eks_identity_provider_config.indentity_provider
}

output "cluster_service_cidr" {
  description = "The CIDR block where Kubernetes pod and service IP addresses are assigned from"
  value       = try(aws_eks_cluster.control_plane.kubernetes_network_config[0].service_ipv4_cidr, aws_eks_cluster.control_plane.kubernetes_network_config[0].service_ipv6_cidr, null)
}

output "cluster_ip_family" {
  description = "The IP family used by the cluster (e.g. `ipv4` or `ipv6`)"
  value       = try(aws_eks_cluster.control_plane.kubernetes_network_config[0].ip_family, null)
}