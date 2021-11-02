$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Set-UserRegistryValue" {
    It "Sets a registry key for a single user" {
        $true | Should Be $false
    }
    It "Sets a registry key for all user profiles" {
        
    }
}