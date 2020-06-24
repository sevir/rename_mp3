# Docker nif checker service

# Compile binary
FROM alpine as compiler
# libraries:
# * musl-dev  =  libc dev libraries
# * curl-dev  =  we use web services so we need curl
RUN apk add --update crystal musl-dev upx
WORKDIR /app
ADD . /app
RUN cd /app && crystal -v && crystal build --progress --no-debug --static --release src/rename_mp3.cr && upx rename_mp3