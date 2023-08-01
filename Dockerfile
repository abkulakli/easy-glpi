FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
EXPOSE 80/tcp
RUN mkdir /data
RUN mkdir /data/glpi
RUN mkdir /data/glpi/log
RUN mkdir /data/glpi/etc
RUN mkdir /data/glpi/lib
RUN mkdir /data/glpi/lib/_cron
RUN mkdir /data/glpi/lib/_dumps
RUN mkdir /data/glpi/lib/_graphs
RUN mkdir /data/glpi/lib/_lock
RUN mkdir /data/glpi/lib/_pictures
RUN mkdir /data/glpi/lib/_plugins
RUN mkdir /data/glpi/lib/_rss
RUN mkdir /data/glpi/lib/_sessions
RUN mkdir /data/glpi/lib/_tmp
RUN mkdir /data/glpi/lib/_uploads
RUN apt update -y
RUN apt upgrade -y
RUN apt install -y nano nginx php-fpm php-mysql php-xml php-curl php-gd php-intl php-ldap php-bz2 php-zip php-mbstring mariadb-server -y
RUN rm /var/www/html/index.nginx-debian.html
COPY glpi-10.0.9.tgz /glpi-10.0.9.tgz
RUN tar xvf /glpi-10.0.9.tgz -C /var/www/html --strip-components=1
RUN chown -R www-data:www-data /var/www/html/marketplace
RUN rm /glpi-10.0.9.tgz
COPY nginx/default /etc/nginx/sites-available/default
COPY php/php.ini /etc/php/8.1/fpm/php.ini
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY glpi/downstream.php /var/www/html/inc/downstream.php
COPY glpi/local_define.php /data/glpi/etc/local_define.php
COPY glpi/glpicrypt.key /data/glpi/etc/glpicrypt.key
COPY glpi/config_db.php /data/glpi/etc/config_db.php

RUN chown -R www-data:www-data /data/glpi
RUN service mariadb start \
    && mariadb -u root -e "CREATE DATABASE glpi;" \
    && mariadb -u root -e "CREATE USER glpi_user@localhost IDENTIFIED BY 'g1piR0CKS';" \
    && mariadb -u root -e "GRANT ALL PRIVILEGES ON glpi.* TO glpi_user@localhost;" \
    && service mariadb stop
VOLUME [ "/data"]
#ENTRYPOINT [ "/entrypoint.sh" ]
#CMD ["nginx", "-g", "daemon off;"]