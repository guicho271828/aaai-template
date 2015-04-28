#! /bin/bash

# watch -d -n 4 --color "./make-notify-and-wait.sh $@"

# if make fails, retry after 2 sec
# on success, retry after 45 sec

while true
do
    ./make-notify-and-wait.sh $@
    sleep 1.5
done
