data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

# EFA Support
data "aws_ec2_instance_type" "ec2_instance_types" {
  count         = var.create && var.enable_efa_support ? 1 : 0
  instance_type = local.efa_instance_type
}

# AMI SSM Parameter
data "aws_ssm_parameter" "ami" {
  count = var.create && var.use_latest_ami_release_version ? 1 : 0
  name  = local.ssm_ami_type_to_ssm_param[var.ami_type]
}

# Find the availability zones supported by the instance type
data "aws_ec2_instance_type_offerings" "instance_type_offerings" {
  count = var.create && var.enable_efa_support ? 1 : 0
  filter {
    name   = "instance-type"
    values = [local.efa_instance_type]
  }
  location_type = "availability-zone-id"
}

# Reverse the lookup to find one of the subnets provided based on the availability
# availability zone ID of the queried instance type (supported)
data "aws_subnets" "efa" {
  count = var.create && var.enable_efa_support ? 1 : 0
  filter {
    name   = "subnet-id"
    values = var.subnet_ids
  }
  filter {
    name   = "availability-zone-id"
    values = data.aws_ec2_instance_type_offerings.instance_type_offerings[0].locations
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "EKSNodeAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}