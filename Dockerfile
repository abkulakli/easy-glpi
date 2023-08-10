FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
EXPOSE 80/tcp
RUN apt update -y
RUN apt upgrade -y
RUN apt install -y cron nano nginx php-fpm php-mysql php-xml php-curl php-gd php-intl php-ldap php-bz2 php-zip php-mbstring mariadb-server -y
RUN apt autoremove
RUN apt autoclean
RUN rm /var/www/html/index.nginx-debian.html
COPY glpi-10.0.9.tgz /glpi-10.0.9.tgz
RUN tar xvf /glpi-10.0.9.tgz -C /var/www/html --strip-components=1
RUN chown -R www-data:www-data /var/www/html/marketplace
RUN rm -rf /var/www/html/install
RUN rm /glpi-10.0.9.tgz
COPY nginx/default /etc/nginx/sites-available/default
COPY php/php.ini /etc/php/8.1/fpm/php.ini
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY glpi/downstream.php /var/www/html/inc/downstream.php
COPY data /data
RUN chown -R www-data:www-data /data/glpi
RUN chown -R mysql:mysql /data/mariadb
COPY /mariadb/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY crontab/www-data /var/spool/cron/crontabs/www-data
RUN chown -R www-data:crontab /var/spool/cron/crontabs/www-data
COPY crontab/root /var/spool/cron/crontabs/root
RUN chown -R root:crontab /var/spool/cron/crontabs/root
RUN touch var/log/cron.log
RUN chmod 666 var/log/cron.log
VOLUME [ "/data"]
#ENTRYPOINT [ "/entrypoint.sh" ]
