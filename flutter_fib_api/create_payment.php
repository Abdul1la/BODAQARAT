<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// 🔹 Step 1: Call get_token.php via cURL
$ch = curl_init();
curl_setopt_array($ch, [
  CURLOPT_URL => "https://bodaqarat.com/flutter_fib_api/get_token.php",
  CURLOPT_RETURNTRANSFER => true,
  CURLOPT_SSL_VERIFYPEER => false
]);
$tokenResponse = curl_exec($ch);
$tokenError = curl_error($ch);
curl_close($ch);

if ($tokenError) {
  echo json_encode(["error" => "Failed to reach get_token.php", "details" => $tokenError]);
  exit;
}

$tokenData = json_decode($tokenResponse, true);
if (!isset($tokenData["access_token"])) {
  echo json_encode(["error" => "Token not found in get_token.php response", "raw" => $tokenResponse]);
  exit;
}

$token = $tokenData["access_token"];
// إعداد بيانات الطلب
$url = "https://fib.stage.fib.iq/protected/v1/payments";
$amount = $_POST['amount'] ?? 1000;
$description = $_POST['description'] ?? "Payment via app";

$payload = [
  "monetaryValue" => [
    "amount" => (int)$amount,
    "currency" => "IQD"
  ],
  "statusCallbackUrl" => "https://bodaqarat.com/flutter_fib_api/payment-callback.php",
  "description" => $description,
  "redirectUri" => "https://bodaqarat.com/flutter_fib_api/success.php",
  "expiresIn" => "PT8H",
  "category" => "ECOMMERCE",
  "refundableFor" => "PT48H"
];

$options = [
  "http" => [
    "header" => "Authorization: Bearer $token\r\nContent-Type: application/json\r\n",
    "method" => "POST",
    "content" => json_encode($payload)
  ]
];

$context = stream_context_create($options);
$result = file_get_contents($url, false, $context);
if ($result === FALSE) {
  echo json_encode(["error" => "Unable to create payment"]);
  exit;
}

echo $result;
?>
