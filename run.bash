#!/usr/bin/env bash

# because I'm too lazy to write an init script

while true; do
  source ./env
  bin/hubot -a slack
done
