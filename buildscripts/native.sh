#!/bin/bash
set -o errexit
set -o nounset
set -o xtrace

# Travis uses rvm, which toys with environment variables enough that it's hard
# to use properly with sudo. So, if rvmsudo is in use, we'll use rvmsudo rather
# than regular sudo.
SUDO="sudo"
if [[ -n "${rvm_path:-}" ]]; then
  echo "Detected rvm: ${rvm_path}"
  SUDO="rvmsudo"
fi

echo "Using SUDO=${SUDO}"

echo "gem env"
gem env

echo "${SUDO} gem env"
"$SUDO" gem env

echo "${SUDO} bundle install"
"$SUDO" bundle install --without development --binstubs /binstubs

echo "${SUDO} build"
"$SUDO" env "DOCKER_TAG=${DOCKER_TAG:-native}" ruby /binstubs/omnibus build aptible-toolbelt

# Smoke test
time /opt/aptible-toolbelt/bin/aptible version
