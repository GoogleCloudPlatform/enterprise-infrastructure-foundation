## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_address.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_address) | resource |
| [google-beta_google_compute_firewall.healthcheck-fw](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_firewall) | resource |
| [google-beta_google_compute_forwarding_rule.http](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_forwarding_rule) | resource |
| [google-beta_google_compute_region_backend_service.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_backend_service) | resource |
| [google-beta_google_compute_region_health_check.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_health_check) | resource |
| [google-beta_google_compute_region_security_policy.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_security_policy) | resource |
| [google-beta_google_compute_region_security_policy_rule.policy_rule_one](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_security_policy_rule) | resource |
| [google-beta_google_compute_region_target_http_proxy.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_target_http_proxy) | resource |
| [google-beta_google_compute_region_url_map.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_region_url_map) | resource |
| [google_compute_network_endpoint_group.neg](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_endpoint_group) | resource |
| [google_compute_network_endpoints.endpoints](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_endpoints) | resource |
| [google-beta_google_compute_network.default](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/data-sources/google_compute_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ca_description"></a> [ca\_description](#input\_ca\_description) | Description of Security policy | `string` | n/a | yes |
| <a name="input_ca_name"></a> [ca\_name](#input\_ca\_name) | Name of the security policy. | `string` | n/a | yes |
| <a name="input_ca_security_rules"></a> [ca\_security\_rules](#input\_ca\_security\_rules) | Map of Security rules with list of IP addresses to block or unblock | <pre>map(object({<br>    action          = string<br>    priority        = number<br>    description     = optional(string)<br>    project         = optional(string)<br>    region          = optional(string)<br>    security_policy = optional(string)<br>    preview         = optional(bool, false)<br>    redirect_type   = optional(string, null)<br>    redirect_target = optional(string, null)<br>    src_ip_ranges   = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_hybrid_neg_groups"></a> [hybrid\_neg\_groups](#input\_hybrid\_neg\_groups) | Map of Hybrid NEG Groups with endpoints and configurations. | `any` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Provide map of labels | `map(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Prefix Name of the LB and its components | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | Name of existing Network | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Provide GCP Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Provide GCP region | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_policy"></a> [ca\_policy](#output\_ca\_policy) | Output of regional security policy |
| <a name="output_ca_policy_rules"></a> [ca\_policy\_rules](#output\_ca\_policy\_rules) | Output list of regional security policy rules |