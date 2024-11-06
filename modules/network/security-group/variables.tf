## --------------------------------------------------------
## Common variables
## --------------------------------------------------------

variable "resource_group_name" {
  description = "EOT The name of the resource group in which to create the virtual network.The Resource Group must already exist."
  type        = string
}

variable "location" {
  description = "The Azure Region where the Resource Group should exist.Changing this forces a new Resource Group to be created."
  type        = string
}

variable "tags" {
  description = "A mapping of tags which should be assigned to Resources."
  type        = map(string)
  default     = {}
}

variable "network_security_group_name" {
  description = "The name of the Network Security Group."
  type        = string
}

variable "security_rules" {
  description = "A list of security rules which should be created within the Network Security Group."
  type = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = {}
}

variable "subnet" {
  description = "A subnet to associate with the Network Security Group."
  type        = string
  default     = ""
}