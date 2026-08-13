# ==============================================================================
# SCRIPT INTERACTIVO DE DESPLIEGUE DE SOFTWARE
# ==============================================================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$repoOwner = "isNorh"
$repoName = "software-despliegue"
$tag = "v1.0.0"

$workDir = "C:\Setup_Temp"
if (!(Test-Path -Path $workDir)) {
    New-Item -ItemType Directory -Path $workDir | Out-Null
}
Set-Location -Path $workDir

# Función para descargar archivos desde las Releases públicas
function Descargar-Asset ($assetName, $destino) {
    $url = "https://github.com/$repoOwner/$repoName/releases/download/$tag/$assetName"
    Write-Host "Descargando $assetName..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $url -OutFile $destino -UseBasicParsing
        return $true
    } catch {
        Write-Host "Error al descargar $assetName : $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

Clear-Host
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "    MENÚ DE INSTALACIÓN DE SOFTWARE CORPORATIVO   " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " [1] GLPI Agent" -ForegroundColor White
Write-Host " [2] Panda Endpoint Agent" -ForegroundColor White
Write-Host " [3] AgentSetup Home" -ForegroundColor White
Write-Host " [4] Office Setup" -ForegroundColor White
Write-Host " [A] INSTALAR TODOS" -ForegroundColor Green
Write-Host " [Q] Salir" -ForegroundColor Gray
Write-Host "==================================================" -ForegroundColor Cyan

$opcion = Read-Host "Ingresa el número de la opción o combinación (ej: 1,3 o A para todos)"

if ($opcion -eq "Q" -or $opcion -eq "q") {
    Write-Host "Operación cancelada por el usuario." -ForegroundColor Yellow
    exit
}

# Determinar qué instalar
$instalarAll   = ($opcion -eq "A" -or $opcion -eq "a")
$instalarGLPI  = $instalarAll -or ($opcion -like "*1*")
$instalarPanda = $instalarAll -or ($opcion -like "*2*")
$instalarAgent = $instalarAll -or ($opcion -like "*3*")
$instalarOffice= $instalarAll -or ($opcion -like "*4*")

# --- EJECUCIÓN DE INSTALACIONES ---

# 1. GLPI Agent
if ($instalarGLPI) {
    $glpiFile = "$workDir\GLPI-Agent.msi"
    if (Descargar-Asset -assetName "GLPI-Agent-1.16-x64.msi" -destino $glpiFile) {
        Write-Host "Instalando GLPI Agent..." -ForegroundColor Green
        Start-Process msiexec.exe -ArgumentList "/i `"$glpiFile`" /quiet /norestart RUNNOW=1" -Wait
    }
}

# 2. Panda Endpoint
if ($instalarPanda) {
    $pandaFile = "$workDir\Panda.Endpoint.Agent.msi"
    if (Descargar-Asset -assetName "Panda.Endpoint.Agent.msi" -destino $pandaFile) {
        Write-Host "Instalando Panda Endpoint..." -ForegroundColor Green
        Start-Process msiexec.exe -ArgumentList "/i `"$pandaFile`" /quiet /norestart" -Wait
    }
}

# 3. AgentSetup Home
if ($instalarAgent) {
    $agentFile = "$workDir\AgentSetup_Home.exe"
    if (Descargar-Asset -assetName "AgentSetup_Home.exe" -destino $agentFile) {
        Write-Host "Instalando AgentSetup..." -ForegroundColor Green
        Start-Process -FilePath $agentFile -ArgumentList "/S" -Wait
    }
}

# 4. Office Setup
if ($instalarOffice) {
    $officeFile = "$workDir\OfficeSetup.exe"
    if (Descargar-Asset -assetName "OfficeSetup.exe" -destino $officeFile) {
        Write-Host "Instalando Office..." -ForegroundColor Green
        Start-Process -FilePath $officeFile -Wait
    }
}

# Limpieza
Set-Location -Path "C:\"
Write-Host ">>> Limpiando archivos temporales..." -ForegroundColor Cyan
if (Test-Path -Path $workDir) {
    Remove-Item -Path $workDir -Recurse -Force
}

Write-Host "==========================================" -ForegroundColor Green
Write-Host " ¡Proceso finalizado!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
