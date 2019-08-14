FROM buzzkillb/xpra-base:latest as builder
#COPY local-entrypoint.sh /

ENV DISPLAY=:100
ENV WEB_VIEW_PORT 10000

RUN apt-get update && apt-get install -y \
git \
wget \
unzip \
automake \
build-essential \
libssl-dev \
libdb++-dev \
libboost-all-dev \
libqrencode-dev \
libminiupnpc-dev \
libevent-dev \
autogen \
automake \
libtool \
make \
libqt5gui5 \
libqt5core5a \
libqt5dbus5 \
qttools5-dev \
qttools5-dev-tools \
qt5-default \
&& rm -rf /var/lib/apt/lists/*
RUN (git clone https://github.com/carsenk/denarius && \
cd denarius && \
git checkout i2pupdate && \
git pull && \
qmake "USE_UPNP=1" "USE_QRCODE=1" denarius-qt.pro && \
make -j3)

FROM buzzkillb/xpra-base:latest

RUN apt-get update && apt-get install -y \
automake \
build-essential \
libssl-dev \
libdb++-dev \
libboost-all-dev \
libqrencode-dev \
libminiupnpc-dev \
libevent-dev \
libtool \
libqt5gui5 \
libqt5core5a \
libqt5dbus5 \
qttools5-dev \
qttools5-dev-tools \
qt5-default \
&& rm -rf /var/lib/apt/lists/*

# final image
COPY --from=builder /denarius/Denarius /usr/local/bin/
COPY local-entrypoint.sh /

#VOLUME /denarius

CMD ["/local-entrypoint.sh"]
EXPOSE 10000
