# infra

This is my current iteration of my home infrastructure, automated using Ansible.

Currently, I run most of my containers on one hypervisor which runs EL10. The hypervisor currently has 2 vms, one with Fedora that I use as a client (for keeping a recent Ansible version + other tools), and another with EL10 that runs additional services separate from the host.  I also have a workstation box separate from the main hypervisor.

My services are shared using Tailscale.

## Adding a new host
Typically, the hostname should be set to the `domain_name` variable, but during initial setup I might not have a domain name.  Just swap it with the current (reachable) ip address, and change it to the correct one after.

### Tailscale
A one time use [tailscale auth key](https://login.tailscale.com/admin/settings/keys) needs to be set for the host during first setup.  This should be set in the vault, but can be set at runtime with:

```bash
ansible-playbook master.yml -e "tailscale_authkey=`#insert_authkey_here`" --limit `#ansible_hostname`
```

Once this succeeds, the DNS for the hostname will have to be updated on [Cloudflare](https://dash.cloudflare.com/) to reflect the new ip (if reinstalling.)

## Secrets
Vault secrets are handled by pass.  This is not automated intentionally.

## Manual Steps

### System mail (Notifications)
For notifications (mailrise), a [Pushover application key](https://pushover.net/) needs to be set for the host.  It should be set as `pushover_application_key` in the appropriate vault.

### Backups
Backups use borgmatic (typically hosted on [borgbase](https://www.borgbase.com/)), use a pinned borgmatic package.  A root ssh key should be generated and propegated to the receiving server. This is not done manually.

Initializing the borg repo also needs to be done manually.  After that, populate the `{{ remote_borg_repo_path }}` and `{{ borg_passphrase }}` variables.

Remember to connect to the target borg server at least once if haven't before, otherwise the borg cronjob while get hung before it can run.

### CalDAV/CardDAV
Vdirsyncer setup (`yes | vdirsyncer discover`) and syncing (`vdirsyncer sync;vdirsyncer metasync`) are handled manually.  Conflicts can happen, and events shouldn't be merged without oversight.

## Usage

Ensure ssh is enabled:
```bash
# systemctl enable --now sshd
```

And copy the ssh key to the host:
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

It's also possible to run against a particular group, which can help speed things up if testing small changes.
```bash
ansible-playbook master.yml --limit interactive_boxes
```

## wsl

Been playing around with wsl.  It has its own playbook as `setup_wsl.yml`

To set up, first install the necessary packages, set up pass, and clone the repo.  Something along the lines of:
```bash
sudo dnf install ansible git pass -y
# Set up pass, omitted
git clone https://github.com/ataylor-us/infra.git
```
