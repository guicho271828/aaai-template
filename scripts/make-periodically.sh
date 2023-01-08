#! /bin/bash

# watch -d -n 4 --color "./make-notify-and-wait.sh $@"

# if make fails, retry after 2 sec
# on success, retry after 45 sec

dir=$(dirname $(readlink -ef $0))

while true
do
    bash $dir/make-notify-and-wait.sh $@
    sleep 1.5
done
