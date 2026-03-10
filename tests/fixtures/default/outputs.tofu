# Output Values
# https://opentofu.org/docs/language/values/outputs

output "env" {
  description = "The short name for the environment, for example prod, nonprod, sb"
  value       = module.core_helpers_root.env
}

output "environment" {
  description = "The full environment name, for example production, non-production, sandbox"
  value       = module.core_helpers_root.environment
}

output "environment_folder_id" {
  description = "The GCP folder ID for the current team and environment"
  value       = module.core_helpers_root.environment_folder_id
}

output "labels" {
  description = "A map of standard labels to apply to resources"
  value       = module.core_helpers_root.labels
}

output "project_naming" {
  description = "The project naming configuration from logos state"
  value       = module.core_helpers_root.project_naming
}

output "region" {
  description = "The region where resources will be deployed"
  value       = module.core_helpers_root.region
}

output "team_key" {
  description = "The team key identifier"
  value       = module.core_helpers_root.team_key
}

output "zone" {
  description = "The zone where resources will be deployed"
  value       = module.core_helpers_root.zone
}
