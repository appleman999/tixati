FROM jlesage/baseimage-gui:ubuntu-20.04

COPY startapp.sh /startapp.sh

# no idea why, but xterm makes it work!
RUN add-pkg xterm openvpn curl

# download tixati, since not in any repo anywhere
RUN curl --silent --output /var/tmp/tixati.deb https://download2.tixati.com/download/tixati_2.87-1_amd64.deb

# install tixati dependencies, because this doesn't happen automatically for some strange reason
RUN add-pkg libdbus-1-dev libdbus-glib-1-2 libgtk2.0-0 apt-utils gconf2

# install tixati
RUN export TERM=vt100 && add-pkg /var/tmp/tixati.deb

ENV APP_NAME="tixati"
