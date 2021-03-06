<#
.SYNOPSIS
Returns information about tomcat instances on remote SSH hosts.
.DESCRIPTION
Returns a formatted table of output.

HOST 
CATALINA_BASE 
STATE <UP|DOWN>
RSS Resident State Size (allocated memory, excluding swap; human readable)
VSZ Virtual Memory Size (total available)
CPU pct usage at time of sample
LOGSZ Total Size of $CATALINA_BASE/logs (human readable)

.PARAMETER SshHosts
List of SSH-accessible hosts.  You should use an SSH Agent (ssh-agent) for these hosts to allow passwordless
access.  If the ssh client doesn't connect automatically to a host in the list, a password prompt will appear.

.PARAMETER ForcePutty
Force the module to use PuTTY plink instead of "ssh" to allow integration with Pageant.

.EXAMPLE
.\CheckTomcats.ps1 user@myhost1,user@myhost2
HOST           CATALINA_BASE       STATE RSS   VSZ    CPU LOGSZ
----           -------------       ----- ---   ---    --- -----
myuser@myhost1 /home/tom/catalina1 UP    95MiB 2.4GiB 0.0 120K 
myuser@myhost1 /tmp/mycatalina1    DOWN  ?     ?      ?   4.0K 
myuser@myhost2 /home/tom/catalina1 UP    95MiB 2.4GiB 0.0 120K 
myuser@myhost2 /tmp/mycatalina1    DOWN  ?     ?      ?   4.0K 

.EXAMPLE
.\CheckTomcats.ps1 -ForcePutty user@myhost1,user@myhost2

Force the module to use PuTTY so that it can use Pageant for ssh keys.
#>


[CmdletBinding()]
param( 
	[Parameter(Position=1,Mandatory=$true)][string[]]$SshHosts,
	[switch]$ForcePutty
)
Import-Module -Force $PSScriptRoot/TomcatMon.psm1
Get-TomcatStats $SshHosts -ForcePutty:$ForcePutty -Verbose:$Verbose | format-table -property HOST,CATALINA_BASE,STATE,RSS,VSZ,CPU,LOGSZ

