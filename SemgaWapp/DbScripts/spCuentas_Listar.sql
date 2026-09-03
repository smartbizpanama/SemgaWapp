-- ============================================================
-- spCuentas_Listar - SemgaWapp (Cooperativa Coopsemga)
-- Lista cuentas contables con filtros opcionales por grupo,
-- código (Cuenta) y nombre (descripción), con ordenamiento
-- dinámico y seguro por columna/dirección.
--
-- @OrderBy admite: 'ID', 'Cuenta', 'Nombre', 'Grupo', 'Imputable', 'Saldo'
-- @OrderDir admite: 'ASC' (default) o 'DESC'
-- ============================================================
CREATE OR ALTER PROCEDURE [dbo].[spCuentas_Listar]
    @IDGrupo  INT = NULL,
    @Codigo   VARCHAR(50) = NULL,
    @Nombre   NVARCHAR(150) = NULL,
    @OrderBy  NVARCHAR(50) = NULL,
    @OrderDir VARCHAR(4) = 'ASC'
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Normalizar dirección (cualquier valor distinto de DESC se trata como ASC)
        SET @OrderDir = CASE WHEN UPPER(LTRIM(RTRIM(ISNULL(@OrderDir, 'ASC')))) = 'DESC' THEN 'DESC' ELSE 'ASC' END;

        SELECT
            c.ID,
            c.Cuenta,
            c.Nombre,
            c.IDGrupo,
            gc.GrupoCuenta AS GrupoDescripcion,
            c.Saldo,
            c.snImputable
        FROM tbCuentas c
        LEFT JOIN tbGrupoCuenta gc ON c.IDGrupo = gc.IDGrupo
        WHERE c.snEliminado = 0
            --AND c.snImputable = 1
            AND (@IDGrupo IS NULL OR c.IDGrupo = @IDGrupo)
            AND (@Codigo IS NULL OR c.Cuenta LIKE '%' + @Codigo + '%')
            AND (@Nombre IS NULL OR c.Nombre LIKE '%' + @Nombre + '%')
        ORDER BY
            -- Columnas de texto ASC
            CASE WHEN @OrderDir = 'ASC' THEN
                CASE @OrderBy
                    WHEN 'Cuenta' THEN c.Cuenta
                    WHEN 'Nombre' THEN c.Nombre
                    WHEN 'Grupo'  THEN gc.GrupoCuenta
                END
            END ASC,
            -- Columnas de texto DESC
            CASE WHEN @OrderDir = 'DESC' THEN
                CASE @OrderBy
                    WHEN 'Cuenta' THEN c.Cuenta
                    WHEN 'Nombre' THEN c.Nombre
                    WHEN 'Grupo'  THEN gc.GrupoCuenta
                END
            END DESC,
            -- Columnas numéricas ASC
            CASE WHEN @OrderDir = 'ASC' THEN
                CASE @OrderBy
                    WHEN 'ID'        THEN CONVERT(NUMERIC(18,2), c.ID)
                    WHEN 'Saldo'     THEN c.Saldo
                    WHEN 'Imputable' THEN CONVERT(NUMERIC(18,2), ISNULL(c.snImputable, 0))
                END
            END ASC,
            -- Columnas numéricas DESC
            CASE WHEN @OrderDir = 'DESC' THEN
                CASE @OrderBy
                    WHEN 'ID'        THEN CONVERT(NUMERIC(18,2), c.ID)
                    WHEN 'Saldo'     THEN c.Saldo
                    WHEN 'Imputable' THEN CONVERT(NUMERIC(18,2), ISNULL(c.snImputable, 0))
                END
            END DESC,
            -- Orden por defecto / desempate
            c.Cuenta ASC;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO
