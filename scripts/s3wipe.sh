#!/usr/bin/bash

export vaultlist=/tmp/vaultlist
export prefix=s3tests-
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-bundle.crt

if [ ! -f ~/.s3cfg ]; then
	echo "s3cmd not found, exiting" && exit 0
fi

function gatherlist {
  s3cmd ls | awk '{print $3}' | grep $prefix > $vaultlist
}
gatherlist
echo -en '\nLsit of vaults:\n'
cat $vaultlist

echo -en '\nDeleting vaults:\n'
function deletevaults {
  cat $vaultlist | while read -r line ; do python scripts/s3wipe --path "$line" --id "$id" --key "$key" --delbucket ; done
}
deletevaults

echo
exit 0
