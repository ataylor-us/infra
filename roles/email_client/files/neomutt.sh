#!/bin/sh
stty discard undef
exec /opt/homebrew/opt/neomutt/bin/neomutt "$@"
