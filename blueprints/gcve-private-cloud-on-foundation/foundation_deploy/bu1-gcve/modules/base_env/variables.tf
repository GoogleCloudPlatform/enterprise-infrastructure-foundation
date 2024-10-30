/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "environment" {
  description = "The environment the single project belongs to"
  type        = string
}

variable "business_unit" {
  description = "The business (ex. business_unit_1)."
  type        = string
  default     = "business_unit_1"
}

variable "remote_state_bucket" {
  description = "Backend bucket to load remote state information from previous steps."
  type        = string
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
}

variable "zone" {
  description = "The GCP zone to create and test resources in"
  type        = string
}

variable "vmware_configuration" {
  description = <<EOT
  - private_cloud_name: Name of the private cloud that will be deployed.
  - private_cloud_cidr_range: CIDR range for the management network of the private cloud that will be deployed.
  - private_cloud_description: Description for the private cloud that will be deployed.
  - private_cloud_type: Initial type of the private cloud. Possible values are: `STANDARD`, `TIME_LIMITED`.
  - cluster_id: The cluster ID for management cluster in the private cloud.
  - cluster_node_type: Specify the node type for the management cluster in the private cloud.
  - cluster_node_count: Specify the number of nodes for the management cluster in the private cloud. For a `TIME_LIMITED` private cloud the cluster node count should be set to `1`.
  - create_network: Set this value to true if you want to create a vmware engine network.
  - network_name: Name of the vmware engine network for the private cloud.
  - network_description: Description of the vmware engine network for the private cloud.
  - network_type: Type of the vmware engine network for the private cloud. Possible values are: `LEGACY`, `STANDARD`.
  - network_location: Region where private cloud will be deployed.
  EOT
  type = object({
    private_cloud_name        = optional(string, "my-private-cloud")
    private_cloud_description = optional(string, "my-private-cloud-description")
    private_cloud_cidr_range  = optional(string, "10.240.0.0/22")
    private_cloud_type        = optional(string, "TIME_LIMITED")
    cluster_id                = optional(string, "management-cluster")
    cluster_node_type         = optional(string, "standard-72")
    cluster_node_count        = optional(number, 1)
    create_network            = optional(bool, true)
    network_name              = optional(string, "prod-net")
    network_description       = optional(string, "vmware-production-network")
    network_type              = optional(string, "STANDARD")
    network_location          = optional(string, "global")


  })
  default = {}
}

variable "network_peering" {
  description = <<EOT
  - gcve_peer_name: The ID of the Network Peering.
  - gcve_peer_description: User-provided description for this network peering.
  - network_type: The type of the network to peer with the VMware Engine network. Possible values are: `STANDARD`, `VMWARE_ENGINE_NETWORK`, `PRIVATE_SERVICES_ACCESS`, `NETAPP_CLOUD_VOLUMES`, `THIRD_PARTY_SERVICE`, `DELL_POWERSCALE`.
  - network_location: The relative resource location of the network to peer with a standard VMware Engine network. The provided network can be a consumer VPC network or another standard VMware Engine network.
  - export_custom_routes: True if custom routes are exported to the peered network; false otherwise.
  - import_custom_routes: True if custom routes are imported from the peered network; false otherwise.
  - export_custom_routes_with_public_ip: True if all subnet routes with a public IP address range are exported; false otherwise.
  - import_custom_routes_with_public_ip: True if custom routes are imported from the peered network; false otherwise.
  - dns_peering: True if a DNS peering zone should be created.
  - dns_zone_name: User assigned name for the peering zone resource. Must be unique within the project.
  - dns_name: The DNS name of this peering zone, for instance "peering.example.com.".
  EOT
  type = object({
    gcve_peer_name                      = optional(string, "prod-network-peering")
    gcve_peer_description               = optional(string, "Production network peering")
    network_type                        = optional(string, "STANDARD")
    network_location                    = optional(string, "global")
    export_custom_routes                = optional(bool, true)
    import_custom_routes                = optional(bool, true)
    export_custom_routes_with_public_ip = optional(bool, false)
    import_custom_routes_with_public_ip = optional(bool, false)
    dns_peering                         = optional(bool, false)
    dns_zone_name                       = optional(string, "gcve-peering-example-com")
    dns_name                            = optional(string, "peering.example.com.")
  })
  default = {}
}

variable "gcve_monitoring" {
  description = <<EOT
  - secret_vsphere_server: The secret name conatining the FQDN of the vSphere vCenter server
  - secret_vsphere_user: The secret name containing the user for the vCenter server. Must be an admin user.
  - secret_vsphere_password: The secret name containing the password for the vCenter admin user
  - vm_mon_name: GCE VM name where GCVE monitoring agent will run.
  - vm_mon_type: GCE VM machine type.
  - sa_monitoring: Service account for GCVE monitoring agent.
  - create_dashboards: Define if sample GCVE monitoring dashboards should be installed.
  EOT
  type = object({
    secret_vsphere_server   = optional(string, "secret_vsphere_server")
    secret_vsphere_user     = optional(string, "secret_vsphere_user")
    secret_vsphere_password = optional(string, "secret_vsphere_password")
    vm_mon_name             = optional(string, "gcve-monitoring-vm")
    vm_mon_type             = optional(string, "e2-small")
    sa_monitoring           = optional(string, "sa-gcve-monitoring")
    create_dashboards       = optional(bool, true)
  })
  default = {}
}
