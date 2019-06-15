#!/usr/bin/env bash

CALCULATE_NEW_VERSION (){
# Increment a version string using Semantic Versioning (SemVer) terminology.
# Copied from: https://github.com/fmahnke/shell-semver

# Parse command line options.

while getopts ":Mmp" Option
    do
      case $Option in
        M ) major=true;;
        m ) minor=true;;
        p ) patch=true;;
      esac
    done

    shift $(($OPTIND - 1))

    version=$1

    # Build array from version string.

    a=( ${version//./ } )

    # If version string is missing or has the wrong number of members, show usage message.

    if [ ${#a[@]} -ne 3 ]
    then
      echo "usage: $(basename $0) [-Mmp] major.minor.patch"
      exit 1
    fi

    # Increment version numbers as requested.

    if [ ! -z $major ]
    then
      ((a[0]++))
      a[1]=0
      a[2]=0
    fi

    if [ ! -z $minor ]
    then
      ((a[1]++))
      a[2]=0
    fi

    if [ ! -z $patch ]
    then
      ((a[2]++))
    fi

    echo "${a[0]}.${a[1]}.${a[2]}"
}

git checkout develop
git pull

git checkout master
git pull

CURRENT_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

git merge develop

echo "Current version: ${CURRENT_VERSION}"

echo "Is this a breaking change, new feature or bugfix?"
echo "type b for breaking change"
echo "type f for a new feature"
echo "type p for patch/bugfix/dependency update"

read CHANGE_TYPE

if [[ "${CHANGE_TYPE}" = "b" ]]
then
    echo "Breaking change"
    NEW_VERSION=$(CALCULATE_NEW_VERSION -M ${CURRENT_VERSION})

elif [[ "${CHANGE_TYPE}" = "f" ]]
then
    echo "New feature"
    NEW_VERSION=$(CALCULATE_NEW_VERSION -m ${CURRENT_VERSION})
elif [[ "${CHANGE_TYPE}" = "p" ]]
then
    echo "patch"
    NEW_VERSION=$(CALCULATE_NEW_VERSION -p ${CURRENT_VERSION})
else
    echo "invalid input, the script will exit now"
    exit 1
fi

echo "Current version: ${CURRENT_VERSION}"
echo "New version: ${NEW_VERSION}"
echo "To continue type y"

read CONTINUE

if [[ ! "${CONTINUE}" = "y" ]]
then
    echo "Stopping"
    exit 1;
fi

mvn org.codehaus.mojo:versions-maven-plugin:set -DnewVersion=${NEW_VERSION} versions:commit
git add pom.xml
git commit -m "Release v${NEW_VERSION}"
git tag -a ${NEW_VERSION} -m "Release v${NEW_VERSION}"
git push
git push --tags

echo "prepare the next development"
git checkout develop
git pull
git merge master
mvn org.codehaus.mojo:versions-maven-plugin:set -DnextSnapshot=true versions:commit
git add pom.xml
git commit -m "Prepare for new development"
git push
git push --tags