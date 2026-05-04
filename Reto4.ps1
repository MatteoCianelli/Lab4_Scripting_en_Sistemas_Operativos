# ----- Reto 4: Script interactivo -----
# Script interactivo que permite acceder a las opciones de los retos anteriores.
# Desde este menú se puede consultar información del sistema, gestionar procesos
# y ejecutar la automatización de carpetas.

# Configurar la consola para mostrar correctamente caracteres en español.
chcp 65001

# ----- Reto 1: Información del sistema -----
# Esta función reúne datos básicos de CPU, memoria y disco.
function InfoSistema {
    # Consultar el uso actual de CPU.
    Write-Host "`n=== Uso de CPU ==="
    $cpu = Get-CimInstance Win32_Processor | Select-Object -ExpandProperty LoadPercentage
    Write-Host ("Uso de CPU: {0}%" -f $cpu)

    # Consultar memoria libre y total en el sistema.
    Write-Host "`n=== Memoria RAM ==="
    $mem = Get-CimInstance Win32_OperatingSystem
    $freeGB = [math]::Round($mem.FreePhysicalMemory / 1MB, 2)
    $totalGB = [math]::Round($mem.TotalVisibleMemorySize / 1MB, 2)
    Write-Host ("Memoria RAM: {0} GB libres de {1} GB" -f $freeGB, $totalGB)

    # Consultar el espacio disponible en los discos locales.
    Write-Host "`n=== Espacio en Disco ==="
    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        $freeGB = [math]::Round($_.FreeSpace / 1GB, 2)
        $sizeGB = [math]::Round($_.Size / 1GB, 2)
        Write-Host ("Unidad {0}: {1} GB libres de {2} GB" -f $_.DeviceID, $freeGB, $sizeGB)
    }
}

# ----- Reto 2: Gestión de procesos -----
# Esta función muestra los procesos activos y permite finalizar uno.
function Procesos {
    # Mostrar los procesos más activos en CPU.
    Write-Host "`n=== Procesos activos (Top 8 por CPU) ==="

    Get-Process |
    Sort-Object CPU -Descending |
    Select-Object -First 8 Id, Name, CPU |
    Format-Table -AutoSize |
    Out-Host

    # Consultar si el usuario desea cerrar un proceso.
    $opcion = Read-Host "¿Desea finalizar un proceso? (s/n)"

    # Si confirma, pedir el ID del proceso y finalizarlo.
    if ($opcion -eq "s") {
        $processId = Read-Host "Ingrese el ID del proceso"
        Stop-Process -Id $processId -Confirm
        Write-Host "Proceso finalizado correctamente."
    }
    else {
        Write-Host "No se finalizó ningún proceso."
    }
}

# ----- Reto 3: Automatización -----
# Esta función crea una carpeta con la fecha del día en el nombre.
function Automatizacion {
    # Generar el nombre de la carpeta con formato de fecha.
    $fecha = Get-Date -Format "yyyy-MM-dd"
    $nombreCarpeta = "Carpeta_$fecha"

    # Intentar crear la carpeta sin detener el script si ya existe.
    $carpeta = New-Item -ItemType Directory -Name $nombreCarpeta -ErrorAction SilentlyContinue

    # Mostrar el resultado según el estado de la carpeta.
    if ($carpeta) {
        $carpeta | Format-Table Mode, LastWriteTime, Length, Name
        Write-Host "Carpeta creada: $nombreCarpeta`n"
    }
    else {
        Get-Item $nombreCarpeta | Format-Table Mode, LastWriteTime, Length, Name
        Write-Host "La carpeta ya existía: $nombreCarpeta`n"
    }
}

# ----- Menú principal -----
# Bucle principal del programa para mostrar opciones y ejecutar funciones.
do {
    # Mostrar el menú de opciones en pantalla.
    Write-Host ""
    Write-Host "1) Información del sistema"
    Write-Host "2) Procesos"
    Write-Host "3) Automatización"
    Write-Host "4) Salir"

    # Leer la opción elegida por el usuario.
    $opcion = Read-Host "`nSeleccione una opción"

    # Ejecutar la función correspondiente según la opción seleccionada.
    switch ($opcion) {
        "1" { InfoSistema }
        "2" { Procesos }
        "3" { Automatizacion }
        "4" { Write-Host "Saliendo..." }
        default { Write-Host "Opción inválida" }
    }
}
while ($opcion -ne "4")