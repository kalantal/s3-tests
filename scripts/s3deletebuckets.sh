#!/usr/bin/bash

export itemList=/tmp/itemList
export vaultList=/tmp/vaultList
export prefix=s3tests-

if [ -e ~/.s3cfg ]
  then echo -en "\ns3cfg found, continuing..\n"
  else
    echo -en "\ns3cfg not found..\n"
    exit 0
fi

echo

function gatherlist-vaults {
  s3cmd ls | awk '{print $3}' | grep $prefix > $vaultList
}
gatherlist-vaults && echo -en '\nLsit of items in vaults:\n' && cat $vaultList

function gatherlist-items {
  s3cmd la | awk '{print $4}' | grep $prefix > $itemList
}
gatherlist-items && echo -en '\nLsit of items in vaults:\n' && cat $itemList

echo -en '\nDeleting items:\n'
# Delete items inside vaults
function deleteitems {
  cat $itemList | while read line ; do s3cmd del --recursive --force $line -v ; done
}
deleteitems

echo -en '\nDeleting vaults:'
# Delete vaults
function deletevaults {
  cat $vaultList | while read line ; do s3cmd rb --recursive --force $line -v ; done
}
deletevaults

echo

exit 0
