#!/usr/bin/bash

if [ -e ~/.aws/credentials ]
        then echo -en "\ns3credentials found, continuing..\n"
        else
                echo -en "\ns3credentials not found..\n"
                exit 0
fi

export vaultlist=/tmp/s3vaultlist
export prefix=s3tests-

function gatherlist {
	aws --endpoint=http://mwdc-plt-obj-wip1.nam.nsroot.net s3  ls | awk '{print $3}' | grep $prefix > $vaultlist
}
gatherlist && echo -en '\nLsit of vaults:\n' && cat $vaultlist

echo -en '\nDeleting vaults\n'
function deletevaults {
cat $vaultlist | while read line ; do aws --endpoint=http://mwdc-plt-obj-wip1.nam.nsroot.net s3 rb s3://$line ; done
}
deletevaults
