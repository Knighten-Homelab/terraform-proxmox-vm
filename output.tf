output "ip-address" {
  value = proxmox_vm_qemu.pve_vm.default_ipv4_address
}

output "dns-record" {
  value = powerdns_record.a_record.records
}
