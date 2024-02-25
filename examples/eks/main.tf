# module EKS cluster
module "control_plane" {
  source                         = "../../module/control_plane"
  cluster_name                   = upper(var.cluster_name)
  cluster_endpoint_public_access = false
  create_cluster_security_group  = false
  additional_cluster_policy_arns = []
  vpc_id                         = var.vpc_id
  control_plane_subnet_ids       = var.control_plane_subnet_ids
  cluster_security_group_id      = var.cluster_security_group_id
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = "${var.cluster_encryption_kms_key}"
  }
}