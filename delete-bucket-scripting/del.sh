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

aws s3 rm s3://s3-t3yook6ipl38vk66tryke9gtd3-295 --recursive