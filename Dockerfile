FROM thindil/gnat
ENV PATH=/opt/gnat/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
COPY install.sh /tmp/
RUN apt-get update && apt-get install -y \
 curl \
 libx11-dev \
 libxinerama-dev \
 libxrender-dev \
 libsm-dev \
 libice-dev \
 && curl -sSLf https://github.com/onox/inotify-ada/archive/v1.0.0.tar.gz \
  --output /tmp/v1.0.0.tar.gz \
 && cd /tmp
 && tar -xf v1.0.0.tar.gz \
 && cd inotify-ada-1.0.0 \
 && make \
 && make install PREFIX=/opt/gnat \
 && cd / \
 && rm -r /tmp/inotify-ada-1.0.0 \
 && rm /tmp/v1.0.0.tar.gz \
 && curl -sSf http://mirrors.cdn.adacore.com/art/5ce8274a09dcd01acedc1ae3 \
  --output /tmp/gtkada-community-2019-20190523-x86_64-linux-bin.tar.gz \
 && tar -xf /tmp/gtkada-community-2019-20190523-x86_64-linux-bin.tar.gz \
 && cp /tmp/install.sh /gtkada-community-2019-20190523-x86_64-linux-bin/ \
 && chmod +x /gtkada-community-2019-20190523-x86_64-linux-bin/install.sh \
 && cd gtkada-community-2019-20190523-x86_64-linux-bin \
 && ./install.sh \
 && find /opt/gnat/ -type d -empty -delete \
 && rm -rf /tmp/gtkada-community-2019-20190523-x86_64-linux-bin.tar.gz \
 && rm -rf gtkada-community-2019-20190523-x86_64-linux-bin \
 && apt-get purge -y --auto-remove curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
