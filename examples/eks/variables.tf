variable "region" {
  type        = string
  description = "Region for the resource to deploy"
}

variable "eks_vpc_name" {
  description = "Desired name for the VPC resources."
  type        = string
}

variable "eks_cidr_block" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden."
  type        = string
}

variable "eks_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool."
  type        = list(string)
  default     = []
}

variable "eks_subnets" {
  description = "A map of subnet with parameters to create subnets with NACL and Route tables"
}

variable "cluster_security_group" {
  description = "security group for cluster"
}

variable "node_security_group" {
  description = "security group for node"
}

variable "security_group_for_vpc_endpoint" {
  description = "security group for vpc endpoints"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# Tags
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}