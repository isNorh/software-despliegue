# ==============================================================================
# SCRIPT DE INSTALACIÓN (REPOSITORIO PRIVADO CORREGIDO)
# ==============================================================================

# Forzar protocolo TLS 1.2 para descargas seguras
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$token = "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"
$headers = @{ 
    "Authorization" = "Bearer $token"
}

$workDir = "C:\Setup_Temp"
if (!(Test-Path -Path $workDir)) {
    New-Item -ItemType Directory -Path $workDir | Out-Null
}

Set-Location -Path $workDir

# Función auxiliar para descargar de forma segura
function Descargar-Archivo ($url, $destino) {
    try {
        Invoke-WebRequest -Uri $url -Headers $headers -OutFile $destino -UseBasicParsing
        return $true
    } catch {
        Write-Host " Error al descargar: $_" -ForegroundColor Red
        return $false
    }
}

Write-Host ">>> Descargando e instalando componentes..." -ForegroundColor Cyan

# 1. GLPI Agent
$glpiUrl = "https://raw.githubusercontent.com/isNorh/software-despliegue/main/GLPI-Agent-1.16-x64.msi"
$glpiFile = "$workDir\GLPI-Agent.msi"
Write-Host "[1/4] Descargando GLPI Agent..." -ForegroundColor Yellow
if (Descargar-Archivo -url $glpiUrl -destino $glpiFile) {
    Write-Host "Instalando GLPI Agent..." -ForegroundColor Green
    Start-Process msiexec.exe -ArgumentList "/i `"$glpiFile`" /quiet /norestart RUNNOW=1" -Wait
}

# 2. Panda Endpoint Agent
$pandaUrl = "https://raw.githubusercontent.com/isNorh/software-despliegue/main/Panda.Endpoint.Agent.msi"
$pandaFile = "$workDir\Panda.Endpoint.Agent.msi"
Write-Host "[2/4] Descargando Panda Endpoint..." -ForegroundColor Yellow
if (Descargar-Archivo -url $pandaUrl -destino $pandaFile) {
    Write-Host "Instalando Panda Endpoint..." -ForegroundColor Green
    Start-Process msiexec.exe -ArgumentList "/i `"$pandaFile`" /quiet /norestart" -Wait
}

# 3. AgentSetup Home
$agentUrl = "https://raw.githubusercontent.com/isNorh/software-despliegue/main/AgentSetup_Home.exe"
$agentFile = "$workDir\AgentSetup_Home.exe"
Write-Host "[3/4] Descargando AgentSetup..." -ForegroundColor Yellow
if (Descargar-Archivo -url $agentUrl -destino $agentFile) {
    Write-Host "Instalando AgentSetup..." -ForegroundColor Green
    Start-Process -FilePath $agentFile -ArgumentList "/S" -Wait
}

# 4. Office Setup
$officeUrl = "https://raw.githubusercontent.com/isNorh/software-despliegue/main/OfficeSetup.exe"
$officeFile = "$workDir\OfficeSetup.exe"
Write-Host "[4/4] Descargando Office Setup..." -ForegroundColor Yellow
if (Descargar-Archivo -url $officeUrl -destino $officeFile) {
    Write-Host "Instalando Office..." -ForegroundColor Green
    Start-Process -FilePath $officeFile -Wait
}

# Limpieza
Set-Location -Path "C:\"
Write-Host ">>> Limpiando temporales..." -ForegroundColor Cyan
if (Test-Path -Path $workDir) {
    Remove-Item -Path $workDir -Recurse -Force
}

Write-Host "==========================================" -ForegroundColor Green
Write-Host " ¡Proceso finalizado con éxito!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
