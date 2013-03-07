#!/bin/bash 

# ATTENTION
# You'll probably want to change the address where errors are sent.
# Probably. 

/usr/sbin/zonec -v -c /etc/nsd3/nsd.conf -f /tmp/zonec.tmp 2> /tmp/zonec.out

if  grep -q "zonec" /tmp/zonec.out
	then /bin/cat /tmp/zonec.out|/usr/bin/mailx -s "Zonec errors" itops@yourdomain.com
fi

/usr/sbin/nsdc rebuild
/usr/sbin/nsdc reload
