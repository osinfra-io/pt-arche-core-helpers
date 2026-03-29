# Input Variables
# https://opentofu.org/docs/language/values/variables

variable "workspace" {
  default     = null
  description = "This is used for tests to set the workspace name. Do not set this variable in any other context"
  type        = string
}
