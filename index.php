<!DOCTYPE html>
<?php
  $title_path = dirname(__FILE__) ."/content/title.txt";
  $contents_path = dirname(__FILE__) ."/content/contents.txt";
  $hint_text_path = dirname(__FILE__) ."/content/hint_text.txt";

  $title = file_get_contents($title_path);
  $contents = file_get_contents($contents_path);
  $hint_text = file_get_contents($hint_text_path);

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
    <div id="blind"></div>
    <div id="canvas">
      <div id="notice"></div>
      <h1><img src="gfx/title.png" /></h1>

      <div id="arrow"><img src="gfx/arrow_right.png" /></div>
      <div id="first_star" class="star"><img src="gfx/star.png" /></div>
      <div id="second_star" class="star"><img src="gfx/star.png" /></div>
      <div id="incoming_logo"><img src="gfx/mannetje.png" /></div>
      <div id="letters">
        <div id="last_letter" class="letter" style="display: none"></div>
        <div id="current_letter" class="letter"></div>
      </div>
      <div id="typed_text"></div>
      <div id="hint_text"><?php echo $hint_text ?></div>
      <div id="congratulations" style="display:none"><img src="gfx/congratulations.png" /></div>
      <div id="timer">Je tijd was: <span class="time"></span> :)</div>
    </div>
  </body>
</html>
