# infra

This is my current iteration of my home infrastructure, automated using Ansible.

Currently, I run most of my containers on one hypervisor which runs EL10. The hypervisor currently has 2 vms, one with Fedora that I use as a client (for keeping a recent Ansible version + other tools), and another with EL10 that runs additional services separate from the host.  I also have a workstation box separate from the main hypervisor.

My services are shared using Tailscale.

## Adding a new host

Typically, the hostname should be set to the `domain_name` variable, but during initial setup you won't have a domain name.  Just swap it with the current (reachable) ip address, and change it to the correct one after.

A one time use [tailscale auth key](https://login.tailscale.com/admin/settings/keys?refreshed=true) needs to be set for the host.  This goes into an encrypted vault in the `host_vars/{{ hostname }}/vault.yml` file.

For notifications (mailrise), a [Pushover application key](https://pushover.net/) needs to be set for the host.  It should be set as `pushover_application_key` in the appropriate vault.

Ensure ssh is enabled:
```bash
# systemctl enable --now sshd
```

And copy your ssh key to the host:
```bash
ssh-copy-id `#hostname or ip`
```

## Usage

### Install requirements:
```bash
ansible-galaxy install -r requirements.yml 
```

### Run playbook
```bash
ansible-playbook master.yml
```

## Secrets

+ Vault secrets are handled by Bitwarden, typically it's best to add the key via environment variable logging in (`bw login`) to your bashrc.  This is not automated intentionally.

