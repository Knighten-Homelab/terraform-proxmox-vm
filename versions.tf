terraform {
  required_version = "1.9.8"

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