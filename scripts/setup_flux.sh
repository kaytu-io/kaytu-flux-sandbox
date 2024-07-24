#!/bin/bash

export GITHUB_TOKEN="<value>"

set -e

if [[ -f scripts/vars.sh ]]; then
  source scripts/vars.sh
fi

FLUX=$(which flux || echo -n "")
if [[ -z $FLUX ]]; then
  curl -s https://fluxcd.io/install.sh | sudo bash
fi

flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --owner=kaytu-io \
  --repository=kaytu-flux \
  --branch=main \
  --path=clusters/dev \
  --token-auth
