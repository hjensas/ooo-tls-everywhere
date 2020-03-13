#!/bin/bash

source /home/centos/stackrc
cd /home/centos

openstack overcloud deploy --templates /home/centos/tripleo-heat-templates \
  -n /home/centos/overcloud/templates/network_data.yaml \
  -r /home/centos/overcloud/templates/roles_data.yaml \
  -e /home/centos/tripleo-heat-templates/environments/enable-swap.yaml \
  -e /home/centos/tripleo-heat-templates/environments/ssl/enable-internal-tls.yaml \
  -e /home/centos/tripleo-heat-templates/environments/ssl/tls-everywhere-endpoints-dns.yaml \
  -e /home/centos/overcloud/environments/node_data.yaml \
  -e /home/centos/tripleo-heat-templates/environments/network-isolation.yaml \
  -e /home/centos/tripleo-heat-templates/environments/network-environment.yaml \
  -e /home/centos/tripleo-heat-templates/environments/net-multiple-nics.yaml \
  -e /home/centos/overcloud/environments/network-environment-overrides.yaml 

#   -e /home/centos/tripleo-heat-templates/environments/services/haproxy-public-tls-certmonger.yaml \
