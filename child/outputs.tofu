# Output Values
# https://opentofu.org/docs/language/values/outputs

output "env" {
  description = "The short name for the environment for example prod, nonprod, sb"
  value       = local.env
}

output "environment" {
  description = "The environment name for example production, non-production, sandbox"
  value       = local.environment
}

output "region" {
  description = "The region where resources will be deployed"
  value       = local.region
}

output "zone" {
  description = "The zone where resources will be deployed"
  value       = local.zone
}
