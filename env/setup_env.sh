#!/bin/bash

apt-get install -y virtinst libvirt-bin genisoimage python-virtualenv kvm curl openssl \
    && rm -rf ../venv/ansible-2.6 && virtualenv ../venv/ansible-2.6 \
    && source ../venv/ansible-2.6/bin/activate \
    && pip install ansible==2.6
