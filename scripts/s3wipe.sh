#!/usr/bin/bash

source cleanupKeys.cfg

export vaultlist=/tmp/s3vaultlist
export prefix=s3tests-

echo -en '\nDeleting Vaults with prefix:' $prefix

function gatherlist {
	s3cmd ls | awk '{print $3}' | grep $prefix > $vaultlist
}
gatherlist 
echo -en '\nLsit of vaults:\n' 
cat $vaultlist
echo -en '\n'

function deletevaults {
	cat $vaultlist | while read line ; do python s3wipe --path $line --id $id --key $key --delbucket ; done
}
deletevaults

echo -en '\n'
gatherlist 
echo -en '\nLsit of vaults:\n'
cat $vaultlist
echo -en '\n'
