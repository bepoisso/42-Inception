FROM debian:bullseye

RUN apt update -y
RUN	apt upgrade -y
RUN	apt install -y wget curl php7.4 php7.4-fpm php7.4-mysql mariadb-client unzip less netcat
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN wget https://fr.wordpress.org/wordpress-6.8.1-fr_FR.tar.gz -P /var/www
RUN tar -xzf /var/www/wordpress-6.8.1-fr_FR.tar.gz -C /var/www
RUN rm /var/www/wordpress-6.8.1-fr_FR.tar.gz
RUN chown -R www-data:www-data /var/www/wordpress

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY my_entrypoint.sh /usr/local/bin/my_entrypoint.sh
RUN chmod +x /usr/local/bin/my_entrypoint.sh

WORKDIR /var/www/wordpress

ENTRYPOINT ["bash", "/usr/local/bin/my_entrypoint.sh"]
