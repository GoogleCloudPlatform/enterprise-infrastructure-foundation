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


variable "project" {
  type        = string
  description = "Project where private cloud will be deployed"
}

variable "vmware_engine_network_location" {
  type        = string
  description = "Region where private cloud will be deployed"
}

variable "gcve_region" {
  type        = string
  description = "Region where private cloud will be deployed"
}

variable "gcve_zone" {
  type        = string
  description = "Zone where private cloud will be deployed"
}

variable "vmware_engine_network_name" {
  type        = string
  description = "Name of the vmware engine network for the private cloud"
}

variable "vmware_engine_network_type" {
  type        = string
  description = "Type of the vmware engine network for the private cloud"
  default     = "LEGACY"
}

variable "vmware_engine_network_description" {
  type        = string
  description = "Description of the vmware engine network for the private cloud"
  default     = "PC Network"
}

variable "create_vmware_engine_network" {
  type        = bool
  description = "Set this value to true if you want to create a vmware engine network"
}

variable "pc_name" {
  type        = string
  description = "Name of the private cloud that will be deployed"
}

variable "pc_type" {
  type        = string
  description = "Initial type of the private cloud. Possible values are: STANDARD, TIME_LIMITED"
  default     = "STANDARD"
}

variable "pc_cidr_range" {
  type        = string
  description = "CIDR range for the management network of the private cloud that will be deployed"
}

variable "pc_description" {
  type        = string
  description = "Description for the private cloud that will be deployed"
  default     = "Private Cloud description"
}

variable "cluster_id" {
  type        = string
  description = "The cluster ID for management cluster in the private cloud"
}

variable "cluster_node_type" {
  type        = string
  description = "Specify the node type for the management cluster in the private cloud"
  default     = "standard-72"
}

variable "cluster_node_count" {
  type        = number
  description = "Specify the number of nodes for the management cluster in the private cloud"
  default     = 3
}

## Peering Section

variable "peer_network_type" {
  type        = string
  description = "The type of the network to peer with the VMware Engine network. Possible values are: STANDARD, VMWARE_ENGINE_NETWORK, PRIVATE_SERVICES_ACCESS, NETAPP_CLOUD_VOLUMES, THIRD_PARTY_SERVICE, DELL_POWERSCALE."

  validation {
    condition     = contains(["STANDARD", "VMWARE_ENGINE_NETWORK", "PRIVATE_SERVICES_ACCESS", "NETAPP_CLOUD_VOLUMES", "THIRD_PARTY_SERVICE", "DELL_POWERSCALE"], var.peer_network_type)
    error_message = "Valid values for var: peer_network_type are (STANDARD, VMWARE_ENGINE_NETWORK, PRIVATE_SERVICES_ACCESS, NETAPP_CLOUD_VOLUMES, THIRD_PARTY_SERVICE, DELL_POWERSCALE)."
  }
}

variable "peer_nw_name" {
  type        = string
  description = "The relative resource name of the network to peer with a standard VMware Engine network. The provided network can be a consumer VPC network or another standard VMware Engine network."
}

variable "peer_nw_location" {
  type        = string
  default     = "global"
  description = "The relative resource location of the network to peer with a standard VMware Engine network. The provided network can be a consumer VPC network or another standard VMware Engine network."
}

variable "peer_nw_project_id" {
  type        = string
  description = " The relative resource project of the network to peer with a standard VMware Engine network. The provided network can be a consumer VPC network or another standard VMware Engine network."
}

variable "gcve_peer_name" {
  type        = string
  description = "The ID of the Network Peering."
}

variable "gcve_peer_description" {
  type        = string
  default     = ""
  description = "User-provided description for this network peering."
}

variable "peer_export_custom_routes" {
  type        = bool
  default     = true
  description = "True if custom routes are exported to the peered network; false otherwise."
}

variable "peer_import_custom_routes" {
  type        = bool
  default     = true
  description = "True if custom routes are imported from the peered network; false otherwise."
}

variable "peer_export_custom_routes_with_public_ip" {
  type        = bool
  default     = false
  description = "True if all subnet routes with a public IP address range are exported; false otherwise"
}

variable "peer_import_custom_routes_with_public_ip" {
  type        = bool
  default     = false
  description = "True if custom routes are imported from the peered network; false otherwise."
}

## dns peering variables
variable "dns_peering" {
  type        = bool
  default     = false
  description = "True if a DNS peering zone should be created"
}

variable "dns_name" {
  type        = string
  default     = "peering.example.com."
  description = "The DNS name of this peering zone, for instance 'peering.example.com.'"
}

variable "dns_zone_name" {
  type        = string
  default     = "gcve-peering-example-com"
  description = "User assigned name for the peering zone resource. Must be unique within the project"
}

## Monitoring Section
variable "vm_mon_name" {
  description = "GCE VM name where GCVE monitoring agent will run"
  type        = string
}

variable "vm_mon_type" {
  description = "GCE VM machine type"
  type        = string
  default     = "e2-small"
}

variable "vm_mon_zone" {
  description = "GCP zone where GCE VM will be deployed"
  type        = string
}

variable "vpc" {
  description = "VPC where the VM will be deployed to"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork where the VM will be deployed to"
  type        = string
}

variable "sa_gcve_monitoring" {
  description = "Service account for GCVE monitoring agent"
  type        = string
}

variable "secret_vsphere_server" {
  type        = string
  description = "The secret name conatining the FQDN of the vSphere vCenter server"
}

variable "secret_vsphere_user" {
  type        = string
  description = "The secret name containing the user for the vCenter server. Must be an admin user"
}

variable "secret_vsphere_password" {
  type        = string
  description = "The secret name containing the password for the vCenter admin user"
}

variable "create_dashboards" {
  description = "Define if sample GCVE monitoring dashboards should be installed"
  type        = bool
  default     = true
}
