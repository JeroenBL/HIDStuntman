#####################################################
# HelloID-Conn-Prov-Source-PSStuntman-Persons
#
# Version: 2.0.0
#####################################################
$VerbosePreference = "Continue"

#region functions
function Get-StuntmanPersons {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $LocationToPSStuntmanDLL
    )

    try {
        Import-Module "$LocationToPSStuntmanDLL\PSStuntman.DLL" -Force

        [System.Collections.Generic.List[object]]$listUsers = @()
        $stuntman = Get-Stuntman

        foreach ($user in $stuntman) {
            [System.Collections.Generic.List[object]]$contracts = @()
            $contract = [PSCustomObject]@{
                ExternalId = "CT$($user.ExternalId)"
                Title = $user.Title
                IsManager = $user.IsManager
                StartDate = $user.StartDate
                EndDate = $user.EndDate
                HoursPerWeek = $user.HoursPerWeek
                Company = $user.Company
                Department = $user.Department
                DepartmentExternalId = $user.DepartmentExternalId
                CostCenter = $user.CostCenter
                ContractGuid = $user.ContractGuid
            }
            $contracts.Add($contract)

            $personObj = [PSCustomObject]@{
                ExternalId = $user.ExternalId
                DisplayName = $user.DisplayName
                NickName = $user.GivenName
                UserId = $user.UserId
                Status = $user.IsActive
                UserGuid = $user.UserGuid
                Personal = @{
                    BirthDate = $user.BirthDate
                    BirthPlace = $user.BirthPlace
                    Language = $user.Language
                    Name = @{
                        GivenName = $user.GivenName
                        FamilyName = $user.FamilyName
                        Initials = $user.Initials
                    }
                    Address = @{
                        City = $user.City
                        Street = $user.Street
                        HouseNumber = $user.HouseNumber
                        ZipCode = $user.ZipCode
                    }
                    Contact = @{
                        PersonalEmailAddress = $user.PersonalEmailAddress
                        PersonalPhoneNumber = $user.PersonalPhoneNumber
                    }
                }
                BusinessCommunication = @{
                    BusinessEmailAddress = $user.BusinessEmailAddress
                    BusinessPhoneNumber = $user.BusinessPhoneNumber
                }
                Contracts = $contracts
            }
            $listUsers.Add($personObj)
        }
        Write-Output $listUsers | ConvertTo-Json -Depth 20

    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
#endregion

$connectionSettings = ConvertFrom-Json $configuration
$splatParams = @{
    LocationToPSStuntmanDLL = $connectionSettings.LocationToPSStuntmanDLL
}
Get-StuntmanPersons @splatParams