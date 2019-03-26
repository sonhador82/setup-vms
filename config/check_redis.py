#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

import redis
import ifaddr
import sys

def get_host_ips():
    ips = []
    interfaces = ifaddr.get_adapters()
    for iface in interfaces:
        for ip in iface.ips:
            ips.append(ip.ip)
    return ips


def check_instance_state(host, port=6379):
    ping = False
    try:
        r = redis.Redis(host=host, port=port, socket_connect_timeout=3)
        ping = r.ping()
    except redis.RedisError as e:
        pass
    return ping


def check_states(redises):
    result = dict()
    for inst in redises:
        state = check_instance_state(inst['host'])
        redis_instance = {
            inst['name']: {
                'host': inst['host'],
                'state': state
            }
        }
        result.update(redis_instance)
    return result


if __name__ == '__main__':
    ips = get_host_ips()
    redises = [
        {
            "name": "redis0",
            "host": "10.0.1.20"
        },
        {
            "name": "redis1",
            "host": "10.0.1.21"
        }
    ]
    states = check_states(redises)
    # all up
    if states['redis0']['state'] and states['redis1']['state']:
        if states['redis0']['host'] in ips:
            sys.exit()
        else:
            sys.exit(2)

    # 0 is up
    if states['redis0']['state']:
        if states['redis0']['host'] in ips:
            sys.exit()
        else:
            sys.exit(2)

    # only redis1 is up
    if not states['redis0']['state'] and states['redis1']['state']:
        if states['redis1']['host'] in ips:
            sys.exit()
        else:
            sys.exit(2)

    # all down
    sys.exit(2)
