data "aws_ami" "bottlerocket_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["bottlerocket-aws-k8s-${local.cluster_version}-x86_64-*"]
  }
}

data "aws_caller_identity" "current" {}