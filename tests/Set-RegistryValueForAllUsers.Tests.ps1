#Requires -RunAsAdministrator
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
#. "$here\$sut"

BeforeDiscovery {
    ..\Set-RegistryValueForAllUsers.ps1 -PathSuffix 'SOFTWARE\Test' -Name 'Test' -PropertyType DWORD -Value 1
    $null = New-PSDrive -PSProvider Registry -Name HCU -Root HKEY_USERS
    $AllProfiles = Get-ChildItem HCU:
    $Profiles = Split-Path -Leaf $AllProfiles.Name | Where-Object { $_ -notlike '*Classes' }
    $null = Remove-PSDrive -Name HCU -ErrorAction SilentlyContinue
}

Describe "Set-UserRegistryValue" -ForEach $Profiles {
    BeforeAll {
        $null = New-PSDrive -PSProvider Registry -Name HCU -Root HKEY_USERS
        $profile = $_
    }

    #For each user profile in profiles
    It "Sets a registry key for $profile" {
        Get-ItemProperty -Path "HCU:\$profile\SOFTWARE\Test" -Name 'Test' | Select-Object -ExpandProperty Test | Should -Be 1
    }

    AfterAll {
        $null = Remove-PSDrive -Name HCU -ErrorAction SilentlyContinue
    }
}