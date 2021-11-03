#Requires -RunAsAdministrator
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
#. "$here\$sut"

BeforeDiscovery {
    ..\Remove-RegistryPropertyForAllUsers.ps1 -PathSuffix 'SOFTWARE\Test' -Name 'Test'
    $null = New-PSDrive -PSProvider Registry -Name HCU -Root HKEY_USERS
    $AllProfiles = Get-ChildItem HCU:
    $Profiles = Split-Path -Leaf $AllProfiles.Name | Where-Object { $_ -notlike '*Classes' }
    $null = Remove-PSDrive -Name HCU -ErrorAction SilentlyContinue
}

Describe "Remove-RegistryPropertyForAllUsers" -ForEach $Profiles {
    BeforeAll {
        $null = New-PSDrive -PSProvider Registry -Name HCU -Root HKEY_USERS
        $profile = $_
    }

    #For each user profile in profiles
    It "Removes a registry property for $profile" {
        Get-ItemProperty -Path "HCU:\$profile\SOFTWARE\Test" -Name 'Test' -ErrorAction SilentlyContinue | Should -Be $null
    }

    AfterAll {
        $null = Remove-PSDrive -Name HCU -ErrorAction SilentlyContinue
    }
}