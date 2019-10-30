#!/usr/bin/bash

export vaultList=/tmp/vaultList
export prefix=s3tests-

if [ ! -f ~/.s3cfg ]; then
	echo "s3cmd not found, exiting" && exit 0
fi

function gatherlist-vaults {
  s3cmd ls | awk '{print $3}' | grep $prefix > $vaultList
}
gatherlist-vaults
echo -en '\nLsit of vaults:\n'
cat $vaultList

echo -en '\nDeleting vaults:\n'
function deletevaults {
  cat $vaultList | while read -r line ; do s3cmd rb --recursive --force "$line" -v ; done
}
deletevaults

echo
exit 0
