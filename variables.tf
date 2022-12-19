variable "name_prefix" {
  description = "Name of the application that is using this table"
  type        = string
}

variable "subdomain_name" {
  type = string
}

variable "hosted_zone_name" {
  type = string
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}
