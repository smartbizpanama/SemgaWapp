@echo off
setlocal enabledelayedexpansion

REM =========================================================
REM CONFIGURACIÓN
REM =========================================================
set "SERVIDOR=GIL-MAIN-PC\MSSQLSERVER01"
set "BASE_DATOS=SegmaDB"
set "USUARIO_BD=wappuser"
set "PASSWORD_BD=gilberto"
set "DESCRIPCION=Respaldo automatico programado"
set "USUARIO_GENERA=0"

REM =========================================================
REM LOG GENERAL (SE CREA LUEGO DE OBTENER LA RUTA)
REM =========================================================
set "RUTA_LOG_TEMP=%~dp0"
set "LOG_FILE=%RUTA_LOG_TEMP%respaldos_bd_log.txt"

echo ========================================================= >> "%LOG_FILE%"
echo [%date% %time%] INICIO DEL PROCESO DE RESPALDO >> "%LOG_FILE%"
echo --------------------------------------------------------- >> "%LOG_FILE%"

REM =========================================================
REM PASO 0: OBTENER RUTA DESDE BASE DE DATOS
REM =========================================================
echo [%date% %time%] Obteniendo ruta de respaldo desde base de datos... >> "%LOG_FILE%"

set "COMANDO_RUTA=SELECT ParamValue FROM [tbParamsKeys] WHERE ParamKey='BACKUP_DIR'"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" ^
 -Q "%COMANDO_RUTA%" -h -1 -W -s "|" -o "%TEMP%\ruta_temp.txt"

if errorlevel 1 (
    echo [%date% %time%] ERROR: No se pudo obtener la ruta desde BD. Código: %errorlevel% >> "%LOG_FILE%"
    echo ERROR: No se pudo obtener la ruta de respaldo desde la base de datos
    exit /b 1
)

REM Leer primera línea
set "RUTA_RESPALDOS="
for /f "usebackq tokens=1 delims=" %%i in ("%TEMP%\ruta_temp.txt") do (
    if not defined RUTA_RESPALDOS set "RUTA_RESPALDOS=%%i"
    goto :ruta_leida
)

:ruta_leida
del "%TEMP%\ruta_temp.txt" >nul 2>&1

if "!RUTA_RESPALDOS!"=="" (
    echo [%date% %time%] ERROR: No se encontró BACKUP_DIR en tbParamsKeys >> "%LOG_FILE%"
    exit /b 1
)

set "RUTA_RESPALDOS=!RUTA_RESPALDOS: =!"
echo [%date% %time%] Ruta obtenida: !RUTA_RESPALDOS! >> "%LOG_FILE%"

REM Asegurar barra invertida
if not "!RUTA_RESPALDOS:~-1!"=="\" (
    set "RUTA_RESPALDOS=!RUTA_RESPALDOS!\"
)

echo [%date% %time%] Ruta final: !RUTA_RESPALDOS! >> "%LOG_FILE%"

REM Crear directorio si no existe
if not exist "!RUTA_RESPALDOS!" (
    echo [%date% %time%] Creando directorio: !RUTA_RESPALDOS! >> "%LOG_FILE%"
    mkdir "!RUTA_RESPALDOS!"
    if errorlevel 1 (
        echo [%date% %time%] ERROR: No se pudo crear el directorio >> "%LOG_FILE%"
        exit /b 1
    )
)

REM Cambiar log a la ruta final
set "LOG_FILE=!RUTA_RESPALDOS!backup_log.txt"

echo [%date% %time%] Log movido a ruta final >> "%LOG_FILE%"
echo [%date% %time%] Base de datos: %BASE_DATOS% >> "%LOG_FILE%"
echo [%date% %time%] Ruta configurada: !RUTA_RESPALDOS! >> "%LOG_FILE%"

REM =========================================================
REM PASO 1: CREAR RESPALDO FÍSICO
REM =========================================================
for /f "delims=" %%i in ('powershell -Command "Get-Date -Format ''yyyyMMdd_HHmmss''"') do set "FECHA_FORMATEADA=%%i"

set "NOMBRE_RESPALDO_AUTOMATICO=Respaldo_!FECHA_FORMATEADA!"
set "NOMBRE_ARCHIVO=!NOMBRE_RESPALDO_AUTOMATICO!.bak"
set "RUTA_COMPLETA=!RUTA_RESPALDOS!!NOMBRE_ARCHIVO!"

echo [%date% %time%] Archivo: !NOMBRE_ARCHIVO! >> "%LOG_FILE%"

set "COMANDO_BACKUP=BACKUP DATABASE [%BASE_DATOS%] TO DISK = '!RUTA_COMPLETA!' WITH FORMAT, INIT, NAME = '!NOMBRE_RESPALDO_AUTOMATICO!', DESCRIPTION = '%DESCRIPCION%'"

