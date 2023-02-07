# Copyright (c) Brandon Pacewic
# SPDX-License-Identifier: MIT

$dir = Get-ChildItem -Path . -Recurse -Filter *.py | Select-Object -ExpandProperty DirectoryName

$paths = [Environment]::GetEnvironmentVariable("PATH", "Machine")

Write-Host "Linking Python files in child directories to the PATH environment variable..."

foreach ($d in $dir) {
  if ($paths -contains $d) {
    Write-Error "$d is already in the PATH environment variable."
    continue
  }
  
  $paths = "$d;$paths"
  Write-Host "Adding $d to PATH environment variable."

  $files = Get-ChildItem -Path $d -Filter *.py
  
  foreach ($f in $files) {
    $wrapper = "$d\$($f.BaseName).cmd"
    $command = "@echo off`npython3 `"$($f.FullName)`" %*"
    Set-Content -Path $wrapper -Value $command
    Write-Host "Created wrapper script for $($f.Name)."
  }
}

[Environment]::SetEnvironmentVariable("PATH", $paths, "Machine")

Write-Host "Successfully linked Python files in child directories to the PATH environment variable."
