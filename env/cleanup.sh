#!/bin/bash

for node in lb0 lb1 consul-server0 consul-server1 consul-server2 consul-client1 consul-client0; do
    echo "remove vm: $node"
    virsh destroy $node
    virsh undefine $node
done


echo "remove storage pool"
virsh pool-destroy vms
rm -rf tmp/*

virsh net-destroy testcase
virsh net-undefine testcase
