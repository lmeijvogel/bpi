<!DOCTYPE html>
<?php
  $title_path = dirname(__FILE__) ."/content/title.txt";
  $contents_path = dirname(__FILE__) ."/content/contents.txt";

  $title = file_get_contents($title_path);
  $contents = file_get_contents($contents_path);
?>
<html>
  <head>
    <title><?php echo $title; ?></title>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.js"></script>
    <script type="text/javascript" src="script/main.js"></script>
    <link rel="stylesheet" type="text/css" href="css/style.css" />
  </head>
  <body>
    <div id="notice"></div>
    <h1><?php echo $title ?></h1>

    <div id="current_letter" class="letter"></div>
    <div id="upcoming_letter" class="letter" style="display: none"></div>
  </body>
</html>
