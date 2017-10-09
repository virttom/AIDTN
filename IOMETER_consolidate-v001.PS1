##### PARAMETRES & DEFINITION DE VARIABLES GLOBALES
param (
[string]$srcfolder="C:\Users\S0056500\Desktop\MyDEV\PERFTEST\io5",
[string]$wkbfolder="C:\Users\S0056500\Desktop\MyDEV\PERFTEST\io5"
)

<# 
.SYNOPSIS Utilisé dans le cas d'un traitement IOMETER sur plusieurs VMs.
.DESCRIPTION nécessite d'avoir préalablement copié tous les fichier généré par un iometer dans un repertoire (en général, 1 par IOMETER).
.DESCRIPTION Génère ensuite un XLS qui va intégrer tous les fichiers CSV (1 par onglet). 
.DESCRIPTION Enfin le fichier est copié dans preprocessed
.NOTES Author: Thomas CHARLES 
.PARAMETER FilePath = nom (+ chemin du fichier XLSX dont on extrait les données
.PARAMETER Wkbfolder = le repertoire contenant les fichiers apres traitement   
.EXAMPLE .\IOmeter_consolidate-v001.ps1 C:\Users\S0056500\Desktop\MyDEV\PERFTEST\io5 C:\Users\S0056500\Desktop\MyDEV\PERFTEST\preprocessed

$srcfolder      => le repertoire contenant les fichiers à scanner
$wkbfolder      => le folder ou sera mis le xls. Par défaut eq srcfolder 
$ext            => paramètre du type de fichier à chercher, ici CSV
$colfiles       => collection contenant l'ensemble des fichiers d'un répertoire
$file           => le fichier de la collection en cours de manipulation 
$i              => index du fichier parmis la collection de fichiers = numéro du worksheet du xls
$workbook       => l'objet workbook de excel
$excel          => l'objet permettant l'instanciation du workbook dans excel
$wkbname        => le nom du fichier excel
$FileName       => le chemin (+nom) du fichier à traiter en batch
$FileShortName  => le nom (seul) du fichier à traiter en batch
$FileExt        => l'extension du fichier à traiter en batch
#>

##### INIT des VARIABLES
$ext=".csv"
$colfiles ="vide"
$file = "vide"
$workbook = "vide"
$excel="vide"
$FileName="vide"
$FileShortName="vide"
$FileExt = "vide"
$i=0
$index=0
$worksheet


<# FONCTIONS
ImportToExcel   => importe le fichier dans excel        
#>


function ImportToExcel ($filename,$FileShortName)
{
write-host "Function ImportExcel:Receiving parameters $filename as filename and $FileShortName as shortname"  -ForegroundColor cyan
write-host "Function ImportExcel:Working with file $filename"  -ForegroundColor Green
#Define locations and delimiter

#$wkbname=$folder + ".xlsx"
$sheetname=$FileShortName
$delimiter=","


$worksheet = $workbook.worksheets.add()
#$worksheet = $workbook.worksheets.Item($i)
$worksheet.name=$FileShortName

# Build the QueryTables.Add command and reformat the data
$TxtConnector = ("TEXT;" + $filename)


#$worksheet.range("A1")=$sheetname

$Connector = $worksheet.QueryTables.add($TxtConnector,$worksheet.Range("A1"))
$query = $worksheet.QueryTables.item($Connector.name)
$query.TextFileOtherDelimiter = $delimiter
$query.TextFileParseType  = 1
$query.TextFileColumnDataTypes = ,1 * $worksheet.Cells.Columns.Count
$query.AdjustColumnWidth = 1

# Execute & delete the import query
$query.Refresh()
$query.Delete()
}




<# CORPS DU SCRIPT 
initialisation du fichier excel en fonction des paramètres
pour chaque fichier dans le repertoire à scanner,
    récupère le nom,
    créée un onglet dans le fichier xls
    appelle l'import excel
finalisation du fichier excel. 
#>

$excel = New-Object -ComObject excel.application 
$excel.Visible=$true
$excel.DisplayAlerts = $False
$workbook=$excel.Workbooks.add(1)

$colfiles=@(get-ChildItem $srcfolder -file)
foreach($file in $colfiles)
{  
    $FileName=$file.fullname
    $FileExt=$file.Extension
    $FileShortName=$file.basename
    if($FileExt -eq $ext)
    {
        write-host "Main Script : $FileName et $FileShortName" -ForegroundColor yellow
        $i++         
        ImportToExcel $FileName $FileShortName
    }

}
$index=$srcfolder.LastIndexOf("\")
$index=$index+1  
$excelname=$srcfolder.substring($index,$srcfolder.Length-$index)
$excelname = $excelname + ".xlsx"
$wkbname = $wkbfolder +"\"+ $excelname


# Save & close the Workbook as XLSX.
$Workbook.SaveAs($wkbname,51)
$excel.Quit()
