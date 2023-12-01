#!/usr/bin/env bash

docker build --platform=linux/amd64 -t camel-jbang-download-bug-reproducer .

# print the contents of .m2
docker run --platform=linux/amd64 --rm --entrypoint=find camel-jbang-download-bug-reproducer -- /root/.m2 -name '*.jar'

# prove, no dependencies need downloading
docker run --platform=linux/amd64 --rm --entrypoint=bash -p 8080:8080 camel-jbang-download-bug-reproducer -- camel run --verbose --console --max-messages=1 \
  --code='from("timer:t?delay=-1&repeatCount=1").to("http://localhost:8080/q/dev/dependency-downloader").to("log:info?plain=true")'

# --download=false should execute, since we have no dependencies to download, but:
docker run --platform=linux/amd64 --rm --entrypoint=bash -p 8080:8080 camel-jbang-download-bug-reproducer -- camel run --download=false --verbose --console --max-messages=1 \
  --code='from("timer:t?delay=-1&repeatCount=1").to("http://localhost:8080/q/dev/dependency-downloader").to("log:info?plain=true")'
