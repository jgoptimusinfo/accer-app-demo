# Terraform Template Repository

This repository contains Terraform configurations for deploying various Azure resources. The repository is structured to support modular and reusable code, making it easier to manage and deploy infrastructure as code.

## Repository Structure

- `main.tf`: Contains the main Terraform configuration for deploying resources.
- `variables.tf`: Defines the input variables for the Terraform configuration.
- `outputs.tf`: Defines the outputs for the Terraform configuration.
- `README.md`: Provides an overview and detailed explanation of the repository and its contents.

## Main Terraform Configuration (`main.tf`)

### Azure Firewall Configuration

The `azurerm_firewall` resource is used to create an Azure Firewall within a Virtual WAN Hub. The firewall is configured with two public IP addresses and a DNAT rule.

```terraform
resource "azurerm_firewall" "example" {
  name                = "example-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Standard"
  zones               = ["1"]

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_address_id
  }

  ip_configuration {
    name                 = "configuration2"
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_address_id2
  }

  firewall_policy_id = var.firewall_policy_id

  tags = var.tags
}
```

- name: The name of the Azure Firewall.
- location: The location/region where the firewall will be deployed.
- resource_group_name: The name of the resource group.
- sku_name: The SKU name for the firewall, set to AZFW_Hub for Virtual WAN Hub.
- sku_tier: The SKU tier for the firewall, set to Standard.
- zones: The availability zones for the firewall.
- ip_configuration: Defines the IP configurations for the firewall, including the subnet and public IP addresses.
- firewall_policy_id: The ID of the firewall policy to be applied.
- tags: A map of tags to assign to the resource.
### DNAT Rule Configuration
The azurerm_firewall_nat_rule_collection resource is used to create a DNAT rule collection for the Azure Firewall.

```terraform
resource "azurerm_firewall_nat_rule_collection" "example" {
  name                = "example-nat-rule-collection"
  azure_firewall_name = azurerm_firewall.example.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Dnat"

  rule {
    name                  = "example-dnat-rule"
    description           = "DNAT rule for inbound traffic"
    source_addresses      = ["*"]
    destination_addresses = [azurerm_firewall.example.ip_configuration[0].public_ip_address_id, azurerm_firewall.example.ip_configuration[1].public_ip_address_id]
    destination_ports     = ["80"]
    translated_address    = var.translated_address
    translated_port       = "8080"
    protocols             = ["TCP"]
  }
}
```
