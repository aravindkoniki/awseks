locals {
  ################################################################################
  # EFA Support
  ################################################################################
  efa_instance_type = try(element(var.instance_types, 0), "")
  num_network_cards = try(data.aws_ec2_instance_type.ec2_instance_types[0].maximum_network_cards, 0)

  efa_network_interfaces = [
    for i in range(local.num_network_cards) : {
      associate_public_ip_address = false
      delete_on_termination       = true
      device_index                = i == 0 ? 0 : 1
      network_card_index          = i
      interface_type              = "efa"
    }
  ]

  network_interfaces = var.enable_efa_support ? local.efa_network_interfaces : var.network_interfaces

  ################################################################################
  # AMI SSM Parameter
  ################################################################################

  # Just to ensure templating doesn't fail when values are not provided
  ssm_cluster_version = var.cluster_version != null ? var.cluster_version : ""
  ssm_ami_type        = var.ami_type != null ? var.ami_type : ""

  # Map the AMI type to the respective SSM param path
  ssm_ami_type_to_ssm_param = {
    AL2_x86_64                 = "/aws/service/eks/optimized-ami/${local.ssm_cluster_version}/amazon-linux-2/recommended/release_version"
    AL2_x86_64_GPU             = "/aws/service/eks/optimized-ami/${local.ssm_cluster_version}/amazon-linux-2-gpu/recommended/release_version"
    AL2_ARM_64                 = "/aws/service/eks/optimized-ami/${local.ssm_cluster_version}/amazon-linux-2-arm64/recommended/release_version"
    CUSTOM                     = "NONE"
    BOTTLEROCKET_ARM_64        = "/aws/service/bottlerocket/aws-k8s-${local.ssm_cluster_version}/arm64/latest/image_version"
    BOTTLEROCKET_x86_64        = "/aws/service/bottlerocket/aws-k8s-${local.ssm_cluster_version}/x86_64/latest/image_version"
    BOTTLEROCKET_ARM_64_NVIDIA = "/aws/service/bottlerocket/aws-k8s-${local.ssm_cluster_version}-nvidia/arm64/latest/image_version"
    BOTTLEROCKET_x86_64_NVIDIA = "/aws/service/bottlerocket/aws-k8s-${local.ssm_cluster_version}-nvidia/x86_64/latest/image_version"
    WINDOWS_CORE_2019_x86_64   = "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-EKS_Optimized-${local.ssm_cluster_version}"
    WINDOWS_FULL_2019_x86_64   = "/aws/service/ami-windows-latest/Windows_Server-2019-English-Core-EKS_Optimized-${local.ssm_cluster_version}"
    WINDOWS_CORE_2022_x86_64   = "/aws/service/ami-windows-latest/Windows_Server-2022-English-Full-EKS_Optimized-${local.ssm_cluster_version}"
    WINDOWS_FULL_2022_x86_64   = "/aws/service/ami-windows-latest/Windows_Server-2022-English-Core-EKS_Optimized-${local.ssm_cluster_version}"
    AL2023_x86_64_STANDARD     = "/aws/service/eks/optimized-ami/${local.ssm_cluster_version}/amazon-linux-2023/x86_64/standard/recommended/release_version"
    AL2023_ARM_64_STANDARD     = "/aws/service/eks/optimized-ami/${local.ssm_cluster_version}/amazon-linux-2023/arm64/standard/recommended/release_version"
  }

  # The Windows SSM params currently do not have a release version, so we have to get the full output JSON blob and parse out the release version
  windows_latest_ami_release_version = var.create && var.use_latest_ami_release_version && startswith(local.ssm_ami_type, "WINDOWS") ? nonsensitive(jsondecode(data.aws_ssm_parameter.ami[0].value)["release_version"]) : null
  # Based on the steps above, try to get an AMI release version - if not, `null` is returned
  latest_ami_release_version = startswith(local.ssm_ami_type, "WINDOWS") ? local.windows_latest_ami_release_version : try(nonsensitive(data.aws_ssm_parameter.ami[0].value), null)

  ################################################################################
  # Node Group
  ################################################################################
  launch_template_id = var.launch_template_id
  # Change order to allow users to set version priority before using defaults
  launch_template_version = var.launch_template_version
}


