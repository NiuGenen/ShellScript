#!/bin/bash

FILENAME=$1
SAVEDIR=$2

if [ -z $SAVEDIR ]; then
    SAVEDIR=./gitlogsave
fi
if [ -x $SAVEDIR ]; then
    now=`date +%y%m%d%H%M%S%N`
    SAVEDIR=${SAVEDIR}$now
fi
mkdir $SAVEDIR

echo   "|||||||||||||||||||||||||||||||||||||||"
printf "||| Find All Git Log ||| %-10s \n" $FILENAME
echo   "|||||||||||||||||||||||||||||||||||||||"
printf "||| Save To This Dir ||| %-10s \n" $SAVEDIR
echo   "|||||||||||||||||||||||||||||||||||||||"

TMPLOG=/tmp/gitlog.tmp

git log $FILENAME > $TMPLOG
if [ $? -ne 0 ]; then
    echo "[GITLOG] git log error : maybe this file not exist in this repository."
    exit
fi
FNAME=${FILENAME##*/}

COMMIT=""
next_is_commit=0
first=1
count=1

for word in `cat $TMPLOG`
do
    if [ $next_is_commit -eq 1 ]; then
        COMMIT=$word
        next_is_commit=0
    fi
    if [ $word == "commit" ]; then
        next_is_commit=1
        if [ $first -ne 1 ]; then
            printf "\n" 
            read -n1 -p "[GITLOG] save and goon [y/n]:" tostop
            if [ $tostop == "n" ]; then
                break
            fi
            `touch $SAVEDIR/$FNAME.$count.gitlog`
            `git show $COMMIT $FILENAME > $SAVEDIR/$FNAME.$count.gitlog`
            count=$(($count+1))
        fi
        first=0
        printf "\n\n[GITLOG] find git log\n"
    fi
    if [ $word == "Author:" -o $word == "Date:" ]; then
        printf "\n"
    fi
    printf "%s " $word
done
