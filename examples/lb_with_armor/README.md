<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ca\_description | n/a | `string` | n/a | yes |
| ca\_name | n/a | `string` | n/a | yes |
| ca\_security\_rules | Map of Security rules with list of IP addresses to block or unblock | <pre>map(object({<br>    action          = string<br>    priority        = number<br>    description     = optional(string)<br>    project         = optional(string)<br>    region          = optional(string)<br>    security_policy = optional(string)<br>    preview         = optional(bool, false)<br>    redirect_type   = optional(string, null)<br>    redirect_target = optional(string, null)<br>    src_ip_ranges   = list(string)<br>  }))</pre> | `{}` | no |
| hybrid\_neg\_groups | Name of the security policy. | `any` | n/a | yes |
| labels | n/a | `map(string)` | n/a | yes |
| name | n/a | `string` | n/a | yes |
| network | n/a | `string` | n/a | yes |
| other\_backends | n/a | `any` | `{}` | no |
| project\_id | The project in which the resource belongs | `string` | n/a | yes |
| region | n/a | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->