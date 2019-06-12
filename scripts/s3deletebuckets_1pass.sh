#!/usr/bin/bash

if [ -e ~/.s3cfg ]
        then echo -en "\ns3cfg found, continuing..\n"
        else
                echo -en "\ns3cfg not found..\n"
                exit 0
fi

export vaultlist_=/tmp/s3vaultlist_
export vaultlist=/tmp/s3vaultlist
export prefix=s3tests-

function gatherlist {
s3cmd ls > $vaultlist_
sed -ri 's .{18}  ' $vaultlist_
cat $vaultlist_ | grep $prefix &> $vaultlist
}
gatherlist && echo -en '\nLsit of vaults:\n' && cat $vaultlist

echo -en '\nDeleting vaults\n'
function deletevaults {
        cat $vaultlist | while read line ; do s3cmd rb --recursive --force $line ; done
}
deletevaults
