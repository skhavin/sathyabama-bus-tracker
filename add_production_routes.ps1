# Add all Sathyabama bus routes to production
# Live GPS sim: simulate-buses.py (repo root) uses the same vehicle_no + route_no + phone per row.
# Login as admin
$body = @{phone="+919876543210";password="admin"} | ConvertTo-Json
$response = Invoke-RestMethod -Uri "https://sathyabama-bus-tracker.onrender.com/api/v1/auth/login" -Method Post -ContentType "application/json" -Body $body
$token = $response.access_token
Write-Host "✅ Logged in as admin"

$headers = @{Authorization="Bearer $token"}
$baseUrl = "https://sathyabama-bus-tracker.onrender.com/api/admin/routes"

$routes = @(
    @{route_no="1";   bus_route="CHEYYAR - Sathyabama Campus";              vehicle_no="TN01AA0001"; driver_name="Driver Bus1";   phone_number="+919800000001"; is_active=$true},
    @{route_no="10";  bus_route="THIRUVALLUR - Sathyabama Campus";           vehicle_no="TN01AA0010"; driver_name="Driver Bus10";  phone_number="+919800000010"; is_active=$true},
    @{route_no="10A"; bus_route="POONAMALLE - Sathyabama Campus";            vehicle_no="TN01AA0011"; driver_name="Driver Bus10A"; phone_number="+919800000011"; is_active=$true},
    @{route_no="10B"; bus_route="POONAMALLE - Sathyabama Campus (B)";        vehicle_no="TN01AA0012"; driver_name="Driver Bus10B"; phone_number="+919800000012"; is_active=$true},
    @{route_no="10D"; bus_route="THIRUVALLUR - Sathyabama Campus (D)";       vehicle_no="TN01AA0013"; driver_name="Driver Bus10D"; phone_number="+919800000013"; is_active=$true},
    @{route_no="10E"; bus_route="PORUR BAI KADAI - Sathyabama Campus";       vehicle_no="TN01AA0014"; driver_name="Driver Bus10E"; phone_number="+919800000014"; is_active=$true},
    @{route_no="11";  bus_route="VEPPAMPATTU - Sathyabama Campus";           vehicle_no="TN01AA0015"; driver_name="Driver Bus11";  phone_number="+919800000015"; is_active=$true},
    @{route_no="11I"; bus_route="SENNARI KUPPAM - Sathyabama Campus";        vehicle_no="TN01AA0016"; driver_name="Driver Bus11I"; phone_number="+919800000016"; is_active=$true},
    @{route_no="11A"; bus_route="THIRUNINDRAVUR - Sathyabama Campus";        vehicle_no="TN01AA0017"; driver_name="Driver Bus11A"; phone_number="+919800000017"; is_active=$true},
    @{route_no="11B"; bus_route="AVADI - Sathyabama Campus";                 vehicle_no="TN01AA0018"; driver_name="Driver Bus11B"; phone_number="+919800000018"; is_active=$true},
    @{route_no="11C"; bus_route="AYAPAKKAM - Sathyabama Campus";             vehicle_no="TN01AA0019"; driver_name="Driver Bus11C"; phone_number="+919800000019"; is_active=$true},
    @{route_no="11E"; bus_route="MUGAPPAIR EAST - Sathyabama Campus";        vehicle_no="TN01AA0020"; driver_name="Driver Bus11E"; phone_number="+919800000020"; is_active=$true},
    @{route_no="11F"; bus_route="SENNARI KUPPAM - Sathyabama Campus (F)";    vehicle_no="TN01AA0021"; driver_name="Driver Bus11F"; phone_number="+919800000021"; is_active=$true},
    @{route_no="11H"; bus_route="AVADI - Sathyabama Campus (H)";             vehicle_no="TN01AA0022"; driver_name="Driver Bus11H"; phone_number="+919800000022"; is_active=$true},
    @{route_no="12B"; bus_route="PERAMBUR BUS STAND - Sathyabama Campus";    vehicle_no="TN01AA0023"; driver_name="Driver Bus12B"; phone_number="+919800000023"; is_active=$true},
    @{route_no="12D"; bus_route="RETTARI - Sathyabama Campus";               vehicle_no="TN01AA0024"; driver_name="Driver Bus12D"; phone_number="+919800000024"; is_active=$true},
    @{route_no="13A"; bus_route="NADAMUNI THEATRE - Sathyabama Campus";      vehicle_no="TN01AA0025"; driver_name="Driver Bus13A"; phone_number="+919800000025"; is_active=$true},
    @{route_no="13C"; bus_route="EGMORE - Sathyabama Campus";                vehicle_no="TN01AA0026"; driver_name="Driver Bus13C"; phone_number="+919800000026"; is_active=$true},
    @{route_no="13D"; bus_route="PURASAIVAKKAM - Sathyabama Campus";         vehicle_no="TN01AA0027"; driver_name="Driver Bus13D"; phone_number="+919800000027"; is_active=$true},
    @{route_no="14";  bus_route="KODAMBAKKAM - Sathyabama Campus";           vehicle_no="TN01AA0028"; driver_name="Driver Bus14";  phone_number="+919800000028"; is_active=$true},
    @{route_no="14A"; bus_route="T.NAGAR BUS STAND - Sathyabama Campus";     vehicle_no="TN01AA0029"; driver_name="Driver Bus14A"; phone_number="+919800000029"; is_active=$true},
    @{route_no="14B"; bus_route="SAIDAPET - Sathyabama Campus";              vehicle_no="TN01AA0030"; driver_name="Driver Bus14B"; phone_number="+919800000030"; is_active=$true},
    @{route_no="15B"; bus_route="SALIGRAMAM - Sathyabama Campus";            vehicle_no="TN01AA0031"; driver_name="Driver Bus15B"; phone_number="+919800000031"; is_active=$true},
    @{route_no="16";  bus_route="SENTHIL NAGAR - Sathyabama Campus";         vehicle_no="TN01AA0032"; driver_name="Driver Bus16";  phone_number="+919800000032"; is_active=$true},
    @{route_no="16A"; bus_route="MFL - Sathyabama Campus";                   vehicle_no="TN01AA0033"; driver_name="Driver Bus16A"; phone_number="+919800000033"; is_active=$true},
    @{route_no="16C"; bus_route="SENTHIL NAGAR - Sathyabama Campus (C)";     vehicle_no="TN01AA0034"; driver_name="Driver Bus16C"; phone_number="+919800000034"; is_active=$true},
    @{route_no="17A"; bus_route="PORUR - Sathyabama Campus";                 vehicle_no="TN01AA0035"; driver_name="Driver Bus17A"; phone_number="+919800000035"; is_active=$true},
    @{route_no="17B"; bus_route="K.K.NAGAR - Sathyabama Campus";             vehicle_no="TN01AA0036"; driver_name="Driver Bus17B"; phone_number="+919800000036"; is_active=$true},
    @{route_no="18";  bus_route="MANGADU - Sathyabama Campus";               vehicle_no="TN01AA0037"; driver_name="Driver Bus18";  phone_number="+919800000037"; is_active=$true},
    @{route_no="18A"; bus_route="KUNDRATHUR - Sathyabama Campus";            vehicle_no="TN01AA0038"; driver_name="Driver Bus18A"; phone_number="+919800000038"; is_active=$true},
    @{route_no="18C"; bus_route="MEENAMBAKKAM - Sathyabama Campus";          vehicle_no="TN01AA0039"; driver_name="Driver Bus18C"; phone_number="+919800000039"; is_active=$true},
    @{route_no="18D"; bus_route="RAMAPURAM - Sathyabama Campus";             vehicle_no="TN01AA0040"; driver_name="Driver Bus18D"; phone_number="+919800000040"; is_active=$true},
    @{route_no="19";  bus_route="WALAJABATH - Sathyabama Campus";            vehicle_no="TN01AA0041"; driver_name="Driver Bus19";  phone_number="+919800000041"; is_active=$true},
    @{route_no="19A"; bus_route="MUDICHUR - Sathyabama Campus";              vehicle_no="TN01AA0042"; driver_name="Driver Bus19A"; phone_number="+919800000042"; is_active=$true},
    @{route_no="1A";  bus_route="VANDAVASI - Sathyabama Campus";             vehicle_no="TN01AA0043"; driver_name="Driver Bus1A";  phone_number="+919800000043"; is_active=$true},
    @{route_no="1C";  bus_route="KANCHEEPURAM - Sathyabama Campus";          vehicle_no="TN01AA0044"; driver_name="Driver Bus1C";  phone_number="+919800000044"; is_active=$true},
    @{route_no="1D";  bus_route="SRIPERAMBATHUR - Sathyabama Campus";        vehicle_no="TN01AA0045"; driver_name="Driver Bus1D";  phone_number="+919800000045"; is_active=$true},
    @{route_no="2";   bus_route="MADHURANTHAGAM - Sathyabama Campus";        vehicle_no="TN01AA0046"; driver_name="Driver Bus2";   phone_number="+919800000046"; is_active=$true},
    @{route_no="20A"; bus_route="HASTHINAPURAM - Sathyabama Campus";         vehicle_no="TN01AA0047"; driver_name="Driver Bus20A"; phone_number="+919800000047"; is_active=$true},
    @{route_no="21B"; bus_route="VANDALOOR - Sathyabama Campus";             vehicle_no="TN01AA0048"; driver_name="Driver Bus21B"; phone_number="+919800000048"; is_active=$true},
    @{route_no="22";  bus_route="NARAYANAPURAM - Sathyabama Campus";         vehicle_no="TN01AA0049"; driver_name="Driver Bus22";  phone_number="+919800000049"; is_active=$true},
    @{route_no="22A"; bus_route="KAMAKSHI HOSPITAL - Sathyabama Campus";     vehicle_no="TN01AA0050"; driver_name="Driver Bus22A"; phone_number="+919800000050"; is_active=$true},
    @{route_no="22B"; bus_route="VENGAIVASAL - Sathyabama Campus";           vehicle_no="TN01AA0051"; driver_name="Driver Bus22B"; phone_number="+919800000051"; is_active=$true},
    @{route_no="24";  bus_route="KOVILAMBAKKAM - Sathyabama Campus";         vehicle_no="TN01AA0052"; driver_name="Driver Bus24";  phone_number="+919800000052"; is_active=$true},
    @{route_no="25";  bus_route="PALLAVARAM VELS COLLEGE - Sathyabama Campus";vehicle_no="TN01AA0053"; driver_name="Driver Bus25";  phone_number="+919800000053"; is_active=$true},
    @{route_no="26";  bus_route="NANGANALLUR SUB WAY - Sathyabama Campus";   vehicle_no="TN01AA0054"; driver_name="Driver Bus26";  phone_number="+919800000054"; is_active=$true},
    @{route_no="26A"; bus_route="MEENAMBAKKAM SUBWAY - Sathyabama Campus";   vehicle_no="TN01AA0055"; driver_name="Driver Bus26A"; phone_number="+919800000055"; is_active=$true},
    @{route_no="27";  bus_route="TAMBARAM - Sathyabama Campus";              vehicle_no="TN01AA0056"; driver_name="Driver Bus27";  phone_number="+919800000056"; is_active=$true},
    @{route_no="27A"; bus_route="BHARATH UNIVERSITY - Sathyabama Campus";    vehicle_no="TN01AA0057"; driver_name="Driver Bus27A"; phone_number="+919800000057"; is_active=$true},
    @{route_no="27B"; bus_route="MAPPEDU - Sathyabama Campus";               vehicle_no="TN01AA0058"; driver_name="Driver Bus27B"; phone_number="+919800000058"; is_active=$true},
    @{route_no="28";  bus_route="RAJAKILPAKKAM - Sathyabama Campus";         vehicle_no="TN01AA0059"; driver_name="Driver Bus28";  phone_number="+919800000059"; is_active=$true},
    @{route_no="2A";  bus_route="UTHIRAMERUR - Sathyabama Campus";           vehicle_no="TN01AA0060"; driver_name="Driver Bus2A";  phone_number="+919800000060"; is_active=$true},
    @{route_no="2C";  bus_route="CHENGALPET - Sathyabama Campus";            vehicle_no="TN01AA0061"; driver_name="Driver Bus2C";  phone_number="+919800000061"; is_active=$true},
    @{route_no="2D";  bus_route="CHENGALPET - Sathyabama Campus (D)";        vehicle_no="TN01AA0062"; driver_name="Driver Bus2D";  phone_number="+919800000062"; is_active=$true},
    @{route_no="2F";  bus_route="THIRUPORUR ROUNDANA - Sathyabama Campus";   vehicle_no="TN01AA0063"; driver_name="Driver Bus2F";  phone_number="+919800000063"; is_active=$true},
    @{route_no="2G";  bus_route="MELMARUVATHUR - Sathyabama Campus";         vehicle_no="TN01AA0064"; driver_name="Driver Bus2G";  phone_number="+919800000064"; is_active=$true},
    @{route_no="3";   bus_route="KANNIVAKKAM - Sathyabama Campus";           vehicle_no="TN01AA0065"; driver_name="Driver Bus3";   phone_number="+919800000065"; is_active=$true},
    @{route_no="30A"; bus_route="N.G.O. COLONY - Sathyabama Campus";         vehicle_no="TN01AA0066"; driver_name="Driver Bus30A"; phone_number="+919800000066"; is_active=$true},
    @{route_no="32B"; bus_route="VELACHERY BABY NAGAR - Sathyabama Campus";  vehicle_no="TN01AA0067"; driver_name="Driver Bus32B"; phone_number="+919800000067"; is_active=$true},
    @{route_no="35";  bus_route="PUDUBAKKAM - Sathyabama Campus";            vehicle_no="TN01AA0068"; driver_name="Driver Bus35";  phone_number="+919800000068"; is_active=$true},
    @{route_no="35A"; bus_route="PONMAR - Sathyabama Campus";                vehicle_no="TN01AA0069"; driver_name="Driver Bus35A"; phone_number="+919800000069"; is_active=$true},
    @{route_no="36A"; bus_route="DLF APPARTMENT - Sathyabama Campus";        vehicle_no="TN01AA0070"; driver_name="Driver Bus36A"; phone_number="+919800000070"; is_active=$true},
    @{route_no="37";  bus_route="UTHANDI - Sathyabama Campus";               vehicle_no="TN01AA0071"; driver_name="Driver Bus37";  phone_number="+919800000071"; is_active=$true},
    @{route_no="3A";  bus_route="GUDUVANCHERRY - Sathyabama Campus";         vehicle_no="TN01AA0072"; driver_name="Driver Bus3A";  phone_number="+919800000072"; is_active=$true},
    @{route_no="3B";  bus_route="URAPAKKAM - Sathyabama Campus";             vehicle_no="TN01AA0073"; driver_name="Driver Bus3B";  phone_number="+919800000073"; is_active=$true},
    @{route_no="4A";  bus_route="KALPAKKAM - Sathyabama Campus";             vehicle_no="TN01AA0074"; driver_name="Driver Bus4A";  phone_number="+919800000074"; is_active=$true},
    @{route_no="4C";  bus_route="THIRUKAZHUKUNDRAM - Sathyabama Campus";     vehicle_no="TN01AA0075"; driver_name="Driver Bus4C";  phone_number="+919800000075"; is_active=$true},
    @{route_no="4G";  bus_route="MARAKANAM - Sathyabama Campus";             vehicle_no="TN01AA0076"; driver_name="Driver Bus4G";  phone_number="+919800000076"; is_active=$true},
    @{route_no="5A";  bus_route="THIRUPORUR - Sathyabama Campus";            vehicle_no="TN01AA0077"; driver_name="Driver Bus5A";  phone_number="+919800000077"; is_active=$true},
    @{route_no="5C";  bus_route="KELAMBAKKAM - Sathyabama Campus";           vehicle_no="TN01AA0078"; driver_name="Driver Bus5C";  phone_number="+919800000078"; is_active=$true},
    @{route_no="5D";  bus_route="THIRUPORUR - Sathyabama Campus (D)";        vehicle_no="TN01AA0079"; driver_name="Driver Bus5D";  phone_number="+919800000079"; is_active=$true},
    @{route_no="6";   bus_route="ENNORE - Sathyabama Campus";                vehicle_no="TN01AA0080"; driver_name="Driver Bus6";   phone_number="+919800000080"; is_active=$true},
    @{route_no="6A";  bus_route="THIRUVOTTIYUR - Sathyabama Campus";         vehicle_no="TN01AA0081"; driver_name="Driver Bus6A";  phone_number="+919800000081"; is_active=$true},
    @{route_no="6C";  bus_route="THANDAYARPET MANI KOONDU - Sathyabama Campus";vehicle_no="TN01AA0082"; driver_name="Driver Bus6C";  phone_number="+919800000082"; is_active=$true},
    @{route_no="6D";  bus_route="THANDAYARPET - Sathyabama Campus";          vehicle_no="TN01AA0083"; driver_name="Driver Bus6D";  phone_number="+919800000083"; is_active=$true},
    @{route_no="6E";  bus_route="MINT BHARATH THEATRE - Sathyabama Campus";  vehicle_no="TN01AA0084"; driver_name="Driver Bus6E";  phone_number="+919800000084"; is_active=$true},
    @{route_no="7";   bus_route="MANALI - Sathyabama Campus";                vehicle_no="TN01AA0085"; driver_name="Driver Bus7";   phone_number="+919800000085"; is_active=$true},
    @{route_no="7A";  bus_route="MADHAVARAM POST OFFICE - Sathyabama Campus";vehicle_no="TN01AA0086"; driver_name="Driver Bus7A";  phone_number="+919800000086"; is_active=$true},
    @{route_no="8";   bus_route="VALLUVAR KOTTAM - Sathyabama Campus";       vehicle_no="TN01AA0087"; driver_name="Driver Bus8";   phone_number="+919800000087"; is_active=$true},
    @{route_no="8A";  bus_route="CITY CENTRE - Sathyabama Campus";           vehicle_no="TN01AA0088"; driver_name="Driver Bus8A";  phone_number="+919800000088"; is_active=$true},
    @{route_no="8C";  bus_route="AMEER MAHAL - Sathyabama Campus";           vehicle_no="TN01AA0089"; driver_name="Driver Bus8C";  phone_number="+919800000089"; is_active=$true},
    @{route_no="9A";  bus_route="ADYAR TELEPHONE EXCHANGE - Sathyabama Campus";vehicle_no="TN01AA0090"; driver_name="Driver Bus9A";  phone_number="+919800000090"; is_active=$true},
    @{route_no="9B";  bus_route="THIRUVANMIYUR - Sathyabama Campus";         vehicle_no="TN01AA0091"; driver_name="Driver Bus9B";  phone_number="+919800000091"; is_active=$true},
    @{route_no="9C";  bus_route="THIRUVANMIYUR - Sathyabama Campus (C)";     vehicle_no="TN01AA0092"; driver_name="Driver Bus9C";  phone_number="+919800000092"; is_active=$true}
)

$success = 0
$failed = 0

foreach ($route in $routes) {
    $body = $route | ConvertTo-Json
    try {
        Invoke-RestMethod -Uri $baseUrl -Method Post -ContentType "application/json" -Body $body -Headers $headers | Out-Null
        Write-Host "✅ Route $($route.route_no) added"
        $success++
    } catch {
        Write-Host "⚠️  Route $($route.route_no) failed or exists: $_"
        $failed++
    }
}

Write-Host "`n🎉 Done! $success routes added, $failed failed/skipped."