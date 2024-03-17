data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

################################################################################
# EFA Support
################################################################################
data "aws_ec2_instance_type" "ec2_instance_types" {
  count = var.create && var.enable_efa_support ? 1 : 0

  instance_type = local.efa_instance_type
}

################################################################################
# AMI SSM Parameter
################################################################################
data "aws_ssm_parameter" "ami" {
  count = var.create && var.use_latest_ami_release_version ? 1 : 0

  name = local.ssm_ami_type_to_ssm_param[var.ami_type]
}
