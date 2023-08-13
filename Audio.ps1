<# .SYNOPSIS #>
param (
  [Parameter(Mandatory = $true, HelpMessage = "sp - Zvucnici, hd - Slusalice")]
  [string]$mode 
)

$port = (Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" -and $_.OwningProcess -eq 4 } | Select-Object -First 1).LocalPort
$url = "http://localhost:$port/audioDevices"
$response = Invoke-WebRequest -Uri $url
$json = $response.Content # prints full content of the response
$objects = ConvertFrom-Json $json

foreach ($obj in $objects) {
  if ($obj.friendlyName -eq "Mi Monitor (NVIDIA High Definition Audio)") {
    $spid = $obj.id
  }
  if ($obj.friendlyName -eq "Headphones (SteelSeries Arctis 9 Game)") {
    $hdid = $obj.id
  }
}

switch -Regex ( $mode ) {
  '1|sp(eaker|eakers)?$|^zvucni(k|ci)?$' {
    $urls = @(
      "http://localhost:$port/classicRedirections/game/deviceId/$spid",
      "http://localhost:$port/classicRedirections/media/deviceId/$spid",
      "http://localhost:$port/classicRedirections/chat/deviceId/$spid",
      "http://localhost:$port/classicRedirections/aux/deviceId/$spid"
    )
    foreach ($url in $urls) {
      $requestBody = @{}
      $jsonBody = $requestBody | ConvertTo-Json
      $headers = @{
        "Content-Type" = "application/json"
      }
      Invoke-RestMethod -Uri $url -Method Put -Body $jsonBody -Headers $headers
    }
  }
  '2|^(hd|headphones|slusalice|sluske)$' {
    $urls = @(
      "http://localhost:$port/classicRedirections/game/deviceId/$hdid",
      "http://localhost:$port/classicRedirections/media/deviceId/$hdid",
      "http://localhost:$port/classicRedirections/chat/deviceId/$hdid",
      "http://localhost:$port/classicRedirections/aux/deviceId/$hdid"
    )
    foreach ($url in $urls) {
      $requestBody = @{}
      $jsonBody = $requestBody | ConvertTo-Json
      $headers = @{
        "Content-Type" = "application/json"
      }
      Invoke-RestMethod -Uri $url -Method Put -Body $jsonBody -Headers $headers
    }
  }
  default { Write-Host "Invalid argument. Please use 'sp' or 'hd'." }
}