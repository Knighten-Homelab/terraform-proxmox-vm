# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Terraform module for creating Proxmox VMs with PowerDNS A records. It's designed for homelab environments and makes opinionated decisions about VM configuration, networking, and DNS management.

## Architecture

The module consists of:
- `main.tf` - Core resources: `proxmox_vm_qemu` and `powerdns_record`
- `vars.tf` - Variable definitions for VM configuration, Cloud-Init, and PowerDNS settings
- `output.tf` - Outputs for VM ID, name, IP address, and DNS records
- `versions.tf` - Provider requirements (Proxmox 3.0.1-rc4, PowerDNS 1.5.0)

### Key Design Decisions

- **Single VM per module instance** - Each module call creates one VM and one DNS A record
- **Cloud-Init focused** - Primary provisioning method with template cloning
- **Fixed disk layout** - scsi0 for storage, ide0 for ISO (when used), ide1 for Cloud-Init
- **Single network interface** - Only one ipconfig supported
- **PowerDNS integration** - Always creates A record with 60s TTL

## Common Commands

### Terraform Operations
```bash
# Initialize and validate
terraform init
terraform validate

# Plan and apply
terraform plan
terraform apply

# Format and validate
terraform fmt
terraform validate
```

### Development Tools
```bash
# Commit linting (uses conventional commits)
npm run prepare  # Sets up husky hooks
npx commitlint --edit $1  # Lint commit message

# Release process (semantic-release)
npm run semantic-release
```

## Required Providers Configuration

The module requires two providers to be configured in your root module:

```hcl
provider "proxmox" {
  # Configure Proxmox connection
}

provider "powerdns" {
  # Configure PowerDNS API connection
}
```

## Variable Categories

- **PVE Core** - `pve_node`, `pve_name`, `pve_id`
- **Template/Clone** - `pve_is_clone`, `pve_template`, `pve_full_clone`
- **Resources** - `pve_core_count`, `pve_memory_size`, `pve_disk_size`
- **Cloud-Init** - `pve_ci_*` variables for user, networking, SSH keys
- **PowerDNS** - `pdns_zone`, `pdns_record_name`

## Commit Convention

Uses conventional commits with commitlint. Format: `type(scope): description`

Common types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**Important**: Do NOT add Claude Code attribution or co-authorship information to commit messages. Keep commits clean and standard.

## Guidance Notes

- Don't be verbose when making commits and PRs. Only use essential information. Don't adding meaningless fluff like "to streamline...".

## Development Workflow

- Always create a new branch of main (also rebase main from origin) when working on a new feature
- Always open a new branch before beginning work

## Process Guidance

- At the end of any process that edits the contents of a file make sure to show me the diffs. Especially if this step is before a git add/commit