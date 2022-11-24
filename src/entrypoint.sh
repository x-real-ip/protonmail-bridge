#!/bin/bash

set -ex

# constants
BRIDGE="protonmail-bridge --cli"
GPG_PARAMS="/home/gpg-key-parameters"
FIFO="/tmp/fifo"
# other variables are coming from the environment itself

# main
if ! [ -d /home/gnupg ]; then
    gpg --generate-key --batch ${GPG_PARAMS}
fi

if ! [ -d /home/.password-store ]; then
    pass init "$(awk -F: '/^Name-Real/ {print $2}' ${GPG_PARAMS})"
fi

if ! [ -f /home/.cache/protonmail/bridge ]; then
    echo -e "login\n${PROTONMAIL_LOGIN}\n${PROTONMAIL_PASSWORD}\n${PROTONMAIL_EXTRA_2FA}" | ${BRIDGE} ${BRIDGE_EXTRA_ARGS}
fi

if [ "${BRIDGE_SPLIT_ADDRESS_MODE}" = true ]; then
    echo -e "change mode\nyes\n" | ${BRIDGE} ${BRIDGE_EXTRA_ARGS}
fi

# socat will make the conn appear to come from 127.0.0.1
# ProtonMail Bridge currently expects that.
# It also allows us to bind to the real ports :)
socat TCP-LISTEN:25,fork TCP:127.0.0.1:1025 &
socat TCP-LISTEN:143,fork TCP:127.0.0.1:1143 &

# display account information, then keep stdin open
[ -e ${FIFO} ] || mkfifo ${FIFO}
{
    echo info
    cat ${FIFO}
} | ${BRIDGE} ${BRIDGE_EXTRA_ARGS}
