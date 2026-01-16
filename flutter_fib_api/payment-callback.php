<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);
if (!$data) {
  http_response_code(400);
  echo json_encode(["error" => "Invalid callback data"]);
  exit;
}

// يمكنك حفظها في قاعدة بيانات
file_put_contents("fib-callback-log.txt", json_encode($data, JSON_PRETTY_PRINT) . "\n", FILE_APPEND);

// يجب أن ترسل 202 حتى تعتبر العملية مستلمة بنجاح
http_response_code(202);
echo json_encode(["status" => "received"]);
?>
