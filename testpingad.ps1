function Get-PingAD {


Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop')
Filter = 'Documents (*.txt)|*.txt' }

$null = $FileBrowser.ShowDialog()

$computer = get-content -path $filebrowser.FileName


$output = $computer | ForEach-Object {
    $computer = $_
    try {
        $adcomp = Get-ADComputer -Identity $computer -ErrorAction Stop | Select-Object -ExpandProperty Enabled
        if($adcomp) {
            $test = Test-Connection -ComputerName $computer -quiet -count 1
            if($test) {
                [PSCustomObject]@{
                    MachineName = $computer
                    PingTest    = $True
                }
            Write-Verbose ('{0} is On' -f $computer)
            }
            else {
                [PSCustomObject]@{
                    MachineName = $computer
                    PingTest    = $false
                }
            Write-Verbose ('{0} is Off' -f $computer)
            }
        }
        else {
            [PSCustomObject]@{
                MachineName = $computer
                PingTest    = $false
            }
        Write-Verbose ('Not in AD')
        }
    }

    catch {
        [PSCustomObject]@{
            MachineName = $computer
            PingTest    = $false
        }
        Write-Verbose ('Unable to locate machine {0}' -f $computer)
    }
}
    $output | export-csv -path C:\Powershell\pingAD.csv
}
