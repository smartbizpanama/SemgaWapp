CREATE OR ALTER PROCEDURE [dbo].[spMovimientos_ListarPorSocio]
     @NumeroAsociado INT,
     @Start INT = 0,
     @Length INT = 20,
     @OrderColumn NVARCHAR(20) = N'Fecha',
     @OrderDirection NVARCHAR(4) = N'DESC'
 AS
 BEGIN
     SET NOCOUNT ON;
 
     SET @Start = CASE WHEN @Start < 0 THEN 0 ELSE @Start END;
     SET @Length = CASE WHEN @Length <= 0 THEN 20 ELSE @Length END;
     SET @OrderDirection = CASE WHEN UPPER(@OrderDirection) = 'ASC' THEN N'ASC' ELSE N'DESC' END;

     DECLARE @OrderByColumn NVARCHAR(50) = N'm.FechaMovimiento';
 
     IF @OrderColumn = N'Transaccion'
         SET @OrderByColumn = N'm.IDMovimiento';
     ELSE IF @OrderColumn = N'Rubro'
         SET @OrderByColumn = N'r.Descripcion';
     ELSE IF @OrderColumn = N'Detalle'
         SET @OrderByColumn = N'ct.Descripcion';
     ELSE IF @OrderColumn = N'Monto'
         SET @OrderByColumn = N'm.Monto';
     ELSE IF @OrderColumn = N'Observaciones'
         SET @OrderByColumn = N'm.Observaciones';

     DECLARE @Sql NVARCHAR(MAX) = N'
         SELECT
             m.IDMovimiento,
             m.NumeroAsociado,
             m.CodigoTransaccion,
             ct.Descripcion AS DescripcionTransaccion,
             m.CodigoRubro,
             r.Descripcion AS DescripcionRubro,
             m.Monto,
             m.Observaciones,
             m.FechaMovimiento,
             m.FechaRegistro,
             m.FechaCreacion,
             m.UsuarioCrea,
             COUNT(1) OVER() AS TotalRegistros
         FROM tbMovimientos m
         INNER JOIN tbCodigosTransaccion ct ON m.CodigoTransaccion = ct.CodigoTransaccion AND m.CodigoRubro = ct.CodigoRubro
         INNER JOIN tbRubros r ON m.CodigoRubro = r.CodigoRubro
         WHERE m.snEliminado = 0
           AND m.NumeroAsociado = @NumeroAsociado
         ORDER BY ' + @OrderByColumn + N' ' + @OrderDirection + N'
         OFFSET @Start ROWS FETCH NEXT @Length ROWS ONLY;';

     EXEC sp_executesql
         @Sql,
         N'@NumeroAsociado INT, @Start INT, @Length INT',
         @NumeroAsociado = @NumeroAsociado,
         @Start = @Start,
         @Length = @Length;
 END;
