#!/bin/env bash

# TAG_NAME="minimal"
TAG_NAME="release"

docker run --rm -it quay.io/plebs_inc/nvim:${TAG_NAME}
