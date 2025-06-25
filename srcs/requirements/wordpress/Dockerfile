FROM debian:bullseye

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install wget -y
RUN apt-get install php7.4 -y
RUN apt-get install php-fpm -y
RUN apt-get install php-mysql -y
RUN apt-get install mariadb-client -y

RUN wget https://fr.wordpress.org/wordpress-6.7-fr_FR.tar.gz -P /var/www
RUN cd /var/www && tar -xzf wordpress-6.7-fr_FR.tar.gz && rm wordpress-6.7-fr_FR.tar.gz
RUN	chown -R root:root /var/www/wordpress

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY conf/my_entrypoint.sh /tmp/my_entrypoint.sh
RUN chmod +x /tmp/my_entrypoint.sh

COPY conf/index.html /tmp/index.html
RUN chmod +x /tmp/index.html

EXPOSE 9000

ENTRYPOINT [ "/tmp/my_entrypoint.sh" ]