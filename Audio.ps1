<# .SYNOPSIS #>
param (
  [Parameter(Mandatory = $true, HelpMessage = "sp - Speaker, hd - Headphones")]
  [string]$mode 
)

$port = (Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" -and $_.OwningProcess -eq 4 } | Select-Object -First 1).LocalPort

switch -Regex ( $mode ) {
  '1|sp(eaker|eakers)?$|^zvucni(k|ci)?$' {
    $urls = @(
      "http://localhost:$port/classicRedirections/game/deviceId/{0.0.0.00000000}.{6504f11b-d45b-45bb-bc40-f0eb3aaaa815}",
      "http://localhost:$port/classicRedirections/media/deviceId/{0.0.0.00000000}.{6504f11b-d45b-45bb-bc40-f0eb3aaaa815}",
      "http://localhost:$port/classicRedirections/chat/deviceId/{0.0.0.00000000}.{6504f11b-d45b-45bb-bc40-f0eb3aaaa815}",
      "http://localhost:$port/classicRedirections/aux/deviceId/{0.0.0.00000000}.{6504f11b-d45b-45bb-bc40-f0eb3aaaa815}"
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
      "http://localhost:$port/classicRedirections/game/deviceId/{0.0.0.00000000}.{421cdede7-046e-4kc9-bcc3-ed26f4b0269c}",
      "http://localhost:$port/classicRedirections/media/deviceId/{0.0.0.00000000}.{421cdede7-046e-4kc9-bcc3-ed26f4b0269c}",
      "http://localhost:$port/classicRedirections/chat/deviceId/{0.0.0.00000000}.{421cdede7-046e-4kc9-bcc3-ed26f4b0269c}",
      "http://localhost:$port/classicRedirections/aux/deviceId/{0.0.0.00000000}.{421cdede7-046e-4kc9-bcc3-ed26f4b0269c}"
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