FROM debian:bookworm AS builder

LABEL maintainer="Ed Beroset <beroset@ieee.org>"

WORKDIR /tmp/
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install packages required to build qml-asteroid
RUN apt-get update && apt-get install -y \
  build-essential cmake git pkg-config qtbase5-dev qtdeclarative5-dev \
  qttools5-dev qttools5-dev-tools libqt5quickcontrols2-5 libqt5svg5-dev \
  qml-module-qtquick2 qml-module-qtquick-controls2 qml-module-qtquick-window2 \
  libglib2.0-dev gettext libicu-dev libssl-dev python3 python3-pip \
  ninja-build ca-certificates qtbase5-dev qtbase5-dev-tools qtchooser \
  qtdeclarative5-dev qml-module-qtquick2 wget libqt5svg5-dev \
  extra-cmake-modules

# get a newer version of CMake to handle nested generator expressions
RUN wget -qO /tmp/cmake.sh https://github.com/Kitware/CMake/releases/download/v4.2.3/cmake-4.2.3-linux-x86_64.sh && sh /tmp/cmake.sh --skip-license --prefix=/usr/local \ && rm /tmp/cmake.sh
RUN git clone https://github.com/AsteroidOS/qml-asteroid
WORKDIR /tmp/qml-asteroid
RUN cmake -DWITH_ASTEROIDAPP=OFF -DWITH_CMAKE_MODULES=OFF -S . -B desktop
RUN cmake --build desktop -j
RUN cmake --build desktop -j -t install

FROM debian:bookworm-slim
WORKDIR /
RUN apt-get update && apt-get install -y git whiptail zenity qmlscene \
  qml-module-qtquick-layouts qml-module-qt-labs-settings qml-module-qtquick-dialogs \
  qml-module-qtquick-controls2 qml-module-qtgraphicaleffects 
COPY --from=builder /usr/lib/x86_64-linux-gnu/qt5/qml/org /usr/lib/x86_64-linux-gnu/qt5/qml/org/
RUN git clone https://github.com/AsteroidOS/unofficial-watchfaces.git

RUN mkdir /xdgcache && chmod 1777 /xdgcache
RUN mkdir -p /.config/fontconfig && chmod 1777 /.config/fontconfig

ENV XDG_CACHE_HOME=/xdgcache
ENV FONTCONFIG_PATH=/.config/fontconfig

WORKDIR /unofficial-watchfaces/
ENTRYPOINT ["/unofficial-watchfaces/watchface"]
