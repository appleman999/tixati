FROM jlesage/baseimage-gui:ubuntu-20.04

COPY startapp.sh /startapp.sh

# tixati install has troubles if front end not set
ENV DEBIAN_FRONTEND noninteractive

# no idea why, but xterm makes it work!
RUN add-pkg xterm curl

# download tixati, since not in any repo anywhere
RUN curl --silent --output /var/tmp/tixati.deb https://download2.tixati.com/download/tixati_2.88-1_amd64.deb

# install tixati dependencies, because this doesn't happen automatically for some strange reason
RUN add-pkg libdbus-1-dev libdbus-glib-1-2 libgtk2.0-0 apt-utils gconf2

# install tixati
RUN export TERM=vt100 && add-pkg /var/tmp/tixati.deb

ENV APP_NAME="tixati"

HEALTHCHECK --interval=30s --timeout=3s \
  CMD /usr/bin/curl --fail --insecure --output /dev/null --silent https://localhost:5800 || exit 1

RUN sed-patch 's/<application type="normal">/<application type="normal" title="Tixati v2.88">/' /etc/xdg/openbox/rc.xml
