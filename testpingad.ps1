Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop')
Filter = 'Documents (*.txt)|*.txt' }

$null = $FileBrowser.ShowDialog()

$computer = get-content -path $filebrowser.FileName


$Results = foreach ($machine in $computer) {
    Try {
    $adcomp = Get-ADComputer -Identity $machine -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Enabled

    [PSCustomObject]@{
        MachineName = $machine
        AD          = $adcomp
        PingTest    = $adcomp -and (Test-Connection -Computername $machine -quiet -count 1)
        }
    }
    catch{
            [PSCustomObject]@{
        MachineName = $machine
        AD          = $false
        PingTest    = $false
        }
    }
}


$Results | Export-Csv -Path C:\Powershell\PingAD.csv
