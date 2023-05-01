#!/usr/bin/env bash
for i in `ls content/posts/`;do;
    p=`echo $i | cut -d. -f1`;
    mkdir content/post/"${p}" && mv content/posts/$i content/post/"${p}"/index.md;  
done