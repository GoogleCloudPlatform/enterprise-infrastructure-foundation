# Single-region GCVE deployment with basic connectivity

## Architecture

This blueprint creates a Google Cloud VMware Engine (GCVE) environment with a single private cloud and a single cluster. The private cloud is peered with a VPC network, and a monitoring VM with a standalone agent is deployed in the VPC network. The standalone agent captures and stores VMware metrics into Cloud Monitoring, and custom dashboards are created to visualize the metrics.

The diagram below depicts the architecture:

![Diagram](./diagram.png)

### Components

* **Google Cloud project**: The project in which to create the resources.
* **VPC network**: The VPC network to which the GCVE private cloud will be peered. Make sure Cloud NAT is already configured.
* **GCVE private cloud**: The private cloud environment in GCVE.
* **GCVE cluster**: The management-cluster in the private cloud.
* **Network peering**: The peering connection between the VPC network and the GCVE private cloud.
* **Monitoring VM**: The VM in the VPC network that runs the standalone agent.
* **Standalone agent**: The gcve observability agent that collects VMware metrics and sends them to Cloud Monitoring.
* **Cloud Monitoring**: The Google Cloud service that collects, stores, and visualizes monitoring data.
* **Custom dashboards**: The dashboards that are created to visualize the VMware metrics.

