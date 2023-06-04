FROM jlesage/baseimage-gui:ubuntu-22.04-v4

RUN \
    add-pkg locales && \
    sed-patch 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8 APP_NAME=tixati APP_VERSION=3.19

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
set-cont-env APP_NAME "${APP_NAME}" && \
set-cont-env APP_VERSION "${APP_VERSION}" && \
/usr/bin/curl \
	--silent \
	--output /var/tmp/tixati.deb https://download2.tixati.com/download/tixati_${APP_VERSION}-1_amd64.deb && \
export TERM=vt100 && add-pkg /var/tmp/tixati.deb && \
mkdir "/etc/openbox" && \
echo "<Type>normal</Type>" >> "/etc/openbox/main-window-selection.xml" && \
echo "<Title>Tixati v${APP_VERSION}</Title>" >> "/etc/openbox/main-window-selection.xml"

# This healthcheck will kill tixati if the tunnel is not running, which will force a restart of the container
HEALTHCHECK CMD /usr/sbin/ip addr show dev tun0 || bash -c 'kill -s 15 -1 && (sleep 10; kill -s 9 -1)'

