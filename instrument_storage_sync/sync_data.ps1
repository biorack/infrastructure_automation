# Get the directory where the script is located
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Specify the relative path to your JSON file
$jsonFilePath = Join-Path -Path $scriptDirectory -ChildPath "config.json"

# Read the JSON file
$jsonContent = Get-Content -Path $jsonFilePath | ConvertFrom-Json

# Access the local JSON data
$department = $jsonContent.department
$instrument = $jsonContent.instrument

# Build data path based on the department
$basePath = "\\storage.jgi.lbl.gov\metabolomics"
$departmentDataPath = Join-Path -Path $basePath -ChildPath $department

# Check if SPSS shared drive is connected as S drive
if (Test-Path -Path “S:”){
"S drive configured. Continuing..."
}
else {
net use S: \\storage.jgi.lbl.gov\metabolomics /savecred /persistent:yes
}

$storage_drive = Get-PSDrive S | Select-Object Used,Free
$date = Get-Date -format yyyy-MM-d

# If S drive has sufficient storage, initiate robocopy transfer from D drive
if ($storage_drive.Free / 1GB -gt 500){

Write-Host 'D drive sync in progress...’

robocopy D:\ `
    $departmentDataPath `
    /e /MT:10 /R:10 /FFT /Z /W:5 /TS /np /v /A-:SH /zB /XJ `
    /XD "D:\staging" "D:\archive" `
    /XJD "D:\`$`RECYCLE.BIN" `
    /log:"$departmentDataPath\${instrument}_D_Backup_Logs\$date.txt"

Write-Host 'D drive sync complete’

}

# Perform second check for storage space, initiate robocopy transfer from C drive
if ($storage_drive.Free / 1GB -gt 500){

Write-Host 'C drive sync in progress...’

robocopy C:\ `
    \\storage.jgi.lbl.gov\metabolomics\Inst_Backup\$department\$instrument `
    /e /MT:10 /R:10 /FFT /Z /W:5 /TS /np /v /A-:SH /zB /XJ `
    /XF ".raw" "hiberfil.sys" "pagefile.sys" "swapfile.sys" `
    /XD "C:\DELL" "C:\Intel" "C:\Users" "C:\Windows" "C:\ProgramData\Dionex\Chromeleon\DataVaults\ChromeleonLocal\RawFiles" "C:\Program Files\Windows Defender " "C:\Program Files\CrowdStrike" "C:\options\Sophos" "C:\Program Files\Windows Defender Advanced Threat Protection " "C:\ProgramData\Package Cache " `
    /XJD "C:\ProgramData\ApplicationData\Dionex\Chromeleon\DataVaults\ChromeleonLocal\RawFiles" "C:\`$`RECYCLE.BIN" `
    /log:"\\storage.jgi.lbl.gov\metabolomics\Inst_Backup\$department\$instrument\${instrument}_C_Backup_Logs\$date.txt"

Write-Host 'C drive sync complete’

}

else {

Write-Host 'Insufficient destination S: disk space. Please clear some data off S: drive prior to copying'

}
