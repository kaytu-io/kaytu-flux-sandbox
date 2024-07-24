#!/bin/bash

set -e

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
  --path=clusters/dev
