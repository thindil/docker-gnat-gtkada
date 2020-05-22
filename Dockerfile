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
 && curl -sSf "https://community.download.adacore.com/v1/8d4bb21f8122cd0796c6aab3541326e2d3bcda0d?filename=gtkada-2020-x86_64-linux-bin.tar.gz" \
  --output /tmp/gtkada-2020-x86_64-linux-bin.tar.gz \
 && tar -xf /tmp/gtkada-2020-x86_64-linux-bin.tar.gz \
 && cp /tmp/install.sh /gtkada-2020-x86_64-linux-bin/ \
 && chmod +x /gtkada-2020-x86_64-linux-bin/install.sh \
 && cd gtkada-2020-x86_64-linux-bin \
 && ./install.sh \
 && find /opt/gnat/ -type d -empty -delete \
 && rm -rf /tmp/gtkada-2020-x86_64-linux-bin.tar.gz \
 && rm -rf gtkada-2020-x86_64-linux-bin \
 && apt-get purge -y --auto-remove curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
