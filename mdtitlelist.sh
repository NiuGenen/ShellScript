#!/bin/bash

# auto generate title list for markdown file for markdown
# input  : filename.md
# output : title list

# output example
# title 1
# - title 1.1
# - title 1.2
#   - title 1.2.1
# - title 1.3

# parameters defination
# $1 : input markdown file 
# $2 : output file, result will be printed to std if $1 is empty

MD_FILE="$1"
OUT_FILE="$2"

file_exist=0

if [ -e ${MD_FILE} ]; then
    file_exist=1
fi

if [ $file_exist -eq 0 ]; then
    echo "[ERROR] ${MD_FILE} does not exists"
    exit
fi

content=`cat ${MD_FILE} | grep ^\#`
content=(${content})
wd_nr=${#content[*]}

# echo $wd_nr

idx=0
while [ $idx -lt $wd_nr ]; do
    wd=${content[$idx]}
    if [ ${wd/\#/a} != $wd ]; then
        nr=${#wd}
        #echo "# ${nr}"

        if [ $nr -eq 1 ]; then
            echo -e "- \c"
        fi

        if [ $nr -eq 2 ]; then
            echo " "
            echo -e "    - \c"
        fi

        if [ $nr -eq 3 ]; then
            echo " "
            echo -e "        - \c"
        fi

        if [ $nr -ge 4 ]; then
            #echo $nr!!!
            idx=$(($idx+1))
            if [ $idx -ge $wd_nr ]; then
                exit
            fi
            w=${content[$idx]}
            while [ ${w/\#/a} == $w ]; do
                idx=$(($idx+1))
                    if [ $idx -ge $wd_nr ]; then
                        exit
                    fi
                w=${content[$idx]}
            done
            idx=$(($idx-1))
        fi
    else
        echo -e ${wd}" \c"
    fi
    #echo $idx
    idx=$(($idx+1))
done

echo ""
