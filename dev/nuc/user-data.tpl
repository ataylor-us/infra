#cloud-config
growpart:
  mode: auto
  devices: ["/"]
  ignore_growroot_disabled: false

resize_rootfs: noblock

ssh_pwauth: false
disable_root: false

users:
  - default
  - name: alex
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: adm,wheel
    lock_passwd: true
    ssh_authorized_keys:
      - ${ssh_public_key}

hostname: ${hostname}
timezone: America/New_York

package_update: true
