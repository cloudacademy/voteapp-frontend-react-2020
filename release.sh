#!/bin/bash
if [[ -z "${GITHUB_TOKEN}" ]]; then
  echo "GITHUB_TOKEN environment variable must be set for this script!"
  exit 0
else
  GITHUB_TOKEN="${GITHUB_TOKEN}"
fi

if [[ -z "${GITHUB_USER}" ]]; then
  echo "GITHUB_USER environment variable must be set for this script!"
  exit 0
else
  GITHUB_USER="${GITHUB_USER}"
fi

#================================
#================================
token=$GITHUB_TOKEN
repo=cloudacademy/voteapp-frontend-react-2020
#================================
#================================

BASE_STRING=`cat VERSION`
BASE_LIST=(`echo $BASE_STRING | tr '.' ' '`)
V_MAJOR=${BASE_LIST[0]}
V_MINOR=${BASE_LIST[1]}
V_PATCH=${BASE_LIST[2]}
echo "Current version : $BASE_STRING"
V_MINOR=0
V_PATCH=$((V_PATCH + 1))
SUGGESTED_VERSION="$V_MAJOR.$V_MINOR.$V_PATCH"
read -p "Enter a version number [$SUGGESTED_VERSION]: " INPUT_STRING
if [ "$INPUT_STRING" = "" ]; then
     INPUT_STRING=$SUGGESTED_VERSION
fi
echo "Will set new version to be $INPUT_STRING"
echo $INPUT_STRING > VERSION

git add VERSION
git commit -m "Version bump to $INPUT_STRING"
git push origin

VERSION=`cat VERSION`

echo ==============================
yarn install
yarn build
tree -a build
zip -r frontend-$VERSION.zip build
echo ==============================
echo

echo latest release = frontend-$VERSION.zip
ls -la
echo ==============================
echo

read -p "Press [Enter] key to start release upload..."

upload_url=$(curl -s -u $GITHUB_USER:$GITHUB_TOKEN \
     --request POST \
     --url https://api.github.com/repos/$repo/releases \
     --data '{"tag_name": "release-'$VERSION'", "name":"release-'$VERSION'","body":"release '$VERSION'"}' \
     | jq -r '.upload_url')

upload_url="${upload_url%\{*}"

echo "uploading build asset to release url : $upload_url"
echo

curl -s -u $GITHUB_USER:$GITHUB_TOKEN \
        -H "Content-Type: application/zip" \
        --data-binary @frontend-$VERSION.zip  \
        "$upload_url?name=frontend-$VERSION.zip&label=frontend-$VERSION.zip"

echo ==============================

echo
echo "uploading release complete!!"
echo