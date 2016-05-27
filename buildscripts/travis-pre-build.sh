#!/bin/bash
set -o errexit
set -o nounset

if [[ "$TRAVIS_OS_NAME" == "osx" ]] && [[ "$TRAVIS_SECURE_ENV_VARS" = "true" ]]; then
  openssl aes-256-cbc -K "$encrypted_02b73d51c278_key" -iv "$encrypted_02b73d51c278_iv" -in signing/secrets.tar.enc -out signing/secrets.tar -d
  unset "encrypted_02b73d51c278_key"
  unset "encrypted_02b73d51c278_iv"
  ( cd signing && tar xvf secrets.tar )
  sudo buildscripts/osx-load-signing.sh
fi
