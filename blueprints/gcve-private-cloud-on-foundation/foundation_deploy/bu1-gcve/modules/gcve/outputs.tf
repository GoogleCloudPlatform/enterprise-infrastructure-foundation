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

output "id" {
  description = "ID of the private cloud"
  value       = module.gcve_private_cloud.id
}

output "management_cluster" {
  description = "Details of the management cluster of the private cloud"
  value       = module.gcve_private_cloud.management_cluster
}

output "network_config" {
  description = "Details about the network configuration of the private cloud"
  value       = module.gcve_private_cloud.network_config
}

output "state" {
  description = "Details about the state of the private cloud"
  value       = module.gcve_private_cloud.state
}

output "peering_state" {
  description = "Details about the state of the network peering"
  value = module.gcve_network_peering.state
}

output "monitoring_gcp_service_account" {
  value       = module.gcve_monitoring.google_service_account
  description = "The resource object of the service account for GCVE monitoring"
}

output "monitoring_gcp_mig" {
  value       = module.gcve_monitoring.mig_monitoring_gcve
  description = "The resource object of the MIG used for GCVE monitoring"
  sensitive   = true
}
