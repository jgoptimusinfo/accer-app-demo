# Azure Infrastructure as Code

This repository contains Terraform configurations for deploying DR Sandbox various Azure resources, including SQL servers, storage accounts, application gateways, and more. The repository is structured to support modular and reusable code.

## Introduction

This project aims to provide a comprehensive set of Terraform modules and configurations to deploy and manage Azure infrastructure. The repository is organized into core infrastructure components and reusable modules to facilitate easy and consistent deployments.

## Getting Started

To get started with this repository, follow these steps:

1. **Clone the repository:**
    ```sh
    git clone https://github.com/your-repo-url.git
    cd your-repo-directory
    ```

2. **Install dependencies:**
    Ensure you have Terraform installed. You can download it from the [Terraform website](https://www.terraform.io/downloads.html).

3. **Configure Azure credentials:**
    Set up your Azure credentials using the Azure CLI:
    ```sh
    az login
    ```

4. **Initialize Terraform:**
    Navigate to the desired module or core infrastructure directory and run:
    ```sh
    terraform init
    ```

5. **Apply the configuration:**
    ```sh
    terraform apply
    ```

## Build and Test

To build and test the Terraform configurations:

1. **Format the code:**
    ```sh
    terraform fmt
    ```

2. **Validate the configuration:**
    ```sh
    terraform validate
    ```

3. **Run tests:**
    If you have tests set up, run them using your preferred testing framework.

## Contribute

We welcome contributions from the community. To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Create a new Pull Request.

For more details, refer to the [contribution guidelines](CONTRIBUTING.md).

## Modules

This repository includes several reusable Terraform modules located in the `modules/` directory. Each module has its own `README.md` file with usage instructions.

## Core Infrastructure

The `infra-core/` directory contains the main Terraform configurations for deploying core Azure infrastructure components like SQL servers, storage accounts, and application gateways.

## Example Usage

Here is an example of how to use the SQL Server module:

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

