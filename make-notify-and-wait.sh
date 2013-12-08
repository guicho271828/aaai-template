#! /bin/bash

message=$(make $@ 2>&1)
success=$?

errors=$(echo "$message" | grep -E "(Error|!)" | sort -u)
warnings=$(echo "$message" | grep -E "Warning" | sort -u)
overfull=$(echo "$message" | grep -E "Overfull" | sort -u)

if [ $success = 0 ]
then
    notify-send -t 1 "TeX Success!" "$warnings $overfull"
else
    notify-send -t 1 "TeX fail!" "$warnings $overfull $errors"
fi

echo "$message" > make.log
inotifywait -r -e modify . --exclude "\.svn/.*"
