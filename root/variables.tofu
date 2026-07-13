# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "cost_center" {
  description = "The cost center the resources will be billed to, must start with 'x' followed by three or four digits"
  type        = string

  validation {
    condition     = can(regex("^(x\\d{3,4}|mock-cost-center)$", var.cost_center))
    error_message = "The cost center must start with 'x' followed by three or four digits"
  }
}

variable "data_classification" {
  description = "The data classification of the resources can be public, internal, or confidential"
  type        = string

  validation {
    condition     = can(regex("^(mock-data-classification|public|internal|confidential)$", var.data_classification))
    error_message = "The data classification must be public, internal, or confidential"
  }
}

variable "logos_workspaces" {
  description = "List of logos workspace names to read remote state from for team data aggregation. When provided, enables logos integration features including team data lookup, project naming, and environment folder IDs. Example: ['corpus-main-production', 'logos-main-production']"
  type        = list(string)
  default     = null
}

variable "repository" {
  description = "The repository name containing only lowercase alphanumeric characters or hyphens"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.repository))
    error_message = "The repository name must consist entirely of lowercase alphanumeric characters or hyphens"
  }
}

variable "team" {
  description = "The team name (should contain only lowercase alphanumeric characters and hyphens)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.team))
    error_message = "The team name should contain only lowercase alphanumeric characters and hyphens"
  }
}
