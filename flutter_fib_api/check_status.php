<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$paymentId = $_GET['paymentId'] ?? null;
if (!$paymentId) {
  echo json_encode(["error" => "Missing paymentId"]);
  exit;
}

$tokenData = json_decode(file_get_contents("https://bodaqarat.com/flutter_fib_api/get_token.php"), true);
if (!isset($tokenData["access_token"])) {
  echo json_encode(["error" => "Token not available"]);
  exit;
}
$token = $tokenData["access_token"];

$url = "https://fib.stage.fib.iq/protected/v1/payments/$paymentId/status";
$options = [
  "http" => [
    "header" => "Authorization: Bearer $token\r\n",
    "method" => "GET"
  ]
];

$context = stream_context_create($options);
$result = file_get_contents($url, false, $context);
echo $result ?: json_encode(["error" => "Failed to fetch status"]);
?>
