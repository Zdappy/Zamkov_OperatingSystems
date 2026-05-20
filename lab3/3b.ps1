param(
    [string]$searchString,
    [string]$directory = ".",
    [string]$outputFile = "result.txt"
)

Get-ChildItem -Path $directory -Recurse -Filter "*.txt" | ForEach-Object {
    if (Select-String -Path $_.FullName -Pattern $searchString -Quiet) {
        $_.FullName | Out-File -FilePath $outputFile -Append
        Write-Host $_.FullName
    }
}