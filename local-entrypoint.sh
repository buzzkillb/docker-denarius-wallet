#!/bin/bash
env > .envrc
echo CMD="/usr/local/bin/Denarius" >> .envrc

. /entrypoint.sh
