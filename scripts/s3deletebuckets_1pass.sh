#!/usr/bin/bash

#delete all s3 test framework vaults ("s3-" or $prefix)

echo -en '\nThis script will attempt to purge any vaults with the specified prefix\n'

#verify configuration
#requires configured s3cmd
if [ -e ~/.s3cfg ]
        then echo -en "\ns3cfg found, continuing..\n"
        else
                echo -en "\ns3cfg not found..\n"
                exit 0
fi

#Variables
export vaultlist_=/tmp/s3vaultlist_
export vaultlist=/tmp/s3vaultlist
export logfile=/tmp/s3deletelog
export itemlist_=/tmp/s3itemlist_
export itemlist=/tmp/s3itemlist

#needs .s3cfg, an admin name, and a prefix
export admin=justin_restivo
export prefix=s3tests-

function gatherlist {
s3cmd ls > $vaultlist_
#delete the unnessecay prefix to give us an easy to read vault list
#removes the first 18 characters from every line
#remove any lines that do not have our test suite prefix: "s3-" or $prefix
sed -ri 's .{18}  ' $vaultlist_
cat $vaultlist_ | grep $prefix &> $vaultlist
#sed -ri '/$prefix/!d' $vaultlist
}
gatherlist && echo -en '\nLsit of vaults:\n' && cat $vaultlist

#make sure the logfile is clear
#not used right now
#echo > $logfile
#&>>$logfile

#first pass
#delete all vaults that do not have 1) items inside. 2) versions inside. 3) ACLs
echo -en '\nDeleting vaults\n'
function deletevaults {
        cat $vaultlist | while read line ; do s3cmd rb --recursive --force $line ; done
}
deletevaults
