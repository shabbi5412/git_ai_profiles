# Downloads 54 Pexels photos (real photography). License: https://www.pexels.com/license/
$ErrorActionPreference = "Stop"
$Base = $PSScriptRoot
$UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (compatible; git_ai_profiles/1.0)"

function Get-PexelsJpeg($id) {
  "https://images.pexels.com/photos/$id/pexels-photo-$id.jpeg?auto=compress&cs=tinysrgb&w=800&h=800&fit=crop"
}

# 18 profiles — ASCII slugs only (no Thai in this script file for encoding safety).
$slugs = @(
  "malee_panit","anong_chaiwan","suda_rattanapong","kanya_chaiwat","pimchanok_suksawat",
  "nicha_thongchai","chanida_boonmi","kanyarat_prasert","napaporn_chompoo","somchai_kittisak",
  "supachai_rattanakorn","thanawat_boonmee","kittipong_sakda","anurak_prasit","worawut_suksan",
  "natthapong_jirawat","sarawut_thammanun","prayut_wichai"
)

$beach = @(2908977,1009946,2387860,1260848,1365425,1557238,2379004,774909,1222278,1681010,2894944,3206079,1043471,1181686,1462980,1755388,1933873,2004446)
$mount = @(2162178,2382666,2434049,2616629,2672979,2703609,2746848,2836480,2885912,2951921,3014856,3059748,3149878,3184465,3211920,3243090,3270985,3300903)
$life  = @(3329236,3359770,3388816,3423613,3456628,3492738,3526416,3552947,3585740,3616678,3648369,3676300,3704979,3740444,3762872,3785079,3807629,3831647)

$lines = @()
$lines += "Photos from Pexels (https://www.pexels.com/license/). Real photography, not AI."
$lines += ""

for ($i = 0; $i -lt 18; $i++) {
  $slug = $slugs[$i]
  $triples = @(
    @{ sfx = "1"; theme = "beach_coast"; id = $beach[$i] },
    @{ sfx = "2"; theme = "mountain_outdoor"; id = $mount[$i] },
    @{ sfx = "3"; theme = "lifestyle"; id = $life[$i] }
  )
  foreach ($t in $triples) {
    $url = Get-PexelsJpeg $t.id
    $out = Join-Path $Base "$($slug)_$($t.sfx).jpg"
    try {
      Invoke-WebRequest -Uri $url -UserAgent $UA -OutFile $out -TimeoutSec 90
      $sz = (Get-Item $out).Length
      if ($sz -lt 5000) { Remove-Item $out -Force; throw "too small" }
      $lines += "$($slug)_$($t.sfx).jpg`t$($t.theme)`tpexels_id=$($t.id)`tOK"
    } catch {
      $lines += "$($slug)_$($t.sfx).jpg`t$($t.theme)`tpexels_id=$($t.id)`tFAIL"
      Write-Warning "Failed $($slug)_$($t.sfx) id=$($t.id)"
    }
  }
}

$lines | Set-Content -Path (Join-Path $Base "ATTRIBUTION.txt") -Encoding UTF8
Write-Host "Done. See ATTRIBUTION.txt"
