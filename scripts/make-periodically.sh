#! /bin/bash

#
# Invokes make-notify-and-wait indefinitely.
#

dir=$(dirname $(readlink -ef $0))

while true
do
    bash $dir/make-notify-and-wait.sh $@
    sleep 1.5
done
