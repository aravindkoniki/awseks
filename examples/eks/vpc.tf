# EKS VPC
module "eks_vpc" {
  source                = "git::https://github.com/aravindkoniki/awsnetwork.git//module//full_vpc?ref=main"
  vpc_name              = var.eks_vpc_name
  cidr_block            = var.eks_cidr_block
  secondary_cidr_blocks = var.eks_secondary_cidr_blocks
  subnets               = var.eks_subnets
  tags                  = var.tags
}

# cluster security group
module "cluster_security_group" {
  source                     = "git::https://github.com/aravindkoniki/awsnetwork.git//module//security_groups?ref=main"
  security_group_name        = var.cluster_security_group["name"]
  security_group_description = var.cluster_security_group["description"]
  vpc_id                     = module.eks_vpc.vpc_id
  nsg_ingress_rules          = var.cluster_security_group["nsg_ingress_rules"]
  nsg_egress_rules           = var.cluster_security_group["nsg_egress_rules"]
  tags                       = var.tags
  depends_on = [
    module.eks_vpc
  ]
}

# node security group
module "node_security_group" {
  source                     = "git::https://github.com/aravindkoniki/awsnetwork.git//module//security_groups?ref=main"
  security_group_name        = var.node_security_group["name"]
  security_group_description = var.node_security_group["description"]
  vpc_id                     = module.eks_vpc.vpc_id
  nsg_ingress_rules          = var.node_security_group["nsg_ingress_rules"]
  nsg_egress_rules           = var.node_security_group["nsg_egress_rules"]
  tags                       = var.tags
  depends_on = [
    module.eks_vpc
  ]
}