echo [%date% %time%] Ejecutando BACKUP físico... >> "%LOG_FILE%"
echo [%date% %time%] Comando: !COMANDO_BACKUP! >> "%LOG_FILE%"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -Q "!COMANDO_BACKUP!"

if errorlevel 1 (
    echo [%date% %time%] ERROR CRITICO: Respaldo físico falló. Código: %errorlevel% >> "%LOG_FILE%"
    exit /b 1
)

timeout /t 5 /nobreak >nul

if not exist "!RUTA_COMPLETA!" (
    echo [%date% %time%] ERROR CRITICO: Archivo físico no creado >> "%LOG_FILE%"
    exit /b 1
)

for %%F in ("!RUTA_COMPLETA!") do set "TAMAÑO_ARCHIVO=%%~zF"

if !TAMAÑO_ARCHIVO! equ 0 (
    echo [%date% %time%] ERROR CRITICO: Archivo vacío >> "%LOG_FILE%"
    exit /b 1
)

echo [%date% %time%] BACKUP físico EXITOSO >> "%LOG_FILE%"
echo [%date% %time%] Tamaño: !TAMAÑO_ARCHIVO! bytes >> "%LOG_FILE%"

REM =========================================================
REM PASO 2: REGISTRAR EN BASE DE DATOS
REM =========================================================
echo [%date% %time%] Registrando respaldo en BD... >> "%LOG_FILE%"

set "COMANDO_INSERT=EXEC spRespaldos_Guardar @UsuarioGenera=%USUARIO_GENERA%, @NombreRespaldo='!NOMBRE_RESPALDO_AUTOMATICO!', @Descripcion='%DESCRIPCION%', @Ruta='!RUTA_COMPLETA!', @Size=!TAMAÑO_ARCHIVO!"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" ^
 -Q "!COMANDO_INSERT!" -o "!RUTA_RESPALDOS!insert_result.txt"

if errorlevel 1 (
    echo [%date% %time%] ERROR: Fallo al ejecutar SP >> "%LOG_FILE%"
    type "!RUTA_RESPALDOS!insert_result.txt" >> "%LOG_FILE%"
    exit /b 2
)

findstr /i "error" "!RUTA_RESPALDOS!insert_result.txt" >nul
if not errorlevel 1 (
    echo [%date% %time%] ERROR: SP devolvió errores >> "%LOG_FILE%"
    type "!RUTA_RESPALDOS!insert_result.txt" >> "%LOG_FILE%"
    exit /b 2
)

del "!RUTA_RESPALDOS!insert_result.txt" >nul 2>&1

echo [%date% %time%] SP ejecutado exitosamente >> "%LOG_FILE%"

REM =========================================================
REM PASO 3: VERIFICAR INSERCIÓN
REM =========================================================
echo [%date% %time%] Verificando inserción... >> "%LOG_FILE%"

set "COMANDO_VERIFICAR=SELECT COUNT(*) FROM Respaldos WHERE NombreRespaldo='!NOMBRE_RESPALDO_AUTOMATICO!' AND Ruta='!RUTA_COMPLETA!'"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" ^
 -Q "!COMANDO_VERIFICAR!" -h -1 -W -o "!RUTA_RESPALDOS!verify_result.txt"

set "REGISTRO_ENCONTRADO=0"
for /f "usebackq delims=" %%i in ("!RUTA_RESPALDOS!verify_result.txt") do (
    set "REGISTRO_ENCONTRADO=%%i"
    goto :verificacion_completa
)

:verificacion_completa

echo [%date% %time%] Registros encontrados: !REGISTRO_ENCONTRADO! >> "%LOG_FILE%"

if "!REGISTRO_ENCONTRADO!"=="0" (
    echo [%date% %time%] ERROR: Registro no insertado >> "%LOG_FILE%"
    exit /b 2
)

del "!RUTA_RESPALDOS!verify_result.txt" >nul 2>&1

echo [%date% %time%] Registro verificado exitosamente >> "%LOG_FILE%"
echo [%date% %time%] PROCESO COMPLETADO EXITOSAMENTE >> "%LOG_FILE%"
echo ========================================================= >> "%LOG_FILE%"

echo.
echo ========================================
echo RESPALDO COMPLETADO EXITOSAMENTE
echo Archivo: !RUTA_COMPLETA!
echo Tamaño: !TAMAÑO_ARCHIVO! bytes
echo Registrado en BD: SI
echo Ruta desde BD: !RUTA_RESPALDOS!
echo ========================================
exit /b 0