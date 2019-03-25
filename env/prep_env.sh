#!/bin/bash


# добавиьт проверку на флажок виртаулизации и нестинга
# curl presents
# libvirt virsh openssl 
# добавить qemu: system в дефолтный connector

#network 10.0.0.1
BASE_DIR=$(dirname $(realpath $0))
if [ ! -d $BASE_DIR/tmp ]; then mkdir $BASE_DIR/tmp; fi

prepare () {
    curl -C - -o $BASE_DIR/tmp/base_image.qcow2 https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
}

setup_virt_network () {
    virsh net-create ${BASE_DIR}/templates/network.xml
}

setup_virt_pool () {
    virsh pool-create-as --name vms --type dir --target $BASE_DIR/tmp
}


setup_virt_images () {
    virsh vol-create-as vms nginx-1.qcow2 5G --format qcow2 --backing-vol base_image.qcow2 --backing-vol-format qcow2
    virsh vol-create-as vms nginx-2.qcow2 5G --format qcow2 --backing-vol base_image.qcow2 --backing-vol-format qcow2
}

setup_vms_nginx () {
    for i in {0..1}; do
        virsh vol-create-as vms lb$i.qcow2 5G --format qcow2 --backing-vol base_image.qcow2 --backing-vol-format qcow2
        virt-install -n lb$i --boot hd --memory 512 --vcpus 1 --network network=testcase,model=virtio --graphics=vnc --disk vol=vms/lb$i.qcow2,bus=virtio --virt-type kvm --disk tmp/lb$i-config.iso,device=cdrom,bus=virtio --memballoon model=virtio --noautoconsole --os-variant ubuntu16.04
    done
}

setup_vms_consul_server () {
    for i in {0..2}; do
      virsh vol-create-as vms consul-server$i.qcow2 5G --format qcow2 --backing-vol base_image.qcow2 --backing-vol-format qcow2
      virt-install -n consul-server$i --boot hd --memory 512 --vcpus 1 --network network=testcase,model=virtio --graphics=vnc --disk vol=vms/consul-server$i.qcow2,bus=virtio --virt-type kvm --disk tmp/consul-server$i-config.iso,device=cdrom,bus=virtio --memballoon model=virtio --noautoconsole --os-variant ubuntu16.04
    done
}

setup_vms_consul_agents() {
    for i in {0..1}; do
      virsh vol-create-as vms consul-client$i.qcow2 5G --format qcow2 --backing-vol base_image.qcow2 --backing-vol-format qcow2
      virt-install -n consul-client$i --boot hd --memory 512 --vcpus 1 --network network=testcase,model=virtio --graphics=vnc --disk vol=vms/consul-client$i.qcow2,bus=virtio --virt-type kvm --disk tmp/consul-client$i-config.iso,device=cdrom,bus=virtio --memballoon model=virtio --noautoconsole --os-variant ubuntu16.04
    done
}

prepare
setup_virt_network
setup_virt_pool
setup_vms_nginx
setup_vms_consul_server
setup_vms_consul_agents
