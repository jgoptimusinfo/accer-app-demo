
variable "name" {
  type        = string
  description = "Storage Container name"
}

variable "storage_account_name" {
  type        = string
  description = "Storage Account name where container will be create"
}

variable "principal_id" {
  type        = string
  description = "Principal id to add RBAC permision on Storage Container"
}



