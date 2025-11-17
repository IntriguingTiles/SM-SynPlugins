foreach ($script in Get-ChildItem *.sp) {
    $output = "..\plugins\" + $script.BaseName + ".smx"

    if (Test-Path $output) {
        $outputtime = (Get-ChildItem $output).LastWriteTime
        $scripttime = $script.LastWriteTime

        if ($scripttime.CompareTo($outputtime) -le 0) {
            continue
        }
    }

    Write-Host -ForegroundColor Green Compiling $script.Name `n
    $sminc = $env:SMINC
    $opts = if ($script.BaseName -eq "crashmap") {""} else {"--require-semicolons"}


    & $env:SPCOMP $script.Name -o"$output" -i"$sminc" $opts

    if (!$?) {
        Write-Host -ForegroundColor Red Build failed!
        return
    }

    Write-Host
}