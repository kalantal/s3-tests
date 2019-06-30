#!/usr/bin/bash

export objectList=/tmp/objectList
export bucketList=/tmp/bucketList
export notDeleted=/tmp/notDeleted

if [ ! -f ~/.aws/credentials ]; then
	./scripts/buildKeys.sh
    cp credentials ~/.aws/credentialsd
fi

python scripts/python/s3objects.py > $objectList
echo -en "List of objects:\n"
cat $objectList


function deleteObjects {
  cat $objectList | while read -r line ; do s3cmd del --recursive --force "$line" -v ; done
}
echo -en "\nDeleting objects:\n"
deleteObjects

python scripts/python/s3buckets.py > $bucketList
echo -en "\nList of Buckets:\n"
cat $bucketList

function deleteBuckets {
  cat $bucketList | while read -r line ; do s3cmd rb --recursive --force "$line" -v ; done
}
echo -en "\nDeleting buckets:\n"
deleteBuckets

python scripts/python/s3list.py > $notDeleted
echo -en "\nRemaining items and buckets\n"
cat $notDeleted

echo

exit 0
