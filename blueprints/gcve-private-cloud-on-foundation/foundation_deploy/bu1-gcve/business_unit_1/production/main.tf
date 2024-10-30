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
  business_unit = "business_unit_1"
  environment   = "production"
}

module "peering_gcve_instance" {
  source = "../../modules/base_env"

  environment         = local.environment
  business_unit       = local.business_unit
  region              = var.region
  zone                = var.zone
  remote_state_bucket = var.remote_state_bucket

  vmware_configuration = {
    network_name        = "prod-net"
    network_description = "vmware-production-network"
    private_cloud_type  = "TIME_LIMITED"
    cluster_node_count  = 1
  }

  network_peering = {
    peer_name        = "prod-network-peering"
    peer_description = "Production network peering"
  }
}
