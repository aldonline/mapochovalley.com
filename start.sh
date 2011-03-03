#!/bin/sh

# we need to cd into this folder
# because some parts of the system may use 'cwd'
# to resolve relative paths instead of the __directory global
# TODO: hunt them down. low priority
cd ./lib/webapp
coffee webapp.coffee