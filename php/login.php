<?php

// Handles DB connection.
include("config.php"); 

header('Content-Type: text/javascript');

 /********************************************
  * POST vars from iPhone app
 ********************************************/
$username = mysql_escape_string($_POST["username"]);
$password = mysql_escape_string($_POST["password"]);

 /********************************************
  * Find job based on QR code that was scanned
 ********************************************/
$selectAllFromAgents = mysql_query(" SELECT * FROM agents WHERE username='{$username}' AND password ='{$password}' ") or die(mysql_error()); 

$count = mysql_num_rows($selectAllFromAgents);

if ($count == 1) {

  echo "200";

}

else {

  echo "404";
}

?>