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

locals {
  env_project_id       = data.terraform_remote_state.projects_env.outputs.peering_project
  subnetwork_self_link = data.terraform_remote_state.projects_env.outputs.peering_subnetwork_self_link
}


data "terraform_remote_state" "projects_env" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/projects/${var.business_unit}/${var.environment}"
  }
}

data "google_compute_subnetwork" "subnet" {
  self_link = local.subnetwork_self_link
}

module "gcve" {
  source = "../gcve"

  project     = local.env_project_id
  gcve_region = var.region
  gcve_zone   = var.zone

  create_vmware_engine_network      = var.vmware_configuration.create_network
  vmware_engine_network_name        = var.vmware_configuration.network_name
  vmware_engine_network_description = var.vmware_configuration.network_description
  vmware_engine_network_type        = var.vmware_configuration.network_type
  vmware_engine_network_location    = var.vmware_configuration.network_location

  pc_name            = var.vmware_configuration.private_cloud_name
  pc_cidr_range      = var.vmware_configuration.private_cloud_cidr_range
  pc_description     = var.vmware_configuration.private_cloud_description
  pc_type            = var.vmware_configuration.private_cloud_type
  cluster_id         = var.vmware_configuration.cluster_id
  cluster_node_type  = var.vmware_configuration.cluster_node_type
  cluster_node_count = var.vmware_configuration.cluster_node_count

  ## network peering
  gcve_peer_name                           = var.network_peering.gcve_peer_name
  gcve_peer_description                    = var.network_peering.gcve_peer_description
  peer_network_type                        = var.network_peering.network_type
  peer_nw_project_id                       = data.google_compute_subnetwork.subnet.project
  peer_nw_name                             = split("/", data.google_compute_subnetwork.subnet.network)[9] # get network name
  peer_nw_location                         = var.network_peering.network_location
  peer_export_custom_routes                = var.network_peering.export_custom_routes
  peer_import_custom_routes                = var.network_peering.import_custom_routes
  peer_export_custom_routes_with_public_ip = var.network_peering.export_custom_routes_with_public_ip
  peer_import_custom_routes_with_public_ip = var.network_peering.import_custom_routes_with_public_ip

  ## optional DNS peering
  dns_peering   = var.network_peering.dns_peering
  dns_zone_name = var.network_peering.dns_zone_name
  dns_name      = var.network_peering.dns_name


  ## gcve monitoring
  secret_vsphere_server   = var.gcve_monitoring.secret_vsphere_server
  secret_vsphere_user     = var.gcve_monitoring.secret_vsphere_user
  secret_vsphere_password = var.gcve_monitoring.secret_vsphere_password
  vm_mon_name             = var.gcve_monitoring.vm_mon_name
  vm_mon_type             = var.gcve_monitoring.vm_mon_type
  vm_mon_zone             = var.zone
  sa_gcve_monitoring      = var.gcve_monitoring.sa_monitoring
  vpc                     = split("/", data.google_compute_subnetwork.subnet.network)[9] # get network name
  subnetwork              = data.google_compute_subnetwork.subnet.name
  create_dashboards       = var.gcve_monitoring.create_dashboards
}
