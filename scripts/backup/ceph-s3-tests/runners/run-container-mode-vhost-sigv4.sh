#!/bin/bash
S3_USE_SIGV4=true ./runtests.sh --with-blacklist \
    --blacklist-file=blacklists/general-blacklist.txt \
    --blacklist-file=blacklists/container-blacklist.txt \
    --blacklist-file=blacklists/vhost-blacklist.txt \
    -a auth_aws4 \
    $@