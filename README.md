nsd3

This is the nsd3 module.

License
-------

Apache 2.0, which should be in this directory.

Contact
-------

john.hawkes-reed@futurenet.com
jhr@mysparedomain.com

Support
-------

Please log tickets and issues on [Github](http://projects.example.com)

Theory of operation
-------------------

There's something of a technical ramble [here](http://ops.failcake.net/blog/2012/12/28/finding-places-to-put-things/)
but the somewhat shorter version looks a lot like this:

I'm assuming you have a directory filled with zonefiles with names of the format 'master.zone-name' and that it's
under git-based version control. If you've not got something like that, you can start now, or spend some time
modifying the code outlined in the above weblog post such that it's triggered on a change in a different file.

So. You make a change to a zonefile, push it, and through the repo being on the master nameserver, or via
a post-commit hook, the state of the zonefile directory changes on your master. On the next puppet run, the 
module picks up that change and triggers a zone-reload in NSD.

Adding or removing a zone. Edit the file domain-list in nsd3/files/code and push that change. On the next 
puppet run, the module picks up that change and triggers a config-file rebuild. If you've added a zone, you 
did remember to create the appropriate master zonefile, right?

Why does the list of domains have to travel separately? Because there has to be some out-of-band way of
signalling secondary nameservers that they should be pulling data for a fresh zone. Or stop pulling data 
for a now removed zone.

Things you will need to change
------------------------------

* The names attached to the static parts of the config files in nsd3/files. This should be the hostname(s)
of the master (and slave) nameservers. For instance 'arthur-nsd.head' and 'ford-nsd.head'.

* The list of domains/rDNS in nsd3/files/code/domain-list.

* The IP addresses of your master and slave nameservers in nsd3/files/master.yaml & slave.yaml
(You may not need to care about 'outbound-addr' if your servers only have one NIC. Our kit has
multiple NICs and a bureacratic firewall policy, so answers from unexpected addresses = quite bad)

* The mail addresses in nsd3/files/code/refresh.sh and generate-zone-config.sh 
