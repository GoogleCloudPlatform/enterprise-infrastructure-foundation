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

output "gcve_private_cloud_id" {
  description = "ID of the private cloud"
  value       = module.peering_gcve_instance.gcve_private_cloud_id
}

output "gcve_management_cluster" {
  description = "Details of the management cluster of the private cloud"
  value       = module.peering_gcve_instance.gcve_management_cluster
}

output "gcve_network_config" {
  description = "Details about the network configuration of the private cloud"
  value       = module.peering_gcve_instance.gcve_network_config
}

output "gcve_private_cloud_state" {
  description = "Details about the state of the private cloud"
  value       = module.peering_gcve_instance.gcve_private_cloud_state
}

output "network_peering_state" {
  description = "Details about the state of the network peering"
  value       = module.peering_gcve_instance.network_peering_state
}

output "gcve_monitoring_service_account" {
  description = "The resource object of the service account for GCVE monitoring"
  value       = module.peering_gcve_instance.gcve_monitoring_service_account
}

output "monitoring_mig" {
  description = "The resource object of the MIG used for GCVE monitoring"
  value       = module.peering_gcve_instance.monitoring_mig
  sensitive   = true
}
