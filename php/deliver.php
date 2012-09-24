<?php

// Handles DB connection.
include("config.php"); 

 /********************************************
  * POST vars from iPhone app
 ********************************************/
$jobNumber = mysql_escape_string($_POST["jobNumber"]);
$collectDeliverCodeFromApp = mysql_escape_string($_POST["deliverBarCodeID"]);

 /********************************************
  * Find job based on QR code that was scanned
 ********************************************/
$selectAllFromJobs = mysql_query(" SELECT * FROM jobs WHERE jobNumber='{$jobNumber}' ") or die(mysql_error()); 

// store the record of the "selectAllFromJobs" table into $row
$row = mysql_fetch_array( $selectAllFromJobs );

 /********************************************
  * compare barcode that was scanned from the App with barcode in the job number, if successful, do something, else fail.
 ********************************************/
	if(empty($_POST['deliverBarCodeID']))
	   	{
	     		echo "404";
	   	}
	   	
	else if ($row['deliverBarCodeID']=="{$collectDeliverCodeFromApp}")
	{

	mysql_query("UPDATE jobs SET status ='Delivered' WHERE jobNumber='$jobNumber'") or die(mysql_error());

	/********************************************
	  * Email Client success!
	 ********************************************/
	$to      = 'crowson.j@gmail.com';
	$subject = 'Your package has been delivered';
	$message = '
	Hello
	
	Just to let you know that Nobby Nobbs has delivered your package successfully.
	
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

?>