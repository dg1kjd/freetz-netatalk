#!/bin/sh

PATH=/bin:/usr/bin:/sbin:/usr/sbin
. /usr/lib/libmodcgi.sh

check "$NETATALK_ENABLED" yes:auto "*":man

sec_begin '$(lang de:"Starttyp" en:"Start type")'

cat << EOF
<p>
<input id="e1" type="radio" name="enabled" value="yes"$auto_chk><label for="e1">$(lang de:"Automatisch" en:"Automatic")</label>
<input id="e2" type="radio" name="enabled" value="no"$man_chk><label for="e2">$(lang de:"Manuell" en:"Manual")</label>
</p>
EOF

sec_end
sec_begin '$(lang de:"Einstellungen" en:"Settings")'

cat << EOF
<ul>
<li><a href="$(href file netatalk afpd.conf)">afpd.conf</a></li>
<li><a href="$(href file netatalk AppleVolumes.default)">AppleVolumes.default</a></li>
</ul>
EOF

sec_end
sec_begin '$(lang de:"Netatalk" en:"Netatalk")'

cat << EOF
<br>
<p>$(lang de:"Name" en:"Name"):<br>
<input type="text" name="name" size="40" maxlength="32" value="$(html "$NETATALK_NAME")">
</p>
<p>$(lang de:"Zone" en:"Zone"):<br>
<input type="text" name="zone" size="40" maxlength="32" value="$(html "$NETATALK_ZONE")">
</p>
<p>$(lang de:"Maximale Anzahl Verbindungen" en:"Maximum number of clients"):<br>
<input type="text" name="max_clients" size="4" maxlength="3" value="$(html "$NETATALK_MAX_CLIENTS")">
</p>
EOF

sec_end
