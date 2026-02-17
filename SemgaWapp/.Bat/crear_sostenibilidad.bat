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
set "LOG_FILE=%RUTA_BAT%crear_sostenibilida_log.txt"

echo ========================================================= >> "%LOG_FILE%"
echo [%date% %time%] INICIO DE PROCESO DE SOSTENIBILIDAD >> "%LOG_FILE%"
echo --------------------------------------------------------- >> "%LOG_FILE%"

REM =============================================
REM SP DE SOSTENIBILIDAD
REM =============================================
echo Ejecutando spBatSocios_CalcularSostenibilidad... >> "%LOG_FILE%"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" -b -h -1 ^
-Q "DECLARE @msg VARCHAR(MAX);
    EXEC dbo.spBatSocios_CalcularSostenibilidad
        @UsuarioID = 0,
        @ReturnMessage = @msg OUTPUT;
    SELECT ISNULL(@msg,'');" > "%RUTA_BAT%_resultado.txt"

set /p RESULTADO=<"%RUTA_BAT%_resultado.txt"

if not "%RESULTADO%"=="" (
    echo [%date% %time%] ERROR en spBatSocios_CalcularSostenibilidad: %RESULTADO% >> "%LOG_FILE%"
    echo ERROR: %RESULTADO%
    exit /b 1
)

echo [%date% %time%] spBatSocios_CalcularSostenibilidad ejecutado correctamente >> "%LOG_FILE%"
echo --------------------------------------------------------- >> "%LOG_FILE%"

REM =============================================
REM FIN DEL PROCESO
REM =============================================
echo [%date% %time%] FIN DEL PROCESO DE SOSTENIBILIDAD >> "%LOG_FILE%"
echo ========================================================= >> "%LOG_FILE%"

echo.
echo ===========================================
echo   SOSTENIBILIDAD CALCULADA CORRECTAMENTE
echo ===========================================