#####################################################
# HelloID-Conn-Prov-Source-PSStuntman-Departments
#
# Version: 2.0.1
#####################################################
$VerbosePreference = "Continue"

#region functions
function Get-STDepartments {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $LocationToPSStuntmanDLL
    )

    try {
        Import-Module "$LocationToPSStuntmanDLL\PSStuntman.DLL" -Force

        $departments = Get-Department
        Write-Output $departments | ConvertTo-Json -Depth 10
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
#endregion

$connectionSettings = ConvertFrom-Json $configuration
$splatParams = @{
    LocationToPSStuntmanDLL = $connectionSettings.LocationToPSStuntmanDLL
}
Get-STDepartments @splatParams