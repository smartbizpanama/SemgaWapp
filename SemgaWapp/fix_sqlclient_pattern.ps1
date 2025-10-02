# Script para corregir el patrón SBSqlClientInterface en Mantenimientos.aspx.vb

$filePath = "Forms/Mantenimientos/Mantenimientos.aspx.vb"
$content = Get-Content $filePath -Raw

# Patrón para encontrar métodos que necesitan corrección
$pattern = '(\s+)(Try\s*\r?\n\s+)(ModGlobal\.EscribirLog.*?\r?\n\s+)(Dim objSql As SBSqlClientInterface = GetDbaObject\(HttpContext\.Current\.Session\(VariablesSesion\.ConnectionString\)\))'

# Reemplazar con el patrón correcto
$replacement = '$1Dim objSql As SBSqlClientInterface = Nothing$2$3objSql = GetDbaObject(HttpContext.Current.Session(VariablesSesion.ConnectionString))'

$content = $content -replace $pattern, $replacement

# Agregar Finally blocks donde no existan
$tryPattern = '(\s+)(Try\s*\r?\n.*?)(\s+)(Catch ex As Exception.*?\r?\n.*?\r?\n\s+)(End Try)'
$finallyReplacement = '$1$2$3$4$3Finally$3If objSql IsNot Nothing Then$3objSql.Close()$3End If$3End Try'

$content = $content -replace $tryPattern, $finallyReplacement

# Guardar el archivo
Set-Content $filePath $content -Encoding UTF8

Write-Host "Archivo corregido exitosamente"

