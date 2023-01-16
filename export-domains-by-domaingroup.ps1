# This script will output a CSV of domains by domain group

$token = "<--api-token-->"
$custid = "<--customer-id-->"
$userid = "<--user-id-->"

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Bearer $token")

function getDomainGroupID(){
#get a list of domain group IDs
$domaingroups = Invoke-RestMethod "https://api.dmarcanalyzer.com/customers/$custid/domaingroup" -Method 'GET' -Headers $headers

#build a list of all domains in each group
$output =    foreach ($domainID in $domaingroups.data){
    $response = Invoke-RestMethod "https://api.dmarcanalyzer.com/customers/$custid/users/$userid/domains/overview?filter[group]=$($domainID.id)" -Method 'GET' -Headers $headers
    write-host "Domains in $($domainID.id)"
    write-host $response.data.domain
        [PSCustomObject]@{
          
          "group id" = $domainID.id
          "group name" = $domainID.name
          "domain name" = [string]$response.data.domain
          }


    }

return $output

}




getDomainGroupID | Export-Csv -NoTypeInformation groupOutput.csv
