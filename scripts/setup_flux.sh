#!/bin/bash

set -e
set -x

read -p "Path of ssh key to use for git (read and write access required): " -r
echo

KEY_FILE="$REPLY"

SSH_KEY_ALGORITHM="ecdsa"
read -p "SSH Key algorithm (rsa, ecdsa or ed25519, default: ecdsa): " -r
echo

if [[ ! -z "$REPLY" ]]; then
  SSH_KEY_ALGORITHM="$REPLY"
fi

if [[ -f scripts/vars.sh ]]; then
  source scripts/vars.sh
fi

FLUX=$(which flux || echo -n "")
if [[ -z $FLUX ]]; then
  curl -s https://fluxcd.io/install.sh | sudo bash
fi

flux bootstrap git \
  --components-extra=image-reflector-controller,image-automation-controller \
  --url=ssh://git@github.com/kaytu-io/kaytu-flux.git \
  --branch=main \
  --recurse-submodules \
  --path=clusters/dev \
  --private-key-file="$KEY_FILE" \
  --ssh-key-algorithm=$SSH_KEY_ALGORITHM
