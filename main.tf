resource "proxmox_vm_qemu" "pve_vm" {
  # Minimum Required Fields
  name        = var.pve_vm_name
  target_node = var.pve_node

  # Metadata Fields
  vmid = var.pve_vm_id
  desc = var.pve_vm_desc

  # Template/Clone Fields
  full_clone = var.pve_is_clone ? var.pve_vm_full_clone : null
  clone      = var.pve_is_clone ? var.pve_template : null

  # Boot Options
  onboot   = var.pve_vm_boot_on_start
  startup  = var.pve_vm_startup_options
  bootdisk = var.pve_vm_boot_disk

  # CPU Options
  cores   = var.pve_vm_core_count
  sockets = var.pve_vm_sockets
  cpu     = var.pve_vm_cpu_type

  # Memory Options
  memory  = var.pve_vm_memory_size
  balloon = var.pve_memory_balloon

  # Network Options
  dynamic "network" {
    for_each = var.pve_vm_networks
    content {
      model  = network.value.model
      bridge = network.value.bridge
      tag    = lookup(network.value, "tag", null)
      queues = lookup(network.value, "queues", null)
    }
  }

  # Cloud-Init Options
  os_type                = var.pve_use_preprovisioner ? "cloud-init" : null
  define_connection_info = var.pve_use_preprovisioner
  ssh_user               = var.pve_use_preprovisioner ? var.pve_ssh_user : null
  ssh_private_key        = var.pve_use_preprovisioner ? var.pve_ssh_private_key : null
  ipconfig0              = var.pve_use_preprovisioner ? (var.pve_vm_use_static_ip ? format("ip=%s,gw=%s", join("/", [var.pve_vm_ip, var.pve_vm_subnet_network_bits]), var.pve_vm_gateway) : "ip=dhcp") : null
  nameserver             = var.pve_use_preprovisioner ? var.pve_vm_dns_server : null

  scsihw = "virtio-scsi-pci"
  agent  = 1

  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.pve_vm_disk_size
          storage = var.pve_vm_disk_storage_location
        }
      }
    }
  }
}

resource "powerdns_record" "a_record" {
  zone    = "${var.pdns_zone}."
  name    = "${var.pdns_record_name}.${var.pdns_zone}."
  type    = "A"
  ttl     = 60
  records = [proxmox_vm_qemu.pve_vm.default_ipv4_address]
}

data "awx_organization" "homelab" {
  name = var.awx_organization
}

data "awx_inventory" "homelab_endpoints" {
  name            = var.awx_inventory
  organization_id = data.awx_organization.homelab.id
}

data "awx_inventory_group" "groups" {
  for_each     = toset(var.awx_host_groups)
  name         = each.value
  inventory_id = data.awx_inventory.homelab_endpoints.id
}

resource "awx_host" "awx_pve_vm" {
  name         = var.awx_host_name
  description  = var.awx_host_description
  inventory_id = data.awx_organization.homelab.id
  group_ids    = [for group in data.awx_inventory_group.groups : group.id]
  enabled      = true
  variables    = <<YAML
---
ansible_host: ${proxmox_vm_qemu.pve_vm.default_ipv4_address}
hostname: ${var.pdns_record_name}.${var.pdns_zone}
YAML
}
