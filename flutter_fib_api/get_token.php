<?php
// get_token.php


$client_id = 'bod-aqarat-test-payment';
$client_secret = '5666824c-10e8-4b54-8649-122506377dca';
$token_url = 'https://fib.stage.fib.iq/auth/realms/fib-online-shop/protocol/openid-connect/token';

$data = http_build_query([
  'grant_type' => 'client_credentials',   
  'client_id' => $client_id,
  'client_secret' => $client_secret
]);

$opts = ['http' =>
  [
    'method'  => 'POST',
    'header'  => "Content-Type: application/x-www-form-urlencoded\r\n",
    'content' => $data
  ]
];

$context  = stream_context_create($opts);
$result = file_get_contents($token_url, false, $context);
if ($result === FALSE) {
    http_response_code(500);
    echo json_encode(['error' => 'token_request_failed']);
    exit;
}
echo $result;
