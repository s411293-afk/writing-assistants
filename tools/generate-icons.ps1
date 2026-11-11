Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$srcPath = Join-Path $root "icons\icon-source.jpg"
$outDir = Join-Path $root "icons"

if (-not (Test-Path $srcPath)) {
    Write-Error "Source image not found: $srcPath"
    exit 1
}

$src = [System.Drawing.Bitmap]::FromFile($srcPath)

function Save-ResizedPng($bitmap, $w, $h, $out) {
    $target = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($target)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.DrawImage($bitmap, 0, 0, $w, $h)
    $g.Dispose()
    $target.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
    $target.Dispose()
    Write-Output "Saved $out ($w x $h)"
}

Save-ResizedPng $src 512 512 (Join-Path $outDir "icon-512.png")
Save-ResizedPng $src 192 192 (Join-Path $outDir "icon-192.png")
Save-ResizedPng $src 512 512 (Join-Path $outDir "maskable-512.png")

# Favicon 32x32
$bmp32 = New-Object System.Drawing.Bitmap(32, 32)
$g = [System.Drawing.Graphics]::FromImage($bmp32)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$g.DrawImage($src, 0, 0, 32, 32)
$g.Dispose()

$hIcon = $bmp32.GetHicon()
$icon = [System.Drawing.Icon]::FromHandle($hIcon)
$favPath = Join-Path $root "favicon.ico"
$fs = [System.IO.File]::Create($favPath)
$icon.Save($fs)
$fs.Close()
$icon.Dispose()
$bmp32.Dispose()
Write-Output "Saved favicon.ico (32x32)"

$src.Dispose()
Write-Output "Successfully generated all icons from icon-source.jpg"
