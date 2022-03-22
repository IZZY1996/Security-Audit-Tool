##########################
#   Find Data Streams    #
##########################
function Get-DataStream {
    $ror = @()
    $streams = (Get-ChildItem -Recurse | get-item -stream * | Where-Object { $_.stream -ne ':$Data' })
    
    foreach ($stream in $streams) {
        if ($stream.Stream -eq "SmartScreen") {
            # if the stream is a smartscreen
        
            $ww = (get-content $stream.pspath)
            
            if ($ww -eq "Anaheim") {}
            else { $ror += $stream }
        }
        elseif ($stream.Stream -eq "Zone.Identifier") {
            # if the stream is a MOTW
    
            $yy = Get-Content -LiteralPath $stream.pspath.ToString()
    
            if (($yy.Length -eq 4 -or $yy.length -eq 3) -and ($yy[0] -eq "[ZoneTransfer]") -and ($yy[1] -match 'ZoneID=[1234]') -and ($yy[2] -match 'ReferrerUrl=+.' -or $yy[2] -match 'HostUrl=+.')) {}
            elseif (($yy.Length -eq 2) -and ($yy[0] -eq "[ZoneTransfer]") -and ($yy[1] -match 'ZoneID=[1234]')) {}
            elseif (($yy.Length -eq 3) -and ($yy[0] -eq "[ZoneTransfer]") -and ($yy[1] -match 'LastWriterPackageFamilyName=+.') -and ($yy[2] -match 'ZoneID=[1234]')) {}
            elseif (($yy.Length -eq 4) -and ($yy[0] -eq "[ZoneTransfer]") -and ($yy[1] -match 'ZoneID=[1234]') -and ($yy[2] -match 'LastWriterPackageFamilyName=+.') -and ($yy[3] -match 'ZoneID=\d')) {}
            else { $ror += $stream }
        }
        elseif ($stream.Stream -eq "Afp_AfpInfo") {
        
            $ll = Get-Content -LiteralPath $stream.pspath.ToString()
            
            if ($ll -eq 'AFP☺€PDF CARO') {}
            else { $ror += $stream }
        }
        else { $ror += $stream } # if none of the above apply
    }
    
    # write output
    "------------ Suspicious Data Streams ------------"
    ForEach ($s in $ror) {
        $e, $r = $s.PSParentPath -split "::"
        Write-Host "$r\" -ForegroundColor darkGray -NoNewline
        Write-Host $s.PSChildName -ForegroundColor White
    }
}
