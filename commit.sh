#!/bin/bash

message=$@

#echo "$message"

git add .
git commit -am "$message"
