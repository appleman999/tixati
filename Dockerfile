FROM jlesage/baseimage-gui:ubuntu-20.04

COPY startapp.sh /startapp.sh

# tixati install has troubles if front end not set
ENV DEBIAN_FRONTEND=noninteractive \
	APP_NAME="tixati"

# no idea why, but xterm makes it work!
# install tixati dependencies, because this doesn't happen automatically for some strange reason
# download tixati, since not in any repo anywhere
RUN add-pkg xterm \
	curl \
	libdbus-1-dev \
	libdbus-glib-1-2 \
	libgtk2.0-0 \
	apt-utils \
	gconf2 && \
curl \
	--silent \
	--output /var/tmp/tixati.deb https://download2.tixati.com/download/tixati_2.89-1_amd64.deb && \
export TERM=vt100 && \
add-pkg /var/tmp/tixati.deb && \
sed-patch \
	's/<application type="normal">/<application type="normal" title="Tixati v2.89">/' \
	/etc/xdg/openbox/rc.xml

# This healthcheck will kill tixati if the tunnel is not running, which will force a restart of the container
HEALTHCHECK CMD /usr/sbin/ip addr show dev tun0 || /usr/bin/tixati -closenow

