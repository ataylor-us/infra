#!/bin/bash
HOSTNAME=laptop
FORMULAE="ansible pass git"
setupHombrew () {
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
setupAnsible () {
	/opt/homebrew/bin/brew install $FORMULAE
}
setupRosetta () {
	softwareupdate --install-rosetta --agree-to-license
}
setupHostname () {
	sudo scutil --set HostName "$HOSTNAME"
}
setupHombrew
setupAnsible
setupRosetta
setupHostname
