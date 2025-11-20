-- =============================================
-- Script de Prueba para Beneficiarios con Auditoría
-- =============================================

-- Limpiar datos de prueba anteriores
DELETE FROM tbBeneficiarios WHERE NumeroAsociado = 999;

-- =============================================
-- Prueba 1: Crear Beneficiario
-- =============================================
PRINT '=== PRUEBA 1: Crear Beneficiario ===';
EXEC spBeneficiarios_CrearBeneficiario 
    @NumeroAsociado = 999,
    @Nombre = 'JUAN',
    @Apellido = 'PEREZ',
    @TipoIdentificacion = 'C',
    @NumeroIdentificacion = '123456789',
    @IDParentezco = 1,
    @Porcentaje = 50.00,
    @UsuarioCrea = 1;

-- Verificar que se creó con campos de auditoría
SELECT 
    IDBeneficiario,
    NumeroAsociado,
    Nombre,
    Apellido,
    UsuarioCrea,
    FechaHoraCrea,
    UsuarioModifica,
    FechaModifica,
    UsuarioElimina,
    FechaElimina
FROM tbBeneficiarios 
WHERE NumeroAsociado = 999;

-- =============================================
-- Prueba 2: Actualizar Beneficiario
-- =============================================
PRINT '=== PRUEBA 2: Actualizar Beneficiario ===';
DECLARE @IDBeneficiario INT;
SELECT @IDBeneficiario = IDBeneficiario FROM tbBeneficiarios WHERE NumeroAsociado = 999;

EXEC spBeneficiarios_ActualizarBeneficiario 
    @IDBeneficiario = @IDBeneficiario,
    @Nombre = 'JUAN CARLOS',
    @Apellido = 'PEREZ GONZALEZ',
    @TipoIdentificacion = 'C',
    @NumeroIdentificacion = '123456789',
    @IDParentezco = 1,
    @Porcentaje = 60.00,
    @UsuarioModifica = 2;

-- Verificar que se actualizó con campos de auditoría
SELECT 
    IDBeneficiario,
    NumeroAsociado,
    Nombre,
    Apellido,
    UsuarioCrea,
    FechaHoraCrea,
    UsuarioModifica,
    FechaModifica,
    UsuarioElimina,
    FechaElimina
FROM tbBeneficiarios 
WHERE IDBeneficiario = @IDBeneficiario;

-- =============================================
-- Prueba 3: Eliminar Beneficiario
-- =============================================
PRINT '=== PRUEBA 3: Eliminar Beneficiario ===';
EXEC spBeneficiarios_EliminarBeneficiario 
    @IDBeneficiario = @IDBeneficiario,
    @UsuarioElimina = 3;

-- Verificar que se eliminó con campos de auditoría
SELECT 
    IDBeneficiario,
    NumeroAsociado,
    Nombre,
    Apellido,
    snEliminado,
    UsuarioCrea,
    FechaHoraCrea,
    UsuarioModifica,
    FechaModifica,
    UsuarioElimina,
    FechaElimina
FROM tbBeneficiarios 
WHERE IDBeneficiario = @IDBeneficiario;

-- =============================================
-- Prueba 4: Error - Usuario no autenticado
-- =============================================
PRINT '=== PRUEBA 4: Error - Usuario no autenticado ===';
EXEC spBeneficiarios_CrearBeneficiario 
    @NumeroAsociado = 999,
    @Nombre = 'MARIA',
    @Apellido = 'GONZALEZ',
    @TipoIdentificacion = 'C',
    @NumeroIdentificacion = '987654321',
    @IDParentezco = 2,
    @Porcentaje = 30.00,
    @UsuarioCrea = NULL;

-- Limpiar datos de prueba
DELETE FROM tbBeneficiarios WHERE NumeroAsociado = 999;

PRINT '=== PRUEBAS COMPLETADAS ===';

