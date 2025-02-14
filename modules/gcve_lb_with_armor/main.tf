# Copyright 2022 Google LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# cloud armor security policy
resource "google_compute_region_security_policy" "default" {
  provider    = google-beta
  name        = var.ca_name
  description = var.ca_description
  project     = var.project_id
  type        = "CLOUD_ARMOR"
  region      = var.region
}

resource "google_compute_region_security_policy_rule" "policy_rule_one" {
  for_each        = var.ca_security_rules
  provider        = google-beta
  region          = var.region
  project         = var.project_id
  security_policy = google_compute_region_security_policy.default.name
  description     = each.value.description
  priority        = each.value.priority
  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = each.value.src_ip_ranges
    }
  }
  action  = each.value.action
  preview = each.value.preview
}

# loadbalancer neg group
resource "google_compute_network_endpoint_group" "neg" {
  for_each = var.hybrid_neg_groups
  name     = each.key
  project  = var.project_id

  network               = each.value.network
  default_port          = each.value.default_port
  zone                  = each.value.zone
  network_endpoint_type = "NON_GCP_PRIVATE_IP_PORT"
}

resource "google_compute_network_endpoints" "endpoints" {
  for_each               = var.hybrid_neg_groups
  project                = var.project_id
  network_endpoint_group = google_compute_network_endpoint_group.neg[each.key].name
  zone                   = each.value.zone

  dynamic "network_endpoints" {
    for_each = each.value.endpoints
    content {
      port       = network_endpoints.value.port
      ip_address = network_endpoints.value.ip_address
    }
  }
}

data "google_compute_network" "default" {
  provider = google-beta
  project  = var.project_id
  name     = var.network
}

resource "google_compute_address" "default" {
  provider     = google-beta
  project      = var.project_id
  name         = "${var.name}-address"
  region       = var.region
  labels       = var.labels
  network_tier = "STANDARD"
}

resource "google_compute_forwarding_rule" "http" {
  provider              = google-beta
  project               = var.project_id
  name                  = "${var.name}-http"
  port_range            = "80"
  region                = var.region
  target                = google_compute_region_target_http_proxy.default.id
  network               = data.google_compute_network.default.id
  ip_address            = google_compute_address.default.id
  ip_protocol           = "TCP"
  labels                = var.labels
  network_tier          = "STANDARD"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_region_target_http_proxy" "default" {
  provider = google-beta
  region   = var.region
  project  = var.project_id

  name    = "${var.name}-http-proxy"
  url_map = google_compute_region_url_map.default.id
}

resource "google_compute_region_url_map" "default" {
  provider = google-beta
  project  = var.project_id

  region          = var.region
  name            = "${var.name}-map"
  default_service = google_compute_region_backend_service.default.id
}

resource "google_compute_region_backend_service" "default" {
  provider              = google-beta
  load_balancing_scheme = "EXTERNAL_MANAGED"
  project               = var.project_id
  region                = var.region
  name                  = "${var.name}-backend"
  protocol              = "HTTP"
  timeout_sec           = 10
  security_policy       = google_compute_region_security_policy.default.id
  health_checks         = [google_compute_region_health_check.default.id]

  dynamic "backend" {
    for_each = var.hybrid_neg_groups
    content {
      group           = google_compute_network_endpoint_group.neg["${backend.key}"].id
      balancing_mode  = backend.value.balancing_mode
      max_rate        = backend.value.max_rate
      capacity_scaler = backend.value.capacity_scaler
    }
  }
}

resource "google_compute_region_health_check" "default" {
  provider            = google-beta
  project             = var.project_id
  region              = var.region
  name                = "${var.name}-hc"
  timeout_sec         = 1
  check_interval_sec  = 5
  healthy_threshold   = 4
  unhealthy_threshold = 5

  tcp_health_check {
    port               = "80"
    port_specification = "USE_FIXED_PORT"
  }
  depends_on = [google_compute_firewall.healthcheck-fw]
}


resource "google_compute_firewall" "healthcheck-fw" {
  provider = google-beta
  project  = var.project_id

  name          = "${var.name}-hc-fw"
  network       = data.google_compute_network.default.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  direction = "INGRESS"
}

