# OpenTofu Core Helpers
# https://github.com/osinfra-io/pt-arche-core-helpers

module "core_helpers_root" {
  source = "../../../root"

  cost_center         = var.cost_center
  data_classification = var.data_classification
  repository          = var.repository
  team                = var.team
  workspace           = var.workspace
}
