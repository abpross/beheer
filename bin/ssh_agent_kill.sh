#!/bin/sh
for agent in /run/user/*/keyring-*/ssh
do
    export SSH_AUTH_SOCK=$agent
    if ssh-add -l 2>&1 > /dev/null
    then
        # working ssh-agent found
        ssh-add -D # delete all identities
    fi
done
