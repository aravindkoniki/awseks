variable "create" {
  description = "Determines whether to create EKS managed node group or not"
  type        = bool
  default     = true
}

variable "instance_types" {
  description = "Set of instance types associated with the EKS Node Group. Defaults to `[\"t3.medium\"]`"
  type        = list(string)
  default     = null
}

variable "enable_efa_support" {
  description = "Determines whether to enable Elastic Fabric Adapter (EFA) support"
  type        = bool
  default     = false
}

variable "network_interfaces" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(any)
  default     = []
}


variable "cluster_version" {
  description = "Kubernetes version. Defaults to EKS Cluster Kubernetes version"
  type        = string
  default     = null
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. See the [AWS documentation](https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType) for valid values"
  type        = string
  default     = null
}

variable "use_latest_ami_release_version" {
  description = "Determines whether to use the latest AMI release version for the given `ami_type` (except for `CUSTOM`). Note: `ami_type` and `cluster_version` must be supplied in order to enable this feature"
  type        = bool
  default     = false
}

variable "launch_template_id" {
  description = "The ID of an existing launch template to use. Required when `create_launch_template` = `false` and `use_custom_launch_template` = `true`"
  type        = string
  default     = ""
}

variable "launch_template_version" {
  description = "Launch template version number. The default is `$Default`"
  type        = string
  default     = null
}

# Tags
variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}