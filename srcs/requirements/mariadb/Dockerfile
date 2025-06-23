FROM debian:bullseye

RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server -y

COPY /conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/my_entrypoint.sh /tmp/my_entrypoint.sh

RUN chmod 755 /tmp/my_entrypoint.sh
RUN /tmp/my_entrypoint.sh