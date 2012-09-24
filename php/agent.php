<?php

// Handles DB connection.
include("config.php"); 

header('Content-Type: text/javascript');

 /********************************************
  * POST vars from iPhone app
 ********************************************/
//$jobNumber = mysql_escape_string($_POST["jobNumber"]);

 /********************************************
  * Find job based on QR code that was scanned
 ********************************************/
$query = "SELECT * FROM agents WHERE username = 'jcrowson' ";

$result = mysql_query($query);

//TEST

$data = array();

while ($agent = mysql_fetch_array($result)) {     
  
    $id = $agent['id'];
    $username = $agent['username'];
    $photograph = $agent['photograph'];
    $reputation = $agent['reputation'];
    $firstName = $agent['firstName'];
    $lastName = $agent['lastName'];
    $addressLine1 = $agent['addressLine1'];
    $addressLine2 = $agent['addressLine2'];
    $city = $agent['city'];
    $postcode = $agent['postcode'];
    $country = $agent['country'];
    $mobile = $agent['mobile'];
    $verifiedMobile = $agent['verifiedMobile'];
    $skype = $agent['skype'];
    $verifiedSkype = $agent['verifiedSkype'];
    $joinDate = $agent['joinDate'];

    $data[] = array(
      "id" => $id,
      "username" => $username,
      "photograph" => $photograph,
      "reputation" => $reputation,
      "firstName" => $firstName,
      "lastName" => $lastName,
      "addressLine1" => $addressLine1,
      "addressLine2" => $addressLine2,
      "city" => $city,
      "postcode" => $postcode,
      "country" => $country,
      "mobile" => $mobile,
      "verifiedMobile" => $verifiedMobile,
      "skype" => $skype,
      "verifiedSkype" => $verifiedSkype,
      "joinDate" => $joinDate
    );
}

$array2 = array(
    "meta" => 
          array(
                  "code" => 200
          ),
      "agent" =>
            $data
      );

echo json_encode($array2);


?>