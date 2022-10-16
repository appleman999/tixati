#!/usr/bin/bash

TIXATI_VERSION=$(/usr/bin/docker exec tixati \
	/usr/bin/dpkg --info /var/tmp/tixati.deb | \
	/usr/bin/grep Version: | \
	/usr/bin/awk '{ print $2 }' | \
	/usr/bin/tr - .)


VERSION_CHECK=$(curl --silent "https://www.tixati.com/checkver/${TIXATI_VERSION}/")
if [[ "${VERSION_CHECK}" == *"You are using the newest version."* ]]; then
	echo "Tixati version is ok"
	exit 0
fi

echo "Tixati version is old"
echo "${VERSION_CHECK}" | /usr/bin/mutt -e "set content_type=text/html" -s "Tixati Image Needs Updating" matt@selick.com 2>&1
exit 0
