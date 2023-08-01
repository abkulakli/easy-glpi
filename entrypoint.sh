#!/usr/bin/env bash
service mariadb start
service php8.1-fpm start
nginx -g 'daemon off;'