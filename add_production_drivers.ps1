# Register all bus drivers (one per route) to production
$body = @{phone="+919876543210";password="admin"} | ConvertTo-Json
$response = Invoke-RestMethod -Uri "https://sathyabama-bus-tracker.onrender.com/api/v1/auth/login" -Method Post -ContentType "application/json" -Body $body
$token = $response.access_token
Write-Host "✅ Logged in as admin"

$headers = @{Authorization="Bearer $token"}
$baseUrl = "https://sathyabama-bus-tracker.onrender.com/api/v1/auth/register"

$drivers = @(
    @{name="Driver Bus1";   phone="+919800000001"; email="bus1@sathyabama.edu";   password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus10";  phone="+919800000010"; email="bus10@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus10A"; phone="+919800000011"; email="bus10a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus10B"; phone="+919800000012"; email="bus10b@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus10D"; phone="+919800000013"; email="bus10d@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus10E"; phone="+919800000014"; email="bus10e@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus11";  phone="+919800000015"; email="bus11@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus11I"; phone="+919800000016"; email="bus11i@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus11A"; phone="+919800000017"; email="bus11a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus11B"; phone="+919800000018"; email="bus11b@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus11C"; phone="+919800000019"; email="bus11c@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus11E"; phone="+919800000020"; email="bus11e@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus11F"; phone="+919800000021"; email="bus11f@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus11H"; phone="+919800000022"; email="bus11h@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus12B"; phone="+919800000023"; email="bus12b@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus12D"; phone="+919800000024"; email="bus12d@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus13A"; phone="+919800000025"; email="bus13a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus13C"; phone="+919800000026"; email="bus13c@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus13D"; phone="+919800000027"; email="bus13d@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus14";  phone="+919800000028"; email="bus14@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus14A"; phone="+919800000029"; email="bus14a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus14B"; phone="+919800000030"; email="bus14b@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus15B"; phone="+919800000031"; email="bus15b@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus16";  phone="+919800000032"; email="bus16@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus16A"; phone="+919800000033"; email="bus16a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus16C"; phone="+919800000034"; email="bus16c@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus17A"; phone="+919800000035"; email="bus17a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus17B"; phone="+919800000036"; email="bus17b@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus18";  phone="+919800000037"; email="bus18@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus18A"; phone="+919800000038"; email="bus18a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus18C"; phone="+919800000039"; email="bus18c@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus18D"; phone="+919800000040"; email="bus18d@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus19";  phone="+919800000041"; email="bus19@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus19A"; phone="+919800000042"; email="bus19a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus1A";  phone="+919800000043"; email="bus1a@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus1C";  phone="+919800000044"; email="bus1c@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus1D";  phone="+919800000045"; email="bus1d@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus2";   phone="+919800000046"; email="bus2@sathyabama.edu";   password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus20A"; phone="+919800000047"; email="bus20a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus21B"; phone="+919800000048"; email="bus21b@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus22";  phone="+919800000049"; email="bus22@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus22A"; phone="+919800000050"; email="bus22a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus22B"; phone="+919800000051"; email="bus22b@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus24";  phone="+919800000052"; email="bus24@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus25";  phone="+919800000053"; email="bus25@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus26";  phone="+919800000054"; email="bus26@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus26A"; phone="+919800000055"; email="bus26a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus27";  phone="+919800000056"; email="bus27@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus27A"; phone="+919800000057"; email="bus27a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus27B"; phone="+919800000058"; email="bus27b@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus28";  phone="+919800000059"; email="bus28@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus2A";  phone="+919800000060"; email="bus2a@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus2C";  phone="+919800000061"; email="bus2c@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus2D";  phone="+919800000062"; email="bus2d@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus2F";  phone="+919800000063"; email="bus2f@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus2G";  phone="+919800000064"; email="bus2g@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus3";   phone="+919800000065"; email="bus3@sathyabama.edu";   password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus30A"; phone="+919800000066"; email="bus30a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus32B"; phone="+919800000067"; email="bus32b@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus35";  phone="+919800000068"; email="bus35@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus35A"; phone="+919800000069"; email="bus35a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus36A"; phone="+919800000070"; email="bus36a@sathyabama.edu"; password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus37";  phone="+919800000071"; email="bus37@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus3A";  phone="+919800000072"; email="bus3a@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus3B";  phone="+919800000073"; email="bus3b@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus4A";  phone="+919800000074"; email="bus4a@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus4C";  phone="+919800000075"; email="bus4c@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus4G";  phone="+919800000076"; email="bus4g@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus5A";  phone="+919800000077"; email="bus5a@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus5C";  phone="+919800000078"; email="bus5c@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus5D";  phone="+919800000079"; email="bus5d@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus6";   phone="+919800000080"; email="bus6@sathyabama.edu";   password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus6A";  phone="+919800000081"; email="bus6a@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus6C";  phone="+919800000082"; email="bus6c@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus6D";  phone="+919800000083"; email="bus6d@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus6E";  phone="+919800000084"; email="bus6e@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus7";   phone="+919800000085"; email="bus7@sathyabama.edu";   password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus7A";  phone="+919800000086"; email="bus7a@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus8";   phone="+919800000087"; email="bus8@sathyabama.edu";   password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus8A";  phone="+919800000088"; email="bus8a@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus8C";  phone="+919800000089"; email="bus8c@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus9A";  phone="+919800000090"; email="bus9a@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus9B";  phone="+919800000091"; email="bus9b@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false},
    @{name="Driver Bus9C";  phone="+919800000092"; email="bus9c@sathyabama.edu";  password="driver123"; is_active=$true; is_admin=$false}
)

$success = 0
$failed = 0

foreach ($driver in $drivers) {
    $body = $driver | ConvertTo-Json
    try {
        Invoke-RestMethod -Uri $baseUrl -Method Post -ContentType "application/json" -Body $body -Headers $headers | Out-Null
        Write-Host "✅ $($driver.name) registered"
        $success++
    } catch {
        Write-Host "⚠️  $($driver.name) failed or exists"
        $failed++
    }
}

Write-Host "`n🎉 Done! $success drivers registered, $failed failed/skipped."
Write-Host "All driver passwords: driver123"
Write-Host "Phone format: +91980000XXXX"