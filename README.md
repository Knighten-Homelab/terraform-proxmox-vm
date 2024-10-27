# Homelab Proxmox VM Terraform Module

Terraform module which creates a ProxMox VM, registers it to AWX, and creates a PowerDNS A record.

This module is designed to be used with the technology stack I utilize in my homelab. It assumes you are using the following technologies:

- [Proxmox](https://www.proxmox.com/en/)
  - Hypervisor
- [AWX](https://github.com/ansible/awx)
  - Ansible Automation Platform
  - Upstream project for Ansible Tower
- [PowerDNS](https://www.powerdns.com/)
  - DNS Server

The main goal of this module was to streamline my VM creation process by: providing sane default values, automating integration with my primary automation platform, and aiding service discovery via DNS. This module is not designed to be used by others as it is highly opinionated and tailored to my specific use case; however, it may be useful as a reference for others.

## Opinionated Decisions

Here are some of the opinionated decisions made in this module (this is not an exhaustive list):

- Technology Stack: Proxmox, AWX, and PowerDNS
- VM Configuration:
  - Limited Number of CPU Options
  - Cloud-Init Use
    - Only Cloud-Init for VM Provisioning
    - Only Allows One ipconfig to be configured
    - Always Upgrades on First Boot
    - Only Uses SSH For Provisioning (No Passwords)
    - Provisioner User Name Matches SSH Name
  - Disks
    - Only One Storage Disk That is Virtio-SCSI Mapped to scsi0
    - ide0 is the CD-ROM Used When Using an ISO
    - ide1 is the Cloud-Init Disk
- DNS
  - Only Creates Single A Record
  - TTL = 60 and Not Configurable
- AWX
  - All Organizations, Inventories, and Inventory Groups Must Already Exist
  - Only adds ansible_host and hostname To Host Variables

## Requirements

### Terraform

This module requires Terraform 1.9.8 or later. It may be compatible with earlier versions but only has been tested with 1.9.8.

### Providers

The table below lists the providers required by this module.

| Name     | Source           | Version     |
| -------- | ---------------- | ----------- |
| proxmox  | telmate/proxmox  | = 3.0.1-rc4 |
| powerdns | pan-net/powerdns | = 1.5.0     |
| awx      | denouche/awx     | = 0.19.0    |

You most configure the above providers (URLs, credentials, ...) in your terraform configuration.

_See the [versions.tf](versions.tf) for more up to date details._

## Variables

### PVE Variables

#### Proxmox and Metadata Variables

| Name       | Description                                  | Type     | Default | Required |
| ---------- | -------------------------------------------- | -------- | ------- | :------: |
| `pve_node` | name of the ProxMox node to create the VM on | `string` | n/a     |   yes    |
| `pve_name` | name of the VM to create                     | `string` | n/a     |   yes    |
| `pve_id`   | id of the VM                                 | `number` | `0`     |    no    |
| `pve_desc` | description of the VM                        | `string` | `""`    |    no    |

#### Cloning and Template Variables

| Name             | Description                                                   | Type     | Default                                     | Required |
| ---------------- | ------------------------------------------------------------- | -------- | ------------------------------------------- | :------: |
| `pve_is_clone`   | Flag to determine if the VM is a clone or not (based off iso) | `bool`   | `true`                                      |    no    |
| `pve_template`   | name of the PVE template to clone                             | `string` | `ubuntu-server-22-04-base-template-homelab` |    no    |
| `pve_full_clone` | whether or not to do a full clone of the template             | `bool`   | `true`                                      |    no    |
| `pve_iso`        | iso to use for the VM                                         | `string` | `""`                                        |    no    |

#### Boot Options

| Name                  | Description                                                                                             | Type     | Default | Required |
| --------------------- | ------------------------------------------------------------------------------------------------------- | -------- | ------- | :------: |
| `pve_boot_on_start`   | whether or not to boot the VM on start                                                                  | `bool`   | `false` |    no    |
| `pve_startup_options` | startup options separated via comma: boot order (order=), startup delay(up=), and shutdown delay(down=) | `string` | `""`    |    no    |
| `pve_boot_disk`       | boot disk for the VM                                                                                    | `string` | `null`  |    no    |

#### CPU Options

| Name             | Description                             | Type     | Default | Required |
| ---------------- | --------------------------------------- | -------- | ------- | :------: |
| `pve_core_count` | number of cores to allocate to the VM   | `string` | `2`     |    no    |
| `pve_cpu_type`   | type of CPU to use for the VM           | `string` | `host`  |    no    |
| `pve_sockets`    | number of sockets to allocate to the VM | `string` | `1`     |    no    |

#### Memory Options

| `pve_memory_size` | amount of memory to allocate to the VM in MB | `number` | `2048` | no |
| `pve_memory_balloon` | whether or not to use memory ballooning | `number` | `0` | no |

#### Network Options

| Name           | Description                               | Type           | Default   | Required |
| -------------- | ----------------------------------------- | -------------- | --------- | :------: |
| `pve_networks` | List of network configurations for the VM | `list(object)` | see below |    no    |

For the pve_networks variable, the default value is a list of objects, which is not easily representable in a single cell. Here is the default value for pve_networks:

```hcl
default = [
  {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = "-1"
    queues = "1"
  }
]
```

#### Cloud-Init Options

| Name                         | Description                                                                     | Type     | Default     | Required |
| ---------------------------- | ------------------------------------------------------------------------------- | -------- | ----------- | :------: |
| `pve_use_ci`                 | whether or not to use the cloud_init                                            | `bool`   | `true`      |    no    |
| `pve_ci_ssh_user`            | ssh user used to provision the VM                                               | `string` | `ansible`   |    no    |
| `pve_ci_ssh_private_key`     | ssh private key used to provision the VM                                        | `string` | `""`        |    no    |
| `pve_ci_use_dhcp`            | whether or not to use a static IP or DHCP                                       | `bool`   | `false`     |    no    |
| `pve_ci_ip_address`          | IP address to use for the VM, must be set if using static IP                    | `string` | `""`        |    no    |
| `pve_ci_subnet_network_bits` | number of subnet network bits to use for the VM, must be set if using static IP | `string` | `""`        |    no    |
| `pve_ci_gateway_address`     | gateway to use for the VM, must be set if using static IP                       | `string` | `""`        |    no    |
| `pve_ci_dns_servers`         | ip of vm's dns server                                                           | `string` | `""`        |    no    |
| `pve_ci_storage_location`    | storage location for the cloud-init iso                                         | `string` | `local-zfs` |    no    |

#### Disk Options

| Name                        | Description                      | Type     | Default           | Required |
| --------------------------- | -------------------------------- | -------- | ----------------- | :------: |
| `pve_disk_size`             | size of the VM disk              | `string` | `40G`             |    no    |
| `pve_disk_storage_location` | storage location for the VM disk | `string` | `local-zfs`       |    no    |
| `pve_scsihw`                | scsi hardware to use for the VM  | `string` | `virtio-scsi-pci` |    no    |

### AWX Variables

You do not need to supply the numeric IDs for the organization, inventory, and inventory groups, the module will look them up based on the name.

| Name                   | Description                                                | Type           | Default | Required |
| ---------------------- | ---------------------------------------------------------- | -------------- | ------- | :------: |
| `awx_organization`     | name of the AWX organization to create the host in         | `string`       | n/a     |   yes    |
| `awx_inventory`        | name of the AWX inventory to create the host in            | `string`       | n/a     |   yes    |
| `awx_host_groups`      | comma separated list of AWX host groups to add the host to | `list(string)` | n/a     |   yes    |
| `awx_host_name`        | name of the AWX host to create                             | `string`       | n/a     |   yes    |
| `awx_host_description` | description of the AWX host to create                      | `string`       | n/a     |   yes    |

### PowerDNS Variables

Currently only a single A record will be created.

| Name               | Description                                       | Type     | Default | Required |
| ------------------ | ------------------------------------------------- | -------- | ------- | :------: |
| `pdns_zone`        | name of the PowerDNS zone to create the record in | `string` | n/a     |   yes    |
| `pdns_record_name` | name of the PowerDNS record to create             | `string` | n/a     |   yes    |

## Outputs

| Name             | Description                                | Type           | Sensitive |
| ---------------- | ------------------------------------------ | -------------- | --------- |
| `vm_id`          | The ID of the Proxmox VM                   | `number`       | no        |
| `vm_name`        | The name of the Proxmox VM                 | `string`       | no        |
| `vm_ip_address`  | The default IPv4 address of the Proxmox VM | `string`       | no        |
| `vm_dns_records` | The DNS records created in PowerDNS        | `list(string)` | no        |

## Usage

### Using An ISO

```hcl
module "test-vm" {
  source = "github.com/Johnny-Knighten/terraform-homelab-pve-vm"

  pve_node = "node-alpha"
  pve_name = "test-vm"
  pve_id   = 400

  pve_is_clone = false
  pve_iso      = "local:iso/ubuntu-server-22-04.iso"

  pve_networks = [
    {
      model  = "virtio"
      bridge = "vmbr0"
      tag    = 6
      queues = 0
    }
  ]

  pve_memory_size    = 7630
  pve_memory_balloon = 7630

  pve_disk_size = "40G"

  pdns_zone        = "homelab.lan"
  pdns_record_name = "test-vm"

  awx_organization     = "Homelab"
  awx_inventory        = "Homelab Endpoints"
  awx_host_groups      = ["proxmox-hosts"]
  awx_host_name        = "test-vm"
  awx_host_description = "A test VM created by Terraform"
}
```

### Using A Template (With Cloud-Init)

```hcl
module "cloned-vm" {
  source = "github.com/Johnny-Knighten/terraform-homelab-pve-vm"

  pve_node = "node-alpha"
  pve_name = "cloned-vm"
  pve_id   = 401

  pve_is_clone   = true
  pve_full_clone = true
  pve_template   = "ubuntu-server-22-04-base-template-homelab"

  pve_use_ci                 = true
  pve_ci_use_dhcp            = true
  pve_ci_ip_address          = "192.168.25.100"
  pve_ci_subnet_network_bits = 24
  pve_ci_gateway_address     = "192.168.25.1"
  pve_ci_dns_servers         = "192.168.25.2 192.168.25.3 192.168.25.1"

  pve_networks = [
    {
      model  = "virtio"
      bridge = "vmbr0"
      tag    = 6
      queues = 0
    }
  ]

  pve_memory_size    = 7630
  pve_memory_balloon = 7630

  pve_disk_size = "40G"

  pdns_zone        = "homelab.lan"
  pdns_record_name = "cloned-vm"

  awx_organization     = "Homelab"
  awx_inventory        = "Homelab Endpoints"
  awx_host_groups      = ["proxmox-hosts"]
  awx_host_name        = "cloned-vm"
  awx_host_description = "A cloned VM created by Terraform"
}
```
