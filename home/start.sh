#!/bin/sh

export LC_ALL=ru_RU.UTF-8 LANG=ru_RU.UTF-8

service sphinxsearch start
service mysql start
service bugzilla start
service bugzilla-jobs start

# Keep container running
tail -fn0 /dev/null
