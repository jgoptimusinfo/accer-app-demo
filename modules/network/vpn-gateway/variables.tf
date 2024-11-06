variable "resource_group_name" {
  type        = string
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network"
  default     = ""
}

variable "vpn_gateway_name" {
  type        = string
  description = "The name of the Virtual Network Gateway"
  default     = ""
}

variable "public_ip_allocation_method" {
  type        = string
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic. Defaults to Dynamic"
  default     = "Dynamic"
}

variable "public_ip_sku" {
  type        = string
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic"
  default     = "Basic"
}

variable "gateway_type" {
  type        = string
  description = "The type of the Virtual Network Gateway. Valid options are Vpn or ExpressRoute"
  default     = "Vpn"
}

variable "vpn_type" {
  type        = string
  description = "The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased"
  default     = "RouteBased"
}

variable "vpn_gw_sku" {
  type        = string
  description = "Configuration of the size and capacity of the virtual network gateway. Valid options are Basic, VpnGw1, VpnGw2, VpnGw3, VpnGw4,VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ,VpnGw4AZ and VpnGw5AZ and depend on the type, vpn_type and generation arguments"
  default     = "VpnGw1"
}

variable "expressroute_sku" {
  type        = string
  description = "Configuration of the size and capacity of the virtual network gateway for ExpressRoute type. Valid options are Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ and depend on the type, vpn_type and generation arguments"
  default     = "Standard"
}

variable "vpn_gw_generation" {
  type        = string
  description = "The Generation of the Virtual Network gateway. Possible values include Generation1, Generation2 or None"
  default     = "Generation1"
}

variable "enable_active_active" {
  type        = bool
  description = "If true, an active-active Virtual Network Gateway will be created. An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false."
  default     = false
}

variable "enable_bgp" {
  type        = bool
  description = "If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false"
  default     = false
}

variable "bgp_asn_number" {
  type        = string
  description = "The Autonomous System Number (ASN) to use as part of the BGP"
  default     = "65515"
}

variable "bgp_peering_address_apipa" {
  type        = list(string)
  description = "(Optional) A list of Azure custom APIPA addresses assigned to the BGP peer of the Virtual Network Gateway."
  default     = []
}

variable "bgp_peering_address_ip_configuration_name" {
  type        = string
  description = "Optional) The name of the IP configuration of this Virtual Network Gateway. In case there are multiple ip_configuration blocks defined, this property is required to specify."
  default     = ""
}

variable "bgp_peer_weight" {
  type        = string
  description = "The weight added to routes which have been learned through BGP peering. Valid values can be between 0 and 100"
  default     = ""
}

variable "vpn_client_configuration" {
  type        = object({ address_space = string, certificate = string, vpn_client_protocols = list(string) })
  description = "Virtual Network Gateway client configuration to accept IPSec point-to-site connections"
  default     = null
}

variable "local_networks" {
  type        = list(object({ local_gw_name = string, local_gateway_address = string, local_address_space = list(string), shared_key = string }))
  description = "List of local virtual network connections to connect to gateway"
  default     = []
}

variable "local_bgp_settings" {
  type        = list(object({ asn_number = number, peering_address = string, peer_weight = number }))
  description = "Local Network Gateway's BGP speaker settings"
  default     = null
}

variable "gateway_connection_type" {
  type        = string
  description = "The type of connection. Valid options are IPsec (Site-to-Site), ExpressRoute (ExpressRoute), and Vnet2Vnet (VNet-to-VNet)"
  default     = "IPsec"
}

variable "express_route_circuit_id" {
  type        = string
  description = "The ID of the Express Route Circuit when creating an ExpressRoute connection"
  default     = null
}

variable "peer_virtual_network_gateway_id" {
  type        = string
  description = "The ID of the peer virtual network gateway when creating a VNet-to-VNet connection"
  default     = null
}

variable "gateway_connection_protocol" {
  type        = string
  description = "The IKE protocol version to use. Possible values are IKEv1 and IKEv2. Defaults to IKEv2"
  default     = "IKEv2"
}

variable "local_networks_ipsec_policy" {
  type        = any
  description = "IPSec policy for local networks. Only a single policy can be defined for a connection."
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
