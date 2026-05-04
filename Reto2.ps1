# ----- Reto 2: Gestión de procesos -----
# Script funcional para listar procesos y permitir finalizar uno de forma manual.

# Mostrar los procesos activos ordenados por consumo de CPU.
# Get-Process obtiene los procesos, Sort-Object los ordena de mayor a menor
# y Select-Object deja solo los campos que se quieren mostrar.
Write-Host "=== Lista de procesos ==="
Get-Process |
Sort-Object CPU -Descending |
Select-Object Id, Name, CPU |
Format-Table -AutoSize

# Preguntar al usuario si desea terminar un proceso.
$opcion = Read-Host "¿Desea finalizar un proceso? (s/n)"

# Si responde que sí, se solicita el ID del proceso y se intenta cerrarlo.
if ($opcion -eq "s") {
    $processId = Read-Host "Ingrese el ID del proceso"
    Stop-Process -Id $processId -Confirm
    Write-Host "Proceso finalizado correctamente."
}
else {
    Write-Host "No se finalizó ningún proceso."
}
