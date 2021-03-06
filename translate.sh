#! /usr/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS=../key.json
find content -iname "2019-**[^.]??.markdown" |
while read filename
do 
  node translate.js -s $filename -t hi,fr,es,ja,de,vi,ru,id  \;
done

#find src/content/en/updates/2018/01/ -iname "*.md" -exec node translate.js -s '{}' -t hi,fr,es,ja,de,vi,ru,id \;