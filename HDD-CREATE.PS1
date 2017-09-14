param(
    [string]$IOMETER
)

$i=1
Do
{Get-VM $IOMETER | New-HardDisk -CapacityKB 20971520 -ThinProvisioned | New-ScsiController -type paravirtual
Write-Output $i
$controller = "SCSI Controller " + $i + ""
New-HardDisk -VM $IOMETER -CapacityKB 20971520 -ThinProvisioned -controller $controller
New-HardDisk -VM $IOMETER -CapacityKB 20971520 -ThinProvisioned -controller $controller
$i=$i + 1
}
Until($i -eq 4)
