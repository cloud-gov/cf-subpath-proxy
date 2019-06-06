#!/bin/bash

# Set the NAMESERVER environment variable to point to a name server that can resolve apps.internal routes
export NAMESERVER="$(cat /etc/resolv.conf | head -n 1 | grep ^nameserver | cut -d ' ' -f 2)"

if [[ -z $NAMESERVER ]] ; then
    # Fall back to the Cloudflare public DNS server
    export NAMESERVER=1.1.1.1
fi

