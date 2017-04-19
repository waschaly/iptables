#!/bin/bash

AWK=`type -p awk`
GREP=`type -p grep`
HEAD=`type -p head`
IPT=`type -p iptables`
#
## 
## create new chain - whitelist 
##
#

CHAIN=whitelist-ssh
#

RULENUM=`${IPT} -L INPUT --line-numbers | ${GREP} ${CHAIN} | ${HEAD} -n 1 | ${AWK} '{print $1}'`
if [ ${RULENUM:-xxx} == 'xxx' ]
then
	${IPT} -N ${CHAIN}
fi

#
##
## SSH LOG stuff
##
#
${IPT} -A ${CHAIN} -p tcp --dport 22 -m state --state ESTABLISHED,RELATED -j ACCEPT
${IPT} -A ${CHAIN} -p tcp --dport 22 -s 192.168.178.0/24 -j ACCEPT
${IPT} -A ${CHAIN} -p tcp -j LOG --log-prefix "ssh-LOG "
${IPT} -A ${CHAIN} -j DROP

${IPT} -A INPUT -p tcp -m multiport --dports 22 -j ${CHAIN}

#
##
###
##
#
CHAIN=whitelist-apache
#

RULENUM=`${IPT} -L INPUT --line-numbers | ${GREP} ${CHAIN} | ${HEAD} -n 1 | ${AWK} '{print $1}'`
if [ ${RULENUM:-xxx} == 'xxx' ]
then
	${IPT} -N ${CHAIN} 
fi

#
##
## apache LOG stuff
##
#
${IPT} -A ${CHAIN} -p tcp --dport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT
${IPT} -A ${CHAIN} -p tcp --dport 80 -s 192.168.178.0/24 -j ACCEPT
${IPT} -A ${CHAIN} -p tcp -j LOG --log-prefix "apache-LOG "
${IPT} -A ${CHAIN} -j DROP
#
## whitelist aktivieren
${IPT} -A INPUT -p tcp -m multiport --dports 80 -j ${CHAIN}

