<# Run ping sweep, port scan and smb enumaration nmap scan !
This script will read through a list of .txt files stored in a folder named SITES on the C:\BUILDS\ . #>

$envPath = "C:\BUILDS\SITES"

$files = Get-ChildItem "$envPath\*.txt"

foreach ($file in $files) 
     {
        $siteLocation = "$envPath\$file"
        $subnets = Get-Content -path $file -Force
        $fileName = (Get-Item $file).Basename
        $dirPath = "$envPath\" + $fileName
        
        if (-not (Test-Path -LiteralPath $DirPath)) 
            {
    
            try {
                New-Item -Path $DirPath -ItemType Directory -ErrorAction Stop | Out-Null #-Force
            }
            catch {
                Write-Error -Message "Unable to create directory '$DirectoryToCreate'. Error was: $_" -ErrorAction Stop
            }
            "Successfully created directory '$DirectoryToCreate'."
            }
        else{
            "Directory already existed"
            }
#run nmap scan for each subnet
 foreach ($subnet in $subnets)
     {
            echo $subnet
        
            $filename = ($subnet.substring(0,$subnet.length - 3))
            $nmapXfile = "c:\BUILDS\temp\" + $filename  + ".xml"
            cmd.exe /c "nmap -PE -T4 --defeat-rst-ratelimit -sS -p 21,22,25,110,135,U:137,T:139,445,3389,80 -oA $filename -A -v $subnet"
            $txtfilename = $filename  + ".txt"
            $xdoc = [xml] (get-content $nmapXfile)
			$xdoc.SelectNodes("//address") |  Export-Csv $dirPath\$txtfilename -NoTypeInformation -Delimiter:"," -Encoding:UTF8

                        

            Start-Sleep -s 45
     }
}
