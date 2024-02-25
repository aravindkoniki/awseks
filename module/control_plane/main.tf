#create security groups
resource "aws_security_group" "cluster" {
  count = local.create_cluster_sg ? 1 : 0

  name        = local.cluster_sg_name
  description = "Security group for EKS ${var.cluster_name}"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { "Name" = local.cluster_sg_name })

  lifecycle {
    create_before_destroy = true
  }
}

# security group rules
resource "aws_security_group_rule" "cluster" {
  for_each = { for k, v in merge(
    var.cluster_security_group_rules
  ) : k => v if local.create_cluster_sg }

  # Required
  security_group_id = aws_security_group.cluster[0].id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  # Optional
  description              = lookup(each.value, "description", null)
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}

# EKS control plane
resource "aws_eks_cluster" "control_plane" {
  name                      = var.cluster_name
  role_arn                  = local.cluster_role
  version                   = var.cluster_version
  enabled_cluster_log_types = var.cluster_enabled_log_types

  vpc_config {
    security_group_ids      = compact(distinct(concat(var.cluster_additional_security_group_ids, [local.cluster_security_group_id])))
    subnet_ids              = coalescelist(var.control_plane_subnet_ids, var.subnet_ids)
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  dynamic "kubernetes_network_config" {
    # Not valid on Outposts
    for_each = [1]
    content {
      ip_family         = var.cluster_ip_family
      service_ipv4_cidr = var.cluster_service_ipv4_cidr
      service_ipv6_cidr = var.cluster_service_ipv6_cidr
    }
  }

  dynamic "encryption_config" {
    # Not available on Outposts
    for_each = local.enable_cluster_encryption_config ? [var.cluster_encryption_config] : []
    content {
      provider {
        key_arn = encryption_config.value.provider_key_arn
      }
      resources = encryption_config.value.resources
    }
  }

  tags = merge(local.tags, var.cluster_tags)
}

resource "aws_ec2_tag" "cluster_primary_security_group" {
  for_each = { for k, v in merge(var.tags, var.cluster_tags) :
    k => v if k != "Name" && var.create_cluster_primary_security_group_tags && v != null
  }

  resource_id = aws_eks_cluster.control_plane.vpc_config[0].cluster_security_group_id
  key         = each.key
  value       = each.value
}

################################################################################
# OIDC
################################################################################
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  count           = var.enable_irsa ? 1 : 0
  client_id_list  = distinct(compact(concat(["sts.${local.dns_suffix}"], var.openid_connect_audiences)))
  thumbprint_list = concat([data.tls_certificate.tls[0].certificates[0].sha1_fingerprint], var.custom_oidc_thumbprints)
  url             = aws_eks_cluster.control_plane.identity[0].oidc[0].issuer

  tags = merge({ Name = upper("${var.cluster_name}-EKS-IRSA") }, local.tags)
}


################################################################################
# EKS Identity Provider
################################################################################

resource "aws_eks_identity_provider_config" "indentity_provider" {
  for_each     = { for k, v in var.cluster_identity_providers : k => v }
  cluster_name = aws_eks_cluster.control_plane.name
  oidc {
    client_id                     = each.value.client_id
    groups_claim                  = lookup(each.value, "groups_claim", null)
    groups_prefix                 = lookup(each.value, "groups_prefix", null)
    identity_provider_config_name = try(each.value.identity_provider_config_name, each.key)
    issuer_url                    = try(each.value.issuer_url, aws_eks_cluster.control_plane.identity[0].oidc[0].issuer)
    required_claims               = lookup(each.value, "required_claims", null)
    username_claim                = lookup(each.value, "username_claim", null)
    username_prefix               = lookup(each.value, "username_prefix", null)
  }
  tags = local.tags
}
