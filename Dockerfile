FROM debian:buster-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        gpg \
        gpg-agent \
        wget \
        ca-certificates \
        supervisor \
        cron \
        logrotate

RUN wget -q -O - https://download.gluster.org/pub/gluster/glusterfs/8/rsa.pub|apt-key add
RUN echo deb [arch=amd64] https://download.gluster.org/pub/gluster/glusterfs/8/LATEST/Debian/buster/amd64/apt buster main > /etc/apt/sources.list.d/gluster.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends glusterfs-server && \
    apt-get clean

COPY etc/supervisor/conf.d/000-supervisor.conf /etc/supervisor/conf.d/
COPY etc/supervisor/conf.d/010-cron.conf /etc/supervisor/conf.d/
COPY etc/supervisor/conf.d/020-gluster.conf /etc/supervisor/conf.d/
COPY usr/local/bin/start-glusterfs-server /usr/local/bin/

RUN chmod +x /usr/local/bin/start-glusterfs-server

VOLUME /data
VOLUME /var/lib/glusterd
VOLUME /var/log/glusterfs

CMD ["/usr/local/bin/start-glusterfs-server"]
