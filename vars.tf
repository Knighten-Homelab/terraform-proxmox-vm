#################
# PVE Variables #
#################

# Minimum Required Variables

variable "pve_node" {
  type        = string
  description = "name of the ProxMox node to create the VM on"
}

variable "pve_name" {
  type        = string
  description = "name of the VM to create"
}

# Metadata Variables

variable "pve_id" {
  type        = number
  description = "id of the VM"
  default     = 0
}

variable "pve_desc" {
  type        = string
  description = "description of the VM"
  default     = ""
}

variable "pve_tags" {
  type        = string
  description = "tags for the VM (comma-separated values, e.g. 'web,production,ubuntu'). Tags may not start with '-' and may only include [a-z], [0-9], '_' and '-'"
  default     = ""
  validation {
    condition     = var.pve_tags == "" || can(regex("^[a-z0-9_][a-z0-9_-]*(?:,[a-z0-9_][a-z0-9_-]*)*$", var.pve_tags))
    error_message = "Tags must be comma-separated values. Each tag may not start with '-' and may only contain lowercase letters (a-z), numbers (0-9), underscores (_), and hyphens (-)."
  }
}

# Clone/Template Variables 

variable "pve_is_clone" {
  type        = bool
  description = "Flag to determine if the VM is a clone or not (based off iso)"
  default     = true
}

variable "pve_template" {
  type        = string
  description = "name of the PVE template to clone"
  default     = "debian-12-cloud-init-template"
}

variable "pve_full_clone" {
  type        = bool
  description = "whether or not to do a full clone of the template"
  default     = true
}

variable "pve_iso" {
  type        = string
  description = "iso to use for the VM"
  default     = ""
}

# Boot Options

variable "pve_boot_on_start" {
  type        = bool
  description = "whether or not to boot the VM on start"
  default     = false
}

variable "pve_startup_options" {
  type        = string
  description = "startup options seperated via comma: boot order (order=), startup delay(up=), and shutdown delay(down=)"
  default     = ""
}

variable "pve_boot_disk" {
  type        = string
  description = "boot disk for the VM"
  default     = null
}

# CPU Options

variable "pve_core_count" {
  type        = string
  description = "number of cores to allocate to the VM"
  default     = "2"
  validation {
    condition     = can(tonumber(var.pve_core_count)) && tonumber(var.pve_core_count) >= 1
    error_message = "pve_core_count must be a valid number greater than or equal to 1."
  }
}

variable "pve_cpu_type" {
  type        = string
  description = "type of CPU to use for the VM"
  default     = "host"
}

variable "pve_sockets" {
  type        = string
  description = "number of sockets to allocate to the VM"
  default     = "1"
}

# Memory Options

variable "pve_memory_size" {
  type        = number
  description = "amount of memory to allocate to the VM in MiB"
  default     = 2048
  validation {
    condition     = var.pve_memory_size >= 512
    error_message = "pve_memory_size must be at least 512 MiB."
  }
}

variable "pve_memory_balloon" {
  type        = number
  description = "whether or not to use memory ballooning"
  default     = 0
}

# Network Options

variable "pve_networks" {
  type = list(object({
    model  = string
    bridge = string
    tag    = optional(string)
    queues = optional(string)
  }))
  description = "List of network configurations for the VM"
  default = [
    {
      model  = "virtio"
      bridge = "vmbr0"
      tag    = "0"
      queues = "1"
    }
  ]
}

# Cloud-Init Options

variable "pve_use_ci" {
  type        = bool
  description = "whether or not to use the cloud_init"
  default     = true
}

variable "pve_ci_ssh_user" {
  type        = string
  description = "ssh user to used to provision the VM"
  default     = "ansible"
}

variable "pve_ci_ssh_private_key" {
  type        = string
  description = "ssh private key to used to provision the VM"
  default     = ""
}

variable "pve_ci_ssh_keys" {
  type        = list(string)
  description = "ssh public keys to assigned to ci user authorized_keys"
  default     = []
}

variable "pve_ci_user" {
  type        = string
  description = "cloud-init user"
  default     = "ansible"
}

variable "pve_ci_password" {
  type        = string
  description = "cloud-init password"
  default     = null
}

variable "pve_ci_use_dhcp" {
  type        = bool
  description = "whether or not to use a static IP or DHCP"
  default     = true
}

variable "pve_ci_ip_address" {
  type        = string
  description = "IP address to use for the VM, must be set if using static IP"
  default     = ""
  validation {
    condition     = var.pve_ci_ip_address == "" || can(cidrhost("${var.pve_ci_ip_address}/32", 0))
    error_message = "pve_ci_ip_address must be a valid IPv4 address or empty string."
  }
}

variable "pve_ci_cidr_prefix_length" {
  type        = string
  description = "number of network bits used to represent the subnet mask, must be set if using static IP"
  default     = ""
  validation {
    condition     = var.pve_ci_cidr_prefix_length == "" || (can(tonumber(var.pve_ci_cidr_prefix_length)) && tonumber(var.pve_ci_cidr_prefix_length) >= 1 && tonumber(var.pve_ci_cidr_prefix_length) <= 32)
    error_message = "pve_ci_cidr_prefix_length must be a number between 1 and 32, or empty string."
  }
}

variable "pve_ci_gateway_address" {
  type        = string
  description = "gateway to use for the VM, must be set if using static IP"
  default     = ""
  validation {
    condition     = var.pve_ci_gateway_address == "" || can(cidrhost("${var.pve_ci_gateway_address}/32", 0))
    error_message = "pve_ci_gateway_address must be a valid IPv4 address or empty string."
  }
}

variable "pve_ci_dns_servers" {
  type        = string
  description = "ip of vm's dns server (space seperated)"
  default     = ""
}

variable "pve_ci_storage_location" {
  type        = string
  description = "storage location for the cloud-init iso"
  default     = "local-zfs"
}

# Disk Configuration

variable "pve_disk_size" {
  type        = string
  description = "size of the VM disk (integer followed by M, G, T,...)"
  default     = "40G"
  validation {
    condition     = can(regex("^[0-9]+[KMGT]$", var.pve_disk_size))
    error_message = "pve_disk_size must be a number followed by K, M, G, or T (e.g., '40G', '512M', '1T')."
  }
}

variable "pve_disk_storage_location" {
  type        = string
  description = "storage location for the VM disk"
  default     = "local-zfs"
}

variable "pve_scsihw" {
  type        = string
  description = "scsi hardware to use for the VM"
  default     = "virtio-scsi-pci"
}

# Agent Options

variable "pve_use_agent" {
  type        = number
  description = "whether or not to use the agent"
  default     = 1
}

# Serial Options

variable "pve_add_serial" {
  type        = bool
  description = "whether or not to add a serial device"
  default     = false
}

variable "pve_serial_type" {
  type        = string
  description = "type of serial device to add"
  default     = "socket"
}

variable "pve_serial_id" {
  type        = number
  description = "id of the serial device"
  default     = 0
}

############
# PowerDNS #
############

variable "create_dns_record" {
  type        = bool
  description = "whether to create a PowerDNS A record for the VM"
  default     = true
}

variable "pdns_zone" {
  type        = string
  description = "name of the PowerDNS zone to create the record in"
}

variable "pdns_record_name" {
  type        = string
  description = "name of the PowerDNS record to create"
}

variable "pdns_ttl" {
  type        = number
  description = "TTL (Time To Live) for the PowerDNS record in seconds"
  default     = 60
  validation {
    condition     = var.pdns_ttl >= 30 && var.pdns_ttl <= 86400
    error_message = "pdns_ttl must be between 30 and 86400 seconds (24 hours)."
  }
}
