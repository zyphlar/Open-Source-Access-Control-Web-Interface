<?php

if(isset($_GET['id']))
  $id = $_GET['id'];

if(isset($_GET['device']))
  $device = $_GET['device'];


$accessdb = file_get_contents('../access-db.txt');
$access = explode("\n", $accessdb);

foreach($access as $line) {
  $user = explode(" ", $line);
  if(isset($user[2]) && strtoupper($user[2]) == strtoupper($id)) {
    echo "^".$user[3]."|OK$";
  }
}
