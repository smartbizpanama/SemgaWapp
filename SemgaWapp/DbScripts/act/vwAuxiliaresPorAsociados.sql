CREATE OR ALTER   VIEW [dbo].[vwAuxiliaresPorAsociados]
AS 

SELECT 
       right('000000000000' + cast(a.ID as varchar(12)),15) as Cuenta,
       a.ID as IdAuxiliar,
        s.NumeroAsociado,
        a.CodigoRubro,
        ta.ID as IdTipoAuxiliar,
        ta.Descripcion DescripcionAuxiliar,
        r.Descripcion AS DescripcionRubro,
        ta.Descripcion AS DescripcionTipoAuxiliar,
        (Select cTran.CodigoRubro, cTran.CodigoTransaccion, cTran.Descripcion as DescripcionTransaccion
         From tbCodigosTransaccion cTran 
         Where cTran.CodigoRubro = a.CodigoRubro
            and cTran.SnEliminado=0 and cTran.SnActivo=1
         For Json Auto) as Transacciones
       
    FROM tbAuxiliares a
    INNER JOIN tbAsociados s ON a.NumeroAsociado = s.NumeroAsociado
    left join tbTipoDocumentos td on td.CodTipoDoc = s.TipoIdentificacion
    LEFT JOIN tbRubros r ON a.CodigoRubro = r.CodigoRubro
    LEFT JOIN tbTiposAuxiliares ta ON a.TipoAuxiliar = ta.ID 
              AND a.CodigoRubro = ta.CodigoRubro
    left join tbUsuarios usrCrea on usrCrea.Id = a.UsuarioCrea    
    left join tbUsuarios usrMod on usrMod.Id = a.UsuarioModifica
    WHERE IsNull(a.snEliminado,0) = 0 and IsNull(a.snActivo,1)=1


GO

