param(

&#x20;   \[string]$OutputFolder = (Join-Path $PWD ("GraphExport\_" + (Get-Date -Format "yyyyMMdd\_HHmmss"))),

&#x20;   \[switch]$TransitiveMembers

)



\# Create output folder

New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null



\# Connect to Microsoft Graph

Connect-MgGraph -Scopes "Group.Read.All","User.Read.All"

Select-MgProfile -Name "v1.0"



Write-Host "Getting all groups..."

$groups = Get-MgGroup -All -Property "id,displayName"



Write-Host "Total groups: $($groups.Count)"



\# Output files

$membersCsv = Join-Path $OutputFolder "GroupMembers.csv"

$summaryCsv = Join-Path $OutputFolder "Summary.csv"



\# Loop through groups

foreach ($g in $groups) {



&#x20;   Write-Host "Processing: $($g.DisplayName)"



&#x20;   try {

&#x20;       # Get members

&#x20;       if ($TransitiveMembers) {

&#x20;           $members = Get-MgGroupTransitiveMember -GroupId $g.Id -All

&#x20;       } else {

&#x20;           $members = Get-MgGroupMember -GroupId $g.Id -All

&#x20;       }



&#x20;       $count = 0



&#x20;       foreach ($m in $members) {

&#x20;           $count++



&#x20;           \[pscustomobject]@{

&#x20;               GroupName   = $g.DisplayName

&#x20;               GroupId     = $g.Id

&#x20;               MemberId    = $m.Id

&#x20;               DisplayName = $m.AdditionalProperties\['displayName']

&#x20;               UPN         = $m.AdditionalProperties\['userPrincipalName']

&#x20;               Type        = $m.AdditionalProperties\['@odata.type']

&#x20;           } | Export-Csv -Path $membersCsv -Append -NoTypeInformation

&#x20;       }



&#x20;       # Summary per group

&#x20;       \[pscustomobject]@{

&#x20;           GroupName = $g.DisplayName

&#x20;           Count     = $count

&#x20;       } | Export-Csv -Path $summaryCsv -Append -NoTypeInformation



&#x20;   }

&#x20;   catch {

&#x20;       Write-Warning "Failed: $($g.DisplayName)"

&#x20;   }

}



Write-Host "Done ✅"

Disconnect-MgGraph

