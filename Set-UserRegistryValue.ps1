#Requires -RunAsAdministrator
<#
.SYNOPSIS
Adds a registry value for a single user or all users

.DESCRIPTION
Adds a registry value for a single user or all user profiles on a system.

.INPUTS
None. You cannot pipe objects to Set-UserRegistryValue.

.OUTPUTS
None.

.EXAMPLE
PS> Set-UserRegistryValue.ps1 -PathSuffix 'SOFTWARE\Microsoft\OfficeApp' -Name '<KeyName>' -PropertyType DWORD -Value '1'

.EXAMPLE
PS> Set-UserRegistryValue.ps1 -PathSuffix 'SOFTWARE\Microsoft\OfficeApp' -Name '<KeyName>' -PropertyType DWORD -Value '1' -UserName '<UserName>'

#>

[cmdletbinding()]
param(
    [Parameter(Mandatory = $true, Position = 1, HelpMessage = 'Relative registry path after HCU:\<UserName>\')][String]$PathSuffix,
    [Parameter(Mandatory = $true, Position = 2, HelpMessage = 'Registry key name')][String]$Name,
    [Parameter(Mandatory = $true, Position = 3, HelpMessage = 'Registry value property type')][ValidateSet('Binary','DWord','ExpandString','MultiString','None','QWORD','String','Unknown')]$PropertyType,
    [Parameter(Mandatory = $true, Position = 4, HelpMessage = 'Registry value')]$Value,
    [Parameter(Position = 5, HelpMessage = 'Optionally specify a UserName for whom to set the registry key')][String]$UserName,
    [Parameter(Position = 6, HelpMessage = 'Optionally specify all user profiles')][Switch]$AllUsers
)

$null = New-PSDrive -PSProvider Registry -Name HCU -Root HKEY_USERS
$profiles = Get-ChildItem HCU:
$Profiles = Split-Path -Leaf $profiles.Name | Where-Object { $_ -notlike '*Classes' }

If ($AllUsers) {   
    #For each user profile in profiles
    ForEach ($p in $Profiles) {
        $Path = "HCU:\$p\$PathSuffix"
        New-Item -Path "$Path" -Force
        New-ItemProperty -Path "$Path" -Name "$Name" -PropertyType $PropertyType -Value $Value
    }
}
If ($null -ne $UserName) {
    $Path = "HCU:\$UserName\$PathSuffix"
    New-Item -Path "$Path" -Force
    New-ItemProperty -Path "$Path" -Name "$Name" -PropertyType $PropertyType -Value $Value
} Else {
    Write-Host "You must specify a username or the -AllUsers parameter" -ForegroundColor Red
}

$null = Remove-PSDrive -Name HCU