@echo off
setlocal enabledelayedexpansion

REM Configuración
set "SERVIDOR=GIL-MAIN-PC\MSSQLSERVER01"
set "BASE_DATOS=SegmaDB"
set "USUARIO_BD=wappuser"
set "PASSWORD_BD=gilberto"
set "DESCRIPCION=Respaldo automatico programado"
set "USUARIO_GENERA=0"

REM --- PASO 0: OBTENER RUTA DESDE BASE DE DATOS ---
echo [%date% %time%] Obteniendo ruta de respaldo desde base de datos...

set "COMANDO_RUTA=SELECT ParamValue FROM [tbParamsKeys] WHERE ParamKey='BACKUP_DIR'"

REM Ejecutar consulta y guardar resultado - FORZAR SOLO UNA LÍNEA DE SALIDA
sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" -Q "%COMANDO_RUTA%" -h -1 -W -s "|" -o "%TEMP%\ruta_temp.txt"

if errorlevel 1 (
    echo [%date% %time%] ERROR: No se pudo obtener la ruta desde BD. Código: %errorlevel%
    echo ERROR: No se pudo obtener la ruta de respaldo desde la base de datos
    exit /b 1
)

REM Leer SOLO la primera línea que contiene la ruta
set "RUTA_RESPALDOS="
for /f "usebackq tokens=1 delims=" %%i in ("%TEMP%\ruta_temp.txt") do (
    if not defined RUTA_RESPALDOS set "RUTA_RESPALDOS=%%i"
    goto :ruta_leida
)

:ruta_leida

REM Limpiar archivo temporal
del "%TEMP%\ruta_temp.txt" >nul 2>&1

REM Validar que se obtuvo una ruta válida
if "!RUTA_RESPALDOS!"=="" (
    echo ERROR: No se encontró la ruta BACKUP_DIR en tbParamsKeys
    exit /b 1
)

REM Limpiar posibles espacios en blanco
set "RUTA_RESPALDOS=!RUTA_RESPALDOS: =!"

echo Ruta obtenida de BD: '!RUTA_RESPALDOS!'

REM --- VALIDAR Y AJUSTAR BARRA INVERTIDA AL FINAL ---
REM Verificar si la ruta termina con \
if "!RUTA_RESPALDOS:~-1!"=="\" (
    echo Ruta ya tiene barra invertida al final
) else (
    echo Agregando barra invertida al final de la ruta
    set "RUTA_RESPALDOS=!RUTA_RESPALDOS!\"
)

echo Ruta final a usar: '!RUTA_RESPALDOS!'

REM Crear directorio si no existe
if not exist "!RUTA_RESPALDOS!" (
    echo Creando directorio: !RUTA_RESPALDOS!
    mkdir "!RUTA_RESPALDOS!"
    if errorlevel 1 (
        echo ERROR: No se pudo crear el directorio
        exit /b 1
    )
)

REM Configurar archivo de log en la ruta de respaldo
set "LOG_FILE=!RUTA_RESPALDOS!backup_log.txt"

REM Log inicial
echo [%date% %time%] Iniciando proceso completo de respaldo >> "!LOG_FILE!"
echo [%date% %time%] Base de datos: %BASE_DATOS% >> "!LOG_FILE!"
echo [%date% %time%] Ruta configurada: !RUTA_RESPALDOS! >> "!LOG_FILE!"

REM Obtener fecha formateada
for /f "delims=" %%i in ('powershell -Command "Get-Date -Format 'yyyyMMdd_HHmmss'"') do set "FECHA_FORMATEADA=%%i"

set "NOMBRE_RESPALDO_AUTOMATICO=Respaldo_!FECHA_FORMATEADA!"
set "NOMBRE_ARCHIVO=!NOMBRE_RESPALDO_AUTOMATICO!.bak"
set "RUTA_COMPLETA=!RUTA_RESPALDOS!!NOMBRE_ARCHIVO!"

echo [%date% %time%] Archivo: !NOMBRE_ARCHIVO! >> "!LOG_FILE!"

REM --- PASO 1: CREAR RESPALDO FÍSICO ---
set "COMANDO_BACKUP=BACKUP DATABASE [%BASE_DATOS%] TO DISK = '!RUTA_COMPLETA!' WITH FORMAT, INIT, NAME = '!NOMBRE_RESPALDO_AUTOMATICO!', DESCRIPTION = '%DESCRIPCION%'"

echo [%date% %time%] Ejecutando BACKUP físico... >> "!LOG_FILE!"
echo [%date% %time%] Comando: !COMANDO_BACKUP! >> "!LOG_FILE!"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -Q "!COMANDO_BACKUP!"

if errorlevel 1 (
    echo [%date% %time%] ERROR CRITICO: Respaldo físico falló. Código: %errorlevel% >> "!LOG_FILE!"
    echo ERROR: El respaldo físico falló
    exit /b 1
)

