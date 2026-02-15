#!/bin/sh
# Ansible managed
stty discard undef
exec /opt/homebrew/opt/neomutt/bin/neomutt "$@"
