<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$paymentId = $_POST['paymentId'] ?? null;
if (!$paymentId) {
  echo json_encode(["error" => "Missing paymentId"]);
  exit;
}

$tokenData = json_decode(file_get_contents("https://bodaqarat.com/flutter_fib_api/get_token.php"), true);
if (!isset($tokenData["token"])) {
  echo json_encode(["error" => "Token not available"]);
  exit;
}
$token = $tokenData["token"];

$url = "https://fib.stage.fib.iq/protected/v1/payments/$paymentId/cancel";
$options = [
  "http" => [
    "header" => "Authorization: Bearer $token\r\n",
    "method" => "POST"
  ]
];

$context = stream_context_create($options);
$result = file_get_contents($url, false, $context);
http_response_code(204);
echo json_encode(["status" => "canceled"]);
?>
