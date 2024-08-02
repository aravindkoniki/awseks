output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = try(aws_eks_node_group.node_group[0].arn, null)
}

output "node_group_id" {
  description = "EKS Cluster name and EKS Node Group name separated by a colon (`:`)"
  value       = try(aws_eks_node_group.node_group[0].id, null)
}

output "node_group_resources" {
  description = "List of objects containing information about underlying resources"
  value       = try(aws_eks_node_group.node_group[0].resources, null)
}

output "node_group_autoscaling_group_names" {
  description = "List of the autoscaling group names"
  value       = try(flatten(aws_eks_node_group.node_group[0].resources[*].autoscaling_groups[*].name), [])
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = try(aws_eks_node_group.node_group[0].status, null)
}

output "node_group_labels" {
  description = "Map of labels applied to the node group"
  value       = try(aws_eks_node_group.node_group[0].labels, {})
}

output "node_group_taints" {
  description = "List of objects containing information about taints applied to the node group"
  value       = try(aws_eks_node_group.node_group[0].taint, [])
}

# Autoscaling Group Schedule
output "autoscaling_group_schedule_arns" {
  description = "ARNs of autoscaling group schedules"
  value       = { for k, v in aws_autoscaling_schedule.autoscaling : k => v.arn }
}

# IAM Role
output "iam_role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.node_role.name
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = aws_iam_role.node_role.arn
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = aws_iam_role.node_role.unique_id
}