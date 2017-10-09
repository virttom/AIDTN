############RECUPERATION DES PARAMETRES DU SCRIPT###############
param (
[string]$FilePath,
[string]$Wkbprocessed,
[string]$Wkbresult
)

<# 
.SYNOPSIS XTRACT les informations des fichiers de wkbprocessed pour les copier dans un nouveau XLS
.DESCRIPTION  les informations préalablement organisées par VM Iometer et intégrées dans les fichiers XLS présents dans processed sont extraits et injecté dans un nouvel XLS : 1 onglet par VM iometer. 
.NOTES Author: Thomas CHARLES 
.NOTES  
.PARAMETER FilePath = nom (+ chemin du fichier XLSX dont on extrait les données
.PARAMETER Wkbprocessed = le repertoire contenant les fichiers apres traitement   
.PARAMETER Wkbresult = nom + chemin du fichier XLS sur lequel on va copier les onglets (1 vm = 1 onglet) 
.EXAMPLE ./IOmeter_xTract-v001.ps1 D:\tmp\PERFTEST\ALL\CS2_NOS464\preprocessed\io2.xlsx D:\tmp\PERFTEST\ALL\CS2_NOS464\processed D:\tmp\PERFTEST\ALL\CS2_NOS464\processed\NOS464.xlsx
.EXAMPLE ./IOmeter_xTract-v001.ps1 D:\tmp\PERFTEST\ALL\preprocessed\io5.xlsx D:\tmp\PERFTEST\ALL\processed D:\tmp\PERFTEST\ALL\processed\NOS502.xlsx
#>


############FONCTIONS###############
<#
    TRAITEMENTXLS => pour chaque worksheet ouvert 
        créée un tableau 
        copie la case A9 (type de traitement) 
        copie la case A6 (date de démarrage)
        ajoute 2 colonnes avant $A,
        copie la valeur de la case A9 dans A16
        copie la valeur de la case B9 dans B16
#>

Function TRAITEMENTXLS
{

$line=new-object PSObject
$NomTest = $WkSheet.Name
$DateTest = $WkSheet.Cells.item(6,1).value()
$VM= $WkSheet.Cells.Item(16,2).value()
$TypeTest = $WkSheet.Cells.Item(16,3).value()
$IOPS = $WkSheet.Cells.Item(16,7).value()
$ReadIOPS = $WkSheet.Cells.Item(16,8).value()
$WriteIOPS = $WkSheet.Cells.Item(16,9).value()
$Debit = $WkSheet.Cells.Item(16,10).value()
$DebitLecture = $WkSheet.Cells.Item(16,11).value() 
$DebitEcriture = $WkSheet.Cells.Item(16,12).value()
$Latence = $WkSheet.Cells.Item(16,18).value()
$LatenceRead = $WkSheet.Cells.Item(16,19).value()
$LatenceWrite = $WkSheet.Cells.Item(16,20).value()

$line | Add-Member -MemberType NoteProperty -name "NomTest" -Value $NomTest
$line | Add-Member -MemberType NoteProperty -name "DateTest" -Value $DateTest
$line | Add-Member -MemberType NoteProperty -name "VM" -Value $VM
$line | Add-Member -MemberType NoteProperty -name "TypeTest" -Value $TypeTest
$line | Add-Member -MemberType NoteProperty -name "IOPS" -Value $IOPS
$line | Add-Member -MemberType NoteProperty -name "ReadIOPS" -Value $ReadIOPS
$line | Add-Member -MemberType NoteProperty -name "WriteIOPS" -Value $WriteIOPS
$line | Add-Member -MemberType NoteProperty -name "Debit (Mips)" -Value $Debit
$line | Add-Member -MemberType NoteProperty -name "DebitLecture (MiBps)" -Value $DebitLecture
$line | Add-Member -MemberType NoteProperty -name "DebitEcriture (MiBps)" -Value $DebitEcriture
$line | Add-Member -MemberType NoteProperty -name "Latence (ms)" -Value $Latence
$line | Add-Member -MemberType NoteProperty -name "LatenceRead (ms)" -Value $LatenceRead
$line | Add-Member -MemberType NoteProperty -name "LatenceWrite (ms)" -Value $LatenceWrite

Write-Host "TRAITEMENTXLS : check de la ligne à injecter : " + $line -ForegroundColor Green 
$global:result += $line 

}

Function AFFICHERTABL($array)
{

<# 
    AFFICHERTABL => permet de vérifier le contenu du tableau

        copie la case A9 (type de traitement) 
        copie la case A6 (date de démarrage)
        ajoute 2 colonnes avant $A,
        copie la valeur de la case A9 dans A16
        copie la valeur de la case B9 dans B16
#>


	for ($i=0;$i -lt $array.Length;$i++)
	{
		Write-Output "boucle N°: $i"
		Write-Output $array[$i]			
		Write-Output "--------"
	}
}

Function FILENAME
{
param (
    [string]$name
)
Write-Host "FUNCTION FILENAME : name" $name -ForegroundColor Green
$excelname = split-path $name -Leaf
Write-Host "FUNCTION FILENAME : excelname" $excelname -ForegroundColor Green
$index=$excelname.LastIndexOf(".")
$index=$index+1  
$sheetname=$excelname.substring(0,$index-1)
Write-Host "FUNCTION FILENAME : sheetname" $sheetname -ForegroundColor Green
return $sheetname
}

############INITIALISATION DES VARIABLES###############
<#
$FilePath
$Wkbprocessed
$excel
$workbook
$wkbname
$tableXLS
$tableWkSheet
$tabletitle
$i= numéro du worksheet
Wkbresult
#>
Clear
$global:result = @()
$i=0

############CORPS DU SCRIPT###############
<#
instancie le fichier XLS correspondant à la VM analysée,
ouvre le fichier,
pour chaque worksheet,
    appelle la fonction XlsTraitement
ferme le fichier excel
Ouvre le fichier ALL.xlsx
injecte le tableau généré précédemment
Ferme le fichier excel
#>

# instancie le fichier XLS et l'ouvre
$excel = New-Object -ComObject excel.application
$excel.Visible=$true
$excel.DisplayAlerts = $False
$workbook=$excel.Workbooks.Open($FilePath)
$SheetsCount = $workbook.worksheets.count

Write-Host "mainscript : FilePath : " $FilePath -ForegroundColor Yellow
Write-Host "mainscript : Wkbprocessed : " $Wkbprocessed -ForegroundColor Yellow
Write-Host "mainscript : Wkbresult : " $Wkbresult -ForegroundColor Yellow

# instancie les worksheet et appelle le traitement du worksheet
foreach ($WkSheet in $Workbook.Worksheets) 
{ 
    $i++
    Write-Host "MAINSCRIPT : feuille " $i " nommée :" $WkSheet.name -ForegroundColor yellow
    if ($WkSheet.name -notlike 'Sheet*')
    {
       TRAITEMENTXLS
# Write-Host "mainscript : TRAITEMENTXLS desactive" -ForegroundColor Yellow
    }

} 

# retrouve le nom et sauve le XLS dans le bon rep une fois traité.
$wkbname = $Wkbprocessed + "\" + $workbook.name
$Workbook.SaveAs($wkbname,51)
$excel.Quit()

$excel = New-Object -ComObject excel.application
$excel.Visible=$true
$excel.DisplayAlerts = $False
$workbook=$excel.Workbooks.Open($Wkbresult)
$Sheetname = filename $FilePath
$WkSheet = $workbook.worksheets.add()
$WkSheet.Select()
$WkSheet.name=$SheetName
Write-Host "mainscript : sheetname" $sheetname -ForegroundColor Yellow
Write-Host "mainscript : WkSheet" $WkSheet.Name -ForegroundColor Yellow

$TempCsv=$Wkbprocessed + "\" + $Sheetname+ ".csv" 
Write-Host "mainscript : TempCsv" $TempCsv -ForegroundColor Yellow
Write-Host "Main Script : test de contenu FINAL " $global:result -ForegroundColor yellow
$global:result | export-csv $TempCsv -Delimiter `t -NoTypeInformation 
get-content $TempCsv | clip

[void]$WkSheet.cells.Item(1).PasteSpecial()

$Workbook.Save()
$excel.Quit()
