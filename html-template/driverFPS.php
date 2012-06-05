<?php
ini_set("display_errors","2"); ERROR_REPORTING(E_ALL);
$con = mysql_connect("localhost","whack_blogger","cobi.buttons.lynchburg.sikeston.whack");
$q = "INSERT INTO fps_data (server_string, driver_info, fps) VALUES ('" . mysql_real_escape_string($_GET['server_string'])."','". mysql_real_escape_string($_GET['driver_info'])."','". mysql_real_escape_string($_GET['fps']) ."')";
echo $q;
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }

mysql_select_db("whack_blog", $con);


mysql_query($q);

mysql_close($con);
echo "<BR>done";
?> 

