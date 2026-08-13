# ==============================================================================
# SCRIPT DE INSTALACIÓN VÍA API DE GITHUB (REQUISITO PARA ARCHIVOS GRANDES)
# ==============================================================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$token = "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"
$repoOwner = "isNorh"
$repoName = "software-despliegue"
$tag = "v1.0.0"

$workDir = "C:\Setup_Temp"
if (!(Test-Path -Path $workDir)) {
    New-Item -ItemType Directory -Path $workDir | Out-Null
}

Set-Location -Path $workDir

# Función para descargar Assets de Releases Privadas usando la API de GitHub
function Descargar-ReleaseAsset ($assetName, $destino) {
    Write-Host "Consultando API de GitHub para $assetName..." -ForegroundColor Yellow
    
    $headers = @{
        "Authorization" = "token $token"
        "User-Agent"    = "PowerShellScript"
    }

    # Obtener metadatos de la Release
    $releaseUrl = "https://api.github.com/repos/$repoOwner/$repoName/releases/tags/$tag"
    try {
        $releaseInfo = Invoke-RestMethod -Uri $releaseUrl -Headers $headers
        $asset = $releaseInfo.assets | Where-Object { $_.name -eq $assetName }

        if ($null -eq $asset) {
            Write-Host " [ERR] No se encontró el archivo $assetName en la Release $tag" -ForegroundColor Red
            return $false
        }

        # Descargar el binario usando la URL del asset en la API
        $apiAssetUrl = $asset.url
        $downloadHeaders = @{
            "Authorization" = "token $token"
            "Accept"        = "application/octet-stream"
            "User-Agent"    = "PowerShellScript"
        }

        Invoke-WebRequest -Uri $apiAssetUrl -Headers $downloadHeaders -OutFile $destino -UseBasicParsing
        return $true
    } catch {
        Write-Host " [ERR] Error al descargar $assetName : $_" -ForegroundColor Red
        return $false
    }
}

Write-Host ">>> Descargando e instalando componentes..." -ForegroundColor Cyan

# 1. GLPI Agent
$glpiFile = "$workDir\GLPI-Agent.msi"
if (Descargar-ReleaseAsset -assetName "GLPI-Agent-1.16-x64.msi" -destino $glpiFile) {
    Write-Host "Instalando GLPI Agent..." -ForegroundColor Green
    Start-Process msiexec.exe -ArgumentList "/i `"$glpiFile`" /quiet /norestart RUNNOW=1" -Wait
}

# 2. Panda Endpoint Agent
$pandaFile = "$workDir\Panda.Endpoint.Agent.msi"
if (Descargar-ReleaseAsset -assetName "Panda.Endpoint.Agent.msi" -destino $pandaFile) {
    Write-Host "Instalando Panda Endpoint..." -ForegroundColor Green
    Start-Process msiexec.exe -ArgumentList "/i `"$pandaFile`" /quiet /norestart" -Wait
}

# 3. AgentSetup Home
$agentFile = "$workDir\AgentSetup_Home.exe"
if (Descargar-ReleaseAsset -assetName "AgentSetup_Home.exe" -destino $agentFile) {
    Write-Host "Instalando AgentSetup..." -ForegroundColor Green
    Start-Process -FilePath $agentFile -ArgumentList "/S" -Wait
}

# 4. Office Setup
$officeFile = "$workDir\OfficeSetup.exe"
if (Descargar-ReleaseAsset -assetName "OfficeSetup.exe" -destino $officeFile) {
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
