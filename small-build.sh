#!/bin/env bash

buildah build --tag quay.io/plebs_inc/nvim:09-23 -f Containerfile .
