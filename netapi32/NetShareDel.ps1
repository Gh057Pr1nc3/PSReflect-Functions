function NetShareDel {
    <#
    .SYNOPSIS

    Deletes share from the local (or a remote) machine.

    .DESCRIPTION

    This function will execute the NetShareDel Win32API call to delete
    a share on the specified host given at specified path.

    .PARAMETER ComputerName

    Specifies the hostname to delete the share from (also accepts IP addresses).
    Defaults to 'localhost'.

    .PARAMETER ShareName

    The name of the share to delete.

    .NOTES

    Author: Will Schroeder (@harmj0y)  
    License: BSD 3-Clause  
    Required Dependencies: PSReflect
    Optional Dependencies: None

    (func netapi32 NetShareDel ([Int]) @(
        [String],                   # _In_  LPWSTR  servername
        [String],                   # _In_  LPWSTR  netname
        [Int]                       # _In_  DWORD   reserved
    ) -EntryPoint NetShareDel)

    .LINK

    https://msdn.microsoft.com/en-us/library/windows/desktop/bb525386(v=vs.85).aspx

    .EXAMPLE
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [Alias('HostName', 'dnshostname', 'name')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ComputerName = 'localhost',

        [Parameter(Position = 1, Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ShareName
    )

    PROCESS {
        ForEach ($Computer in $ComputerName) {

            $Result = $Netapi32::NetShareDel($Computer, $ShareName, 0)

            if ($Result -eq 0) {
                Write-Verbose "Share '$ShareName' successfully deleted from server '$Computer'"
            }
            else {
                Throw "[NetShareDel] Error deleting share '$ShareName' from server '$Computer' : $(([ComponentModel.Win32Exception]$Result).Message)"
            }
        }
    }
}