## Prerequisites
### Exising resources
- GCP project
  - Enabled APIs:
    - Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`
    - Compute Engine API: `compute.googleapis.com`
    - Identity and Access Management API: `iam.googleapis.com`
    - Cloud Monitoring API: `monitoring.googleapis.com`
    - Secret Manager API: `secretmanager.googleapis.com`
    - Service Usage API: `serviceusage.googleapis.com`
    - VMware Engine API: `vmwareengine.googleapis.com`
- VPC network
  - 1 subnet in same region as intended private cloud

### Permissions
- You will need the following IAM roles on the project where you deploy this blueprint:
  - Compute Admin: `roles/compute.admin`
  - Security Admin: `roles/iam.securityAdmin`
  - Service Account Admin: `roles/iam.serviceAccountAdmin`
  - Monitoring Admin: `roles/monitoring.admin`
  - Secret Manager Admin: `roles/secretmanager.admin`
  - VMware Engine Admin: `roles/vmwareengine.vmwareengineAdmin`
- If you are peering to a VPC outside of this project, you will need the following roles on the host project of the network:
  - Compute Network Admin: `roles/compute.networkAdmin`
- If you are creating the monitoring VM in a Shared VPC subnet, ensure that the deployment project has access to the subnet:
  - Compute Network User: `roles/compute.networkUser`

## Deployment instructions

1. Clone this repository or [open it in Cloud Shell](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/enterprise-gcve-foundation&cloudshell_working_dir=blueprints%2Fsingle-vpc-lz), then proceed.

2. Create `terraform.tfvars` variable file for Terraform execution inputs.

    ```
    cp terraform.tfvars.example terraform.tfvars
    ```
3. Modify the variables in the new `terraform.tfvars` file. See the [Inputs](#inputs) section for a description of all available variables.

4. Initialize Terraform 

    ```
    terraform init
    ```

5. Apply the Terraform configuration
    ```
    terraform apply -var-file terraform.tfvars
    ```

6. Monitor the deployment progress. The deployment may take around 2 hours to complete.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The cluster ID for management cluster in the private cloud | `string` | n/a | yes |
| <a name="input_cluster_node_count"></a> [cluster\_node\_count](#input\_cluster\_node\_count) | Specify the number of nodes for the management cluster in the private cloud | `number` | `3` | no |
| <a name="input_cluster_node_type"></a> [cluster\_node\_type](#input\_cluster\_node\_type) | Specify the node type for the management cluster in the private cloud | `string` | `"standard-72"` | no |
| <a name="input_create_dashboards"></a> [create\_dashboards](#input\_create\_dashboards) | Define if sample GCVE monitoring dashboards should be installed | `bool` | `true` | no |
| <a name="input_create_vmware_engine_network"></a> [create\_vmware\_engine\_network](#input\_create\_vmware\_engine\_network) | Set this value to true if you want to create a vmware engine network, | `bool` | n/a | yes |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | n/a | `string` | n/a | yes |
| <a name="input_dns_peering"></a> [dns\_peering](#input\_dns\_peering) | # dns peering variables | `bool` | n/a | yes |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | n/a | `string` | n/a | yes |
| <a name="input_gcve_peer_description"></a> [gcve\_peer\_description](#input\_gcve\_peer\_description) | User-provided description for this network peering. | `string` | `""` | no |
| <a name="input_gcve_peer_name"></a> [gcve\_peer\_name](#input\_gcve\_peer\_name) | The ID of the Network Peering. | `string` | n/a | yes |
| <a name="input_gcve_zone"></a> [gcve\_zone](#input\_gcve\_zone) | Zone where private cloud will be deployed | `string` | n/a | yes |
| <a name="input_pc_cidr_range"></a> [pc\_cidr\_range](#input\_pc\_cidr\_range) | CIDR range for the management network of the private cloud that will be deployed | `string` | n/a | yes |
| <a name="input_pc_description"></a> [pc\_description](#input\_pc\_description) | Description for the private cloud that will be deployed | `string` | `"Private Cloud description"` | no |
| <a name="input_pc_name"></a> [pc\_name](#input\_pc\_name) | Name of the private cloud that will be deployed | `string` | n/a | yes |
| <a name="input_peer_export_custom_routes"></a> [peer\_export\_custom\_routes](#input\_peer\_export\_custom\_routes) | True if custom routes are exported to the peered network; false otherwise. | `bool` | `true` | no |
| <a name="input_peer_export_custom_routes_with_public_ip"></a> [peer\_export\_custom\_routes\_with\_public\_ip](#input\_peer\_export\_custom\_routes\_with\_public\_ip) | True if all subnet routes with a public IP address range are exported; false otherwise | `bool` | `false` | no |
| <a name="input_peer_import_custom_routes"></a> [peer\_import\_custom\_routes](#input\_peer\_import\_custom\_routes) | True if custom routes are imported from the peered network; false otherwise. | `bool` | `true` | no |
| <a name="input_peer_import_custom_routes_with_public_ip"></a> [peer\_import\_custom\_routes\_with\_public\_ip](#input\_peer\_import\_custom\_routes\_with\_public\_ip) | True if custom routes are imported from the peered network; false otherwise. | `bool` | `false` | no |
| <a name="input_peer_network_type"></a> [peer\_network\_type](#input\_peer\_network\_type) | The type of the network to peer with the VMware Engine network. Possible values are: STANDARD, VMWARE\_ENGINE\_NETWORK, PRIVATE\_SERVICES\_ACCESS, NETAPP\_CLOUD\_VOLUMES, THIRD\_PARTY\_SERVICE, DELL\_POWERSCALE. | `string` | n/a | yes |
| <a name="input_peer_nw_location"></a> [peer\_nw\_location](#input\_peer\_nw\_location) | The relative resource location of the network to peer with a standard VMware Engine network. The provided network can be a consumer VPC network or another standard VMware Engine network. | `string` | `"global"` | no |
| <a name="input_peer_nw_name"></a> [peer\_nw\_name](#input\_peer\_nw\_name) | The relative resource name of the network to peer with a standard VMware Engine network. The provided network can be a consumer VPC network or another standard VMware Engine network. | `string` | n/a | yes |
| <a name="input_peer_nw_project_id"></a> [peer\_nw\_project\_id](#input\_peer\_nw\_project\_id) | The relative resource project of the network to peer with a standard VMware Engine network. The provided network can be a consumer VPC network or another standard VMware Engine network. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project where private cloud will be deployed | `string` | n/a | yes |
| <a name="input_sa_gcve_monitoring"></a> [sa\_gcve\_monitoring](#input\_sa\_gcve\_monitoring) | Service account for GCVE monitoring agent | `string` | n/a | yes |
| <a name="input_secret_vsphere_password"></a> [secret\_vsphere\_password](#input\_secret\_vsphere\_password) | The secret name containing the password for the vCenter admin user | `string` | n/a | yes |
| <a name="input_secret_vsphere_server"></a> [secret\_vsphere\_server](#input\_secret\_vsphere\_server) | The secret name conatining the FQDN of the vSphere vCenter server | `string` | n/a | yes |
| <a name="input_secret_vsphere_user"></a> [secret\_vsphere\_user](#input\_secret\_vsphere\_user) | The secret name containing the user for the vCenter server. Must be an admin user | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Subnetwork where the VM will be deployed to | `string` | n/a | yes |
| <a name="input_vm_mon_name"></a> [vm\_mon\_name](#input\_vm\_mon\_name) | GCE VM name where GCVE monitoring agent will run | `string` | n/a | yes |
| <a name="input_vm_mon_type"></a> [vm\_mon\_type](#input\_vm\_mon\_type) | GCE VM machine type | `string` | `"e2-small"` | no |
| <a name="input_vm_mon_zone"></a> [vm\_mon\_zone](#input\_vm\_mon\_zone) | GCP zone where GCE VM will be deployed | `string` | n/a | yes |
| <a name="input_vmware_engine_network_description"></a> [vmware\_engine\_network\_description](#input\_vmware\_engine\_network\_description) | Description of the vmware engine network for the private cloud | `string` | `"PC Network"` | no |
| <a name="input_vmware_engine_network_location"></a> [vmware\_engine\_network\_location](#input\_vmware\_engine\_network\_location) | Region where private cloud will be deployed | `string` | n/a | yes |
| <a name="input_vmware_engine_network_name"></a> [vmware\_engine\_network\_name](#input\_vmware\_engine\_network\_name) | Name of the vmware engine network for the private cloud | `string` | n/a | yes |
| <a name="input_vmware_engine_network_type"></a> [vmware\_engine\_network\_type](#input\_vmware\_engine\_network\_type) | Type of the vmware engine network for the private cloud | `string` | `"LEGACY"` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC where the VM will be deployed to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the private cloud |
| <a name="output_management_cluster"></a> [management\_cluster](#output\_management\_cluster) | Details of the management cluster of the private cloud |
| <a name="output_monitoring_gcp_mig"></a> [monitoring\_gcp\_mig](#output\_monitoring\_gcp\_mig) | The resource object of the MIG used for GCVE monitoring |
| <a name="output_monitoring_gcp_service_account"></a> [monitoring\_gcp\_service\_account](#output\_monitoring\_gcp\_service\_account) | The resource object of the service account for GCVE monitoring |
| <a name="output_network_config"></a> [network\_config](#output\_network\_config) | Details about the network configuration of the private cloud |
| <a name="output_peering_state"></a> [peering\_state](#output\_peering\_state) | n/a |
| <a name="output_state"></a> [state](#output\_state) | Details about the state of the private cloud |

## Usage

```hcl
module "gcve_private_cloud" {
    source = "github.com/GoogleCloudPlatform/enterprise-gcve-foundation//blueprints/single-vpc-lz"

