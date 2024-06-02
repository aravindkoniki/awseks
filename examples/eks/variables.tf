variable "region" {
  type        = string
  description = "Region for the resource to deploy"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "control_plane_subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster control plane (ENIs) will be provisioned. Used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane"
  type        = list(string)
  default     = []
}

variable "node_subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster nodes will be provisioned."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster security group will be provisioned"
  type        = string
}

variable "cluster_security_group_id" {
  description = "Existing security group ID to be attached to the cluster"
  type        = string
}

variable "node_security_group_id" {
  description = "Existing security group ID to be attached to the cluster"
  type        = string 
}

variable "cluster_encryption_kms_key" {
  description = "Cluster encryption key"
  type        = string
}



# Tags
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}