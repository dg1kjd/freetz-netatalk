Netatalk
========

If you don't speak German but would like to work on this project, please let me know by 
adding a comment to: http://www.ip-phone-forum.de/showthread.php?p=1483609


Stand der Dinge
---------------

Netatalk produziert einen Fehler (checking Berkeley DB library (-ldb47)... configure: error:
cannot run test program while cross compiling). Um den zu lösen, muss man - als Workaround - 
nach dem ersten, fehlerhaften Lauf den Patch patches-OFF/100-configure.patch anwenden:

cd source/netatalk-2.1 && patch <../../make/netatalk/patches-OFF/100-configure.patch

Danach kompiliert Netatalk bis zu folgendem Fehler:

ad_open.c:715: error: expected ';', ',' or ')' before '_U_'

Die CGI fürs Freetz Backend, Init Scripts etc fehlen noch.


Leute
-----

Im Moment schraube nur ich (Sven) an diesen Paketen. Um mit mir Kontakt aufzuznehmen, schreibe eine
Reply auf http://www.ip-phone-forum.de/showthread.php?p=1483609, schicke mir auf Github eine Message
an "svoop" oder suche mich auf IRC http://trac.freetz.org/wiki/help/irc (nick: "svoop").


Installation
------------

Zuerst sollte das Git Repo geforked werden:
http://github.com/svoop/freetz-netatalk

Danach die Entwicklungsumgebung erzeugen. Anstelle von {USERNAME} sollte der
eigene Github-Username eingesetzt werden:

svn checkout http://svn.freetz.org/trunk devel
git clone git@github.com:{USERNAME}/freetz-netatalk.git netatalk
ln -s ../../netatalk devel/make/
sed -i 's%ncftp/Config.in%ncftp/Config.in\nsource make/netatalk/Config.in%' devel/make/Config.in
cd devel
make menuconfig


Pakete
------

FREETZ_PACKAGE_NETATALK
  Package selection -> Testing -> Netatalk


Links
-----
* Forum: http://www.ip-phone-forum.de/showthread.php?p=1483609
* Ticket: http://trac.freetz.org/ticket/671
* IRC: http://trac.freetz.org/wiki/help/irc
* Netatalk: http://netatalk.sourceforge.net
* Github: http://help.github.com/forking
* Netatalk auf OpenWRT: https://dev.openwrt.org/attachment/ticket/6619/netatalk.diff
