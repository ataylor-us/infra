# infra

This is my current iteration of my home infrastructure, automated using Ansible.

Currently, I run most of my containers on one hypervisor which runs EL10. The hypervisor currently has 2 vms, one with Fedora that I use as a client (for keeping a recent Ansible version + other tools), and another with EL10 that runs additional services separate from the host.

My services are shared using Tailscale.
