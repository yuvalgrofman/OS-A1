#!/bin/bash
#yuval grofman 214975245

if [ $# -lt 2 ]
then
    echo Not enough parameters
    exit 1
fi

dirPath=$1
wordToFind=$2

wordToFind="${wordToFind,,}"

#loop over all files in the directory
#and delete all .out files
for file in "$dirPath"/*.out; do
    [ -f "$file" ] || break

    rm "$file"
done

#loop over all .c file in the directory
#and compile them if they contain the word
for file in "$dirPath"/*.c; do
    [ -f "$file" ] || break

    if grep -q -i -w -F $wordToFind "$file"; then
        gcc "$file" -w -o "${file%.*}.out"
    fi

done

#call the script recursively for all subdirectories if -r is passed
if test -r = $3; then 
    for dir in "$dirPath"/*/; do

        if [ -d "$dir" ]; then
            ./$0 ${dir::-1} "$wordToFind" "-r" 
        fi
    done
fi