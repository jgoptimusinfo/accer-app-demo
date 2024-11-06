
## --------------------------------------------------------
##  KeyVault - Module 
## --------------------------------------------------------
 /* 
module "keyvault_main" {
  source = "../modules/keyvault"

  location            = var.location
  resource_group_name = module.rg_main_shared.name

  name                          = var.keyvault_config.name
  sku_name                      = var.keyvault_config.sku_name
  soft_delete_retention_days    = var.keyvault_config.soft_delete_retention_days
  purge_protection_enabled      = var.keyvault_config.purge_protection_enabled
  public_network_access_enabled = var.keyvault_config.public_network_access_enabled

  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false

  tags = var.tags
}

## --------------------------------------------------------
##  KeyVault - Diagnostic Setting
## --------------------------------------------------------

module "keyvault_diagnostic_setting" {
  source = "../modules/diag-setting"

  name                              = "kv-diag-setting"
  target_log_analytics_workspace_id = module.log_analytics_workspace.id
  target_resource_id                = module.keyvault_main.id
  log_analytics_destination_type    = "Dedicated"

  log_categories = [
    "AuditEvent",
    "AzurePolicyEvaluationDetails"
  ]
  log_metrics = [
    "AllMetrics"
  ]
}

## --------------------------------------------------------
##  TimeSleep - wait 200 seg
## --------------------------------------------------------

resource "time_sleep" "wait_120_seconds" {

  create_duration = "120s"
  depends_on = [ module.keyvault_main ]
}

## --------------------------------------------------------
##  KeyVault - Generate SSL Certificate
## --------------------------------------------------------

resource "azurerm_key_vault_certificate" "ssl_cert" {
  name         = "generated-cert"
  key_vault_id = module.keyvault_main.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["www.msi-test.com", "api.msi-test.com"]
      }

      subject            = "CN=www.msi-test.com"
      validity_in_months = 12
    }
  }

  depends_on = [ time_sleep.wait_120_seconds ]
} */