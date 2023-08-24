variable "enable_prevent_destroy" {
  description = "Boolean to decide whether to enable enable_prevent_destroy or not"
  default     = true
}

variable "allowed_cidr" {
  description = "CIDR to be added to security group rule to allow ssh connection from it"
  type = list
  default = [ ]
}