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
echo [%date% %time%] INICIO DE PROCESO >> "%LOG_FILE%"
echo --------------------------------------------------------- >> "%LOG_FILE%"

REM =============================================
REM PRIMER SP
REM =============================================
echo Ejecutando spAuxiliares_CalcularIntereses... >> "%LOG_FILE%"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" -b -h -1 ^
-Q "DECLARE @msg VARCHAR(MAX);
    EXEC dbo.spAuxiliares_CalcularIntereses 
        @ReturnMessage = @msg OUTPUT;
    SELECT ISNULL(@msg,'');" > "%RUTA_BAT%_resultado1.txt"

set /p RESULTADO1=<"%RUTA_BAT%_resultado1.txt"

if not "%RESULTADO1%"=="" (
    echo [%date% %time%] ERROR en spAuxiliares_CalcularIntereses: %RESULTADO1% >> "%LOG_FILE%"
    echo ERROR: %RESULTADO1%
    exit /b 1
)

echo [%date% %time%] spAuxiliares_CalcularIntereses ejecutado correctamente >> "%LOG_FILE%"
echo --------------------------------------------------------- >> "%LOG_FILE%"

REM =============================================
REM SEGUNDO SP
REM =============================================
echo Ejecutando spAuxiliares_CalcularInteresesAhorro... >> "%LOG_FILE%"

sqlcmd -S "%SERVIDOR%" -U "%USUARIO_BD%" -P "%PASSWORD_BD%" -d "%BASE_DATOS%" -b -h -1 ^
-Q "DECLARE @msg VARCHAR(MAX);
    EXEC dbo.spAuxiliares_CalcularInteresesAhorro 
        @ReturnMessage = @msg OUTPUT;
    SELECT ISNULL(@msg,'');" > "%RUTA_BAT%_resultado2.txt"

set /p RESULTADO2=<"%RUTA_BAT%_resultado2.txt"

if not "%RESULTADO2%"=="" (
    echo [%date% %time%] ERROR en spAuxiliares_CalcularInteresesAhorro: %RESULTADO2% >> "%LOG_FILE%"
    echo ERROR: %RESULTADO2%
    exit /b 1
)

echo [%date% %time%] spAuxiliares_CalcularInteresesAhorro ejecutado correctamente >> "%LOG_FILE%"
echo --------------------------------------------------------- >> "%LOG_FILE%"

REM =============================================
REM FIN DEL PROCESO
REM =============================================
echo [%date% %time%] FIN DEL PROCESO >> "%LOG_FILE%"
echo ========================================================= >> "%LOG_FILE%"

echo.
echo ===========================================
echo   AMBOS SP EJECUTADOS CORRECTAMENTE
echo ===========================================