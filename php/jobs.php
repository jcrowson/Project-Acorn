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
$query = "SELECT * FROM jobs WHERE agentUsername = 'jcrowson' ";

$result = mysql_query($query);

//TEST

$data = array();

while ($job = mysql_fetch_array($result)) {     
  
    $id = $job['id'];
    $jobNumber = $job['jobNumber'];
    $price = $job['price'];
    $status = $job['status'];
    $collectionPostcode = $job['collectionPostcode'];
    $collectionTime = $job['collectionTime'];
    $deliveryTime = $job['deliveryTime'];
    $collectBarCodeID = $job['collectBarCodeID'];
    $deliverBarCodeID = $job['deliverBarCodeID'];
    $recipientFirstName = $job['recipientFirstName'];
    $recipientLastName = $job['recipientLastName'];
    $recipientPostCode = $job['recipientPostCode'];
    $agentUsername = $job['agentUsername'];
    $clientUsername = $job['clientUsername'];

    $data[] = array(
      "id" => $id,
      "jobNumber" => $jobNumber,
      "price" => $price,
      "status" => $status,
      "collectionPostcode" => $collectionPostcode,
      "collectionTime" => $collectionTime,
      "deliveryTime" => $deliveryTime,
      "collectBarCodeID" => $collectBarCodeID,
      "deliverBarCodeID" => $deliverBarCodeID,
      "recipientFirstName" => $recipientFirstName,
      "recipientLastName" => $recipientLastName,
      "recipientPostCode" => $recipientPostCode,
      "agentUsername" => $agentUsername,
      "clientUsername" => $clientUsername
    );
}

$array2 = array(
    "meta" => 
          array(
                  "code" => 200
          ),
      "jobs" =>
            $data
      );

echo json_encode($array2);


?>