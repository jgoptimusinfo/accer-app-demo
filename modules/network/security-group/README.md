# Network Security Group Module

This Terraform module creates an Azure Network Security Group (NSG) and associated security rules. It also sets up the association of the NSG with specified subnets.

## Module Features

- Creates an Azure Network Security Group.
- Adds security rules to the Network Security Group.
- Associates the Network Security Group with specified subnets.

## Usage

```hcl
module "network_security_group" {
  source = "../modules/network/security-group"

  resource_group_name          = var.resource_group_name
  location                     = var.location
  tags                         = var.tags
  network_security_group_name  = var.network_security_group_name
  security_rules               = var.security_rules
  subnet                       = var.subnet
}
```
## Variables

| Name                        | Type           | Description                                                                 | Default |
|-----------------------------|----------------|-----------------------------------------------------------------------------|---------|
| resource_group_name         | string         | The name of the resource group in which to create the virtual network. The Resource Group must already exist. | N/A     |
| location                    | string         | The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created. | N/A     |
| tags                        | map(string)    | A mapping of tags which should be assigned to Resources.                    | {}      |
| network_security_group_name | string         | The name of the Network Security Group.                                     | N/A     |
| security_rules              | map(object)    | A list of security rules which should be created within the Network Security Group. | {}      |
| subnet                | string   | A subnet id to associate with the Network Security Group.             | []      |


## Security Rules Object

The security_rules variable is a map of objects with the following attributes:

| Attribute                   | Type    | Description                                                                 |
|-----------------------------|---------|-----------------------------------------------------------------------------|
| name                        | string  | The name of the security rule.                                              |
| priority                    | number  | The priority of the rule. Lower numbers indicate higher priority.           |
| direction                   | string  | The direction of the rule. Possible values are Inbound and Outbound.        |
| access                      | string  | The access type of the rule. Possible values are Allow and Deny.            |
| protocol                    | string  | The network protocol this rule applies to. Possible values are Tcp, Udp, and * (for all). |
| source_port_range           | string  | The source port or range. Use * to match all ports.                         |
| destination_port_range      | string  | The destination port or range. Use * to match all ports.                    |
| source_address_prefix       | string  | The source address prefix. Use * to match all addresses.                    |
| destination_address_prefix  | string  | The destination address prefix. Use * to match all addresses.               |

## Example

```terraform

module "nsg" {
  source = "git::https://repo.com/v1/repos/az-virtual-network//security-group"

  location                    = var.location
  resource_group_name         = var.rg_network.name
  network_security_group_name = "nsg-01"
  
  subnet    = module.customer_network.subnet_1.id
  
  security_rules  = {
    allow_ssh = {
      name                       = "allow_ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    allow_rdp = {
      name                       = "allow_rdp"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
  }
} 
```