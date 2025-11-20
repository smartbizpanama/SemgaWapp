USE [SegmaDB]
GO

-- Probar el stored procedure con datos de prueba
DECLARE @testEquipo NVARCHAR(MAX) = '{"test": "data", "userAgent": "Mozilla/5.0", "timestamp": "2025-01-27T10:30:00Z"}';

EXEC spAuxiliares_EliminarAuxiliar_ConAuditoria 
    @ID = 2, 
    @NumeroAsociado = 1, 
    @UsuarioElimina = '4', 
    @EquipoElimina = @testEquipo;

-- Verificar el resultado
SELECT 
    ID,
    NumeroAsociado,
    snEliminado,
    UsuarioElimina,
    FechaElimina,
    EquipoElimina
FROM tbAuxiliares 
WHERE ID = 2;
GO
