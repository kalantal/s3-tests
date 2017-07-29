#!/usr/bin/bash
 
#list all vaults in Cleversafe Dev
#delete all s3 test framework vaults ("s3-")
#need to make testing prefix more complex/random
#this is intentionally iterative to speed up the process
 
echo -en '\nThis script will attempt to purge any vaults with the specified prefix\n'
 
#verify configuration
#requires configured s3cmd
if [ -e ~/.s3cfg ]
        then echo -en "\ns3cfg found, continuing..\n"
        else
                echo -en "\ns3cfg not found..\n"
                exit 0
fi
 
#assumes s3cmd moved to /opt/
cd /opt/s3cmd/
 
#Variables
#export s3cmd=/bin/s3cmd
#export s3cmd=./s3cmd
export vaultlist=/tmp/s3vaultlist
export logfile=/tmp/s3deletelog
export itemlist=/tmp/s3itemlist
export admin=justin_restivo
#export prefix=~/.s3cfg line 2 "s3-"
#export prefix=s3-
 
 
function gatherlist {
./s3cmd ls > $vaultlist
#delete the unnessecay prefix to give us an easy to read vault list
#removes the first 18 characters from every line
#remove any lines that do not have our test suite prefix: 's3-'
sed -ri 's .{18}  ' $vaultlist
sed -ri '/s3-/!d' $vaultlist
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
        cat $vaultlist | while read line ; do ./s3cmd rb $line ; done
}
deletevaults
 
function itemlist {
./s3cmd la > $itemlist
#clean up itemlist
#delete the unnessecay prefix to give us an easy to read vault list
#removes the first 18 characters from every line
#remove any lines that do not have our test suite prefix: 's3-'
sed -ri '/^\s*$/d' $itemlist
sed -ri '/s3-/!d' $itemlist
sed -ri 's .{29}  ' $itemlist
}
itemlist && echo -en '\nLsit of vaults containing keys:\n' && cat $itemlist && echo -en '\n'
 
echo -en '\nDeleting items\n'
function deleteitems {
#second pass
#delete vaults with items inside
#clean up vaults with items inside
cat $itemlist | while read line ; do ./s3cmd del --recursive --force $line ; done
}
deleteitems
deletevaults
 
echo -en '\nRunning vaultfix\n'
function vaultfix {
#third pass
#move broken keys to new vault for deletion
#attempt a vaultfix
cat $itemlist | while read line ; do ./s3cmd fixbucket --recursive --force $line ; done
}
vaultfix
 
echo -en '\nMoving empty objects\n'
function emptyfiles {
#make a temp vault to move empty files
./s3cmd mb s3://s3delete
cat $itemlist | while read line ; do ./s3cmd mv $line s3://s3delete --recursive --force ; done
#remove the temp vault
./s3cmd rb s3://s3delete --recursive --force
}
emptyfiles
 
echo -en '\nSetting ACLs\n'
function acls {
#fourth pass
#add access to delete vaults with ACLs
#should be a superadmin account, not justin_Restivo
cat $vaultlist | while read line ; do ./s3cmd setacl --recursive --force --acl-grant=full_control:$admin $line ; done
cat $itemlist | while read line ; do ./s3cmd setacl --recursive --force --acl-grant=full_control:$admin $line ; done
}
acls
 
#delete all vaults again
echo -en '\nDeleting vaults\n'
deletevaults
 
gatherlist && echo -en '\nLsit of vaults:\n' && cat $vaultlist && echo -en '\nDone\n\n'
 
exit 0