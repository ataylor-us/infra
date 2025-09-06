# infra

This is my current iteration of my home infrastructure, automated using Ansible.

Currently, I run most of my containers on one hypervisor which runs EL10. The hypervisor currently has 2 vms, one with Fedora that I use as a client (for keeping a recent Ansible version + other tools), and another with EL10 that runs additional services separate from the host.  I also have a workstation box separate from the main hypervisor.

My services are shared using Tailscale.

## Adding a new host
Typically, the hostname should be set to the `domain_name` variable, but during initial setup you won't have a domain name.  Just swap it with the current (reachable) ip address, and change it to the correct one after.

## Secrets
Vault secrets are handled by Bitwarden, typically it's best to add the key via environment variable logging in (`bw login`) to your bashrc.  This is not automated intentionally.

## Manual Steps

### Tailscale
A one time use [tailscale auth key](https://login.tailscale.com/admin/settings/keys?refreshed=true) needs to be set for the host.

### System mail (Notifications)
For notifications (mailrise), a [Pushover application key](https://pushover.net/) needs to be set for the host.  It should be set as `pushover_application_key` in the appropriate vault.

### Backups
Backups use borgmatic (typically hosted on [borgbase](https://www.borgbase.com/)), use a pinned borgmatic package.  A root ssh key should be generated and propegated to the receiving server. This is not done manually.

Initializing the borg repo also needs to be done automatically.  After that, populate the `{{ remote_borg_repo_path }}` and `{{ borg_passphrase }}` variables.

### CalDAV/CardDAV
Vdirsyncer setup (`yes | vdirsyncer discover`) and syncing (`vdirsyncer sync;vdirsyncer metasync`) are handled manually.  Conflicts can happen, and events shouldn't be merged without oversight.

## Usage

Ensure ssh is enabled:
```bash
# systemctl enable --now sshd
```

And copy your ssh key to the host:
```bash
ssh-copy-id `#hostname or ip`
```

### Install requirements:
```bash
ansible-galaxy install -r requirements.yml 
```

### Run full playbook
```bash
ansible-playbook master.yml
```

It's also possible to run against a particular group, which can help speed things up if testing small changes
```bash
ansible-playbook master.yml --limit interactive_boxes
```