REM Verificar archivo físico
timeout /t 5 /nobreak >nul
if not exist "!RUTA_COMPLETA!" (
    echo [%date% %time%] ERROR CRITICO: Archivo físico no creado >> "!LOG_FILE!"
    echo ERROR: Archivo de respaldo no creado
    exit /b 1
)

REM Obtener tamaño
for %%F in ("!RUTA_COMPLETA!") do set "TAMAÑO_ARCHIVO=%%~zF"

if !TAMAÑO_ARCHIVO! equ 0 (
    echo [%date% %time%] ERROR CRITICO: Archivo físico está vacío >> "!LOG_FILE!"
    echo ERROR: Archivo de respaldo está vacío
    exit /b 1
)

echo [%date% %time%] BACKUP físico EXITOSO >> "!LOG_FILE!"
echo [%date% %time%] Ruta: !RUTA_COMPLETA! >> "!LOG_FILE!"
echo [%date% %time%] Tamaño: !TAMAÑO_ARCHIVO! bytes >> "!LOG_FILE!"

REM --- PASO 2: REGISTRAR EN BASE DE DATOS ---
echo [%date% %time%] Registrando respaldo en base de datos... >> "!LOG_FILE!"

set "COMANDO_INSERT=EXEC spRespaldos_Guardar @UsuarioGenera=%USUARIO_GENERA%, @NombreRespaldo='!NOMBRE_RESPALDO_AUTOMATICO!', @Descripcion='%DESCRIPCION%', @Ruta='!RUTA_COMPLETA!', @Size=!TAMAÑO_ARCHIVO!"

REM Ejecutar y capturar salida
sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" -Q "!COMANDO_INSERT!" -o "!RUTA_RESPALDOS!insert_result.txt"

if errorlevel 1 (
    echo [%date% %time%] ERROR: Fallo al ejecutar stored procedure. Código: %errorlevel% >> "!LOG_FILE!"
    echo [%date% %time%] Ver archivo: !RUTA_RESPALDOS!insert_result.txt para detalles >> "!LOG_FILE!"
    type "!RUTA_RESPALDOS!insert_result.txt" >> "!LOG_FILE!"
    echo ADVERTENCIA: Respaldo físico creado pero no se registró en BD
    exit /b 2
)

REM Verificar si hay mensajes de error en el resultado
if exist "!RUTA_RESPALDOS!insert_result.txt" (
    findstr /i "error" "!RUTA_RESPALDOS!insert_result.txt" >nul
    if not errorlevel 1 (
        echo [%date% %time%] SE ENCONTRARON ERRORES en el resultado >> "!LOG_FILE!"
        type "!RUTA_RESPALDOS!insert_result.txt" >> "!LOG_FILE!"
        exit /b 2
    )
    del "!RUTA_RESPALDOS!insert_result.txt" >nul 2>&1
)

echo [%date% %time%] Stored procedure ejecutado exitosamente >> "!LOG_FILE!"

REM --- VERIFICAR QUE REALMENTE SE INSERTÓ ---
echo [%date% %time%] Verificando insersión en la tabla... >> "!LOG_FILE!"
set "COMANDO_VERIFICAR=SELECT COUNT(*) AS Total FROM Respaldos WHERE NombreRespaldo = '!NOMBRE_RESPALDO_AUTOMATICO!' AND Ruta = '!RUTA_COMPLETA!'"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" -Q "!COMANDO_VERIFICAR!" -h -1 -W -o "!RUTA_RESPALDOS!verify_result.txt"

set "REGISTRO_ENCONTRADO=0"
for /f "usebackq delims=" %%i in ("!RUTA_RESPALDOS!verify_result.txt") do (
    set "REGISTRO_ENCONTRADO=%%i"
    goto :verificacion_completa
)

:verificacion_completa

echo [%date% %time%] Registros encontrados: !REGISTRO_ENCONTRADO! >> "!LOG_FILE!"

if "!REGISTRO_ENCONTRADO!"=="0" (
    echo [%date% %time%] ERROR: No se encontró el registro insertado >> "!LOG_FILE!"
    echo ERROR: El registro no se insertó en la tabla
    exit /b 2
)

echo [%date% %time%] Registro verificado exitosamente en la tabla >> "!LOG_FILE!"

REM Limpiar archivos temporales
del "!RUTA_RESPALDOS!verify_result.txt" >nul 2>&1

REM --- ÉXITO COMPLETO ---
echo [%date% %time%] PROCESO COMPLETADO EXITOSAMENTE >> "!LOG_FILE!"
echo.
echo ========================================
echo RESpaldo COMPLETADO EXITOSAMENTE
echo ========================================
echo Archivo: !RUTA_COMPLETA!
echo Tamaño: !TAMAÑO_ARCHIVO! bytes
echo Registrado en BD: SI
echo Ruta desde BD: !RUTA_RESPALDOS!
echo ========================================

exit /b 0