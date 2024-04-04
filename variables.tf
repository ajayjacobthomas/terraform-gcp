variable "app_name" {
  description = "The name of the application, used in naming firewall rules"
  type        = string
}

variable "app_domain" {
  description = "The domain of the application, used in the hostname of a VM"
  type        = string
}
