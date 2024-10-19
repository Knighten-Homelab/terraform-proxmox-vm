#################
# PVE Variables #
#################

# Minimum Required Variables

variable "pve_node" {
  type        = string
  description = "name of the ProxMox node to create the VM on"
}

variable "pve_vm_name" {
  type        = string
  description = "name of the VM to create"
}

# Metadata Variables

variable "pve_vm_id" {
  type        = number
  description = "id of the VM"
  default     = 0
}

variable "pve_vm_desc" {
  type        = string
  description = "description of the VM"
  default     = ""
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
  default     = "ubuntu-server-22-04-base-template-homela"
}

variable "pve_vm_full_clone" {
  type        = bool
  description = "whether or not to do a full clone of the template"
  default     = true
}

variable "pve_vm_iso" {
  type        = string
  description = "iso to use for the VM"
  default     = ""
}

# Boot Options

variable "pve_vm_boot_on_start" {
  type        = bool
  description = "whether or not to boot the VM on start"
  default     = false
}

variable "pve_vm_startup_options" {
  type        = string
  description = "startup options seperated via comma: boot order (order=), startup delay(up=), and shutdown delay(down=)"
  default     = "order=any"
}

variable "pve_vm_boot_disk" {
  type        = string
  description = "boot disk for the VM"
  default     = "scsi0"

}

# CPU Options

variable "pve_vm_core_count" {
  type        = string
  description = "number of cores to allocate to the VM"
  default     = "2"
}

variable "pve_vm_cpu_type" {
  type        = string
  description = "type of CPU to use for the VM"
  default     = "host"
}

variable "pve_vm_sockets" {
  type        = string
  description = "number of sockets to allocate to the VM"
  default     = "1"
}

# Memory Options

variable "pve_vm_memory_size" {
  type        = number
  description = "amount of memory to allocate to the VM in MB"
  default     = 2048
}

variable "pve_memory_balloon" {
  type        = number
  description = "whether or not to use memory ballooning"
  default     = 0
}

# Network Options

variable "pve_vm_networks" {
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
      tag    = "-1"
      queues = "1"
    }
  ]
}

# Cloud-Init Options

variable "pve_use_preprovisioner" {
  type        = bool
  description = "whether or not to use the preprovisioner"
  default     = true
}

variable "pve_ssh_user" {
  type        = string
  description = "ssh user to use for the VM"
  default     = "ansible"
}

variable "pve_ssh_private_key" {
  type        = string
  description = "ssh private key to use for the VM"
  default     = ""
}

variable "pve_vm_use_static_ip" {
  type        = bool
  description = "whether or not to use a static IP or DHCP"
  default     = false
}

variable "pve_vm_ip" {
  type        = string
  description = "IP address to use for the VM, must be set if using static IP"
  default     = ""
}

variable "pve_vm_subnet_network_bits" {
  type        = string
  description = "number of subnet network bits to use for the VM, must be set if using static IP"
  default     = ""
}

variable "pve_vm_gateway" {
  type        = string
  description = "gateway to use for the VM, must be set if using static IP"
  default     = ""
}

variable "pve_vm_dns_server" {
  type        = string
  description = "ip of vm's dns server"
  default     = ""
}

# Disk Configuration

variable "pve_vm_disk_size" {
  type        = string
  description = "size of the VM disk "
  default     = "20G"
}

variable "pve_vm_disk_storage_location" {
  type        = string
  description = "storage location for the VM disk"
  default     = "local-zfs"
}

variable "pve_vm_scsihw" {
  type        = string
  description = "scsi hardware to use for the VM"
  default     = "virtio-scsi-pci"
}

# Agent Options

variable "pve_vm_agent" {
  type        = number
  description = "whether or not to use the agent"
  default     = 1
}

#################
# AWX Variables #
#################

variable "awx_organization" {
  type        = string
  description = "name of the AWX organization to create the host in"
}

variable "awx_inventory" {
  type        = string
  description = "name of the AWX inventory to create the host in"
}

variable "awx_host_groups" {
  type        = list(string)
  description = "comma separated list of AWX host groups to add the host to"
}

variable "awx_host_name" {
  type        = string
  description = "name of the AWX host to create"
}

variable "awx_host_description" {
  type        = string
  description = "description of the AWX host to create "
}

############
# PowerDNS #
############

variable "pdns_zone" {
  type        = string
  description = "name of the PowerDNS zone to create the record in"
}

variable "pdns_record_name" {
  type        = string
  description = "name of the PowerDNS record to create"
}
