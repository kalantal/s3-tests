#!/bin/bash

s3cmd ls >bucket.list2
cat bucket.list2 | awk '{ print $3} ' bucket.list2 > bucket.list
rm bucket.list2

s3cmd la >key.list

###

aws s3 ls >input.data
awk '{print $3}' input.data > output.data
cat output.data
cat output.data | while read line ; do aws s3 rm s3://$line ; done

###

cat output.data | while read line ; do aws s3api list-objects --bucket $line --no-paginate >> list-object.log; done

for key in $(aws s3api list-objects --bucket example --no-paginate --query Contents[].Key)


if [ "$EC2_REGION" = "us-west-2" ]; 
then BUCKET=vz-app-nts-ivav-qa-vz-app-nts-ivav-ditn1-s3bucket-s3u‌​‌​ca5imooh 
for key in $(aws s3api list-objects --bucket BUCKET --no-paginate --query Contents[].Key) 
else BUCKET=vz-app-nts-ivav-dev-vz-ivav-nts-1991-dev-s3bucket-11o‌​‌​f49nc4qhem fi

###

nuke_s3_bucket.py bucket-name-goes-here

###

s3cmd ls >bucket.list2
cat bucket.list2 | awk '{ print $3} ' bucket.list2 > bucket.list
rm bucket.list2

cat bucket.list | while read line ; do python nuke_s3_bucket.py $line ; done