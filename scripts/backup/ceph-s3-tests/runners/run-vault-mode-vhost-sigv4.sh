#!/bin/bash
S3_USE_SIGV4=true S3_DO_PER_TEST_CLEANUP=true ./runtests.sh --with-blacklist \
    --blacklist-file=blacklists/general-blacklist.txt \
    --blacklist-file=blacklists/vhost-blacklist.txt \
    -a auth_aws4 \
    $@