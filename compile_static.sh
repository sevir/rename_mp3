#!/bin/bash

BIN=rename_mp3
COMPILER=static_compiler

# build Dockerfile
docker build -t $COMPILER .

# create without run
CID=$(docker create $COMPILER)

# copy binary
docker cp $CID:/app/$BIN .

# remove docker
docker rm $CID
docker rmi $COMPILER