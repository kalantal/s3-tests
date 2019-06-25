#!/usr/bin/bash

source credentials

if [ -e ~/.s3cfg ]
        then echo -en "\ns3cfg found, continuing..\n"
        else
                echo -en "\ns3cfg not found..\n"
                exit 0
fi

export vaultlist=/tmp/s3vaultlist
export prefix=s3tests-

function gatherlist {
	python scripts/listObjects.py | grep $prefix > $vaultlist
}
gatherlist && echo -en '\nLsit of vaults:\n' && cat $vaultlist

echo -en '\nDeleting vaults\n\n'
# Delete vaults
function deletevaults {
cat $vaultlist | while read line ; do python scripts/s3wipe --path $line --id $id --key $key --delbucket ; done
}
deletevaults
