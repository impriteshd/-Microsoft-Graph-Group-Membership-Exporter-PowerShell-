# -----------------------------
# Set Output Folder
# -----------------------------
$OutputFolder = "C:\Group Data"

# Ensure folder exists
if (!(Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

# -----------------------------
# Connect to Microsoft Graph
# -----------------------------
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "Group.Read.All","User.Read.All"

# Optional: ensure context is correct
$context = Get-MgContext
Write-Host "Connected as: $($context.Account)" -ForegroundColor Green

# -----------------------------
# Get all groups
# -----------------------------
Write-Host "Fetching groups..." -ForegroundColor Cyan
$groups = Get-MgGroup -All -Property "id,displayName"
Write-Host "Total groups found: $($groups.Count)" -ForegroundColor Yellow

# -----------------------------
# Output containers
# -----------------------------
$allMembers = @()
$summary    = @()

# -----------------------------
# Process groups
# -----------------------------
foreach ($g in $groups) {
    Write-Host "Processing group: $($g.DisplayName)" -ForegroundColor Cyan
    try {
        $members = Get-MgGroupMember -GroupId $g.Id -All

        $count = 0
        foreach ($m in $members) {
            $count++

            $displayName = $m.AdditionalProperties["displayName"]
            $upn         = $m.AdditionalProperties["userPrincipalName"]
            $type        = $m.AdditionalProperties["@odata.type"]

            $allMembers += [pscustomobject]@{
                GroupName   = $g.DisplayName
                GroupId     = $g.Id
                MemberId    = $m.Id
                DisplayName = $displayName
                UPN         = $upn
                Type        = $type
            }
        }

        $summary += [pscustomobject]@{
            GroupName = $g.DisplayName
            GroupId   = $g.Id
            Count     = $count
        }
    }
    catch {
        Write-Warning "Failed to process group: $($g.DisplayName) | $($_.Exception.Message)"
    }
}

# -----------------------------
# Export results
# -----------------------------
# Safety check (prevents null error)
if (-not $OutputFolder) {
    throw "OutputFolder is not set!"
}

$membersCsv = Join-Path -Path $OutputFolder -ChildPath "GroupMembers.csv"
$summaryCsv = Join-Path -Path $OutputFolder -ChildPath "Summary.csv"

Write-Host "Exporting CSV files..." -ForegroundColor Cyan

$allMembers | Export-Csv -Path $membersCsv -NoTypeInformation -Encoding UTF8
$summary    | Export-Csv -Path $summaryCsv -NoTypeInformation -Encoding UTF8

# -----------------------------
# Cleanup
# -----------------------------
Disconnect-MgGraph | Out-Null

Write-Host "Done successfully ✅" -ForegroundColor Green
Write-Host "Output folder: $OutputFolder" -ForegroundColor Yellow
