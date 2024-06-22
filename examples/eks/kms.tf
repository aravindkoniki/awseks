# KMS Key
module "kms" {
  source                = "git::https://github.com/aravindkoniki/awskms.git//module?ref=main"
  key_name              = "eks/${var.cluster_name}"
  description           = "${var.cluster_name} cluster encryption key"
  key_usage             = "ENCRYPT_DECRYPT"
  enable_default_policy = false
  key_administrators    = [data.aws_caller_identity.current.arn]
  computed_aliases = {
    cluster = { name = "eks/${var.cluster_name}" }
  }
  tags = var.tags
}
