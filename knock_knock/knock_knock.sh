#!/bin/bash 

PORTS="1111 2222 3333"
HOST=""
NMAP=`type -p nmap`


if [ ${HOST:-xxx} = 'xxx' ]
then

	echo "ERROR :: targethost is not set"
	exit 127

fi

if [ ${NMAP:-xxx} = 'xxx' ]
then

	echo "ERROR :: nmap probably not installed - please install nmap"
	exit 127

fi

for i in ${PORTS}
do

	${NMAP} -Pn --host_timeout 201 --max-retries 0 -p ${i} ${HOST}
	sleep 1

done
ssh ${HOST}


