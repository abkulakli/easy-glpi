<?php
class DB extends DBmysql {
   public $dbhost = 'localhost';
   public $dbuser = 'glpi_user';
   public $dbpassword = 'g1piR0CKS';
   public $dbdefault = 'glpi';
   public $use_utf8mb4 = true;
   public $allow_myisam = false;
   public $allow_datetime = false;
   public $allow_signed_keys = false;
}
