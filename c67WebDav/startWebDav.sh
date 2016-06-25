#/bin/bash
# We assume that VOLPATHS is a : separated list of volumes to export via webdav
# e.g. VOLPATHS="/home/gm2/foo:/home/gm2/bla"
#
#  The username/password will be webdav/webdav

httpdconf="/etc/httpd/conf/httpd.conf"

IFS=':' read -r -a array <<< "$VOLPATHS"
for element in "${array[@]}"
do
  # Strip off last part of path
  volname=$(basename "$element")
  echo "Exporting $element as /${volname}"

  echo "" >> $httpdconf
  echo "Alias /${volname} ${element}" >> $httpdconf
  echo "<Location /${volname}>" >> $httpdconf
  cat << EOF >> $httpdconf
  Options Indexes
  Dav on

  AuthType Basic
  AuthName webdav
  AuthUserFile /tmp/webdav-login
  Require valid-user
</Location>
EOF
done

echo 'Starting apache'
/usr/sbin/apachectl -D FOREGROUND
