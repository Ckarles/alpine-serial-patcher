#!/usr/bin/env bash

SCREEN_NAME="remote_kickstart"
hostname="test"

ANSWERFILE="setup-alpine.ks"
ANSWERFILE_REMOTE="${hostname}.ks"

screen -dmS "${SCREEN_NAME}" /dev/pts/2 9600

file_push() {
	remote_exec <<- eos "
	cat <<- eof > ${2}
	$(cat ${1})
	eof
	"
	eos
}

remote_exec() {
	screen -S "${SCREEN_NAME}" -X stuff "${1}\n"
}

remote_exec "root"
sleep 1
file_push "${ANSWERFILE}" "${ANSWERFILE_REMOTE}"
remote_exec "setup-alpine -e -f ${ANSWERFILE_REMOTE}"