    ## gcve private cloud
    project   = "my-project-id"
    gcve_zone = "asia-southeast1-a"

    create_vmware_engine_network      = true
    vmware_engine_network_name        = "prod-net"
    vmware_engine_network_description = "my-prod-description"
    vmware_engine_network_type        = "STANDARD"
    vmware_engine_network_location    = "global"

    pc_name            = "my-private-cloud"
    pc_cidr_range      = "10.0.0.0/22"
    pc_description     = "my-pc-description"
    cluster_id         = "management-cluster"
    cluster_node_type  = "standard-72"
    cluster_node_count = 3

    ## network peering
    gcve_peer_name                           = "prod-network-peering"
    gcve_peer_description                    = "Prod network peering description"
    peer_network_type                        = "STANDARD"
    peer_nw_name                             = "demo-network"
    peer_nw_location                         = "global"
    peer_nw_project_id                       = "my-peer-nw-project-id"
    peer_export_custom_routes                = true
    peer_import_custom_routes                = true
    peer_export_custom_routes_with_public_ip = false
    peer_import_custom_routes_with_public_ip = false

    ## optional DNS peering
    dns_peering   = false
    dns_zone_name = "gcve-peering-example-com"
    dns_name      = "peering.example.com."

    ## gcve monitoring
    secret_vsphere_server   = "secret_vsphere_server"
    secret_vsphere_user     = "secret_vsphere_user"
    secret_vsphere_password = "secret_vsphere_password"
    vm_mon_name             = "gcve-monitoring-vm"
    vm_mon_type             = "e2-small"
    vm_mon_zone             = "us-central1-a"
    sa_gcve_monitoring      = "sa-gcve-monitoring"
    vpc                     = "demo-network"
    subnetwork              = "subnet-01"
    create_dashboards       = true
}
```
