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
#RUN service mariadb start \
#    && mariadb -u root -e "CREATE DATABASE glpi;" \
#    && mariadb -u root -e "CREATE USER glpi_user@localhost IDENTIFIED BY 'g1piR0CKS';" \
#    && mariadb -u root -e "GRANT ALL PRIVILEGES ON glpi.* TO glpi_user@localhost;" \
#    && service mariadb stop
VOLUME [ "/data"]
ENTRYPOINT [ "/entrypoint.sh" ]
#CMD ["nginx", "-g", "daemon off;"]