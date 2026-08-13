# ==============================================================================
# SCRIPT DE INSTALACIÓN (REPOSITORIO PRIVADO)
# ==============================================================================

# Autenticación para repositorio privado
$token = "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"
$headers = @{ 
    "Authorization" = "token $token"
    "Accept"        = "application/octet-stream"
}

$workDir = "C:\Setup_Temp"
if (!(Test-Path -Path $workDir)) {
    New-Item -ItemType Directory -Path $workDir | Out-Null
}

Set-Location -Path $workDir

Write-Host ">>> Descargando e instalando componentes..." -ForegroundColor Cyan

# 1. GLPI Agent
$glpiUrl = "https://github.com/isNorh/software-despliegue/releases/download/v1.0.0/GLPI-Agent-1.16-x64.msi"
$glpiFile = "$workDir\GLPI-Agent.msi"
Write-Host "[1/4] Descargando GLPI Agent..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $glpiUrl -Headers $headers -OutFile $glpiFile
Write-Host "Instalando GLPI Agent..." -ForegroundColor Green
Start-Process msiexec.exe -ArgumentList "/i `"$glpiFile`" /quiet /norestart RUNNOW=1" -Wait

# 2. Panda Endpoint Agent
$pandaUrl = "https://github.com/isNorh/software-despliegue/releases/download/v1.0.0/Panda.Endpoint.Agent.msi"
$pandaFile = "$workDir\Panda.Endpoint.Agent.msi"
Write-Host "[2/4] Descargando Panda Endpoint..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $pandaUrl -Headers $headers -OutFile $pandaFile
Write-Host "Instalando Panda Endpoint..." -ForegroundColor Green
Start-Process msiexec.exe -ArgumentList "/i `"$pandaFile`" /quiet /norestart" -Wait

# 3. AgentSetup Home
$agentUrl = "https://github.com/isNorh/software-despliegue/releases/download/v1.0.0/AgentSetup_Home.exe"
$agentFile = "$workDir\AgentSetup_Home.exe"
Write-Host "[3/4] Descargando AgentSetup..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $agentUrl -Headers $headers -OutFile $agentFile
Write-Host "Instalando AgentSetup..." -ForegroundColor Green
Start-Process -FilePath $agentFile -ArgumentList "/S" -Wait

# 4. Office Setup
$officeUrl = "https://github.com/isNorh/software-despliegue/releases/download/v1.0.0/OfficeSetup.exe"
$officeFile = "$workDir\OfficeSetup.exe"
Write-Host "[4/4] Descargando Office Setup..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $officeUrl -Headers $headers -OutFile $officeFile
Write-Host "Instalando Office..." -ForegroundColor Green
Start-Process -FilePath $officeFile -Wait

# Limpieza
Write-Host ">>> Limpiando temporales..." -ForegroundColor Cyan
Remove-Item -Path $workDir -Recurse -Force

Write-Host "==========================================" -ForegroundColor Green
Write-Host " ¡Proceso finalizado con éxito!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
