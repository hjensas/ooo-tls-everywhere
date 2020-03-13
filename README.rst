ooo-bp-tripleo-routed-networks-templates-testing
================================================

Set up OVB environment
----------------------

::

  mkdir ~/ovb-lab-freeipa
  virtualenv ~/ovb-lab-freeipa
  source ~/ovb-lab-freeipa/bin/activate
  git clone https://opendev.org/openstack/openstack-virtual-baremetal.git ~/ovb-lab-freeipa/openstack-virtual-baremetal
  pip install ~/ovb-lab-freeipa/openstack-virtual-baremetal
  pip install python-openstackclient
  pip install ansible
  git clone https://github.com/hjensas/ooo-tls-everywhere.git ~/ovb-lab-freeipa/ooo-tls-everywhere
  cp ~/ovb-lab-freeipa/ooo-tls-everywhere/ovb/* ~/ovb-lab-freeipa/openstack-virtual-baremetal/

Set up OVB routed-networks lab
------------------------------

The OVB environment files expect:
 - A pre-existing private network to be available in the tenant.
   This network also need to be connected to a router with a connection
   to the external network.
 - A key, key_name: default must exist

  .. NOTE:: Source the cloud RC file first

::

  cd ~/ovb-lab-freeipa/openstack-virtual-baremetal/
  bash ~/ovb-lab-freeipa/openstack-virtual-baremetal/deploy_ovb.sh


