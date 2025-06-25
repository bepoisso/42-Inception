FROM debian:bullseye

RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server -y

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld



COPY /conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/my_entrypoint.sh /tmp/my_entrypoint.sh

RUN chmod +x /tmp/my_entrypoint.sh

ENTRYPOINT ["/tmp/my_entrypoint.sh"]