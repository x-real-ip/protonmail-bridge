#!/bin/bash

set -ex

GPG_PARAMS="/protonmail/gpg-key-parameters"
FIFO="/tmp/fifo"

if ! [ -d /protonmail/.gnupg ]; then
    gpg --generate-key --batch ${GPG_PARAMS}
fi

if ! [ -d /protonmail/.password-store ]; then
    pass init "$(awk -F: '/^Name-Real/ {print $2}' ${GPG_PARAMS})"
fi

if ! [ -f /protonmail/.cache/protonmail/bridge ]; then
    echo -e "login\n${PROTONMAIL_LOGIN}\n${PROTONMAIL_PASSWORD}\n${PROTONMAIL_EXTRA_2FA}" | ${BRIDGE} ${BRIDGE_EXTRA_ARGS}
fi

if [ "${BRIDGE_SPLIT_ADDRESS_MODE}" = true ]; then
    echo -e "change mode\nyes\n" | ${BRIDGE} ${BRIDGE_EXTRA_ARGS}
fi

# socat will make the conn appear to come from 127.0.0.1
# ProtonMail Bridge currently expects that.
# It also allows us to bind to the real ports :)
socat TCP-LISTEN:${SMTP_PORT},fork TCP:127.0.0.1:1025 &
socat TCP-LISTEN:${IMAP_PORT},fork TCP:127.0.0.1:1143 &

# display account information, then keep stdin open
[ -e ${FIFO} ] || mkfifo ${FIFO}
{
    echo info
    cat ${FIFO}
} | ${BRIDGE} ${BRIDGE_EXTRA_ARGS}
