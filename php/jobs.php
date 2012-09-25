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

    //Collection
    $collectionAddressLine1 = $job['collectionAddressLine1'];
    $collectionAddressLine2 = $job['collectionAddressLine2'];
    $collectionCity = $job['collectionCity'];
    $collectionPostcode = $job['collectionPostcode'];
    $collectionTime = $job['collectionTime'];

    //Delivery
    $deliveryAddressLine1 = $job['deliveryAddressLine1'];
    $deliveryAddressLine2 = $job['deliveryAddressLine2'];
    $deliveryCity = $job['deliveryCity'];
    $deliveryPostcode = $job['deliveryPostcode'];
    $deliveryTime = $job['deliveryTime'];

    //QR code stuff
    $collectBarCodeID = $job['collectBarCodeID'];
    $deliverBarCodeID = $job['deliverBarCodeID'];

    //Recipient stuff
    $recipientFirstName = $job['recipientFirstName'];
    $recipientLastName = $job['recipientLastName'];
    $agentUsername = $job['agentUsername'];
    $clientUsername = $job['clientUsername'];

    $comments = $job['comments'];

    $data[] = array(
      "id" => $id,
      "jobNumber" => $jobNumber,
      "price" => $price,
      "status" => $status,
      "collectionAddressLine1" => $collectionAddressLine1,
      "collectionAddressLine2" => $collectionAddressLine2,
      "collectionCity" => $collectionCity,
      "collectionPostcode" => $collectionPostcode,
      "deliveryAddressLine1" => $deliveryAddressLine1,
      "deliveryAddressLine2" => $deliveryAddressLine2,
      "deliveryCity" => $deliveryCity,
      "deliveryPostcode" => $deliveryPostcode,
      "deliveryTime" => $deliveryTime,
      "collectBarCodeID" => $collectBarCodeID,
      "deliverBarCodeID" => $deliverBarCodeID,
      "recipientFirstName" => $recipientFirstName,
      "recipientLastName" => $recipientLastName,
      "recipientPostCode" => $recipientPostCode,
      "agentUsername" => $agentUsername,
      "clientUsername" => $clientUsername,
      "comments" => $comments
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