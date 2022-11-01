<#
Automatizador de execução de script AT

Autor: Hélio Pasko R.
Setor: P&D (HQA)

Data: 17/03/2022
#>


$sorce_PATH = "C:\Users\RompkoH\OneDrive - Landis+Gyr\dsk\Scripts\Test_scripts"
$dest_PATH =  "C:\Users\RompkoH\OneDrive - Landis+Gyr\dsk\E430_2W\Queue"

$file_NAME = "8623-10.1.003-Relayopcl.tst"
$global:last_fileChange = $null

#param([Parameter(Mandatory)]$file_NAME)

function check_folders
{
    if((Test-Path -Path $sorce_PATH) -and (Test-Path -Path $dest_PATH))
        { return 0 } else { return 1 }
}

function copy_files
{
    $dir_NAME = Join-Path -Path $sorce_PATH -ChildPath $file_NAME
    Copy-Item -Path $dir_NAME -Destination $dest_PATH -Force -ErrorAction Ignore
}

function check_fileChange()
{
    $dir_NAME = Join-Path -Path $sorce_PATH -ChildPath $file_NAME
    $aux = (Get-ChildItem -Path $dir_NAME).LastWriteTime.DateTime
    $last_fileChange = Get-Content -Path .\dateFile.txt -ErrorAction SilentlyContinue
    if($last_fileChange -eq $aux ){ return 0 }
    else{
        (Get-ChildItem -Path $dir_NAME).LastWriteTime.DateTime | Out-File -FilePath .\dateFile.txt
        Write-Host "Arquivo modificado, data modificação ->" + $aux -ForegroundColor Magenta
        return 1
    }
}

function check_BefTaks()
{
    if((Get-Process -Name "Befehlsinterpreter" -ErrorAction SilentlyContinue) -eq $null)
    { return 0 }else{ return 1 }
}


function send_Menu 
{
    Write-host "Atenção siga os steps abaixo:" -ForegroundColor Red 
    
    Write-Host "1 - Modifique o (sorce_PATH) para o diretório do script de teste do ATS" -ForegroundColor Green
    Write-Host "2 - Modifique o (dest_PATH) para apontar para QUEUE do ATS" -ForegroundColor Green
    Write-Host "3 - Passe por parametro o nome do arquivo que está sendo testado" -ForegroundColor Green
}

if( $args.Count -lt "1"){ 
    Write-Host "Favor inserir o nome do arquivo" -ForegroundColor Red
    send_Menu
}
else
{
    #Remove-Item .\dateFile.txt -Force -ErrorAction SilentlyContinue

    Write-Host "Iniciando !!!" -ForegroundColor Green
    while(1)
    {
        if((check_fileChange) -eq "1" )
        {
            if((check_folders) -eq "0")
            {
                Write-Host "copiando arquivo" -ForegroundColor Yellow
                #sleep -Seconds 1
                if((check_BefTaks) -eq 0){copy_files}                
            }else{ return 1 }
        }

        sleep -Seconds 1
    }

}




