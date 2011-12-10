<!DOCTYPE html>
<?php
  $title_path = dirname(__FILE__) ."/content/title.txt";
  $contents_path = dirname(__FILE__) ."/content/contents.txt";
  $congratulations_path = dirname(__FILE__) ."/content/congratulations.txt";

  $title = file_get_contents($title_path);
  $contents = file_get_contents($contents_path);
  $congratulations = file_get_contents($congratulations_path);

  function get_javascript_filenames($javascript_dir) {
    $result = Array();

    $dirs = scandir($javascript_dir);
    foreach ($dirs as $entry) {
      $entry_path = $javascript_dir . $entry;
      $entry_parts = pathinfo($entry_path);

      if ($entry_parts['extension'] == 'js') {
        $result[] = $entry_path;
      }
    }

    return $result;
  }
?>
<html>
  <head>
    <title><?php echo $title; ?></title>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
    <script type="text/javascript" src="script/jquery-dotimeout/jquery.ba-dotimeout.js"></script>
    <?php
      $files = get_javascript_filenames('script/');

      foreach ($files as $file) {
        echo "<script type=\"text/javascript\" src=\"$file\"></script>";
      }
    ?>
    <link rel="stylesheet" type="text/css" href="css/style.css" />
  </head>
  <body>
    <div id="notice"></div>
    <h1><?php echo $title ?></h1>

    <div id="letters">
      <div id="last_letter" class="letter" style="display: none"></div>
      <div id="current_letter" class="letter"></div>
    </div>
    <div id="typed_text"></div>
    <div id="congratulations" style="display:none"><?php echo $congratulations ?></div>
  </body>
</html>
