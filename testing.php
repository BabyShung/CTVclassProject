<?php

require_once 'includes/main.php';
require_once "includes/Register.class.php";
require_once "includes/form_functions.php";

echo 'hi';

$resultUser = ORM::for_table('courses')->create();
		$resultUser->id = 1;
		$resultUser->coursename = 'hh';
		$resultUser->token = 'fda';
		$resultUser->save();
echo $resultUser->save();

?>

<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8"/>
		<title>Register</title>

		<link href="http://fonts.googleapis.com/css?family=Open+Sans:400,700" rel="stylesheet">

		<!-- The main CSS file -->
		<link href="assets/css/loginRegister.css" rel="stylesheet" />

		<!--[if lt IE 9]>
			<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
	</head>

	<body>


        
		<!-- JavaScript Includes -->
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
		<script src="assets/js/loginRegister.js"></script>

	</body>
</html>