# Azure SQL Server Terraform Module

This Terraform module provisions an Azure SQL Server with optional configurations for managed identities, firewall rules, and Azure Active Directory (AAD) administrators.

## Usage

```hcl
module "sql_server" {
  source = "../modules/sql-server"

  location            = var.location
  resource_group_name = var.resource_group_name
  sql_server_name     = var.sql_server_name
  sql_admin_username  = var.sql_admin_username
  sql_password        = var.sql_password
  server_version      = var.server_version
  connection_policy   = var.connection_policy
  identity_ids        = var.identity_ids
  sql_aad_administrator = var.sql_aad_administrator
  public_network_access_enabled        = var.public_network_access_enabled
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled
  start_ip_address = var.start_ip_address
  end_ip_address   = var.end_ip_address
  tags             = var.tags
}

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `location` | Specifies the supported Azure location where the resource exists | `string` | n/a | yes |
| `resource_group_name` | The name of the resource group in which to create the SQL server | `string` | n/a | yes |
| `sql_server_name` | Specifies the name of the SQL server. Only lowercase alphanumeric characters allowed | `string` | n/a | yes |
| `sql_admin_username` | The administrator username of the SQL server | `string` | n/a | yes |
| `sql_password` | The administrator password of the SQL server | `string` | n/a | yes |
| `server_version` | The version for the database server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server) | `string` | `"12.0"` | no |
| `connection_policy` | The connection policy of the server. Valid values are Default, Proxy, Redirect | `string` | `"Default"` | no |
| `identity_ids` | Specifies a list of user managed identity ids to be assigned. This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned` | `list(string)` | `null` | no |
| `sql_aad_administrator` | Configuration for SQL Server AAD Administrator | `object` | `null` | no |
| `public_network_access_enabled` | Specifies whether public network access is allowed for this server. Possible values are `true` or `false` | `bool` | `true` | no |
| `outbound_network_restriction_enabled` | Specifies whether the server should have its outbound network access restricted. Possible values are `true` or `false` | `bool` | `false` | no |
| `start_ip_address` | Defines the start IP address used in your database firewall rule | `string` | `"0.0.0.0"` | no |
| `end_ip_address` | Defines the end IP address used in your database firewall rule | `string` | `"0.0.0.0"` | no |
| `tags` | Tags to be applied to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `sql_server_fqdn` | Fully Qualified Domain Name (FQDN) of the Azure SQL Database created |
| `sql_server_location` | Location of the Azure SQL Database created |
| `sql_server_name` | Server name of the Azure SQL Database created |
| `sql_server_version` | Version of the Azure SQL Database created |

