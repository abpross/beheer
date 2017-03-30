#!/bin/bash
set -x 
COMMAND=$(echo $1 | sed 's!://! !g' )
gnome-terminal -e "${COMMAND}"
