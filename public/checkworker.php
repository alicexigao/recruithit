<?php

  $server = 'localhost';
  $database = "turkserver";
  $username = "xagao";
  $password = "fashion";
  $db_handle = mysql_connect($server, $username, $password);
  @mysql_select_db($database) or die ("Unable to select database");
  
  $workerId = mysql_real_escape_string($_POST["workerId"]);
  
  $query = "select * from session where workerId='" . $workerId . "'";
  $result = mysql_query($query);
  if (!$result) {
    die ("Cannot run query" + $query);
  }
  if (mysql_num_rows($result) > 0) {
    $returnVal = array("found"=>true);
  } else {
    $returnVal = array("found"=>false);
  }
  echo json_encode($returnVal);
  mysql_close($db_handle);
  
?>