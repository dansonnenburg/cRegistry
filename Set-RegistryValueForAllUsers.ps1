#Requires -RunAsAdministrator
<#
.SYNOPSIS
Adds a registry value for a single user or all users

.DESCRIPTION
Adds a registry value for a single user or all user profiles on a system.

.INPUTS
None. You cannot pipe objects to Set-RegistryValueForAllUsers.

.OUTPUTS
None.

.EXAMPLE
PS> Set-RegistryValueForAllUsers.ps1 -PathSuffix 'SOFTWARE\Microsoft\OfficeApp' -Name '<KeyName>' -PropertyType DWORD -Value '1'

#>

[cmdletbinding()]
param(
    [Parameter(Mandatory = $true, Position = 1, HelpMessage = 'Relative registry path in user registry hive')][String]$PathSuffix,
    [Parameter(Mandatory = $true, Position = 2, HelpMessage = 'Registry Property Name')][String]$Name,
    [Parameter(Mandatory = $true, Position = 3, HelpMessage = 'Registry value property type')][ValidateSet('Binary', 'DWord', 'ExpandString', 'MultiString', 'None', 'QWORD', 'String', 'Unknown')]$PropertyType,
    [Parameter(Mandatory = $true, Position = 4, HelpMessage = 'Registry value')]$Value
)

$null = New-PSDrive -PSProvider Registry -Name HCU -Root HKEY_USERS
$AllProfiles = Get-ChildItem HCU:
$Profiles = Split-Path -Leaf $AllProfiles.Name | Where-Object { $_ -notlike '*Classes' }

#For each user profile in profiles
ForEach ($p in $Profiles) {
    $Path = "HCU:\$p\$PathSuffix"
    New-Item -Path "$Path" -Force
    New-ItemProperty -Path "$Path" -Name "$Name" -PropertyType $PropertyType -Value $Value
}

$null = Remove-PSDrive -Name HCU