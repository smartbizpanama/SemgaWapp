@echo off
setlocal enabledelayedexpansion

REM Configuración
set "SERVIDOR=GIL-MAIN-PC\MSSQLSERVER01"
set "BASE_DATOS=SegmaDB"
set "USUARIO_BD=wappuser"
set "PASSWORD_BD=gilberto"
set "RUTA_RESPALDOS=D:\CoopBackup"
set "DESCRIPCION=Respaldo automatico programado"
set "LOG_FILE=%RUTA_RESPALDOS%\backup_log.txt"

REM IMPORTANTE: Cambiar por el ID de usuario correcto de tu sistema
set "USUARIO_GENERA=0"

REM Crear directorio si no existe
if not exist "%RUTA_RESPALDOS%" mkdir "%RUTA_RESPALDOS%"

REM Obtener fecha formateada
for /f "delims=" %%i in ('powershell -Command "Get-Date -Format 'yyyyMMdd_HHmmss'"') do set "FECHA_FORMATEADA=%%i"

set "NOMBRE_RESPALDO_AUTOMATICO=Respaldo_%FECHA_FORMATEADA%"
set "NOMBRE_ARCHIVO=%NOMBRE_RESPALDO_AUTOMATICO%.bak"
set "RUTA_COMPLETA=%RUTA_RESPALDOS%\%NOMBRE_ARCHIVO%"

REM Log inicial
echo [%date% %time%] Iniciando proceso completo de respaldo >> "%LOG_FILE%"
echo [%date% %time%] Base de datos: %BASE_DATOS% >> "%LOG_FILE%"
echo [%date% %time%] Archivo: %NOMBRE_ARCHIVO% >> "%LOG_FILE%"

REM --- PASO 1: CREAR RESPALDO FÍSICO ---
set "COMANDO_BACKUP=BACKUP DATABASE [%BASE_DATOS%] TO DISK = '%RUTA_COMPLETA%' WITH FORMAT, INIT, NAME = '%NOMBRE_RESPALDO_AUTOMATICO%', DESCRIPTION = '%DESCRIPCION%'"

echo [%date% %time%] Ejecutando BACKUP físico... >> "%LOG_FILE%"
sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -Q "%COMANDO_BACKUP%"

if errorlevel 1 (
    echo [%date% %time%] ERROR CRITICO: Respaldo físico falló. Código: %errorlevel% >> "%LOG_FILE%"
    echo ERROR: El respaldo físico falló
    exit /b 1
)

REM Verificar archivo físico
timeout /t 5 /nobreak >nul
if not exist "%RUTA_COMPLETA%" (
    echo [%date% %time%] ERROR CRITICO: Archivo físico no creado >> "%LOG_FILE%"
    echo ERROR: Archivo de respaldo no creado
    exit /b 1
)

REM Obtener tamaño
for %%F in ("%RUTA_COMPLETA%") do set "TAMAÑO_ARCHIVO=%%~zF"

if %TAMAÑO_ARCHIVO% equ 0 (
    echo [%date% %time%] ERROR CRITICO: Archivo físico está vacío >> "%LOG_FILE%"
    echo ERROR: Archivo de respaldo está vacío
    exit /b 1
)

echo [%date% %time%] BACKUP físico EXITOSO >> "%LOG_FILE%"
echo [%date% %time%] Ruta: %RUTA_COMPLETA% >> "%LOG_FILE%"
echo [%date% %time%] Tamaño: %TAMAÑO_ARCHIVO% bytes >> "%LOG_FILE%"

REM --- PASO 2: REGISTRAR EN BASE DE DATOS ---
echo [%date% %time%] Registrando respaldo en base de datos... >> "%LOG_FILE%"

REM Mostrar los parámetros que se enviarán
echo [%date% %time%] Parámetros para INSERT: >> "%LOG_FILE%"
echo [%date% %time%]   UsuarioGenera: %USUARIO_GENERA% >> "%LOG_FILE%"
echo [%date% %time%]   NombreRespaldo: %NOMBRE_RESPALDO_AUTOMATICO% >> "%LOG_FILE%"
echo [%date% %time%]   Descripcion: %DESCRIPCION% >> "%LOG_FILE%"
echo [%date% %time%]   Ruta: %RUTA_COMPLETA% >> "%LOG_FILE%"
echo [%date% %time%]   Size: %TAMAÑO_ARCHIVO% >> "%LOG_FILE%"

