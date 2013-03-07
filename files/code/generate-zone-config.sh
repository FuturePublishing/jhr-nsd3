#!/bin/bash 

# ATTENTION
# You'll probably want to change the address where zone errors are sent
#

while getopts ":t:" opt; do
  case $opt in
    t)
      stype=$OPTARG
      echo "Server type is $stype" >&2

      /etc/nsd3/code/fbridge.rb -c /etc/nsd3/code/config.yaml -s $stype -z  /etc/nsd3/code/domain-list > /etc/nsd3/future.domains
      cp /etc/nsd3/nsd.conf /etc/nsd3/nsd.conf.old
      cat /etc/nsd3/nsd.head /etc/nsd3/future.domains > /etc/nsd3/nsd.conf

      /usr/sbin/zonec -v -c /etc/nsd3/nsd.conf -f /tmp/zonec.tmp 2> /tmp/zonec.out

      if  grep -q "zonec" /tmp/zonec.out
	      then /bin/cat /tmp/zonec.out|/usr/bin/mailx -s "Zonec errors" itops@yourdomain.com
      fi

      /usr/sbin/nsdc rebuild
      /etc/init.d/nsd3 stop && sleep 3 && /etc/init.d/nsd3 start
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
