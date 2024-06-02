locals {
  cluster_version = "1.29"
}

# module EKS cluster
module "control_plane" {
  source                         = "../../module/control_plane"
  cluster_name                   = upper(var.cluster_name)
  cluster_endpoint_public_access = false
  create_cluster_security_group  = false
  cluster_version                = local.cluster_version
  additional_cluster_policy_arns = []
  vpc_id                         = var.vpc_id
  control_plane_subnet_ids       = var.control_plane_subnet_ids
  cluster_security_group_id      = var.cluster_security_group_id
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = "${var.cluster_encryption_kms_key}"
  }
}

# user data module
module "user_data" {
  source               = "git::https://github.com/aravindkoniki/cloudinit_config.git//module?ref=main"
  platform             = "bottlerocket"
  cluster_name         = module.control_plane.cluster_name
  cluster_endpoint     = module.control_plane.cluster_endpoint
  cluster_ip_family    = module.control_plane.cluster_ip_family
  cluster_service_cidr = module.control_plane.cluster_service_cidr

  bootstrap_extra_args = <<-EOT
    # extra args added
    [settings.kernel]
    lockdown = "integrity"

  EOT

}


# module launch template
module "eks_launch_template" {
  source                               = "git::https://github.com/aravindkoniki/awslaunchtemplate.git//module?ref=main"
  prefix                               = "lt"
  description                          = "EKS launchtemplate"
  name                                 = "eks-launchtemaplate"
  user_data                            = module.user_data.user_data
  ami_id                               = data.aws_ami.bottlerocket_ami.id
  instance_initiated_shutdown_behavior = null
  vpc_security_group_ids               = [var.cluster_security_group_id, var.node_security_group_id]
}

# module eks nodes
module "self_managed_nodes" {
  source                  = "../../module/nodes/eks_managed_node_group"
  launch_template_id      = module.eks_launch_template.id
  launch_template_version = module.eks_launch_template.latest_version
  cluster_name            = module.control_plane.cluster_name
  subnet_ids              = var.node_subnet_ids
  
  #tags                    = { "kubernetes.io/cluster/${upper(var.cluster_name)}" = "owned" }
}
