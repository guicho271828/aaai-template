#! /bin/bash


make $@ 2>&1 | tee make.log
success=$?
message=$(cat make.log)

errors=$(echo "$message" | grep -E "(Error|!)" | sort -u)
warnings=$(echo "$message" | grep -E "Warning" | sort -u)
overfull=$(echo "$message" | grep -E "Overfull" | sort -u)

if [ $success = 0 ]
then
    notify-send -t 1 "TeX Success!" "$warnings $overfull"
else
    notify-send -t 1 "TeX fail!" "$warnings $overfull $errors"
fi

# ignore *.log, which is problematic when multiple calls to make-notify-and-wait occured. 
inotifywait -r -e modify . --exclude "\.git/.*" --exclude "\.svn/.*" --exclude ".*\.log"
