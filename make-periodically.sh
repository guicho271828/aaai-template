#! /bin/bash

watch -d -n 4 --color "./make-notify-and-wait.sh $@"

# if make fails, retry after 2 sec
# on success, retry after 45 sec
