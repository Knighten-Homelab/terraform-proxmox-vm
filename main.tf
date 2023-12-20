terraform {
  required_version = "1.6.6"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0"
    }
    awx = {
      source  = "denouche/awx"
      version = "0.19.0"
    }
  }
}

resource "proxmox_vm_qemu" "pve_vm" {
  name        = var.pve_vm_name
  target_node = var.pve_node
  full_clone  = var.pve_vm_full_clone
  clone       = var.pve_template
  onboot      = var.pve_vm_boot_on_start
  startup     = var.pve_vm_startup_options
  cores       = var.pve_vm_core_count
  desc        = var.pve_vm_desc
  sockets     = 1
  cpu         = "host"
  memory      = var.pve_vm_memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  agent       = 1
  ipconfig0   = var.pve_vm_use_static_ip ? format("ip=%s,gw=%s", join("/", [var.pve_vm_ip, var.pve_vm_subnet_network_bits]), var.pve_vm_gateway) : "ip=dhcp"
  nameserver  = var.pve_vm_dns_server
  os_type     = "cloud-init"

  # SSH (Cloud-Init Used To Make This User)
  ssh_user        = "ansible"
  ssh_private_key = var.ansible_service_account_ssh_key

  disk {
    size    = var.pve_vm_disk_size
    type    = "scsi"
    storage = var.pve_vm_disk_storage_location
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = var.pve_vm_vlan_tag
    queues = var.pve_vm_packet_queue_count
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
