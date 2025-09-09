#!/bin/bash
read -p "Server Or Client? [s/c]: " machine_type
if [ "$machine_type" = "s" ]; then
        sudo systemctl enable named
        sudo systemctl start named
        read -p "Enter Network ID: " network_id
        read -p "Enter Host Identifier: " machine_ip
        fq_ip="${network_id}.${machine_ip}"
        server=$((num + 10)
        full_rev_zone="$(echo "$network_id" | awk -F. '{print $3"."$2"."$1}').in-addr.arpa"
        #named.conf.local file
        sudo tee -a named.conf.local >/dev/null <<ENDZONE
        zone "$full_rev_zone" {
                type master;
                file "/etc/bind/db.$network_id";
        };
ENDZONE

        cp named.conf /etc/bind/named.conf
        #db.ccdc.local file
        sudo tee -a db.ccdc.local >/dev/null <<ENDZ
        ns1     IN      A       $fq_ip
        srv     IN      A       $network_id.server
ENDZ
        cp db.ccdc.local /etc/bind/db.ccdc.local
        sudo tee -a /db.$network_id >/dev/null <<EOF
        $machine_ip     IN      PTR     ns1.ccdc.local.
        $machine_ip     IN      PTR     srv.ccdc.local.
EOF
fi
~
(END)
