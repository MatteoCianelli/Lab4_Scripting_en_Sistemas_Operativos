# ----- Reto 3: Automatización -----
# Script funcional para crear una carpeta con la fecha actual en el nombre.

# Construir el nombre de la carpeta usando la fecha del sistema.
$fecha = Get-Date -Format "yyyy-MM-dd"
$nombreCarpeta = "Carpeta_$fecha"

# Intentar crear la carpeta sin mostrar error si ya existe.
$carpeta = New-Item -ItemType Directory -Name $nombreCarpeta -ErrorAction SilentlyContinue

# Mostrar el resultado según si la carpeta fue creada o ya existía.
if ($carpeta) {
    $carpeta | Format-Table Mode, LastWriteTime, Length, Name
    Write-Host "Carpeta creada: $nombreCarpeta`n"
}
else {
    Get-Item $nombreCarpeta | Format-Table Mode, LastWriteTime, Length, Name
    Write-Host "La carpeta ya existía: $nombreCarpeta`n"
}