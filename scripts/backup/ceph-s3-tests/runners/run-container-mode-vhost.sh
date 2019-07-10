#!/bin/bash
./runtests.sh --with-blacklist \
    --blacklist-file=blacklists/general-blacklist.txt \
    --blacklist-file=blacklists/container-blacklist.txt \
    --blacklist-file=blacklists/vhost-blacklist.txt \
    $@