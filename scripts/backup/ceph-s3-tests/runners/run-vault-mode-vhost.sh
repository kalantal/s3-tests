#!/bin/bash
S3_DO_PER_TEST_CLEANUP=true ./runtests.sh --with-blacklist \
    --blacklist-file=blacklists/general-blacklist.txt \
    --blacklist-file=blacklists/vault-blacklist.txt \
    --blacklist-file=blacklists/vhost-blacklist.txt \
    $@