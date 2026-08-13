# ==============================================================================
# SCRIPT DE INSTALACIÓN AUTOMÁTICA
# Ejecutar en PowerShell como Administrador
# ==============================================================================

$workDir = "C:\Setup_Temp"
if (!(Test-Path -Path $workDir)) {
    New-Item -ItemType Directory -Path $workDir | Out-Null
}

Set-Location -Path $workDir

Write-Host ">>> Descargando e instalando componentes..." -ForegroundColor Cyan

# 1. GLPI Agent
$glpiUrl = "https://github.com/isNorh/software-despliegue/releases/download/v1.0.0/GLPI-Agent-1.16-x64.msi"
$glpiFile = "$workDir\GLPI-Agent.msi"
Write-Host "[1/4] Instalando GLPI Agent..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $glpiUrl -OutFile $glpiFile
Start-Process msiexec.exe -ArgumentList "/i `"$glpiFile`" /quiet /norestart RUNNOW=1" -Wait

# 2. Panda Endpoint Agent
$pandaUrl = "https://github.com/isNorh/software-despliegue/releases/download/v1.0.0/Panda.Endpoint.Agent.msi"
$pandaFile = "$workDir\Panda.Endpoint.Agent.msi"
Write-Host "[2/4] Instalando Panda Endpoint..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $pandaUrl -OutFile $pandaFile
Start-Process msiexec.exe -ArgumentList "/i `"$pandaFile`" /quiet /norestart" -Wait

# 3. AgentSetup Home
$agentUrl = "https://github.com/isNorh/software-despliegue/releases/download/v1.0.0/AgentSetup_Home.exe"
$agentFile = "$workDir\AgentSetup_Home.exe"
Write-Host "[3/4] Instalando AgentSetup..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $agentUrl -OutFile $agentFile
Start-Process -FilePath $agentFile -ArgumentList "/S" -Wait

# 4. Office Setup
$officeUrl = "https://github.com/isNorh/software-despliegue/releases/download/v1.0.0/OfficeSetup.exe"
$officeFile = "$workDir\OfficeSetup.exe"
Write-Host "[4/4] Descargando Office Setup..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $officeUrl -OutFile $officeFile
# Ejecuta la instalación por defecto de Office
Start-Process -FilePath $officeFile -Wait

# Limpieza
Write-Host ">>> Limpiando temporales..." -ForegroundColor Cyan
Remove-Item -Path $workDir -Recurse -Force

Write-Host "==========================================" -ForegroundColor Green
Write-Host " ¡Proceso finalizado con éxito!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
