#!/bin/sh

echo "You need to edit LongTail.sh.  Please see LongTail.sh for details"
echo ""
echo "You need to edit this file for SCRIPT_DIR, HTML_DIR, DICT_DIR, and OWNER."

echo "And then comment out the exit statement"

exit

SCRIPT_DIR="/usr/local/etc"    # Where do we put the scripts?
HTML_DIR="/var/www/html/honey" # Where do we put the HTML files?
DICT_DIR="/usr/local/dict"

OWNER="wedaa"                  # What is the owner of the process running LongTail?

mkdir -p $HTML_DIR/historical/`date +%Y`/`date +%m`/`date +%d`
if [ ! -d "$HTML_DIR/dashboard" ] ; then
	mkdir $HTML_DIR/dashboard
fi

OTHER_DIRS="/usr/local/etc/black_lists /var/www/html/honey-2222 /var/www/html/honey-22 /var/www/html/telnet /var/www/html/ftp /var/www/html/rlogin"

for dir in $SCRIPT_DIR $HTML_DIR  $DICT_DIR $OTHER_DIRS ; do
	if [ -e $dir ] ; then
		if [ -d $dir ] ; then
			echo "$dir allready exists, this is a good thing"
		else
			echo "$dir allready exists but is not a directory"
			echo "This is a bad thing, exiting now!"
			exit
		fi
	else
		mkdir -p $dir
		chown $OWNER $dir
		chmod a+rx $dir
	fi
done

if [ ! -d $SCRIPT_DIR/LongTail_local_reports ] ; then
	if [ -e $SCRIPT_DIR/LongTail_local_reports ] ; then
		echo "$SCRIPT_DIR/LongTail_local_reports exists, but is not a directory"
		echo "Exiting now"
		exit
	else
		mkdir $SCRIPT_DIR/LongTail_local_reports
		chown $OWNER $SCRIPT_DIR/LongTail_local_reports
	fi
fi

DICT_FILES="wordsEn.txt"

ETC_FILES="ip-to-country \
translate_country_codes.sed \
translate_country_codes \
LongTail-exclude-accounts.grep \
LongTail-exclude-webpages.grep  \
LongTail-exclude-IPs-httpd.grep \
LongTail-exclude-IPs-ssh.grep \
LongTail_friends_of_sshPsycho_IP_addresses \
LongTail_associates_of_sshPsycho_IP_addresses \
LongTail_sshPsycho_IP_addresses"


for file in $ETC_FILES ; do
	echo $file
	cp $file $SCRIPT_DIR
	chmod a+r $SCRIPT_DIR/$file
done

PROGRAMS=" LongTail_rebuild_dashboard_index.pl \
LongTail_dashboard.pl \
LongTail_rebuild_last_month_dashboard_charts.sh \
LongTail_rebuild_dashboard_index.pl \
LongTail_make_dashboard_graph.php \
LongTail_rebuild_month_dashboard_charts.sh \
LongTail_make_historical_dashboard_charts.pl \
LongTail_make_30_days_imagemap.pl \
LongTail_make_top_20_imagemap.pl \
LongTail_password_analysis_part_1.pl \
LongTail_password_analysis_part_2.pl \
LongTail_dashboard.pl \
LongTail_password_analysis.pl \
LongTail_analyze_attacks.pl \
catall.sh \
LongTail_add_country_to_ip.pl \
LongTail.sh \
LongTail_make_graph_sshpsycho.php \
LongTail_friends_of_sshPsycho_IP_addresses \
LongTail_sshPsycho_IP_addresses \
LongTail_rebuild_last_month_dashboard_charts.sh \
LongTail_rebuild_month_dashboard_charts.sh \
LongTail_compare_IP_addresses.pl \
LongTail_make_graph.php \
LongTail_make_historical_dashboard_charts.pl \
LongTail_make_dashboard_graph.php \
LongTail_make_daily_attacks_chart.pl \
LongTail_class_b_hall_of_shame.pl \
LongTail_class_c_hall_of_shame.pl \
LongTail_find_first_password_use.pl \
whois.pl "

for file in $PROGRAMS ; do
	echo $file
	cp $file $SCRIPT_DIR
	chmod a+rx $SCRIPT_DIR/$file
done

for file in $DICT_FILES ; do
	echo $file
	cp $file $DICT_DIR
	chmod a+r $DICT_DIR/$file
done

HTML_FILES="ip_addresses.shtml \
index.shtml \
how_to_protect_yourself.shtml \
index-long.shtml \
how_to_protect_yourself.shtml \
about.shtml \
index-historical.shtml \
graphics.shtml \
header.html \
footer.html \
institution.html \
notes.shtml \
LongTail.css \
buttons.css \
404.shtml \
attacks_view_restricted.shtml"

for dir in $HTML_DIR $OTHER_DIRS ; do
	for file in $HTML_FILES ; do
		cp $file $dir
		chmod a+r $dir/$file	
	done
