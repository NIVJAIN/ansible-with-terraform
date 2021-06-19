#!/bin/bash
# readonly -a arr=(a b c)
readonly -a arr=(a)
readonly tag=1.4.0

for i in "${arr[@]}"
do
  cp -f Dockerfile "service-$i"
  pushd "service-$i"
  docker build -t "nivjain/node-srv-$i:$tag" . --no-cache
  rm -rf Dockerfile
  popd
done

docker image ls | grep 'nivjain/node-srv-'
