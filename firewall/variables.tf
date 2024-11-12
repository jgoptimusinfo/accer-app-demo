## ------------------------------------
##  COMMON VARIABLES
## ------------------------------------

variable "location" {
  type        = string
  default     = "eastus"
  description = "all resource location"
}

variable "tags" {
  type        = map(string)
  description = "tags value for resources"
}