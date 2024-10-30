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

module "gcve_private_cloud" {
  source = "github.com/GoogleCloudPlatform/gcve-iac-foundations//modules/gcve-private-cloud?ref=v1.0.0"

  project                           = var.project
  gcve_zone                         = var.gcve_zone
  vmware_engine_network_name        = var.vmware_engine_network_name
  vmware_engine_network_type        = var.vmware_engine_network_type
  vmware_engine_network_description = var.vmware_engine_network_description
  vmware_engine_network_location    = var.vmware_engine_network_location
  create_vmware_engine_network      = var.create_vmware_engine_network
  pc_name                           = var.pc_name
  pc_type                           = var.pc_type
  pc_cidr_range                     = var.pc_cidr_range
  pc_description                    = var.pc_description
  cluster_id                        = var.cluster_id
  cluster_node_type                 = var.cluster_node_type
  cluster_node_count                = var.cluster_node_count
}

module "gcve_network_peering" {
  source = "github.com/GoogleCloudPlatform/gcve-iac-foundations//modules/gcve-network-peering?ref=v1.0.0"

  project_id            = var.project
  gcve_peer_name        = var.gcve_peer_name
  gcve_peer_description = var.gcve_peer_description
  peer_network_type     = var.peer_network_type

  # vmware network
  vmware_engine_network_id = module.gcve_private_cloud.network_config[0].vmware_engine_network

  # peer network configs
  peer_nw_name       = var.peer_nw_name
  peer_nw_location   = var.peer_nw_location
  peer_nw_project_id = var.peer_nw_project_id

  peer_export_custom_routes                = var.peer_export_custom_routes
  peer_import_custom_routes                = var.peer_import_custom_routes
  peer_export_custom_routes_with_public_ip = var.peer_export_custom_routes_with_public_ip
  peer_import_custom_routes_with_public_ip = var.peer_import_custom_routes_with_public_ip
}


data "google_vmwareengine_network" "gcve_network" {
  count      = var.dns_peering ? 1 : 0
  project    = var.project
  name       = var.vmware_engine_network_name
  location   = var.vmware_engine_network_location
  depends_on = [module.gcve_private_cloud]
}

resource "google_dns_managed_zone" "peering-zone" {
  count      = var.dns_peering ? 1 : 0
  project    = var.project
  name       = var.dns_zone_name
  dns_name   = var.dns_name
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = element([for x in data.google_vmwareengine_network.gcve_network[0].vpc_networks : x.network if x.type == "INTRANET"], 0)
    }
  }

  peering_config {
    target_network {
      network_url = "projects/${var.peer_nw_project_id}/global/networks/${var.peer_nw_name}"
    }
  }
}

## store vcenter login into secret manager
resource "google_secret_manager_secret" "secret_vsphere_server" {
  project   = var.project
  secret_id = "secret_vsphere_server"
  labels    = { managed-by = "terraform" }
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_vsphere_server" {
  secret      = google_secret_manager_secret.secret_vsphere_server.id
  secret_data = module.gcve_private_cloud.vcenter[0].fqdn
}

data "google_vmwareengine_vcenter_credentials" "ds" {
  parent = module.gcve_private_cloud.id
}

resource "google_secret_manager_secret" "secret_vsphere_user" {
  project   = var.project
  secret_id = "secret_vsphere_user"
  labels    = { managed-by = "terraform" }
  replication {
    auto {}
  }
}
resource "google_secret_manager_secret_version" "secret_vsphere_user" {
  secret      = google_secret_manager_secret.secret_vsphere_user.id
  secret_data = data.google_vmwareengine_vcenter_credentials.ds.username
}

resource "google_secret_manager_secret" "secret_vsphere_password" {
  project   = var.project
  secret_id = "secret_vsphere_password"
  labels    = { managed-by = "terraform" }
  replication {
    auto {}
  }
}
resource "google_secret_manager_secret_version" "secret_vsphere_password" {
  secret      = google_secret_manager_secret.secret_vsphere_password.id
  secret_data = data.google_vmwareengine_vcenter_credentials.ds.password
}

module "gcve_monitoring" {
  source = "github.com/GoogleCloudPlatform/gcve-iac-foundations//modules/gcve-monitoring?ref=v1.0.0"

  gcve_region             = var.gcve_region
  project                 = var.project
  secret_vsphere_server   = var.secret_vsphere_server
  secret_vsphere_user     = var.secret_vsphere_user
  secret_vsphere_password = var.secret_vsphere_password
  vm_mon_name             = var.vm_mon_name
  vm_mon_type             = var.vm_mon_type
  vm_mon_zone             = var.vm_mon_zone
  sa_gcve_monitoring      = var.sa_gcve_monitoring
  subnetwork              = var.subnetwork
  create_dashboards       = var.create_dashboards
}
