#!/bin/bash

# get version------------
version=`cat Dockerfile | grep "ARG CORE_VERSION=" | cut -d'=' -f2`

branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
branch_name="(unnamed branch)"     # detached HEAD

branch_name=${branch_name##refs/heads/}

# check if branch is correct based on the version-----------

if ! [[ $version == $branch_name* ]]
then
	RED='\033[0;31m'
    NC='\033[0m' # No Color
    printf "${RED}Adding tag to wrong branch. Stopping process${NC}\n"
    exit 1
fi

git fetch --tags -f
git fetch --prune --prune-tags

# get current commit hash------------
if [ $# -eq 0 ]
then
	commit_hash=`git log --pretty=format:'%H' -n 1`
else
	commit_hash=$1
fi


# check if current commit already has a tag or not------------

if [[ `git tag -l --points-at $commit_hash` == "" ]]
then
	continue=1
else
	RED='\033[0;31m'
	NC='\033[0m'
	printf "${RED}This commit already has a tag. Please remove that and re-run this script${NC}\n"
	echo "git tag --delete <tagName>"
	echo "git push --delete origin <tagName>"
	exit 1
fi


# tag this commit and push it------------
git push origin :refs/tags/dev-v$version
git fetch --prune --prune-tags
git tag dev-v$version $commit_hash
git push --tags