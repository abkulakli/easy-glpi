FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
EXPOSE 80/tcp
RUN apt update -y
RUN apt upgrade -y
RUN apt install -y nginx php-fpm mariadb-server -y
RUN rm /var/www/html/index.nginx-debian.html
COPY nginx/default /etc/nginx/sites-available/default
COPY glpi /var/www/html/
#CMD ["nginx", "-g", "daemon off;"]