resource "proxmox_vm_qemu" "pve_vm" {
  # Minimum Required Fields
  name        = var.pve_name
  target_node = var.pve_node

  # Metadata Fields
  vmid = var.pve_id
  desc = var.pve_desc

  # Template/Clone Fields
  full_clone = var.pve_is_clone ? var.pve_full_clone : null
  clone      = var.pve_is_clone ? var.pve_template : null

  # Boot Options
  onboot   = var.pve_boot_on_start
  startup  = var.pve_startup_options
  bootdisk = var.pve_boot_disk

  # CPU Options
  cores   = var.pve_core_count
  sockets = var.pve_sockets
  cpu     = var.pve_cpu_type

  # Memory Options
  memory  = var.pve_memory_size
  balloon = var.pve_memory_balloon

  # Network Options
  dynamic "network" {
    for_each = var.pve_networks
    content {
      model  = network.value.model
      bridge = network.value.bridge
      tag    = lookup(network.value, "tag", null)
      queues = lookup(network.value, "queues", null)
    }
  }

  # Cloud-Init Options
  os_type                = var.pve_use_ci ? "cloud-init" : null
  define_connection_info = var.pve_use_ci
  ssh_user               = var.pve_use_ci ? var.pve_ci_ssh_user : null
  ssh_private_key        = var.pve_use_ci ? var.pve_ci_ssh_private_key : null
  sshkeys                = var.pve_use_ci ? join("\n", var.pve_ci_ssh_keys) : null
  ciuser                 = var.pve_use_ci ? var.pve_ci_user : null
  cipassword             = var.pve_use_ci ? var.pve_ci_password : null
  ciupgrade              = true
  ipconfig0              = var.pve_use_ci ? (var.pve_ci_use_dhcp ? "ip=dhcp" : format("ip=%s,gw=%s", join("/", [var.pve_ci_ip_address, var.pve_ci_cidr_prefix_length]), var.pve_ci_gateway_address)) : null
  nameserver             = var.pve_use_ci ? var.pve_ci_dns_servers : null

  # Agent Options
  agent = var.pve_use_agent

  # Disk Options

  scsihw = var.pve_scsihw

  disks {
    ide {
      dynamic "ide0" {
        for_each = var.pve_iso != "" ? [1] : []
        content {
          cdrom {
            iso = var.pve_iso
          }
        }
      }
      dynamic "ide1" {
        for_each = var.pve_use_ci ? [1] : []
        content {
          cloudinit {
            storage = var.pve_ci_storage_location
          }
        }
      }
    }

    scsi {
      scsi0 {
        disk {
          size    = var.pve_disk_size
          storage = var.pve_disk_storage_location
          format  = "raw"
        }
      }
    }
  }

  dynamic "serial" {
    for_each = var.pve_add_serial ? [1] : []
    content {
      id   = var.pve_serial_id
      type = var.pve_serial_type
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
