# Local Values
# https://opentofu.org/docs/language/values/locals

locals {
  # Production state provides shared team metadata; environment state provides scoped folders
  # and identity groups for the current deployment environment.
  all_teams = {
    for team_key in local.all_team_keys : team_key => merge(
      try(local.production_teams[team_key], {}),
      try(local.environment_teams[team_key], {}),
      {
        billing_users_group = try(local.environment_teams[team_key].billing_users_group, null) != null ? local.environment_teams[team_key].billing_users_group : try(local.production_teams[team_key].billing_users_group, null)
        environments = merge(
          try(local.production_teams[team_key].environments, {}),
          try(local.environment_teams[team_key].environments, {})
        )
        github_repositories = merge(
          try(local.production_teams[team_key].github_repositories, {}),
          try(local.environment_teams[team_key].github_repositories, {})
        )
        identity_groups = merge(
          try(local.production_teams[team_key].identity_groups, {}),
          try(local.environment_teams[team_key].identity_groups, {})
        )
      }
    )
  }

  all_team_keys = toset(concat(
    keys(local.production_teams),
    keys(local.environment_teams)
  ))

  environment_teams = local.environment != "production" && length(local.logos_workspaces) > 0 ? merge([
    for workspace_name, workspace_data in data.terraform_remote_state.logos_environment :
    try(workspace_data.outputs.teams, {})
  ]...) : {}

  environment_folder_id = local.team_data != null && local.environment_key != null ? try(local.team_data.environments[local.environment_key], null) : null

  environment_key = local.environment != null ? title(local.environment) : null

  environment_root_folder_id = local.team_data != null ? try(local.team_data.environment_root_folder_id, null) : null

  # Environment workspace names mirror the production workspace names supplied by consumers.
  logos_environment_workspaces = var.logos_workspaces != null && local.environment != "production" ? toset([
    for workspace_name in var.logos_workspaces :
    "${trimsuffix(workspace_name, "-main-production")}-main-${local.environment}"
  ]) : toset([])

  logos_workspaces = var.logos_workspaces != null ? toset(var.logos_workspaces) : toset([])

  production_teams = length(local.logos_workspaces) > 0 ? merge([
    for workspace_name, workspace_data in data.terraform_remote_state.logos :
    try(workspace_data.outputs.teams, {})
  ]...) : {}

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

  # Project naming components for downstream consumption
  project_naming = local.team_data != null ? {
    prefix      = local.team_prefix
    team_key    = var.team
    team_prefix = local.team_prefix
  } : null

  team_data = var.logos_workspaces != null ? try(local.all_teams[var.team], null) : null

  # Team prefix extraction (pt, st, ct, et)
  team_prefix = var.team != null ? split("-", var.team)[0] : null
}
