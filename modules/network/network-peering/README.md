# Network Peering Module

This Terraform module is used to create a Virtual Network Peering between two Azure Virtual Networks. It supports configuration of various peering options such as allowing virtual network access, forwarded traffic, gateway transit, and using remote gateways.

## Usage

```hcl
module "network_peering" {
    source = "../modules/network/network-peering"

    peering_src_name                = "peering-src"
    vnet_src_id                     = "source-vnet-id"
    vnet_dest_id                    = "destination-vnet-id"
    allow_virtual_src_network_access = true
    allow_forwarded_src_traffic     = false
    allow_gateway_src_transit       = false
    use_remote_src_gateway          = false
}


```hcl
module "network_peering" {
  source = "../modules/network/network-peering"

  peering_src_name                = "peering-src"
  vnet_src_id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVnet"
  vnet_dest_id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/anotherResourceGroup/providers/Microsoft.Network/virtualNetworks/anotherVnet"
  allow_virtual_src_network_access = true
  allow_forwarded_src_traffic     = true
  allow_gateway_src_transit       = false
  use_remote_src_gateway          = false
}

This example creates a peering between two virtual networks with specific configurations for network access, forwarded traffic, gateway transit, and remote gateway usage. 
```

## Variables

| Name                          | Description                                                                 | Type    | Default | Required |
|-------------------------------|-----------------------------------------------------------------------------|---------|---------|----------|
| `peering_src_name`            | Name of the source virtual network peering.                                 | string  | n/a     | Yes      |
| `vnet_src_id`                 | ID of the source virtual network to peer.                                   | string  | n/a     | Yes      |
| `vnet_dest_id`                | ID of the destination virtual network to peer.                              | string  | n/a     | Yes      |
| `allow_virtual_src_network_access` | Controls if the VMs in the remote virtual network can access VMs in the local virtual network. | bool    | false   | No       |
| `allow_forwarded_src_traffic` | Controls if forwarded traffic from VMs in the remote virtual network is allowed. | bool    | false   | No       |
| `allow_gateway_src_transit`   | Controls if gateway links can be used in the remote virtual network’s link to the local virtual network. | bool    | false   | No       |
| `use_remote_src_gateway`      | Controls if remote gateways can be used on the local virtual network.       | bool    | false   | No       |
