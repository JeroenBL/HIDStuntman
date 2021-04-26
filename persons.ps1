#####################################################
# HelloID-Conn-Prov-SOURCE-PSStuntman
#
# Version: 1.0.0
#
# Requirements:
#
# PSStuntman PowerShell Module
# Windows PowerShell 5.1
# DOTNET 4.8
#####################################################
function Import-HelloIDPersonData {
        <#
    .SYNOPSIS
    Imports person data into HelloID
    .DESCRIPTION
    Imports person data into HelloID
    .PARAMETER HelloIDSystemConfiguration
    The configuration settings specified on the 'Configuration tab' within HelloID
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]
        $HelloIDSystemConfiguration
    )

    try {
        $splatInvokeStuntman = @{
            DLLFileLocation = $($HelloIDSystemConfiguration.LocationToPSStuntmanDLL)
            Amount = $($HelloIDSystemConfiguration.Amount)
            CompanyName = $($HelloIDSystemConfiguration.CompanyName)
            DomainName = $($HelloIDSystemConfiguration.DomainName)
            DomainSuffix = $($HelloIDSystemConfiguration.DomainSuffix)
            Locale = $($settHelloIDSystemConfigurationings.Locale)
            GenerateStuntman = $($HelloIDSystemConfiguration.GenerateStuntman)
        }
        $persons = Invoke-GetStuntman @splatInvokeStuntman
        foreach ($person in $persons){
            $person | ConvertTo-Json -Depth 10
        }
    } catch {
        Write-Error "could not import HelloID Persons. Error: $($_.Exception.Message)"
    }
}

function Invoke-GetStuntman {
    <#
    .SYNOPSIS
    Generates and retrieves stuntman
    .DESCRIPTION
    Generates and retrieves new stuntman. The generated stuntman are saved to a SQlite database. This function relies on the 'PSStuntman' binary module
    .PARAMETER DLLFileLocation
    The path to the location where the PSStuntman dll files are saved
    .PARAMETER Amount
    The amount of stuntman you want to create, e.g. 10
    .PARAMETER CompanyName
    The CompanyName. e.g. 'Contoso'. When left empty, a random CompanyName will be picked
    .PARAMETER DomainName
    The DomainName. e.g. 'contoso.com'. The default DomainName is set to 'enyoi'
    .PARAMETER DomainSuffix
    The DomainSuffix e.g. '.com'.
    .PARAMETER Locale
    The locale for the stuntman e.g. 'fr' (for French) or 'en' (for English). The default locale is set to 'nl'. To find more locales: https://github.com/bchavez/Bogus
    .PARAMETER GenerateStuntman
    Set to: $true of you want to generate new stuntman. Or: $false if you want to use the stuntman from the SQlite database
    #>
    [OutputType([System.Object[]])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $DLLFileLocation,

        [Int]
        $Amount,

        [String]
        $CompanyName,

        [String]
        $DomainName,

        [String]
        $DomainSuffix,

        [String]
        $Locale,

        [Bool]
        $GenerateStuntman
    )

    try {
        Import-Module "$DLLFileLocation\PSStuntman.dll"
    } catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }

    [System.Collections.Generic.List[object]]$listUsers = @()

    try {
        if ($GenerateStuntman){
            New-Stuntman -Amount $Amount -ExternalIdPrefix $ExternalIdPrefix -UserIdRange $UserIdRange -CompanyName $CompanyName -DomainName $DomainName -DomainSuffix $DomainSuffix -Locale $Locale -SaveToSqlite
        }

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
                CostCenter = $user.CostCenter
                ContractGuid = $user.ContractGuid
                Manager = @{
                    ExternalId = "Test"
                    DisplayName = "Test"
                    PersonId = "Test"
                }
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
        #$listUsers

        # Add the first [0] user from the list as the manager for the other users
        $manager = $listUsers | Select-Object -First 1
        foreach ($user in $listUsers){
            $user.Contracts[0].Manager.ExternalId = $manager.ExternalId
            $user.Contracts[0].Manager.DisplayName = $manager.DisplayName
            $user.Contracts[0].Manager.PersonId = $manager.UserId
        }
        $listUsers
    } catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}

<#
    The configuration settings specified on the 'Configuration tab'
    within HelloID are stored in the *.JSON format.
    Before passing them to the 'Import-HelloIDPersonData'
    function, they need to converted to an object.
#>
$HelloIDSystemConfiguration = ConvertFrom-Json $configuration
Import-HelloIDPersonData $HelloIDSystemConfiguration
