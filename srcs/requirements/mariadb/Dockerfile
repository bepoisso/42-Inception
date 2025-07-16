FROM debian:bullseye

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y mariadb-server
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld
RUN chmod -R 755 /var/run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql
RUN chmod -R 755 /var/lib/mysql

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY my_entrypoint.sh /my_entrypoint.sh
RUN chmod +x /my_entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["bash", "/my_entrypoint.sh"]
