-- =============================================
-- Script: Probar spGestionSocios_ActualizarSocio
-- Descripción: Verificar que el SP funcione con todos los parámetros
-- Fecha: 2024
-- =============================================

-- Probar el stored procedure con un socio existente
DECLARE @NumeroAsociado INT = 1; -- Cambiar por un número de socio existente

-- Verificar que el socio existe
SELECT NumeroAsociado, Nombre, Apellido, Sexo 
FROM tbAsociados 
WHERE NumeroAsociado = @NumeroAsociado;

-- Probar el stored procedure
EXEC spGestionSocios_ActualizarSocio
    @NumeroAsociado = @NumeroAsociado,
    @IdTipoAsociado = 1,
    @Nombre = 'Test',
    @SegundoNombre = NULL,
    @Apellido = 'Test',
    @SegundoApellido = NULL,
    @Estatus = 'A',
    @TipoIdentificacion = 'C',
    @NumeroIdentificacion = '12345678',
    @TelefonoResidencia = '12345678',
    @TelefonoCelular = '87654321',
    @TelefonoFamiliar = '11223344',
    @CorreoElectronico = 'test@test.com',
    @Sexo = 'M',
    @FechaNacimiento = '1990-01-01',
    @DireccionResidencia = 'Test Address',
    @DireccionTrabajo = 'Test Work Address',
    @NivelEstudio = 1,
    @Profesion = 1,
    @UsuarioModifica = 1,
    @LugarTrabajo = 1,
    @Ocupacion = 1,
    @PaisTrabajo = 'PA',
    @ProvinciaTrabajo = 8,
    @DistritoTrabajo = 47,
    @CorregimientoTrabajo = 0,
    @PaisResidencia = 'PA',
    @ProvinciaResidencia = 8,
    @DistritoResidencia = 47,
    @CorregimientoResidencia = 0;

PRINT '✅ Prueba del stored procedure completada'

