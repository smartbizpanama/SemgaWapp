@echo off
setlocal enabledelayedexpansion

REM =============================================
REM CONFIGURACIÓN
REM =============================================
set "SERVIDOR=GIL-MAIN-PC\MSSQLSERVER01"
set "BASE_DATOS=SegmaDB"
set "USUARIO_BD=wappuser"
set "PASSWORD_BD=gilberto"

REM Ruta donde está el BAT
set "RUTA_BAT=%~dp0"

REM Archivo de log
set "LOG_FILE=%RUTA_BAT%cierres_mensuales_log.txt"

REM =============================================
REM ESCRIBIR INICIO
REM =============================================
echo ========================================================= >> "%LOG_FILE%"
echo [%date% %time%] INICIO DE PROCESO >> "%LOG_FILE%"
echo Ejecutando sp_sys_HST_GenerarHistorialMensual... >> "%LOG_FILE%"
echo --------------------------------------------------------- >> "%LOG_FILE%"

echo Ejecutando SP...

REM =============================================
REM EJECUTAR SP
REM =============================================
sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" -b ^
-Q "EXEC sp_sys_HST_GenerarHistorialMensual;"

IF errorlevel 1 (
    echo [%date% %time%] ERROR: Falló la ejecución del SP >> "%LOG_FILE%"
    echo --------------------------------------------------------- >> "%LOG_FILE%"
    echo ERROR en la ejecución del SP.
    exit /b 1
)

REM =============================================
REM FIN DEL PROCESO
REM =============================================
echo [%date% %time%] SP ejecutado correctamente >> "%LOG_FILE%"
echo [%date% %time%] FIN DEL PROCESO >> "%LOG_FILE%"
echo --------------------------------------------------------- >> "%LOG_FILE%"

echo.
echo ===========================================
echo     SP EJECUTADO CORRECTAMENTE
echo ===========================================
echo L
