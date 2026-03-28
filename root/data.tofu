# Terraform Remote State - Logos
# https://opentofu.org/docs/language/state/remote-state-data

data "terraform_remote_state" "logos" {
  for_each = local.logos_workspaces

  backend = "gcs"

  config = {
    bucket = "pt-logos-state-prod"
    prefix = "pt-logos"
  }

  workspace = each.key
}
