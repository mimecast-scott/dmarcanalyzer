$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Bearer <-- your bearer token -->")

# NOTE: domain_patterns needs to be an array and can be represented by appending &domain_patterns[x] to the end of the Uri where x is the array object id (incremented by 1)

$response = Invoke-RestMethod 'https://api.dmarcanalyzer.com/customers/<--customer-id->>/domaingroup/<--group-ip-->>?name=Finance&activity=all&domain_patterns[0]=*.example.org&domain_patterns[1]=example.org' -Method 'PUT' -Headers $headers
$response | ConvertTo-Json
