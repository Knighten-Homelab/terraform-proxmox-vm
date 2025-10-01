# Homelab Proxmox VM Terraform Module

Terraform module which creates a ProxMox VM and a DNS A record.

This module is designed to be used with the technology stack I utilize in my homelab. It assumes you are using the following technologies:

- [Proxmox](https://www.proxmox.com/en/)
  - Hypervisor
- DNS Server supporting RFC 2136 Dynamic Updates
  - Examples: BIND, PowerDNS, Windows DNS, etc.

The main goal of this module was to streamline my VM creation process by: providing sane default values and aiding service discovery via DNS. This module is not designed to be used by others as it is highly opinionated and tailored to my specific use case; however, it may be useful as a reference for others.

## Opinionated Decisions

Here are some of the opinionated decisions made in this module (this is not an exhaustive list):

- Technology Stack: Proxmox and DNS Server with RFC 2136 support
- VM Configuration:
  - Limited Number of CPU Options
  - Cloud-Init Use
    - Only Cloud-Init for VM Provisioning
    - Only Allows One ipconfig to be configured
    - Always Upgrades on First Boot
    - Only can add a single serial device
  - Disks
    - Only One Storage Disk That is Virtio-SCSI Mapped to scsi0
    - ide0 is the CD-ROM Used When Using an ISO
    - ide1 is the Cloud-Init Disk
- DNS
  - Only Creates Single A Record
  - Default TTL = 60 (Configurable)


## Requirements

### Terraform

This module requires Terraform 1.9.8 or later. It may be compatible with earlier versions but only has been tested with 1.9.8.

### Providers

The table below lists the providers required by this module.

| Name    | Source          | Version     |
| ------- | --------------- | ----------- |
| proxmox | telmate/proxmox | = 3.0.1-rc4 |
| dns     | hashicorp/dns   | ~> 3.4      |

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
| `pve_tags` | tags for the VM (comma-separated values)     | `string` | `""`    |    no    |

#### Cloning and Template Variables

| Name             | Description                                                   | Type     | Default                         | Required |
| ---------------- | ------------------------------------------------------------- | -------- | ------------------------------- | :------: |
| `pve_is_clone`   | Flag to determine if the VM is a clone or not (based off iso) | `bool`   | `true`                          |    no    |
| `pve_template`   | name of the PVE template to clone                             | `string` | `debian-12-cloud-init-template` |    no    |
| `pve_full_clone` | whether or not to do a full clone of the template             | `bool`   | `true`                          |    no    |
| `pve_iso`        | iso to use for the VM                                         | `string` | `""`                            |    no    |

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

| Name                 | Description                                                               | Type     | Default | Required |
| -------------------- | ------------------------------------------------------------------------- | -------- | ------- | :------: |
| `pve_memory_size`    | amount of memory to allocate to the VM in MiB                             | `number` | `2048`  |    no    |
| `pve_memory_balloon` | whether or not to use memory ballooning (set to 0 to turn off ballooning) | `number` | `0`     |    no    |

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

| Name                        | Description                                                                              | Type           | Default     | Required |
| --------------------------- | ---------------------------------------------------------------------------------------- | -------------- | ----------- | :------: |
| `pve_use_ci`                | whether or not to use the cloud_init                                                     | `bool`         | `true`      |    no    |
| `pve_ci_ssh_user`           | ssh user used to provision the VM                                                        | `string`       | `ansible`   |    no    |
| `pve_ci_ssh_private_key`    | ssh private key used to provision the VM                                                 | `string`       | `""`        |    no    |
| `pve_ci_ssh_keys`           | ssh public keys to assigned to ci user authorized_keys                                   | `list(string)` | `[]`        |    no    |
| `pve_ci_user`               | cloud-init user                                                                          | `string`       | `ansible`   |    no    |
| `pve_ci_password`           | cloud-init password                                                                      | `string`       | `null`      |    no    |
| `pve_ci_use_dhcp`           | whether or not to use a static IP or DHCP                                                | `bool`         | `true`      |    no    |
| `pve_ci_ip_address`         | IP address to use for the VM, must be set if using static IP                             | `string`       | `""`        |    no    |
| `pve_ci_cidr_prefix_length` | number of network bits used to represent the subnet mask, must be set if using static IP | `string`       | `""`        |    no    |
| `pve_ci_gateway_address`    | gateway to use for the VM, must be set if using static IP                                | `string`       | `""`        |    no    |
| `pve_ci_dns_servers`        | ip of vm's dns server                                                                    | `string`       | `""`        |    no    |
| `pve_ci_storage_location`   | storage location for the cloud-init iso                                                  | `string`       | `local-zfs` |    no    |

#### Disk Options

| Name                        | Description                      | Type     | Default           | Required |
| --------------------------- | -------------------------------- | -------- | ----------------- | :------: |
| `pve_disk_size`             | size of the VM disk              | `string` | `40G`             |    no    |
| `pve_disk_storage_location` | storage location for the VM disk | `string` | `local-zfs`       |    no    |
| `pve_scsihw`                | scsi hardware to use for the VM  | `string` | `virtio-scsi-pci` |    no    |

# Agent Options

| Name            | Description                     | Type   | Default | Required |
| --------------- | ------------------------------- | ------ | ------- | :------: |
| `pve_use_agent` | whether or not to use the agent | `number` | `1`  |    no    |

# Serial Options

| Name              | Description                    | Type     | Default  | Required |
| ----------------- | ------------------------------ | -------- | -------- | :------: |
| `pve_add_serial`  | whether or not to add a serial | `bool`   | `false`  |    no    |
| `pve_serial_type` | type of serial to add          | `string` | `socket` |    no    |
| `pve_serial_id`   | id of the serial to add        | `number` | `0`      |    no    |

### DNS Variables

Currently only a single A record will be created.

| Name                 | Description                                     | Type     | Default | Required |
| -------------------- | ----------------------------------------------- | -------- | ------- | :------: |
| `create_dns_record`  | whether to create a DNS A record for the VM     | `bool`   | `true`  |    no    |
| `dns_zone`           | name of the DNS zone to create the record in    | `string` | n/a     |   yes    |
| `dns_record_name`    | name of the DNS record to create                | `string` | n/a     |   yes    |
| `dns_ttl`            | TTL (Time To Live) for the DNS record in seconds| `number` | `60`    |    no    |

## Outputs

| Name             | Description                                | Type           | Sensitive |
| ---------------- | ------------------------------------------ | -------------- | --------- |
| `vm_id`          | The ID of the Proxmox VM                   | `number`       | no        |
| `vm_name`        | The name of the Proxmox VM                 | `string`       | no        |
| `vm_ip_address`  | The default IPv4 address of the Proxmox VM | `string`       | no        |
| `vm_dns_records` | The DNS A record addresses created         | `list(string)` | no        |

## Usage

### Using An ISO

```hcl
module "test-vm" {
  source = "github.com/Johnny-Knighten/terraform-homelab-pve-vm"

  pve_node = "node-alpha"
  pve_name = "test-vm"
  pve_id   = 400
  pve_tags = "test,development,ubuntu"

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

  dns_zone        = "homelab.lan"
  dns_record_name = "test-vm"
}
```

### Using A Template (With Cloud-Init)

```hcl
module "cloned-vm" {
  source = "github.com/Johnny-Knighten/terraform-homelab-pve-vm"

  pve_node = "node-alpha"
  pve_name = "cloned-vm"
  pve_id   = 401
  pve_tags = "production,web-server,database"

  pve_is_clone   = true
  pve_full_clone = true
  pve_template   = "ubuntu-server-22-04-base-template-homelab"

  pve_use_ci                 = true
  pve_ci_use_dhcp            = true
  pve_ci_ip_address          = "192.168.25.100"
  pve_ci_cidr_prefix_length  = "24"
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
  pve_memory_balloon = 0

  pve_disk_size = "40G"

  dns_zone        = "homelab.lan"
  dns_record_name = "cloned-vm"
}
```
