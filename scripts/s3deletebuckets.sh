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
	s3cmd ls | awk '{print $3}' | grep $prefix > $vaultlist
}
gatherlist && echo -en '\nLsit of vaults:\n' && cat $vaultlist

echo -en '\nDeleting items\n'
function deleteitems {
#delete items inside vaults
cat $vaultlist | while read line ; do s3cmd del --recursive --force $line ; done
}
deleteitems

#delete vaults
echo -en '\nDeleting vaults\n'
function deletevaults {
        cat $vaultlist | while read line ; do s3cmd rb --recursive --force $line ; done
}
deletevaults

gatherlist
