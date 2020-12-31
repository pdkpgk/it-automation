# it-automation
My automation scripts (in PowerShell, Python)

## Getting Started
These instructions will get you a csv file of Azure CDN links from your local resource.  
You can import the exported csv file to your favorite IDE (I use PowerShell ISE and Pycharm).

### Prerequisites
* Windows PowerShell - 5.0 or higher

### Change PowerShell execution policy
Your PowerShell's execution policy needs to be "Unrestricted".  
You can set it by below command:
```
Set-ExecutionPolicy Unrestricted -Force
```

## Description

### writeLog function
The function writes logs where you use the function in the script.  
Log files will be saved in a folder where you saved the script file.
<br><br>
### cdnLinkGeneration function
After specifying your source's local path you need to generate Azure CDN links, the script will check if it exists.  
It will generate Azure CDN links with specified Azure CDN link form.
<br><br>
### csvExportation function
It will export generated Azure CDN links to a csv file and save it to a folder where you saved the script file.

## Examples
The example below shows how to write logs by using writeLog function:
```
PS C:\> writeLog -Msg " [Start] Generating Azure CDN links"
```
<br><br>
The example below shows how to generate Azure CDN links by using cdnLinkGeneration function:
cdnLinkGeneration -localSourcePath 'your local path needs to generate CDN links' -cdnLinkForm 'your Azure CDN's endpoint hostname + container name'
```
PS C:\> cdnLinkGeneration -localSourcePath 'E:\contents' -cdnLinkForm 'https://cdnEndpointhostname/containerName'
```
<br><br>
The example below shows how to export Azure CDN links to a csv file by using csvExportation function:
```
PS C:\> csvExportation
```

## Author
* **Peter G. Kim** (https://github.com/pdkpgk)

## Acknowledgments
* Anyone who needs to generate Azure CDN links for any usage
* Appreciation to HIM
