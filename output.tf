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
  value = length(dns_a_record_set.vm_a_record) > 0 ? dns_a_record_set.vm_a_record[0].addresses : []
}
