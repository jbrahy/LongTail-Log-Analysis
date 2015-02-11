README for LongTail Log Analysis.
==============

WARNING
--------------
If you manage to stumble across this at GitHub, this is
not ready to be released.  I'M STILL WORKING ON IT.  OTOH,
I'm close enough to actually be putting it up here so that
I can test the install procedure on a different server 
than the one I'm developing on.

If you're that interested, drop me an email to wedaa@wedaa.com

Licensing
--------------
LongTail is a messages and access_log analyzer

Copyright (C) 2015 Eric Wedaa

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

What LongTail does
--------------
Longtail analyzes your /var/log/messages files to report on 
the ssh attacks against your server.  LongTail pre-supposes 
that you have compiled your own openssh daemon as described 
below.

LongTail also analyzes your /var/log/httpd/access_log files
to analyze the attacks and probes that your webserver is
subject to.

LongTail is for small (1 server)  to medium size (50 servers)
organizations.  If you have a large organization, then you'll 
probably have too much data to be analyzed.  Of course if you
run this on larger installations and it works, please let me
know so I can increase this number.

LongTail ALSO refers to a statistical distribution where there
are many "Hits" at the left, and tapering down to a "Long Tail"
towards the right.  See http://en.wikipedia.org/wiki/Long_tail
for more details.

New SSHD Installation
--------------
Download a copy of openssh from http://www.openssh.com/portable.html#ftp

Untar the file and modify auth-passwd.c to add the 
following line to the auth_password function(See the
included auth-passwd.c file for exact placing) :
 logit("PassLog: Username: %s Password: %s", authctxt->user, password);

Then configure, make, and install openssh on your server.  I 
assume since you're interested in HoneyPots, you know your OS 
well enough to do this.

You can also run a second sshd on your system on a different 
port.  BUT...  To be able to tell which sshd is on which port, 
you should eit auth-passwd.c again, and instead of "PassLog", 
use "Pass2222Log.  Note that the port number is in the middle 
of the word PassLog.  This is because the search string LongTail 
uses in "PassLog"  Making the string "Pass2222Log" makes it 
possible to search for ssh attempts to the different ports.

And of course, you should run a "real" sshd on some very high 
number port so that you can ssh into your server and not have 
your account and password show up in the log files.  You can 
use your default /etc/ssh/sshd_config file to reset your port 
number.

LongTail Installation
--------------
Edit LongTail.sh for the locations of your 
/var/log/messages and /var/log/httpd/access_log files.

Edit LongTail.sh for the location of your 
/honey directory (or whatever you call the directory
you want your reports to go to.

Edit Longtail.sh for the following variables (which are explained
in the script): 
	GRAPHS
	DEBUG
	DO_SSH
	DO_HTTPD
	OBFUSCATE_IP_ADDRESSES
	OBFUSCATE_URLS
	PASSLOG
	PASSLOG2222
	SCRIPT_DIR
	HTML_DIR
	PATH_TO_VAR_LOG
	PATH_TO_VAR_LOG_HTTPD

Edit LongTail-exclude-accounts.grep to add your valid local 
accounts.  This will exclude these accounts from your reports.  
(You wouldn't want to have your password or account name 
showing up in your reports, now would you?)

Edit LongTail-exclude-IPs.grep to add your local IP addresses.  
This will exclude these IPs from your reports.  (You wouldn't 
want to have your personal or work IPs exposed in your reports, 
now would you?)

Edit LongTail-exclude-webpages.grep to add any local webpages 
you don't want in your LongTail reports.

Edit LongTail_make_graph.php for the appropriate location of
the jpgraph installation.

Edit install.sh for SCRIPT_DIR, HTML_DIR, and OWNER.  You also 
need to comment out the "exit" command, which is there to make 
sure you edit the install.sh script.

Run ./install.sh to install everything.

Run LongTail by hand as the account you want it to run as to 
make sure it works.  (And that it can write to the /honey 
directory.)

Site Specific Reports
--------------
After you have run LongTail for "a while", you may wish to 
add your own special reports.  Those reports should be included 
in two special files that will NOT be overwritten by install.sh

These scripts are:
	$SCRIPT_DIR/Longtail-ssh-local-reports
	$SCRIPT_DIR/Longtail-httpd-local-reports


CRON Entry
--------------
You'll need to run this through cron every hour.  PLEASE NOTE
that it starts at the 59 minute mark.  If you want to run this
just once a day, I would advise running it at 11:59 PM, as there
is code that only runs during the 11 PM time frame.

MY crontab entry looks like this one:
59 * * * * /usr/local/etc/LongTail >> /tmp/LongTail.out 2>> /tmp/LongTail.out

WARNING about reports before you have enough data
--------------
Some of the reports are going to look a little "off" until you
have a few days worth of data.  This is because I am currently
assuming that after a few days, attacks will have come in at
every hour of the day.

Also, historical trends reports will look "off" until you actually
have a few days worth of data to do a trend report on.

These issues will not be fixed anytime soon.

WARNING about jpgraph alignment issues
--------------
Two warnings about jpgraph alignment issues.

ONE) Right now the X and Y axis labels can be overwritten by the
tick marks for the axis.  I am looking into this issue.

TWO) For some reason, the X axis labels show up shifted to the
right on some systems (notably my CentOS 6.5 using the Atomic
PHP repos.  On a vanilla Fedora Core 20 system the labels show
up properly under the appropriate bar.  I am looking into this 
issue.

KNOWN ISSUES
--------------
I don't know if it handles spaces at the start or end of the passwords
properly.

I don't deal with blank/empty passwords at all

I need to add a chart of password lengths

It would be nice in the "Trends" tables if the first time an entry 
is used that it showed up in a different color.

I should make a line chart of attacks per day.

I should make a line chart of number of attacks for an account 
per day.

I should make a line chart of number of uses of a password for 
an account per day.

I still need to finish my third level analysis of brute force
attacks, which is the real reason I wrote LongTail.
