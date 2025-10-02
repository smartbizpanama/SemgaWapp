CREATE PROCEDURE [dbo].[spParametrosAplicacion_Listar]
    @ParamGroup VARCHAR(50) = NULL,
    @Buscar NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        ParamKey,
        ParamDescription,
        ParamGroup,
        ParamValue
    FROM tbParamsKeys
    WHERE (@ParamGroup IS NULL OR ParamGroup = @ParamGroup)
      AND (@Buscar IS NULL OR ParamDescription LIKE '%' + @Buscar + '%' OR ParamKey LIKE '%' + @Buscar + '%');
END