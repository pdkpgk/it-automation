<#
.SYNOPSIS
    The script generates Azure CDN links from your local source to a csv file.

.DESCRIPTION
    After specifying local source path you want to generate Azure CDN links, it will create export folder automatically if it doesn't exist.
    Finally, it checks if script was able to export to a csv.

.FUNCTION writeLog
    The function writes logs where you use the function in the script.
    Log files will be saved in a folder where you saved the script file.

.FUNCTION cdnLinkGeneration
    After specifying your source's local path you need to generate Azure CDN links, the script will check if it exists.
    It will generate Azure CDN links with specified Azure CDN link form.

.FUNCTION csvExportation
    It will export generated Azure CDN links to a csv file and save it to a folder where you saved the script file.

.EXAMPLE
    The example below shows how to write logs by using writeLog function.

    PS C:\> writeLog -Msg " [Start] Generating Azure CDN links"

.EXAMPLE
    The example below shows how to generate Azure CDN links by using cdnLinkGeneration function.

    cdnLinkGeneration -localSourcePath 'your local path needs to generate CDN links' -cdnLinkForm 'your Azure CDN's endpoint hostname + container name'

    PS C:\> cdnLinkGeneration -localSourcePath 'E:\contents' -cdnLinkForm 'https://cdnEndpointhostname/containerName'

.EXAMPLE
    The example below shows how to export Azure CDN links to a csv file by using csvExportation function.

    PS C:\> csvExportation

.NOTES
    Author: Peter G. Kim
    Last Edit: 2020-12-31
    Version 1.0 - initial release
#>

# Get date for logging function (writeLog)
$DateLog = (Get-Date).ToString('yyyy-MM-dd')

function writeLog {
    param(
        $msg
    )   
    $dateTime = (Get-Date).ToString('yyyy-MM-dd hh:mm:ss')

    if (Test-Path "${PSScriptRoot}\Log") {
        "[${dateTime}] : ${msg}" | Out-File "${PSScriptRoot}\Log\${DateLog}.log" -Append
    } else {
        Write-Warning "Log folder doesn't exist.`nCreating log folder..."
        New-Item "${PSScriptRoot}\Log" -ItemType Directory -Force
        "[${dateTime}] : ${msg}" | Out-File "${PSScriptRoot}\Log\${DateLog}.log" -Append
    } 
}

function cdnLinkGeneration {
    param (
    [Parameter(Mandatory=$true)] [String]$localSourcePath,
    [Parameter(Mandatory=$true)] [String]$cdnLinkForm
    )

    writeLog -Msg " [Start] Validating path for localSourcePath"
    # Check if $localSourcePath exists
    if (Test-Path $localSourcePath) {
        Write-Host "`nlocalSourcePath exists!`n`nProceeding to next step...`n" -ForegroundColor Green
        writeLog -Msg " Path for localSourcePath exists."
    }
    else {
        Write-Warning "localSourcePath does NOT exist!`n`nExiting...`n"
        writeLog -Msg " localSourcePath does NOT exist. Terminate program"
        Exit
    }
    writeLog -Msg " [End] Validating path for localSourcePath"
     
    # Get all folders sort by folder name
    $linkSortByFolder = Get-ChildItem -Path $localSourcePath -Directory | Sort-Object {$_.Name -as [int]}

    # Declare an array for full path
    $fullPath = @()

    # Declare an array for complete path
    $completePath = @()

    writeLog -Msg " [Start] Generating Azure CDN links"
    Write-Warning "DO NOT CLOSE!`n`nGenerating Azure CDN links...`n"
    $linkSortByFolder | % {
        $tempFullDirectoryPath = $_.FullName

        # Get all files from the folder and sort by file name
        $tempFullPath = Get-ChildItem -Path $tempFullDirectoryPath -Recurse | Sort-Object -Property {if (($i = $_.BaseName -as [int])) { $i } else { $_ }} | Select-Object -Property FullName
   
        # Save fullname object only to a variable
        $tempFullPath = $tempFullPath.FullName

        # Cut base path
        $splitPath = $tempFullPath.Replace("E:\BGMFACTORY_V2\bfacmusic","")
    
        $splitPath | % {
            $tempSplitPath = "$_"

            # Replace any '\' to '/'
            $replaceSlash = $tempSplitPath.Replace('\','/')
        
            # Merge Azure CDN link with split link
            $fullPath = $cdnLinkForm + $replaceSlash

            # Stack fullPath values to $completePath
            $completePath += $fullPath
        }
    }
    writeLog -Msg " [End] Generating Azure CDN links"
}

function csvExportation {

    $csvPath = "${PSScriptRoot}\export"

    $todayDate = Get-Date
    $formatedDate = $todayDate.ToString("yyyy-MM-dd")

    $csvFileName = "${formatedDate}.csv"
    $csvExportPath = Join-Path -Path $csvPath -ChildPath $csvFileName

    writeLog -Msg " [Start] Validating path for csvPath"
    # Check if $csvPath exists
    if (Test-Path $csvPath) {
        Write-Host "csvPath exists!`n`nProceeding to next step...`n" -ForegroundColor Green
        writeLog -Msg " Path for csvPath exists."
    }
    else {
        Write-Warning "csvPath does NOT exist. Creating csvPath...`n"
        writeLog -Msg " csvPath does NOT exist. Creating csvPath."
        # Creates $csvPath if it doesn't exists
        New-Item -ItemType Directory -Force -Path $csvPath

        # Check if $csvPath was created
        if (Test-Path $csvPath) {
            Write-Host "csvPath has been created successfully!`n`nProceeding to next step...`n" -ForegroundColor Green
            writeLog -Msg " csvPath has been created successfully."
        }
        else {
            Write-Warning "csvPath was NOT created. Please check PowerShell policy.`n`nExiting...`n"
            writeLog -Msg " csvPath was NOT created. Please check PowerShell policy. Terminate program"
            # Terminates program if $csvPath couldn't be created
            Exit
        }
    }
    writeLog -Msg " [End] Validating path for csvPath"

    # Export result (completePath) to a csv file
    writeLog -Msg " [Start] Exporting to csv file"
    Write-Warning "DO NOT CLOSE!`n`nExporting...`n"
    $completePath | Out-File $csvExportPath

    if (Test-Path $csvExportPath) {
        Write-Host "Completed to export" -ForegroundColor Green
        writeLog -Msg " Completed to export"
    }
    else {
        Write-Warning "Couldn't be exported!`nContact the scripter`n`nExiting...`n"
        writeLog -Msg " Couldn't be exported. Terminate program"
        Exit
    }
    writeLog -Msg " [End] Exporting to csv file`n`n"
}

# Example to run the script
cdnLinkGeneration -localSourcePath 'E:\azure\download\contents' -cdnLinkForm 'https://peterCDN.net/contentContainer'
csvExportation -csvPath