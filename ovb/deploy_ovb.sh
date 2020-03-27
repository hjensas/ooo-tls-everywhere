# Deploy ovb lab
./bin/deploy.py \
	--env env-tls-lab.yaml \
	--quintupleo \
	--env environments/all-networks.yaml \
	--env env-custom-registry.yaml \
	--role env-freeipa.yaml \
	--poll

# Build nodes json
./bin/build-nodes-json \
	--env env-tls-lab.yaml

OVB_UNDERCLOUD=$(openstack stack show quintupleo -f json -c outputs | jq '.outputs[0].output_value' | sed s/'"'//g)
# OVB_UNDERCLOUD_PUBLIC=$(openstack server show undercloud -f json -c addresses | jq '.addresses' | sed s/.*public=// | sed s/\"//)
OVB_UNDERCLOUD_PUBLIC=10.0.0.4
FREEIPA=$(openstack server show baremetal-extra_0 -f json |  jq '.addresses' | awk '{ print $3 }' | sed s/\;//)
FREEIPA_CTLPLANE=192.168.24.5
OVB_UNDERCLOUD_CTLPLANE=192.168.24.1
IPA_PASSWORD=$(uuidgen)
cat << EOF > inventory.ini
[all:children]
undercloud
freeipa

[undercloud]
$OVB_UNDERCLOUD ansible_user=centos ansible_ssh_extra_args='-o StrictHostKeyChecking=no' undercloud_public_ip=$OVB_UNDERCLOUD_PUBLIC
[freeipa]
$FREEIPA ansible_user=centos ansible_ssh_extra_args='-o StrictHostKeyChecking=no' ctlplane_ip=$FREEIPA_CTLPLANE

[all:vars]
freeipa_ip=$FREEIPA_CTLPLANE
undercloud_ip=$OVB_UNDERCLOUD_CTLPLANE
ipa_password=$IPA_PASSWORD
EOF

ansible-playbook -i inventory.ini ../ooo-tls-everywhere/playbooks/ssh_hardening.yaml

scp -o StrictHostKeyChecking=no nodes-no-profile.json centos@$OVB_UNDERCLOUD:~/instackenv.json

DEPLOY_FREEIPA="ansible-playbook -i inventory.ini ../ooo-tls-everywhere/playbooks/deploy_freeipa.yaml"
DEPLOY_UNDERCLOUD="ansible-playbook -i inventory.ini ../ooo-tls-everywhere/playbooks/deploy_undercloud.yaml"
DEPLOY_OVERCLOUD="Log into undercloud ($OVB_UNDERCLOUD) and run command: bash ~/overcloud/deploy_overcloud.sh"
echo "###############################################"
echo -e "Undercloud floating IP:\n\t$OVB_UNDERCLOUD"
echo -e "Deploy FreeIPA:\n\t$DEPLOY_FREEIPA"
echo -e "Deploy undercloud:\n\t$DEPLOY_UNDERCLOUD"
echo -e "Deploy overcloud:\n\t$DEPLOY_OVERCLOUD"
echo "###############################################"

