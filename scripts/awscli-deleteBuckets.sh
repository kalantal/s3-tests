#!/usr/bin/bash

if [ -e ~/.aws/credentials ]
        then echo -en "\ns3credentials found, continuing..\n"
        else
                echo -en "\ns3credentials not found..\n"
                exit 0
fi

export vaultlist=/tmp/s3vaultlist
export prefix=s3tests-

# Gather and clean a list of vaults
function gatherlist {
	aws s3 ls | awk '{print $3}' | grep $prefix > $vaultlist
}
gatherlist && echo -en '\nLsit of vaults:\n' && cat $vaultlist

echo -en '\nDeleting items\n'
function deleteitems {
# Delete items inside vaults
cat $vaultlist | while read line ; do aws --endpoint=http://mwdc-plt-obj-wip1.nam.nsroot.net s3 rm s3://$line --recursive; done
}
deleteitems

# Delete vaults after clean
echo -en '\nDeleting vaults\n'
function deletevaults {
cat $vaultlist | while read line ; do aws --endpoint=http://mwdc-plt-obj-wip1.nam.nsroot.net s3 rb s3://$line --force; done
}
deletevaults
