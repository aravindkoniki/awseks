output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.control_plane.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.control_plane.cluster_endpoint
}

output "cluster_id" {
  description = "The ID of the EKS cluster. Note: currently a value is returned only for local EKS clusters created on Outposts"
  value       = module.control_plane.cluster_id
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.control_plane.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value       = module.control_plane.oidc_provider_arn
}

output "cluster_platform_version" {
  description = "Platform version for the cluster"
  value       = module.control_plane.cluster_platform_version
}