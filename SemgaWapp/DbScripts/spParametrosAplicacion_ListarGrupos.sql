CREATE PROCEDURE [dbo].[spParametrosAplicacion_ListarGrupos]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT ParamGroup FROM tbParamsKeys ORDER BY ParamGroup;
END