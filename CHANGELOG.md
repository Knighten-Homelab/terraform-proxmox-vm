## [2.6.0](https://github.com/Knighten-Homelab/terraform-proxmox-vm/compare/2.5.0...2.6.0) (2025-07-09)


### Features

* upgrade Proxmox provider to 3.0.2-rc01 ([#9](https://github.com/Knighten-Homelab/terraform-proxmox-vm/issues/9)) ([e3b3bf7](https://github.com/Knighten-Homelab/terraform-proxmox-vm/commit/e3b3bf76b991a3b2ad9ef7be03136f64514de790))

## [2.5.0](https://github.com/Knighten-Homelab/terraform-proxmox-vm/compare/2.4.0...2.5.0) (2025-07-06)


### Features

* add configurable DNS TTL ([#8](https://github.com/Knighten-Homelab/terraform-proxmox-vm/issues/8)) ([a265e3e](https://github.com/Knighten-Homelab/terraform-proxmox-vm/commit/a265e3e2f81b351a962df6e6f728f937d7e04d4c))

## [2.4.0](https://github.com/Knighten-Homelab/terraform-proxmox-vm/compare/2.3.0...2.4.0) (2025-07-06)


### Features

* add optional DNS record creation ([#7](https://github.com/Knighten-Homelab/terraform-proxmox-vm/issues/7)) ([830e933](https://github.com/Knighten-Homelab/terraform-proxmox-vm/commit/830e933a5b1d30cf71b75dc6ac156b6d80c66bb2))

## [2.3.0](https://github.com/Knighten-Homelab/terraform-proxmox-vm/compare/2.2.0...2.3.0) (2025-07-06)


### Features

* add static IP configuration validation ([#6](https://github.com/Knighten-Homelab/terraform-proxmox-vm/issues/6)) ([15a11ee](https://github.com/Knighten-Homelab/terraform-proxmox-vm/commit/15a11eee2402529d773fe596ee816798294cb90c))

## [2.2.0](https://github.com/Knighten-Homelab/terraform-proxmox-vm/compare/2.1.2...2.2.0) (2025-07-06)


### Features

* add input validation for critical variables ([#5](https://github.com/Knighten-Homelab/terraform-proxmox-vm/issues/5)) ([e443e39](https://github.com/Knighten-Homelab/terraform-proxmox-vm/commit/e443e3965b13523f5bf4866104bcdf35b25df05d))

## [2.1.2](https://github.com/Knighten-Homelab/terraform-proxmox-vm/compare/2.1.1...2.1.2) (2025-07-04)


### Bug Fixes

* correct documentation and default value discrepancies ([#4](https://github.com/Knighten-Homelab/terraform-proxmox-vm/issues/4)) ([1950e35](https://github.com/Knighten-Homelab/terraform-proxmox-vm/commit/1950e35f07cc00c6dd75e1d8b4386c1a27ba9d89))

## [2.1.1](https://github.com/Knighten-Homelab/terraform-proxmox-vm/compare/2.1.0...2.1.1) (2025-07-04)


### Bug Fixes

* correct repository URL in package.json ([27a0400](https://github.com/Knighten-Homelab/terraform-proxmox-vm/commit/27a04002310f2cbe2ca3998ef248729465911c18))

## [2.1.0](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/2.0.0...2.1.0) (2025-07-04)


### Features

* add GitHub CLI to devcontainer ([#3](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/issues/3)) ([7d1d06b](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/7d1d06bae27d659a957dd330d0237790bccd035a))

## [2.0.0](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.7.1...2.0.0) (2025-01-19)


### ⚠ BREAKING CHANGES

* removed AWX resources from module

### Features

* removed AWX resources from module ([eef9582](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/eef9582a731e7935b38a3199e9b492cace344ffe))

## [1.7.1](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.7.0...1.7.1) (2024-12-06)


### Bug Fixes

* updated required_version for tf ([5819ce7](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/5819ce773ca6209c629746405dab1866daa14ba6))

## [1.7.0](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.6.1...1.7.0) (2024-11-15)


### Features

* added the ability to add a single serial device ([5cbef7f](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/5cbef7fe10eb6b7da4618d7f00ed31512dc5e613))

## [1.6.1](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.6.0...1.6.1) (2024-11-15)


### Bug Fixes

* changed default pve_ci_user to ansible and changed default pve templat to debian-12 ([7888548](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/7888548a5e67706fa0e0fc341bbe807330276051))

## [1.6.0](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.5.3...1.6.0) (2024-11-15)


### Features

* exposed variable to control cloudinit ssh authorized keys ([3972810](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/397281055096646884c79d00b939933e4e8e5c18))

## [1.5.3](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.5.2...1.5.3) (2024-11-03)


### Bug Fixes

* renamed cipassword and ciusern var ([86d73ca](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/86d73ca432a8f8a417656d384446f197e4662d6c))

## [1.5.2](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.5.1...1.5.2) (2024-11-03)


### Bug Fixes

* reintroduced cipassword and ciuser but made default null ([47257f6](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/47257f63d8e9952e178694a68947124e4c0c5d4e))

## [1.5.1](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.5.0...1.5.1) (2024-11-03)


### Bug Fixes

* removed ciuser and cipassword vars for cleaning provisioning ([242b49e](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/242b49e98acecb0e08e7b4f2d4b74d601e0a1d43))

## [1.5.0](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.4.1...1.5.0) (2024-11-03)


### Features

* added pve_ci_user_password var ([a91ea52](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/a91ea52049934cab6506a54d1547057d8d590ffa))

## [1.4.1](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.4.0...1.4.1) (2024-10-29)


### Bug Fixes

* renamed pve_ci_subnet_network_bits to pve_ci_cidr_prefix_length ([dfe4d62](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/dfe4d62c4e76a02150d7d079781e2f0fce22df70))

## [1.4.0](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.3.5...1.4.0) (2024-10-27)


### Features

* refined variable and output names ([44b778a](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/44b778ad07af36dc6f15ffc1f7f7a1958d50fc65))

## [1.3.5](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.3.4...1.3.5) (2024-10-27)


### Bug Fixes

* made default vm disk size be 40G to match default template ([70bd4ca](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/70bd4ca3f284a3a509f7a08dd1822f8b28b3afb6))

## [1.3.4](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.3.3...1.3.4) (2024-10-23)


### Bug Fixes

* correct dir ssh keys are mounted to ([b5ed1cc](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/b5ed1cc8f683e2b4d91b6dd331c7daa2f67e479b))
* made devcontainer run as non-root and removed extra mount ([60472a1](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/60472a1df8db9d79a3dcdcb42bc9183b8824d018))

## [1.3.3](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.3.2...1.3.3) (2024-10-22)


### Bug Fixes

* changed comparison for dynamic ide0 to compare against empty string ([2f06a8a](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/2f06a8a20c1a98942324f7893dff9f9407e38808))

## [1.3.2](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.3.1...1.3.2) (2024-10-22)


### Bug Fixes

* made cloudinit drive creation be based on pve_use_ci var ([b9c4ae7](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/b9c4ae72f12a613f2e9c3692d9ef887026b07177))

## [1.3.1](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.3.0...1.3.1) (2024-10-21)


### Bug Fixes

* made boot disk var default to null ([213d7cd](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/213d7cd5bb17577da1a779ad395acd8cba4bac99))

## [1.3.0](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.2.5...1.3.0) (2024-10-21)


### Features

* added ip and dns outputs ([02ac0a8](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/02ac0a8d10ab9325ad833c9c7294e12c9e75a3e2))

## [1.2.5](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.2.4...1.2.5) (2024-10-21)


### Bug Fixes

* corrected startup option default value ([4873231](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/48732318a2b3a0227dc00190771a8b956e19dc5a))

## [1.2.4](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.2.3...1.2.4) (2024-10-20)


### Bug Fixes

* added ci vars to fix issues with cloudinit ([a05144a](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/a05144a5c66ef2db69e328ed1465711fd6925102))

## [1.2.3](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.2.2...1.2.3) (2024-10-19)


### Bug Fixes

* added cloudinit storage config ([d2cba69](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/d2cba69d2ce409bdecc1332613cd71e82cf3b504))

## [1.2.2](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.2.1...1.2.2) (2024-10-19)


### Bug Fixes

* corrected default pve_template value ([143cd64](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/143cd64cdcd18924bfdfc36d051c842ce9d9778f))

## [1.2.1](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.2.0...1.2.1) (2024-10-19)


### Bug Fixes

* made ssh key have a blank default ([285acff](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/285acff40e7b449f172ca1e600442409af675e20))

## [1.2.0](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/1.1.0...1.2.0) (2024-10-18)


### Features

* overhaul on pve vm vars ([#2](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/issues/2)) ([581a4f9](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/581a4f9daadb32b225b8dbaf73a834d882566876))

## [1.1.0](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/compare/v1.0.0...1.1.0) (2024-10-17)


### Features

* overhaul and deps update ([#1](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/issues/1)) ([3a45b93](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/commit/3a45b93c71767fbad2e3b6d84df312c69c5b0d0f))
