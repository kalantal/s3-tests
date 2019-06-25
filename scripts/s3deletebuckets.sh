#!/usr/bin/bash

if [ -e ~/.s3cfg ]
        then echo -en "\ns3cfg found, continuing..\n"
        else
                echo -en "\ns3cfg not found..\n"
                exit 0
fi

export vaultlist=/tmp/s3vaultlist
export prefix=s3tests-

function gatherlist {
	python listObjects.py | grep $prefix > $vaultlist
}
gatherlist && echo -en '\nLsit of vaults:\n' && cat $vaultlist

echo -en '\nDeleting items\nWarnings will appear for vaults that do not have items.\n\n'
# Delete items inside vaults
function deleteitems {
cat $vaultlist | while read line ; do s3cmd del --recursive --force $line ; done
}
deleteitems

echo -en '\nDeleting vaults\n'
# Delete vaults
function deletevaults {
        cat $vaultlist | while read line ; do s3cmd rb --recursive --force $line ; done
}
deletevaults
