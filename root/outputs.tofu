# Output Values
# https://opentofu.org/docs/language/values/outputs

output "cost_center" {
  description = "The cost center the resources will be billed to"
  value       = var.cost_center
}

output "data_classification" {
  description = "The data classification of the resources"
  value       = var.data_classification
}

output "environment_folder_id" {
  description = "The folder ID for the current team and environment from logos state"
  value       = local.environment_folder_id
}

output "labels" {
  description = "A map of labels to apply to resources"
  value       = local.labels
}

output "project_naming" {
  description = "The project naming configuration from logos state. Contains prefix, team_key, and team_prefix."
  value       = local.project_naming
}

output "repository" {
  description = "The repository name"
  value       = var.repository
}

output "team" {
  description = "The team name"
  value       = var.team
}

output "team_key" {
  description = "The team key (same as team for consistency)"
  value       = local.team_key
}

output "team_prefix" {
  description = "Team type prefix extracted from team key (e.g., 'pt', 'st', 'ct', 'et')"
  value       = local.team_prefix
}

output "teams" {
  description = "All teams data from logos workspaces"
  value       = local.all_teams
}
