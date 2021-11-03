#Requires -RunAsAdministrator
<#
.SYNOPSIS
Removes a registry property for all users

.DESCRIPTION
Removes a registry property for all user profiles on a system.

.INPUTS
None. You cannot pipe objects to Remove-RegistryPropertyForAllUsers.

.OUTPUTS
None.

.EXAMPLE
PS> Remove-RegistryPropertyForAllUsers.ps1 -PathSuffix 'SOFTWARE\Microsoft\OfficeApp' -Name '<KeyName>'

#>

[cmdletbinding()]
param(
    [Parameter(Mandatory = $true, Position = 1, HelpMessage = 'Relative registry path in user registry hive')][String]$PathSuffix,
    [Parameter(Mandatory = $true, Position = 2, HelpMessage = 'Registry Property Name')][String]$Name
)

$null = New-PSDrive -PSProvider Registry -Name HCU -Root HKEY_USERS
$AllProfiles = Get-ChildItem HCU:
$Profiles = Split-Path -Leaf $AllProfiles.Name | Where-Object { $_ -notlike '*Classes' }

#For each user profile in profiles
ForEach ($p in $Profiles) {
    $Path = "HCU:\$p\$PathSuffix"
    Remove-ItemProperty -Path "$Path" -Name "$Name"
}

$null = Remove-PSDrive -Name HCU