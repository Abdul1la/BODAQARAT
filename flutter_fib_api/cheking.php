<?php
if (function_exists('curl_version')) {
    echo "✅ cURL is enabled<br>";
} else {
    echo "❌ cURL is NOT enabled<br>";
}

echo "<br>allow_url_fopen = " . (ini_get('allow_url_fopen') ? "ON" : "OFF");
?>
