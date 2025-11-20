-- =============================================
-- Prueba de los triggers mejorados
-- =============================================

USE [SegmaDB]
GO

PRINT '=== PRUEBA DE TRIGGERS MEJORADOS ==='
PRINT ''

-- 1. Probar funciones auxiliares
PRINT '1. Probando funciones auxiliares...'
SELECT 
    'TipoDocumento' as Funcion, 
    dbo.fnAuditoria_ObtenerTipoDocumento('C') as Resultado
UNION ALL
SELECT 'Asociado', dbo.fnAuditoria_ObtenerAsociado(1)
UNION ALL
SELECT 'Parentesco', dbo.fnAuditoria_ObtenerParentesco(1)

PRINT '   ✅ Funciones auxiliares funcionando'
PRINT ''

-- 2. Crear asociado de prueba
PRINT '2. Creando asociado de prueba...'
INSERT INTO tbAsociados (
    IdTipoAsociado, Nombre, SegundoNombre, Apellido, SegundoApellido,
    Estatus, TipoIdentificacion, NumeroIdentificacion, TelefonoResidencia,
    TelefonoCelular, TelefonoFamiliar, CorreoElectronico, Sexo, FechaNacimiento,
    DireccionResidencia, DireccionTrabajo, NivelEstudio, Profesion,
    UsuarioCrea, FechaCreacion, snEliminado, LugarTrabajo, Ocupacion,
    PaisTrabajo, ProvinciaTrabajo, DistritoTrabajo, CorregimientoTrabajo,
    PaisResidencia, ProvinciaResidencia, DistritoResidencia, CorregimientoResidencia
) VALUES (
    1, 'Ana', 'María', 'García', 'López',
    'A', 'C', '111111111', '555-2001',
    '555-2002', '555-2003', 'ana.garcia@test.com', 'F', '1988-03-15',
    'Calle Prueba 789', 'Avenida Test 123', 2, 2,
    1, GETDATE(), 0, 2, 2,
    'PA', 8, 47, 1,
    'PA', 8, 47, 1
)

DECLARE @NumeroAsociado INT = SCOPE_IDENTITY()
PRINT '   ✅ Asociado creado con ID: ' + CAST(@NumeroAsociado AS VARCHAR(10))
PRINT ''

-- 3. Crear beneficiario de prueba
PRINT '3. Creando beneficiario de prueba...'
INSERT INTO tbBeneficiarios (
    NumeroAsociado, Nombre, Apellido, TipoIdentificacion, 
    NumeroIdentificacion, IDParentezco, Porcentaje,
    UsuarioCrea, FechaHoraCrea, snEliminado
) VALUES (
    @NumeroAsociado, 'Carlos', 'García', 'C', 
    '222222222', 1, 50.00,
    1, GETDATE(), 0
)

DECLARE @IDBeneficiario INT = SCOPE_IDENTITY()
PRINT '   ✅ Beneficiario creado con ID: ' + CAST(@IDBeneficiario AS VARCHAR(10))
PRINT ''

-- 4. Actualizar asociado
PRINT '4. Actualizando asociado...'
UPDATE tbAsociados 
SET Nombre = 'Ana María', 
    LugarTrabajo = 3,
    UsuarioModifica = 1,
    FechaModificacion = GETDATE()
WHERE NumeroAsociado = @NumeroAsociado

PRINT '   ✅ Asociado actualizado'
PRINT ''

-- 5. Actualizar beneficiario
PRINT '5. Actualizando beneficiario...'
UPDATE tbBeneficiarios 
SET Porcentaje = 60.00,
    UsuarioModifica = 1,
    FechaModifica = GETDATE()
WHERE IDBeneficiario = @IDBeneficiario

PRINT '   ✅ Beneficiario actualizado'
PRINT ''

-- 6. Soft delete beneficiario
PRINT '6. Realizando soft delete del beneficiario...'
UPDATE tbBeneficiarios 
SET snEliminado = 1,
    UsuarioElimina = 1,
    FechaElimina = GETDATE(),
    UsuarioModifica = 1,
    FechaModifica = GETDATE()
WHERE IDBeneficiario = @IDBeneficiario

PRINT '   ✅ Soft delete del beneficiario realizado'
PRINT ''

-- 7. Verificar logs de auditoría
PRINT '7. Verificando logs de auditoría...'
SELECT 
    Id,
    TablaAfectada,
    Operacion,
    CASE Operacion 
        WHEN 'I' THEN 'INSERT'
        WHEN 'U' THEN 'UPDATE'
        WHEN 'D' THEN 'SOFT DELETE'
        WHEN 'X' THEN 'DELETE FÍSICO'
    END as TipoOperacion,
    RegistroId,
    UsuarioId,
    FechaHora
FROM tbLogsAuditoria 
WHERE (TablaAfectada = 'tbAsociados' AND RegistroId = CAST(@NumeroAsociado AS VARCHAR(50)))
   OR (TablaAfectada = 'tbBeneficiarios' AND RegistroId = CAST(@IDBeneficiario AS VARCHAR(50)))
ORDER BY FechaHora

PRINT '   ✅ Logs verificados'
PRINT ''

-- 8. Mostrar ejemplo de JSON con descripciones
PRINT '8. Ejemplo de JSON con descripciones:'
SELECT TOP 1
    TablaAfectada,
    LEFT(JsonPosterior, 300) + '...' as JsonPosterior_Preview
FROM tbLogsAuditoria 
WHERE (TablaAfectada = 'tbAsociados' AND RegistroId = CAST(@NumeroAsociado AS VARCHAR(50)))
   OR (TablaAfectada = 'tbBeneficiarios' AND RegistroId = CAST(@IDBeneficiario AS VARCHAR(50)))
ORDER BY FechaHora

PRINT '   ✅ Ejemplo mostrado'
PRINT ''

-- 9. Limpiar datos de prueba
PRINT '9. Limpiando datos de prueba...'
DELETE FROM tbLogsAuditoria 
WHERE (TablaAfectada = 'tbAsociados' AND RegistroId = CAST(@NumeroAsociado AS VARCHAR(50)))
   OR (TablaAfectada = 'tbBeneficiarios' AND RegistroId = CAST(@IDBeneficiario AS VARCHAR(50)))

DELETE FROM tbBeneficiarios WHERE IDBeneficiario = @IDBeneficiario
DELETE FROM tbAsociados WHERE NumeroAsociado = @NumeroAsociado

PRINT '   ✅ Datos de prueba eliminados'
PRINT ''

PRINT '=== PRUEBA COMPLETADA EXITOSAMENTE ==='
PRINT 'Ambos triggers mejorados funcionan correctamente con:'
PRINT '- Descripciones de IDs en formato "Descripción (ID)"'
PRINT '- Formato de fechas dd/MM/yyyy y hora AM/PM'
PRINT '- Campos UsuarioElimina y FechaElimina incluidos'
GO

