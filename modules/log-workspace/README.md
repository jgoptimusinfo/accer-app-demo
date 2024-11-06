# Terraform Azure Log Analytics Workspace Module

This Terraform module facilitates the creation of a Log Analytics Workspace in Azure, along with configuring RBAC role assignments and deploying Log Analytics solutions.

## Features

- **Log Analytics Workspace**: Provision a Log Analytics Workspace with customizable settings.
- **RBAC Role Assignment**: Assign Azure AD groups to the workspace with Owner roles.
- **Log Analytics Solutions**: Deploy solutions to the workspace for enhanced monitoring capabilities.

## Usage

Below is an example of how to use this module to create a Log Analytics Workspace, assign an Azure AD group as the Owner, and deploy solutions.

```hcl
module "log_analytics_workspace" {
  source = "../modules/log-workspace"

  name                     = "example-law"
  location                 = "East US"
  resource_group_name      = "example-resources"
  sku                      = "PerGB2018"
  retention_days           = 30
  daily_quota_gb           = -1
  tags                     = {"Environment" = "Production"}

  law_owners_ad_group      = "g-sec-log-analytics-workspace-admin"

  solution_plan_map = {
    "ContainerInsights" = {
      product   = "OMSGallery/ContainerInsights"
      publisher = "Microsoft"
    }
  }
}