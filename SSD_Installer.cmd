@echo off
rem Yasin School Software Center - SSD installer chooser v1.1
rem Does not modify Windows policies, AppLocker, registry or security settings.
setlocal
set "MSC_SSD_FOLDER=%~dp0"
powershell.exe -NoLogo -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $d=New-Object System.Windows.Forms.OpenFileDialog; $d.Title='Select an installer from your SSD or USB drive'; $d.Filter='Installers and archives|*.exe;*.msi;*.msix;*.msixbundle;*.zip;*.iso|All files|*.*'; $d.Multiselect=$false; $d.CheckFileExists=$true; $d.InitialDirectory=$env:MSC_SSD_FOLDER; if($d.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK){exit 0}; $p=$d.FileName; $ext=[IO.Path]::GetExtension($p).ToLowerInvariant(); if(@('.exe','.msi','.msix','.msixbundle','.zip','.iso') -notcontains $ext){[System.Windows.Forms.MessageBox]::Show('Only EXE, MSI, MSIX, ZIP and ISO files are supported.','Not supported','OK','Warning')|Out-Null;exit 1}; $question='Open '+[IO.Path]::GetFileName($p)+'?'+[Environment]::NewLine+'Use only software from a trusted source and with a valid license.'; $choice=[System.Windows.Forms.MessageBox]::Show($question,'Confirm SSD software launch',[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Warning); if($choice -ne [System.Windows.Forms.DialogResult]::Yes){exit 0}; try{if($ext -eq '.msi'){Start-Process -FilePath 'msiexec.exe' -ArgumentList ('/i '+[char]34+$p+[char]34)}elseif($ext -in @('.zip','.iso')){Invoke-Item -LiteralPath $p}else{Start-Process -FilePath $p}}catch{[System.Windows.Forms.MessageBox]::Show($_.Exception.Message,'Could not open selected file','OK','Error')|Out-Null;exit 1}"
if errorlevel 1 (
  echo The SSD installation file could not be opened. Check permissions and the file type.
  pause
)
endlocal
