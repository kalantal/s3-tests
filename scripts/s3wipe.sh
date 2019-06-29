#!/usr/bin/bash

source cleanupKeys
export vaultlist=/tmp/vaultlist
export prefix=s3tests-

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
# Delete vaults
function deletevaults-hc {
  cat $vaultlist | while read line ; do python scripts/s3wipe-hc --path $line --id $id --key $key --delbucket ; done
}

function deletevaults {
  cat $vaultlist | while read line ; do python scripts/s3wipe --path $line --id $id --key $key --delbucket ; done
}

if [ `whoami` != 'root' ]
  then deletevaults-hc
  else deletevaults
fi

echo

exit 0
