FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
EXPOSE 80/tcp
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
RUN mkdir /var/lib/glpi
RUN mkdir /var/lib/glpi/_cron
RUN mkdir /var/lib/glpi/_dumps
RUN mkdir /var/lib/glpi/_graphs
RUN mkdir /var/lib/glpi/_lock
RUN mkdir /var/lib/glpi/_pictures
RUN mkdir /var/lib/glpi/_plugins
RUN mkdir /var/lib/glpi/_rss
RUN mkdir /var/lib/glpi/_sessions
RUN mkdir /var/lib/glpi/_tmp
RUN mkdir /var/lib/glpi/_uploads
RUN chown -R www-data:www-data /var/lib/glpi
RUN mkdir /var/log/glpi
RUN chown -R www-data:www-data /var/log/glpi
COPY glpi/downstream.php /var/www/html/inc/downstream.php
COPY glpi/local_define.php /etc/glpi/local_define.php
COPY glpi/glpicrypt.key /etc/glpi/glpicrypt.key
COPY glpi/config_db.php /etc/glpi/config_db.php

RUN chown -R www-data:www-data /etc/glpi
RUN service mariadb start \
    && mariadb -u root -e "CREATE DATABASE glpi;" \
    && mariadb -u root -e "CREATE USER glpi_user@localhost IDENTIFIED BY 'g1piR0CKS';" \
    && mariadb -u root -e "GRANT ALL PRIVILEGES ON glpi.* TO glpi_user@localhost;" \
    && service mariadb stop
#ENTRYPOINT [ "/entrypoint.sh" ]
#CMD ["nginx", "-g", "daemon off;"]