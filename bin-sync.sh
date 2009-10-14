#!/bin/sh
 
branch_name=gh-pages
doc_root=bin-debug
 
refname=refs/heads/$branch_name
 
doc_sha=`git ls-tree -d HEAD $doc_root | awk '{print $3}'`
 
if git rev-parse --verify -q $refname > /dev/null
then
new_commit=`echo "Auto-update bin." | git commit-tree $doc_sha -p $refname`
else
new_commit=`echo "Auto-update bin." | git commit-tree $doc_sha`
fi
 
git update-ref $refname $new_commit