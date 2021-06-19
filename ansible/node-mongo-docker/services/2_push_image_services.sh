#!/bin/bash


# readonly -a arr=(a b c)
readonly -a arr=(a)
readonly tag=1.4.0

for i in "${arr[@]}"
do
  docker push "nivjain/node-srv-$i:$tag"
done

# docker push "nivjain/angular-observe:$tag"