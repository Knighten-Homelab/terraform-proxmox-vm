# ProxMox VM Single Node (PowerDNS Record + AWX Registration)

[![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/Johnny-Knighten/terraform-homelab-pve-vm/lint-and-test.yml?logo=github&label=lint%20and%20test%20-%20status)
](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/actions/workflows/lint-and-test.yml)

This Terraform module will create a single VM on a ProxMox cluster. It will also create a DNS A record on a local PowerDNS server and also register the host on AWX.

The module assumes that you have a service account called `ansible` baked into your PVE template which has an assigned SSH key. The `ansible` service account is used by PVE to finalize VM setup and by AWX to connect to the host and run playbooks. In the future this may change to be less opinionated.

Typically I create a PVE template using Packer that setups the `ansible` service account and also installs the SSH key.

## Required Providers

The table below lists the providers required by this module.

| Name | Source| Version |
|------|-----|----|
| proxmox | telmate/proxmox | = 2.9.14 |
| powerdns | pan-net/powerdns |= 1.5.0 |
| awx | denouche/awx |= 0.19.0 |

*See the provider block in [main.tf](main.tf) for more up to date details.*

## Variables
### Auth Variables

These variables are all required and are used to authenticate to the various services.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| pve_username | username for the ProxMox API | `string` | n/a | yes |
| pve_password | password for the ProxMox API | `string` | n/a | yes |
| ansible_service_account_ssh_key | SSH key for the ansible service account | `string` | n/a | yes |
| awx_account_username | username used to interact with the AWX API | `string` | n/a | yes |
| awx_account_password | password used to interact with the AWX API | `string` | n/a | yes |
| pdns_api_key | API key for the PowerDNS API | `string` | n/a | yes |

### All Other Variables

#### PVE Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| pve_cluster_url | URL for the ProxMox cluster | `string` | n/a | yes |
| pve_node | name of the ProxMox node to create the VM on | `string` | n/a | yes |
| pve_vm_name | name of the VM to create | `string` | n/a | yes |
| pve_template | name of the PVE template to clone | `string` | n/a | yes |
| pve_vm_desc | description of the VM | `string` | `""` | no |
| pve_vm_full_clone | whether or not to do a full clone | `string` | `"true"` | no |
| pve_vm_boot_on_start | whether or not to boot the VM on start | `bool` | `false` | no |
| pve_vm_startup_options | startup options separated via comma - boot order (order=), startup delay(up=), and shutdown delay(down=)| `string` | `"order=any"` | no |
| pve_vm_use_static_ip | whether or not to use a static IP or DHCP | `bool` | `false` | no |
| pve_vm_ip | IP address to use for the VM, must be set if using static IP | `string` | `""` | no |
| pve_vm_subnet_network_bits | number of subnet network bits to use for the VM, must be set if using static IP | `string` | `""` | no |
| pve_vm_gateway | gateway to use for the VM, must be set if using static IP | `string` | `""` | no |
| pve_vm_dns_servers | DNS servers to use for the VM, space separated, must be set if using static IP | `string` | `""` | no |
| pve_vm_vlan_tag | VLAN tag to use for the VM | `string` | `"-1"` | no |
| pve_vm_packet_queue_count | number of VM packet queues | `string` | `"1"` | no |
| pve_vm_core_count | number of cores to allocate to the VM | `string` | `"2"` | no |
| pve_vm_memory | amount of memory to allocate to the VM in MB | `string` | `"2048"` | no |
| pve_vm_disk_size | size of the VM disk | `string` | `"20G"` | no |
| pve_vm_disk_storage_location | storage location for the VM disk | `string` | `"local-zfs"` | no |

#### AWX Variables

You do not need to supply the numeric IDs for the organization, inventory, and inventory groups, the module will look them up based on the name.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| awx_url | URL for the AWX API | `string` | n/a | yes |
| awx_organization | name of the AWX organization to create the host in | `string` | n/a | yes |
| awx_inventory | name of the AWX inventory to create the host in | `string` | n/a | yes |
| awx_host_groups | comma separated list of AWX host groups to add the host to | `list(string)` | `""` | no |
| awx_host_name | name of the AWX host to create | `string` | n/a | yes |
| awx_host_description | description of the AWX host to create | `string` | `""` | no |


#### PowerDNS Variables

Currently only a single A record will be created.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| pdns_url | URL for the PowerDNS API | `string` | n/a | yes |
| pdns_zone | name of the PowerDNS zone to create the record in | `string` | n/a | yes |
| pdns_record_name | name of the PowerDNS record to create | `string` | n/a | yes |

## Possible Enhancements

* PVE
    * Add support to use a different service account other than `ansible` 
    * Allow multiple ipconfig# options to be passed in
    * Allow multiple DNS records to be created
    * Allow network model to be passed in
    * Allow multiple disks to be created
    * Allow CPU type to be passed in
* AWX
    * Use a different authentication method for AWX other than username/password
    * Change hardcoded variables section to something more dynamic
* PowerDNS
    * Allow multiple records to be created
    * Allow different record types to be created
