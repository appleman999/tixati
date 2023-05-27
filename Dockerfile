FROM jlesage/baseimage-gui:ubuntu-22.04-v4

COPY startapp.sh /startapp.sh

# install tixati dependencies, because this doesn't happen automatically for some strange reason
# download tixati, since not in any repo anywhere
RUN add-pkg xterm \
	curl \
	libgtk-3-0 \
	iproute2 \
	ca-certificates \
	xdg-utils && \
update-ca-certificates && \
/usr/bin/curl \
	--silent \
	--output /var/tmp/tixati.deb https://download2.tixati.com/download/tixati_3.19-1_amd64.deb && \
export TERM=vt100 && add-pkg /var/tmp/tixati.deb && \
set-cont-env APP_NAME "tixati" && \
set-cont-env APP_VERSION "3.19"

# This healthcheck will kill tixati if the tunnel is not running, which will force a restart of the container
HEALTHCHECK CMD /usr/sbin/ip addr show dev tun0 || bash -c 'kill -s 15 -1 && (sleep 10; kill -s 9 -1)'

