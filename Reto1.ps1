# ----- Reto 1: Información del sistema -----
# Script funcional para mostrar información básica del sistema en Windows.

# Consultar el uso actual de CPU.
Write-Output "=== Uso de CPU ==="
$cpu = Get-CimInstance Win32_Processor | Select-Object -ExpandProperty LoadPercentage
Write-Output ("Uso de CPU: {0}%" -f $cpu)

# Consultar el estado de la memoria RAM.
Write-Output "`n=== Memoria RAM ==="
$mem = Get-CimInstance Win32_OperatingSystem
$freeGB = [math]::Round($mem.FreePhysicalMemory / 1MB, 2)
$totalGB = [math]::Round($mem.TotalVisibleMemorySize / 1MB, 2)
Write-Output ("Memoria RAM: {0} GB libres de {1} GB" -f $freeGB, $totalGB)

# Consultar el espacio disponible en los discos locales.
Write-Output "`n=== Espacio en Disco ==="
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    $freeGB = [math]::Round($_.FreeSpace / 1GB, 2)
    $sizeGB = [math]::Round($_.Size / 1GB, 2)
    Write-Output ("Unidad {0}: {1} GB libres de {2} GB" -f $_.DeviceID, $freeGB, $sizeGB)
}