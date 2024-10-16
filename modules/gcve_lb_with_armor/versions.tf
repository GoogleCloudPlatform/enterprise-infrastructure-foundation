# Copyright 2024 Google LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }

  provider_meta "google" {
    module_name = "blueprints/terraform/enterprise-gcve-foundation:gcve_lb_with_armor/v1.0.0"
  }
  provider_meta "google-beta" {
    module_name = "blueprints/terraform/enterprise-gcve-foundation:gcve_lb_with_armor/v1.0.0"
  }
}
