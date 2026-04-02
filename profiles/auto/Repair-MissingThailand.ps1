$ErrorActionPreference = "Continue"
$Base = $PSScriptRoot
$UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
function Pex($id) { "https://images.pexels.com/photos/$id/pexels-photo-$id.jpeg?auto=compress&cs=tinysrgb&w=800&h=800&fit=crop" }

# filename -> list of fallback Pexels IDs to try in order
$repairs = @{
  "anong_chaiwan_1.jpg"     = @(1520760, 1536619, 1124963, 2908977)
  "suda_rattanapong_1.jpg" = @(2469128, 2531238, 2599150, 2387860)
  "kanya_chaiwat_3.jpg"    = @(3461952, 3477683, 3516793, 3526416)
  "pimchanok_suksawat_3.jpg" = @(3477683, 3498938, 3505579, 3526416)
  "nicha_thongchai_2.jpg"  = @(2724746, 2737054, 2757492, 2770135)
  "nicha_thongchai_3.jpg"  = @(3516793, 3526416, 3536061, 3552947)
  "chanida_boonmi_2.jpg"   = @(2770135, 2789180, 2802212, 2836480)
  "napaporn_chompoo_1.jpg" = @(1251834, 1278567, 1300527, 1323556)
  "supachai_rattanakorn_3.jpg" = @(3651820, 3669736, 3694388, 3719033)
  "thanawat_boonmee_3.jpg" = @(3687770, 3704979, 3725208, 3740444)
  "worawut_suksan_3.jpg"   = @(3771060, 3785079, 3807629, 3829605)
  "prayut_wichai_1.jpg"    = @(2034892, 2055228, 2078468, 2098930)
  "prayut_wichai_3.jpg"    = @(3844788, 3861964, 3887855, 3900513)
}

foreach ($kv in $repairs.GetEnumerator()) {
  $name = $kv.Key
  $ids = $kv.Value
  $out = Join-Path $Base $name
  if (Test-Path $out) { $sz = (Get-Item $out).Length; if ($sz -gt 5000) { continue } }
  foreach ($id in $ids) {
    try {
      $url = Pex $id
      Invoke-WebRequest -Uri $url -UserAgent $UA -OutFile $out -TimeoutSec 90
      if ((Get-Item $out).Length -gt 5000) {
        Write-Host "OK $name via $id"
        break
      }
    } catch { }
  }
}
