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
set "LOG_FILE=%RUTA_BAT%calculo_intereses_log.txt"

echo ========================================================= >> "%LOG_FILE%"
echo [%date% %time%] INICIO DE PROCESO DE INTERESES >> "%LOG_FILE%"
echo --------------------------------------------------------- >> "%LOG_FILE%"

REM =============================================
REM PRIMER SP - Intereses PR
REM =============================================
echo Ejecutando spBatAuxiliares_CalcularInteresesPR... >> "%LOG_FILE%"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" -b -h -1 ^
-Q "DECLARE @msg VARCHAR(MAX);
    EXEC dbo.spBatAuxiliares_CalcularInteresesPR
        @ReturnMessage = @msg OUTPUT;
    SELECT ISNULL(@msg,'');" > "%RUTA_BAT%_resultado.txt"

set /p RESULTADO1=<"%RUTA_BAT%_resultado.txt"

if not "%RESULTADO1%"=="" (
    echo [%date% %time%] ERROR en spBatAuxiliares_CalcularInteresesPR: %RESULTADO1% >> "%LOG_FILE%"
    echo ERROR: %RESULTADO1%
    exit /b 1
)

echo [%date% %time%] spBatAuxiliares_CalcularInteresesPR ejecutado correctamente >> "%LOG_FILE%"
echo --------------------------------------------------------- >> "%LOG_FILE%"

REM =============================================
REM SEGUNDO SP - Intereses Ahorro
REM =============================================
echo Ejecutando spBatAuxiliares_CalcularInteresesAhorro... >> "%LOG_FILE%"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" -b -h -1 ^
-Q "DECLARE @msg VARCHAR(MAX);
    EXEC dbo.spBatAuxiliares_CalcularInteresesAhorro 
        @ReturnMessage = @msg OUTPUT;
    SELECT ISNULL(@msg,'');" > "%RUTA_BAT%_resultado.txt"

set /p RESULTADO2=<"%RUTA_BAT%_resultado.txt"

if not "%RESULTADO2%"=="" (
    echo [%date% %time%] ERROR en spBatAuxiliares_CalcularInteresesAhorro: %RESULTADO2% >> "%LOG_FILE%"
    echo ERROR: %RESULTADO2%
    exit /b 1
)

echo [%date% %time%] spBatAuxiliares_CalcularInteresesAhorro ejecutado correctamente >> "%LOG_FILE%"
echo --------------------------------------------------------- >> "%LOG_FILE%"

REM =============================================
REM FIN DEL PROCESO
REM =============================================
echo [%date% %time%] FIN DEL PROCESO DE INTERESES >> "%LOG_FILE%"
echo ========================================================= >> "%LOG_FILE%"

echo.
echo ===========================================
echo   INTERESES CALCULADOS CORRECTAMENTE
echo ===========================================