done

cp honey-2222/* /var/www/html/honey-2222/
chmod a+r /var/www/html/honey-2222/*

cp dashboard-index.shtml $HTML_DIR/dashboard/index.shtml
cp dashboard-1.shtml $HTML_DIR/dashboard/ 
cp dashboard.shtml $HTML_DIR/

echo "0" > $HTML_DIR/dashboard/count

if [ ! -e $SCRIPT_DIR/LongTail-exclude-accounts.grep ] ; then
	echo "LongTail-exclude-accounts.grep not in $SCRIPT_DIR"
	cp LongTail-exclude-accounts.grep $SCRIPT_DIR
fi

if [ ! -e $SCRIPT_DIR/LongTail-exclude-IPs-httpd.grep ] ; then
	echo "LongTail-exclude-IPs-httpd.grep not in $SCRIPT_DIR"
	cp LongTail-exclude-IPs-httpd.grep $SCRIPT_DIR
fi

if [ ! -e $SCRIPT_DIR/LongTail-exclude-IPs-ssh.grep ] ; then
	echo "LongTail-exclude-IPs-ssh.grep not in $SCRIPT_DIR"
	cp LongTail-exclude-IPs-ssh.grep $SCRIPT_DIR
fi

if [ ! -e $SCRIPT_DIR/LongTail-exclude-webpages.grep ] ; then
	echo "LongTail-exclude-webpages.grep not in $SCRIPT_DIR"
	cp LongTail-exclude-webpages.grep $SCRIPT_DIR
fi


chmod a+r $HTML_DIR/index.shtml 
chown $OWNER $HTML_DIR/index.shtml 
chmod a+r $HTML_DIR/index-long.shtml 
chown $OWNER $HTML_DIR/index-long.shtml 
chmod a+r $HTML_DIR/index-historical.shtml
chown $OWNER $HTML_DIR/index-historical.shtml 
chmod a+r $HTML_DIR/graphics.shtml
chown $OWNER $HTML_DIR/graphics.shtml 
chmod a+r $HTML_DIR/graphics.shtml
chown $OWNER $HTML_DIR/graphics.shtml 

chmod a+r $HTML_DIR/LongTail.css
chown $OWNER $HTML_DIR/LongTail.css 
chmod a+r $HTML_DIR/header.html
chown $OWNER $HTML_DIR/header.html
chmod a+r $HTML_DIR/footer.html
chown $OWNER $HTML_DIR/footer.html

touch $SCRIPT_DIR/Longtail-ssh-local-reports
touch $SCRIPT_DIR/Longtail-httpd-local-reports

#
# Make a default file THISYEAR/THISMONTH/TODAY/current-attack-count.data
# To clear a divide by 0 error that shows up on the fist day running it.


YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`

mkdir -p $HTML_DIR/historical/$YEAR/$MONTH/$DAY
echo "0" > $HTML_DIR/historical/$YEAR/$MONTH/$DAY/current-attack-count.data
chown -R $OWNER $HTML_DIR/historical
chmod a+rx $HTML_DIR $HTML_DIR/historical $HTML_DIR/historical/$YEAR $HTML_DIR/historical/$YEAR/$MONTH $HTML_DIR/historical/$YEAR/$MONTH/$DAY $HTML_DIR/historical/$YEAR/$MONTH/$DAY/current-attack-count.data 

#
# Lets deal with the tour
#
mkdir -p $HTML_DIR/tour
chmod a+rx $HTML_DIR/tour
cd tour
cp * $HTML_DIR/tour
chmod a+r $HTML_DIR/tour/*
cd ..

#
# Lets deal with the LongTail_local_reports
#
cd LongTail_local_reports
cp * $SCRIPT_DIR/LongTail_local_reports
chmod a+rx $SCRIPT_DIR/LongTail_local_reports/*
cd ..


#
# Check for required software here
#
#Check for required software here
#
for i in perl php find sort uniq grep egrep cat tac unzip bzcat zcat whois ; do
	echo -n "Checking for $i...  "
	which $i >/dev/null 
	if [ $? -eq 0 ]; then
		echo "$i found"
	else
		echo "$i not found, you need to install this"
	fi
done
echo "You should probably run the following command to install all the php "
echo "required for graphing"
echo "       yum install jwhois php php-devel php-common php-cli php-xml php-pear php-pdo php-gd (RHEL 6)"
echo "            OR"
echo "       yum install whois php php-devel php-common php-cli php-xml php-pear php-pdo php-gd (RHEL 7)"
echo ""
echo "And download jpgraph from http://jpgraph.net/download/ installed into "
echo "/usr/local/php/jpgraph.  (Don't forget to edit the include line in "
echo "/etc/php.ini to reference /usr/local/php)."

echo "Please add these entries to your crontab file"
echo ""
cat sample.crontab
