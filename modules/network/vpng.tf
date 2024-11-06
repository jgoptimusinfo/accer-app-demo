module "vpn-gateway" {
  source = "./vpn-gateway"

  count = var.enable_vpn_gateway ? 1 : 0

  resource_group_name      = var.resource_group_name
  virtual_network_name     = azurerm_virtual_network.vnet.name
  vpn_gateway_name         = var.vpn_gateway_name
  gateway_type             = var.gateway_type
  vpn_gw_sku               = var.vpn_gw_sku
  vpn_type                 = var.vpn_type
  vpn_gw_generation        = var.vpn_gw_generation
  vpn_client_configuration = var.vpn_client_configuration
  gateway_connection_type  = var.gateway_connection_type
  enable_active_active     = var.enable_active_active

  public_ip_allocation_method = var.public_ip_allocation_method
  public_ip_sku               = var.public_ip_sku

  # local network gateway connection
  local_networks              = var.local_networks
  local_bgp_settings          = var.local_bgp_settings
  local_networks_ipsec_policy = var.local_networks_ipsec_policy

  enable_bgp                                = var.enable_bgp
  bgp_asn_number                            = var.bgp_asn_number
  bgp_peering_address_apipa                 = var.bgp_peering_address_apipa
  bgp_peering_address_ip_configuration_name = var.bgp_peering_address_ip_configuration_name
  bgp_peer_weight                           = var.bgp_peer_weight

  express_route_circuit_id        = var.express_route_circuit_id
  expressroute_sku                = var.expressroute_sku
  gateway_connection_protocol     = var.gateway_connection_protocol
  peer_virtual_network_gateway_id = var.peer_virtual_network_gateway_id

  tags = var.tags
}