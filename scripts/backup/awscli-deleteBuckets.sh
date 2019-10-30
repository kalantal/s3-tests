#!/usr/bin/bash

export vaultlist=/tmp/vaultlist
export prefix=s3tests-

if [ ! -e ~/.aws/credentials ]
  then echo -en "\nsaws credentials not found, exiting.\n"
  exit 0             
fi

# Gather and clean a list of vaults
function gatherlist {
  aws --endpoint=http://mwdc-plt-obj-wip1.nam.nsroot.net s3 ls | awk '{print $3}' | grep $prefix > $vaultlist
}
gatherlist && echo -en '\nLsit of vaults:\n' && cat $vaultlist

# Delete vaults after clean
echo -en '\nDeleting vaults\n'
function deletevaults {
  cat $vaultlist | while read -r line ; do aws --endpoint=http://mwdc-plt-obj-wip1.nam.nsroot.net s3 rb s3://"$line" --recursive --force; done
}
deletevaults

echo
exit 0
