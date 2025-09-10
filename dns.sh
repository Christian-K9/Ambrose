#!/bin/bash
read -p "Server Or Client? [s/c]: " machine_type
if [ "$machine_type" = "s" ]; then
        sudo systemctl enable named
        sudo systemctl start named
        read -p "Enter Network ID: " network_id
        read -p "Enter Host Identifier: " machine_ip
        fq_ip="${network_id}.${machine_ip}"
        server=$((num + 10))
        full_rev_zone="$(echo "$network_id" | awk -F. '{print $3"."$2"."$1}').in-addr.arpa"
        #named.conf file
        sudo cp /etc/bind/named.conf original_named.conf
        sudo cp named.conf /etc/bind/named.conf
        #named.conf.options file
        sudo cp /etc/bind/named.conf.options original_named.conf.options
        sudo cp named.conf.options /etc/bind/named.conf.options
        #named.conf.local file
        sudo tee -a named.conf.local >/dev/null <<ENDZONE
zone "$full_rev_zone" {
        type master;
        file "/etc/bind/db.$full_rev_zone";
};
ENDZONE
        sudo cp /etc/bind/named.conf.local original_named.conf.local
        sudo cp named.conf.local /etc/bind/named.conf.local
        #named.conf.default-zones file
        sudo cp /etc/bind/named.conf.default-zones original_named.conf.default-zones
        sudo cp named.conf.default-zones /etc/bind/named.conf.default-zones
        #db.ccdc.local file
        sudo tee -a db.ccdc.local >/dev/null <<ENDZ
@       IN      NS      ns1.ccdc.local.
ns1     IN      A       $fq_ip
srv     IN      A       $network_id.server
ENDZ
        cp db.ccdc.local /etc/bind/db.ccdc.local
        #db.network_id
        sudo touch db.$network_id
        sudo cp db_default db.$network_id
        cp db.$network_id /etc/bind/db.$network_id
        sudo systemctl restart named
fi





