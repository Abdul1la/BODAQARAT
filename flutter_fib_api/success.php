<?php
// Gather any details passed back from the gateway (if any)
$query = [];
foreach ($_GET as $k => $v) {
    $query[$k] = htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8');
}

$paymentId = $query['paymentId'] ?? '';
$amount = $query['amount'] ?? '';
$currency = $query['currency'] ?? 'IQD';
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Payment Successful</title>
  <style>
    :root {
      --bg: #0f172a;
      --card: #0b1223;
      --muted: #9aa4b2;
      --success: #22c55e;
      --ring: rgba(34, 197, 94, 0.35);
      --text: #e5e7eb;
      --text-strong: #f8fafc;
      --divider: rgba(148, 163, 184, 0.18);
    }
    * { box-sizing: border-box; }
    html, body { height: 100%; }
    body {
      margin: 0;
      background: radial-gradient(1200px 600px at 20% -10%, #11311f, transparent 50%),
                  radial-gradient(1000px 800px at 120% 10%, #142648, transparent 50%),
                  var(--bg);
      color: var(--text);
      font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, Cantarell, Noto Sans, Arial, "Apple Color Emoji", "Segoe UI Emoji";
      display: grid;
      place-items: center;
      padding: 24px;
    }
    .card {
      width: 100%;
      max-width: 720px;
      background: linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01)) padding-box,
                  linear-gradient(135deg, rgba(34,197,94,0.35), rgba(59,130,246,0.25)) border-box;
      border: 1px solid transparent;
      border-radius: 16px;
      box-shadow: 0 10px 35px rgba(0,0,0,0.45);
      position: relative;
      overflow: hidden;
    }
    .card::after {
      content: "";
      position: absolute;
      inset: -1px;
      background: radial-gradient(600px 120px at -10% -10%, rgba(34,197,94,0.15), transparent 40%),
                  radial-gradient(500px 100px at 110% -20%, rgba(59,130,246,0.15), transparent 40%);
      pointer-events: none;
    }
    .content { padding: 28px 28px 24px; }
    .header {
      display: flex;
      align-items: center;
      gap: 16px;
      margin-bottom: 12px;
    }
    .check {
      width: 56px; height: 56px;
      display: grid; place-items: center;
      background: radial-gradient(circle at 30% 30%, rgba(255,255,255,0.25), rgba(255,255,255,0.05));
      border: 1px solid rgba(34,197,94,0.35);
      color: var(--text-strong);
      border-radius: 50%;
      position: relative;
      box-shadow: 0 0 0 6px var(--ring);
      animation: pop 450ms ease-out both;
    }
    @keyframes pop { 0% { transform: scale(.8); opacity: 0; } 100% { transform: scale(1); opacity: 1; } }
    .check svg { width: 28px; height: 28px; }
    h1 {
      margin: 0;
      font-size: 24px;
      color: var(--text-strong);
      letter-spacing: .2px;
    }
    .subtitle { color: var(--muted); font-size: 14px; margin-top: 4px; }

    .grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      margin-top: 20px;
    }
    .panel {
      background: rgba(2,6,23,0.35);
      border: 1px solid var(--divider);
      border-radius: 12px;
      padding: 16px;
    }
    .panel h3 { margin: 0 0 12px; font-size: 14px; color: #cbd5e1; font-weight: 600; letter-spacing: .2px; }
    .row {
      display: flex; align-items: center; justify-content: space-between;
      border-top: 1px dashed var(--divider);
      padding: 10px 0;
    }
    .row:first-of-type { border-top: 0; padding-top: 0; }
    .k { color: var(--muted); font-size: 13px; }
    .v { color: var(--text-strong); font-size: 13px; font-weight: 600; }

    .status {
      display: inline-flex; align-items: center; gap: 8px;
      background: rgba(34,197,94,0.12);
      color: #86efac;
      border: 1px solid rgba(34,197,94,0.35);
      padding: 6px 10px; border-radius: 999px; font-size: 12px; font-weight: 600;
    }
    .status .dot { width: 7px; height: 7px; background: var(--success); border-radius: 50%; box-shadow: 0 0 10px var(--success); }

    .footer {
      display: flex; flex-wrap: wrap; gap: 10px; align-items: center; justify-content: space-between;
      padding: 16px 24px; border-top: 1px solid var(--divider); background: linear-gradient(0deg, rgba(2,6,23,0.35), rgba(2,6,23,0));
    }
    .btn {
      appearance: none; border: 0; cursor: pointer;
      display: inline-flex; align-items: center; gap: 10px;
      border-radius: 10px; padding: 10px 14px; font-weight: 600; font-size: 14px;
      transition: transform .05s ease, background .2s ease, opacity .2s ease;
    }
    .btn-primary { background: rgba(34,197,94,0.18); color: #bbf7d0; border: 1px solid rgba(34,197,94,0.35); }
    .btn-primary:hover { background: rgba(34,197,94,0.28); }
    .btn-ghost { background: transparent; color: #cbd5e1; border: 1px solid var(--divider); }
    .btn:active { transform: translateY(1px); }

    .muted { color: var(--muted); font-size: 12px; }

    @media (max-width: 640px) {
      .grid { grid-template-columns: 1fr; }
      .content { padding: 22px 18px 18px; }
      .footer { padding: 14px 16px; }
    }
  </style>
</head>
<body>
  <main class="card" role="main" aria-labelledby="title">
    <div class="content">
      <div class="header">
        <div class="check" aria-hidden="true">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M20 6L9 17l-5-5" />
          </svg>
        </div>
        <div>
          <h1 id="title">Payment Successful</h1>
          <div class="subtitle">Thank you. Your payment has been processed.</div>
        </div>
      </div>

      <div class="grid">
        <section class="panel" aria-label="Summary">
          <h3>Summary</h3>
          <div class="row"><div class="k">Status</div><div class="v"><span id="statusBadge" class="status"><span class="dot"></span><span id="statusText">Confirmed</span></span></div></div>
          <?php if ($amount !== ''): ?>
          <div class="row"><div class="k">Amount</div><div class="v"><?php echo $amount; ?> <?php echo htmlspecialchars($currency, ENT_QUOTES, 'UTF-8'); ?></div></div>
          <?php endif; ?>
          <?php if ($paymentId !== ''): ?>
          <div class="row"><div class="k">Payment ID</div><div class="v" id="paymentIdText"><?php echo $paymentId; ?></div></div>
          <?php endif; ?>
          <div class="row"><div class="k">Date</div><div class="v"><?php echo date('Y-m-d H:i'); ?></div></div>
        </section>

        <section class="panel" aria-label="Details">
          <h3>Details</h3>
          <?php if (!empty($query)): ?>
            <?php foreach ($query as $k => $v): ?>
              <div class="row">
                <div class="k"><?php echo htmlspecialchars($k, ENT_QUOTES, 'UTF-8'); ?></div>
                <div class="v" title="<?php echo $v; ?>"><?php echo $v; ?></div>
              </div>
            <?php endforeach; ?>
          <?php else: ?>
              <div class="muted">No additional details were provided by the payment gateway.</div>
          <?php endif; ?>
        </section>
      </div>
    </div>

    <div class="footer">
      <div class="muted">You can close this page or keep a copy for your records.</div>
      <div>
        <button class="btn btn-ghost" onclick="window.print()" aria-label="Download receipt">ðŸ§¾ Download receipt</button>
        <button class="btn btn-primary" onclick="window.close()" aria-label="Close">Close</button>
      </div>
    </div>
  </main>

  <script>
    (function () {
      const pid = <?php echo json_encode($paymentId); ?>;
      const statusText = document.getElementById('statusText');
      const badge = document.getElementById('statusBadge');

      function setStatus(text, ok) {
        statusText.textContent = text;
        badge.style.background = ok ? 'rgba(34,197,94,0.12)' : 'rgba(239,68,68,0.12)';
        badge.style.borderColor = ok ? 'rgba(34,197,94,0.35)' : 'rgba(239,68,68,0.35)';
        badge.style.color = ok ? '#86efac' : '#fca5a5';
        const dot = badge.querySelector('.dot');
        if (dot) dot.style.background = ok ? '#22c55e' : '#ef4444';
      }

      if (pid) {
        setStatus('Verifyingâ€¦', true);
        fetch('check_status.php?paymentId=' + encodeURIComponent(pid))
          .then(r => r.ok ? r.json() : Promise.reject())
          .then(data => {
            // Try to infer a readable status from the API response
            const s = (data && (data.status || data.state || data.paymentStatus || data.currentStatus)) || 'confirmed';
            const normalized = String(s).toLowerCase();
            const ok = ['confirmed','success','succeeded','approved','paid','completed'].some(x => normalized.includes(x));
            setStatus(s.toString(), ok);
          })
          .catch(() => setStatus('Confirmed', true));
      }
    })();
  </script>
</body>
</html>
