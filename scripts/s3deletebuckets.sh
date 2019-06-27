#!/usr/bin/bash

export vaultlist=/tmp/vaultlist
export prefix=s3tests-

if [ -e ~/.s3cfg ]
  then echo -en "\ns3cfg found, continuing..\n"
  else
    echo -en "\ns3cfg not found..\n"
    exit 0
fi

function gatherlist {
  s3cmd ls | awk '{print $3}' | grep $prefix > $vaultlist
}
gatherlist && echo -en '\nLsit of vaults:\n' && cat $vaultlist

echo -en '\nDeleting items:\n'
# Delete items inside vaults
function deleteitems {
  cat $vaultlist | while read line ; do s3cmd del --recursive --force $line ; done
}
deleteitems

echo -en '\nDeleting vaults:'
# Delete vaults
function deletevaults {
  cat $vaultlist | while read line ; do s3cmd rb --recursive --force $line ; done
}
deletevaults
