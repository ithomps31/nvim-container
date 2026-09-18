#!/bin/env bash

buildah build --tag quay.io/plebs_inc/nvim:latest -f Containerfile .
