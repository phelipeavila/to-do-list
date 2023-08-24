variable "enable_prevent_destroy" {
  description = "Boolean to decide whether to enable enable_prevent_destroy or not"
  default     = true
}

variable "my_ext_ip" {
  description = "External IP of the host running terraform. This IP will be added in the security group to allow SSH Connections from it."
  type = string
}