#!/usr/bin/env bash

which nomad &>/dev/null || {

  which curl wget unzip jq &>/dev/null || {
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install --no-install-recommends -y curl wget unzip jq
  }

  #always use highest release
  NOMAD=$(curl -sL https://releases.hashicorp.com/nomad/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)


  wget -q -O /tmp/nomad.zip https://releases.hashicorp.com/nomad/${NOMAD}/nomad_${NOMAD}_linux_amd64.zip
  unzip -d /usr/local/bin /tmp/nomad.zip
}

sudo mkdir -p /etc/nomad.d
sudo cp /vagrant/conf/nomad.service /etc/systemd/system/nomad.service
sudo cp /vagrant/conf/nomad_server.hcl /etc/nomad.d/server.hcl
sudo systemctl enable nomad.service
sudo systemctl start nomad.service