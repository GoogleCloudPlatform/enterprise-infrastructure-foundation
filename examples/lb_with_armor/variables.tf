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

variable "project_id" {
  description = "The project in which the resource belongs"
  type        = string
}

variable "region" {
  type = string
}
variable "labels" {
  type = map(string)
}

variable "name" {
  type = string
}

variable "network" {
  type = string
}

variable "hybrid_neg_groups" {
  description = "Name of the security policy."
  type        = any
}

variable "ca_name" {
  type = string
}

variable "ca_description" {
  type = string
}

variable "ca_security_rules" {
  description = "Map of Security rules with list of IP addresses to block or unblock"
  type = map(object({
    action          = string
    priority        = number
    description     = optional(string)
    project         = optional(string)
    region          = optional(string)
    security_policy = optional(string)
    preview         = optional(bool, false)
    redirect_type   = optional(string, null)
    redirect_target = optional(string, null)
    src_ip_ranges   = list(string)
  }))

  default = {}
}


variable "other_backends" {
  type    = any
  default = {}
}
