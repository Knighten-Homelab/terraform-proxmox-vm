output "vm_id" {
  value = proxmox_vm_qemu.pve_vm.id
}

output "vm_name" {
  value = proxmox_vm_qemu.pve_vm.name
}

output "vm_ip_address" {
  value = proxmox_vm_qemu.pve_vm.default_ipv4_address
}

output "vm_dns_records" {
  value = powerdns_record.a_record.records
}
