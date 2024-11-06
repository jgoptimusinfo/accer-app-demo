
variable "vnet_id" {
  type        = string
  description = "Vnet ID to deploy this subnet"

}

variable "subnet" {
  description = "Subnets configuration"
  type = object({
    name                                          = string
    address_prefixes                              = list(string)
    private_endpoint_network_policies             = string
    private_link_service_network_policies_enabled = bool
  })
}

variable "service_delegation_name" {
  type        = string
  default     = null
  description = <<EOT
  The name of service to delegate to. Possible values are GitHub.Network/networkSettings, 
  Microsoft.ApiManagement/service, Microsoft.Apollo/npu, Microsoft.App/environments, 
  Microsoft.App/testClients, Microsoft.AVS/PrivateClouds, Microsoft.AzureCosmosDB/clusters, 
  Microsoft.BareMetal/AzureHostedService, Microsoft.BareMetal/AzureHPC, 
  Microsoft.BareMetal/AzurePaymentHSM, Microsoft.BareMetal/AzureVMware, 
  Microsoft.BareMetal/CrayServers, Microsoft.BareMetal/MonitoringServers, 
  Microsoft.Batch/batchAccounts, Microsoft.CloudTest/hostedpools, Microsoft.CloudTest/images, 
  Microsoft.CloudTest/pools, Microsoft.Codespaces/plans, Microsoft.ContainerInstance/containerGroups, 
  Microsoft.ContainerService/managedClusters, Microsoft.ContainerService/TestClients, 
  Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/servers, 
  Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, 
  Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers,
  Microsoft.DelegatedNetwork/controller, Microsoft.DevCenter/networkConnection, 
  Microsoft.DocumentDB/cassandraClusters, Microsoft.Fidalgo/networkSettings, 
  Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, 
  Microsoft.LabServices/labplans, Microsoft.Logic/integrationServiceEnvironments, 
  Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/dnsResolvers, 
  Microsoft.Network/managedResolvers, Microsoft.Network/fpgaNetworkInterfaces, 
  Microsoft.Network/networkWatchers., Microsoft.Network/virtualNetworkGateways, 
  Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/enterprisePolicies, 
  Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, 
  Microsoft.ServiceNetworking/trafficControllers, Microsoft.Singularity/accounts/networks, 
  Microsoft.Singularity/accounts/npu, Microsoft.Sql/managedInstances, Microsoft.Sql/managedInstancesOnebox, 
  Microsoft.Sql/managedInstancesStage, Microsoft.Sql/managedInstancesTest, Microsoft.Sql/servers, 
  Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, 
  Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments, 
  PaloAltoNetworks.Cloudngfw/firewalls, Qumulo.Storage/fileSystems, and Oracle.Database/networkAttachments.
  EOT
}

variable "service_delegation_actions" {
  type        = list(string)
  default     = []
  description = <<EOT
  The name of service to delegate to. Possible values are 
  Microsoft.Network/networkinterfaces/*, Microsoft.Network/publicIPAddresses/join/action,
  Microsoft.Network/publicIPAddresses/read, Microsoft.Network/virtualNetworks/read, 
  Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, 
  Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action,
  and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.
  EOT
}

variable "service_endpoints" {
  type        = set(string)
  default     = []
  description = <<EOT
  The list of Service endpoints to associate with the subnet. 
  Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry
  Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage,
  Microsoft.Storage.Global and Microsoft.Web.
  EOT
}

variable "service_endpoint_policy_ids" {
  type        = list(string)
  description = "The list of Service endpoints to associate with the subnet"
  default     = []
}

variable "default_route_table_asociate" {
  type        = bool
  description = "(Optional) Specifies default route table id to associate"
  default     = false
}

variable "default_route_table_id" {
  type        = string
  description = "(Optional) Specifies default route table id to associate"
  default     = null
}
