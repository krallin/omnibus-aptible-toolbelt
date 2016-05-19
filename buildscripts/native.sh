#!/bin/bash
set -o errexit
set -o nounset
set -o xtrace

# This uses sudo ... $(which)  everywhere to ensure we use the right Ruby
# despite the fact that Ruby on Travis comes from RVM and isn't necessarily
# going to be on the PATH.
sudo "$(which ruby)" "$(which bundle)" install --without development --binstubs /binstubs
sudo env "DOCKER_TAG=${DOCKER_TAG:-native}" "$(which ruby)" /binstubs/omnibus build aptible-toolbelt

# Smoke test
time /opt/aptible-toolbelt/bin/aptible version
