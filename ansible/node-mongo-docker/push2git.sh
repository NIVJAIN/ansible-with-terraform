set -o errexit

if [ "$#" -ne 2 ]; then
    echo "Incorrect parameters"
    echo "Usage: push2git.sh <version> <prefix>"
    exit 1
fi
VERSION=$1
PREFIX=$2
git add .
git commit -m $1
git push origin master