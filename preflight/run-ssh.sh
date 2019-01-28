#!/bin/bash

# Reload configuration
source /config.saved

if [[ "" != "$PHABRICATOR_HOST_KEYS_PATH" && -d $PHABRICATOR_HOST_KEYS_PATH ]]; then
  cp -v $PHABRICATOR_HOST_KEYS_PATH/* /etc/ssh/
  #ensure correct file modes of private keys
  chmod 600 /etc/ssh/ssh_host_{dsa_,ecdsa_,ed25519_,,rsa_}key
  #generate missing keys --> sshd needs sometimes more keys for newer protocols
  /usr/sbin/sshd-gen-keys-start
  mkdir -pv $PHABRICATOR_HOST_KEYS_PATH
  #copy only when the file does not exist
  cp -vn /etc/ssh/ssh_host_{dsa_,ecdsa_,ed25519_,,rsa_}key{,.pub} $PHABRICATOR_HOST_KEYS_PATH/
fi

# Run SSHD
exec /usr/sbin/sshd -D -f /etc/phabricator-ssh/sshd_config.phabricator
