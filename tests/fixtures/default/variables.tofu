# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "cost_center" {
  description = "The cost center the resources will be billed to"
  type        = string
}

variable "data_classification" {
  description = "The data classification of the resources"
  type        = string
}

variable "repository" {
  description = "The repository name"
  type        = string
}

variable "team" {
  description = "The team name"
  type        = string
}

variable "workspace" {
  description = "The workspace name used for testing environment detection"
  type        = string
}
