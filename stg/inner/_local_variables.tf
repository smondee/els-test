variable "role" {
  default = "inner"
}

locals {
  role_prefix = "${local.resource_prefix}-${var.role}"
}

