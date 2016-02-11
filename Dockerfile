FROM debian:jessie

RUN groupadd -r tpcc-mysql && useradd -r -g tpcc-mysql tpcc-mysql

# mysql server is necessary because segmentation fault occurs on tpcc_start
ENV MYSQL_MAJOR 5.6
ENV MYSQL_VERSION 5.6.29-1debian8

RUN echo "deb http://repo.mysql.com/apt/debian/ jessie mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list
RUN { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections

RUN apt-get update && apt-get install -y --force-yes --no-install-recommends \
    build-essential \
		ca-certificates \
		curl \
    zlib1g-dev \
    libmysql++-dev \
    bzr \
    mysql-server="${MYSQL_VERSION}" \
	&& rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/mysql

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && curl -o /usr/local/bin/gosu -fSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" \
	&& curl -o /usr/local/bin/gosu.asc -fSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

RUN bzr branch lp:~percona-dev/perconatools/tpcc-mysql /opt/tpcc-mysql \
  && chown -R tpcc-mysql:tpcc-mysql /opt/tpcc-mysql \
  && cd /opt/tpcc-mysql/src \
  && make all

ENV PATH /opt/tpcc-mysql:$PATH
WORKDIR /opt/tpcc-mysql

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY _test.sh /opt/tpcc-mysql/_test.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
