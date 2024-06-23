# EKS VPC
module "eks_vpc" {
  source                = "git::https://github.com/aravindkoniki/awsnetwork.git//module//full_vpc?ref=main"
  vpc_name              = var.eks_vpc_name
  cidr_block            = var.eks_cidr_block
  secondary_cidr_blocks = var.eks_secondary_cidr_blocks
  subnets               = var.eks_subnets
  create_igw            = true
  nat_gateways          = var.nat_gateways
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


# # VPC endpoint
# module "vpc_endpoint" {
#   source = "git::https://github.com/aravindkoniki/awsnetwork.git//module//module//vpc-endpoint?ref=master"
#   vpc_id = module.vpc.id
#   subnet_ids = [
#     module.dmz_subnets.subnets_by_name[upper("pt-hub-dmz-uat-web-subnet-1a")].id,
#     module.dmz_subnets.subnets_by_name[upper("pt-hub-dmz-uat-web-subnet-1b")].id,
#     module.dmz_subnets.subnets_by_name[upper("pt-hub-dmz-uat-web-subnet-1c")].id
#   ]
#   security_group_ids = [module.security_groups_for_vpc_endpoint.security_group_id]
#   endpoints = {
#     s3 = {
#       service      = "s3",
#       service_type = "Interface",
#       policy       = null,
#       tags         = { Name = upper("pt-hub-dmz-uat-s3-vpc-endpoint-1") }
#     },
#     sts = {
#       service             = "sts",
#       service_type        = "Interface",
#       private_dns_enabled = true,
#       policy              = null,
#       tags                = { Name = upper("pt-hub-dmz-uat-sts-vpc-endpoint-2") }
#     }
#   }
#   tags = var.tags
#   depends_on = [
#     module.vpc,
#     module.dmz_subnets,
#     module.security_groups_for_vpc_endpoint
#   ]
# }
