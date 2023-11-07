#!/bin/bash

# Copyright (c) Brandon Pacewic
# SPDX-License-Identifier: MIT

if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi

git submodule update --init --recursive

find . -name "*.py" -exec chmod +x {} \;
sudo find . -name "*.py" -exec sh -c 'filename=$(basename "{}"); ln {} /usr/local/bin/${filename%???}' \;