REM Opción 1: Ejecutar con salida detallada
echo [%date% %time%] Ejecutando stored procedure... >> "%LOG_FILE%"
set "COMANDO_INSERT=EXEC spRespaldos_Guardar @UsuarioGenera=%USUARIO_GENERA%, @NombreRespaldo='%NOMBRE_RESPALDO_AUTOMATICO%', @Descripcion='%DESCRIPCION%', @Ruta='%RUTA_COMPLETA%', @Size=%TAMAÑO_ARCHIVO%"

REM Ejecutar y capturar salida
sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" -Q "%COMANDO_INSERT%" -o "%RUTA_RESPALDOS%\insert_result.txt"

if errorlevel 1 (
    echo [%date% %time%] ERROR: Fallo al ejecutar stored procedure. Código: %errorlevel% >> "%LOG_FILE%"
    echo [%date% %time%] Ver archivo: %RUTA_RESPALDOS%\insert_result.txt para detalles >> "%LOG_FILE%"
    type "%RUTA_RESPALDOS%\insert_result.txt" >> "%LOG_FILE%"
    echo ADVERTENCIA: Respaldo físico creado pero no se registró en BD
    exit /b 2
)

REM Verificar si hay mensajes de error en el resultado
if exist "%RUTA_RESPALDOS%\insert_result.txt" (
    echo [%date% %time%] Resultado del INSERT: >> "%LOG_FILE%"
    type "%RUTA_RESPALDOS%\insert_result.txt" >> "%LOG_FILE%"
    
    findstr /i "error" "%RUTA_RESPALDOS%\insert_result.txt" >nul
    if not errorlevel 1 (
        echo [%date% %time%] SE ENCONTRARON ERRORES en el resultado >> "%LOG_FILE%"
        exit /b 2
    )
)

echo [%date% %time%] Stored procedure ejecutado aparentemente sin errores >> "%LOG_FILE%"

REM --- VERIFICAR QUE REALMENTE SE INSERTÓ ---
echo [%date% %time%] Verificando insersión en la tabla... >> "%LOG_FILE%"
set "COMANDO_VERIFICAR=SELECT COUNT(*) AS Total FROM Respaldos WHERE NombreRespaldo = '%NOMBRE_RESPALDO_AUTOMATICO%' AND Ruta = '%RUTA_COMPLETA%'"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" -Q "%COMANDO_VERIFICAR%" -h -1 -W -o "%RUTA_RESPALDOS%\verify_result.txt"

set "REGISTRO_ENCONTRADO=0"
for /f "delims=" %%i in ('type "%RUTA_RESPALDOS%\verify_result.txt"') do set "REGISTRO_ENCONTRADO=%%i"

echo [%date% %time%] Registros encontrados: !REGISTRO_ENCONTRADO! >> "%LOG_FILE%"

if "!REGISTRO_ENCONTRADO!"=="0" (
    echo [%date% %time%] ERROR: No se encontró el registro insertado >> "%LOG_FILE%"
    echo ERROR: El registro no se insertó en la tabla
    exit /b 2
)

echo [%date% %time%] Registro verificado exitosamente en la tabla >> "%LOG_FILE%"

REM Limpiar archivos temporales
del "%RUTA_RESPALDOS%\insert_result.txt" >nul 2>&1
del "%RUTA_RESPALDOS%\verify_result.txt" >nul 2>&1

REM --- ÉXITO COMPLETO ---
echo [%date% %time%] PROCESO COMPLETADO EXITOSAMENTE >> "%LOG_FILE%"
echo.
echo ========================================
echo RESpaldo COMPLETADO EXITOSAMENTE
echo ========================================
echo Archivo: %RUTA_COMPLETA%
echo Tamaño: %TAMAÑO_ARCHIVO% bytes
echo Registrado en BD: SI
echo ========================================

exit /b 0