# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  # Aggregate all teams data from all logos workspaces
  all_teams = var.logos_workspaces != null ? merge([
    for workspace_name, workspace_data in data.terraform_remote_state.logos :
    try(workspace_data.outputs.teams, {})
  ]...) : {}

  # Environment folder ID for the current team and environment
  environment_folder_id = local.team_data != null && local.environment_key != null ? local.team_data.environments[local.environment_key] : null

  # Environment key for logos lookup (title case keeping hyphens)
  environment_key = local.environment != null ? title(local.environment) : null

  labels = {
    # Datadog expects the label env for unified service tagging otherwise we'd use the full name of environment.
    cost-center         = var.cost_center
    data-classification = var.data_classification
    env                 = local.environment
    region              = local.region
    repository          = var.repository
    team                = var.team
    zone                = local.zone != null ? "${local.region}-${local.zone}" : null
  }

  logos_workspaces = var.logos_workspaces != null ? toset(var.logos_workspaces) : toset([])

  # Project naming components for downstream consumption
  project_naming = local.team_data != null ? {
    prefix      = local.team_prefix
    team_key    = local.team_key
    team_prefix = local.team_prefix
  } : null

  # Logos functionality - parse team data from remote state when available
  # Find the workspace that contains our team data
  team_data = var.logos_workspaces != null ? try(
    # Look for our team in each workspace
    [for workspace_name, workspace_data in data.terraform_remote_state.logos :
      workspace_data.outputs.teams[var.team]
      if try(contains(keys(workspace_data.outputs.teams), var.team), false)
    ][0],
    null
  ) : null

  # Extract team key from team variable
  team_key = var.team

  # Team prefix extraction (pt, st, ct, et)
  team_prefix = local.team_key != null ? split("-", local.team_key)[0] : null
}
