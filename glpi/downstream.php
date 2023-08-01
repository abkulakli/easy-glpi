<?php
define('GLPI_CONFIG_DIR', '/data/glpi/etc/');

if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
   require_once GLPI_CONFIG_DIR . '/local_define.php';
}
?>