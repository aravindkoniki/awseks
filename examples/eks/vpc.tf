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


# VPC endpoint
module "vpc_endpoint" {
  source = "git::https://github.com/aravindkoniki/awsnetwork.git//module//module//vpc-endpoint?ref=master"
  vpc_id = module.vpc.id
  subnet_ids = [
    module.eks_vpc.subnets_by_name[upper("EKS-NODES-SUBNET-2A")].id,
    module.eks_vpc.subnets_by_name[upper("EKS-NODES-SUBNET-2B")].id,
    module.eks_vpc.subnets_by_name[upper("EKS-NODES-SUBNET-2C")].id
  ]
  security_group_ids = [module.security_groups_for_vpc_endpoint.security_group_id]
  endpoints = {
    s3 = {
      service      = "s3",
      service_type = "Interface",
      policy       = null,
      tags         = { Name = upper("eks-s3-vpc-endpoint-1") }
    },
    sts = {
      service             = "sts",
      service_type        = "Interface",
      private_dns_enabled = true,
      policy              = null,
      tags                = { Name = upper("eks-sts-vpc-endpoint-2") }
    },
    ecr_dkr = {
      service             = "ecr.dkr",
      service_type        = "Interface",
      private_dns_enabled = true,
      policy              = null,
      tags                = { Name = upper("eks-ecr-dkr-vpc-endpoint-3") }
    },
    sqs = {
      service             = "sqs",
      service_type        = "Interface",
      private_dns_enabled = true,
      policy              = null,
      tags                = { Name = upper("eks-sqs-vpc-endpoint-4") }
    },
    elasticloadbalancing = {
      service             = "elasticloadbalancing",
      service_type        = "Interface",
      private_dns_enabled = true,
      policy              = null,
      tags                = { Name = upper("eks-elasticloadbalancing-vpc-endpoint-5") }
    },
    ec2 = {
      service             = "ec2",
      service_type        = "Interface",
      private_dns_enabled = true,
      policy              = null,
      tags                = { Name = upper("eks-ec2-vpc-endpoint-6") }
    },
    ecr_api = {
      service             = "ecr.api",
      service_type        = "Interface",
      private_dns_enabled = true,
      policy              = null,
      tags                = { Name = upper("eks-ecr-api-vpc-endpoint-7") }
    },
    logs = {
      service             = "logs",
      service_type        = "Interface",
      private_dns_enabled = true,
      policy              = null,
      tags                = { Name = upper("eks-logs-vpc-endpoint-8") }
    },
    ssm = {
      service             = "ssm",
      service_type        = "Interface",
      private_dns_enabled = true,
      policy              = null,
      tags                = { Name = upper("eks-ssm-vpc-endpoint-9") }
    },
    eks_auth = {
      service             = "eks-auth",
      service_type        = "Interface",
      private_dns_enabled = true,
      policy              = null,
      tags                = { Name = upper("eks-eks-auth-vpc-endpoint-10") }
    },
    s3_gateway = {
      service      = "s3",
      service_type = "Gateway",
      policy       = null,
      route_table_ids = [
        "${module.eks_vpc.route_table_id_subnet_key["subnet_cp_1a"]}",
        "${module.eks_vpc.route_table_id_subnet_key["subnet_cp_1b"]}",
        "${module.eks_vpc.route_table_id_subnet_key["subnet_cp_1c"]}",
        "${module.eks_vpc.route_table_id_subnet_key["subnet_nodes_2a"]}",
        "${module.eks_vpc.route_table_id_subnet_key["subnet_nodes_2b"]}",
        "${module.eks_vpc.route_table_id_subnet_key["subnet_nodes_2c"]}",
        "${module.eks_vpc.route_table_id_subnet_key["subnet_pod_3a"]}",
        "${module.eks_vpc.route_table_id_subnet_key["subnet_pod_3b"]}",
        "${module.eks_vpc.route_table_id_subnet_key["subnet_pod_3c"]}",
      ],
      tags = { Name = upper("eks-s3-gateway-vpc-endpoint-12") }
    }
  }
  tags = var.tags
  depends_on = [
    module.vpc,
    module.dmz_subnets,
    module.security_groups_for_vpc_endpoint
  ]
}
