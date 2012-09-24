<?php

// Handles DB connection.
include("config.php"); 

 /********************************************
  * POST vars from iPhone app
 ********************************************/
$jobNumber = mysql_escape_string($_POST["jobNumber"]);
$collectBarCodeIDFromApp = mysql_escape_string($_POST["collectBarCodeID"]);

 /********************************************
  * Find job based on QR code that was scanned
 ********************************************/
$selectAllFromJobs = mysql_query(" SELECT * FROM jobs WHERE jobNumber='{$jobNumber}' ") or die(mysql_error()); 

// store the record of the "selectAllFromJobs" table into $row
$row = mysql_fetch_array( $selectAllFromJobs );

 /********************************************
  * compare barcode that was scanned from the App with barcode in the job number, if successful, do something, else fail.
 ********************************************/
if(empty($_POST['collectBarCodeID']))
   	{
     		echo "404";
   	}

	else if ($row['collectBarCodeID']=="{$collectBarCodeIDFromApp}")
	{

	  //Generate random 5 digit string for delivery QR Code
	$deliverBarCodeIDRandomString = rand_string( 5 );

	mysql_query("UPDATE jobs SET status ='COLLECTED', deliverBarCodeID ='{$deliverBarCodeIDRandomString}' WHERE jobNumber='$jobNumber'") or die(mysql_error());

	/********************************************
	  * Email recipient QR code and 5 digit delivery code.
	 ********************************************/
	$to      = 'crowson.j@gmail.com';
	$subject = 'Someone has collected your package';
	$message = '
	Hello
	
	Someone has collected your package and will deliver it shortly.
	
	Please show them this 5 digit code when they arrive to confirm they have delivered your package: '

	.$deliverBarCodeIDRandomString. '

	';

	$headers = 'From: postroom@example.com' . "\r\n" .
			'Content-type: text/html' . "\r\n" .
	    'Reply-To: do-not-reply@example.com' . "\r\n" .
	    'X-Mailer: PHP/' . phpversion();

	mail($to, $subject, $message,  $headers);

	/********************************************
	  * Echo out 200 status code
	 ********************************************/  
	echo "200";
	}

	else
	{
		echo "501";
	}	 

/********************************************
  * Generate 5 digit random string for DeliverBarCodeID
 ********************************************/

function rand_string( $length ) {

	$chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";	
	$size = strlen( $chars );
	for( $i = 0; $i < $length; $i++ ) {
		$str .= $chars[ rand( 0, $size - 1 ) ];
	}

	return $str;
}



?>