<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | The GCP region where resources will be created. A subnetwork must exists in the region. | `string` | n/a | yes |
| remote\_state\_bucket | Backend bucket to load remote state information from previous steps. | `string` | n/a | yes |
| zone | The GCP zone where resources will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gcve\_management\_cluster | Details of the management cluster of the private cloud |
| gcve\_monitoring\_service\_account | The resource object of the service account for GCVE monitoring |
| gcve\_network\_config | Details about the network configuration of the private cloud |
| gcve\_private\_cloud\_id | ID of the private cloud |
| gcve\_private\_cloud\_state | Details about the state of the private cloud |
| monitoring\_mig | The resource object of the MIG used for GCVE monitoring |
| network\_peering\_state | Details about the state of the network peering |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
