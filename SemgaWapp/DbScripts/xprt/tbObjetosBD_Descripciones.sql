USE [SegmaDB]
GO

-- Tabla para almacenar descripciones de objetos de base de datos
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbObjetosBD_Descripciones]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[tbObjetosBD_Descripciones](
        [ID] [INT] IDENTITY(1,1) NOT NULL,
        [NombreObjeto] [NVARCHAR](255) NOT NULL,
        [TipoObjeto] [NVARCHAR](50) NOT NULL, -- SP, FUNCTION, TABLE, VIEW, TRIGGER
        [DescripcionLogica] [NVARCHAR](MAX) NULL,
        [SPsLlamados] [NVARCHAR](1000) NULL, -- Lista separada por comas de SPs que llama este objeto
        [TablasUtilizadas] [NVARCHAR](1000) NULL, -- Lista separada por comas de tablas utilizadas por este objeto
        [FechaCreacion] [DATETIME] NULL DEFAULT GETDATE(),
        [FechaModificacion] [DATETIME] NULL,
        [UsuarioCrea] [INT] NULL,
        [UsuarioModifica] [INT] NULL,
        [snEliminado] [BIT] NOT NULL DEFAULT 0,
        CONSTRAINT [PK_tbObjetosBD_Descripciones] PRIMARY KEY CLUSTERED ([ID] ASC),
        CONSTRAINT [UQ_ObjetosBD_NombreTipo] UNIQUE NONCLUSTERED ([NombreObjeto] ASC, [TipoObjeto] ASC)
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    
    PRINT 'Tabla tbObjetosBD_Descripciones creada exitosamente'
END
ELSE
BEGIN
    PRINT 'La tabla tbObjetosBD_Descripciones ya existe'
    
    -- Verificar si existe la columna TablasUtilizadas y agregarla si no existe
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[tbObjetosBD_Descripciones]') AND name = 'TablasUtilizadas')
    BEGIN
        ALTER TABLE [dbo].[tbObjetosBD_Descripciones]
        ADD [TablasUtilizadas] [NVARCHAR](1000) NULL;
        PRINT 'Columna TablasUtilizadas agregada exitosamente'
    END
    ELSE
    BEGIN
        PRINT 'La columna TablasUtilizadas ya existe'
    END
END
GO

-- Limpiar datos existentes para reinsertar
DELETE FROM [dbo].[tbObjetosBD_Descripciones]
GO

-- INSERTs para Stored Procedures
-- IMPORTANTE: DescripcionLogica debe contener HTML formateado que se renderizará directamente
-- Ver archivo EJEMPLO_FORMATO_HTML_LOGICA.md para ejemplos de formato
INSERT INTO [dbo].[tbObjetosBD_Descripciones] ([NombreObjeto], [TipoObjeto], [DescripcionLogica], [SPsLlamados], [TablasUtilizadas], [FechaCreacion], [snEliminado])
VALUES
-- Auxiliares
-- NOTA: Ejemplo con HTML formateado - actualizar los demás INSERTs con formato HTML similar
('spAuxiliares_GuardarAuxiliar', 'SP', 
'<div style="line-height: 1.9; font-size: 15px; color: #333;"><p style="margin-bottom: 14px; text-align: justify;">Guarda o actualiza un auxiliar asociado en la base de datos.</p><p style="margin-bottom: 14px;"><strong style="color: #2c3e50;">Realiza 6 validaciones:</strong></p><div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;"><span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span> <span>Verifica que número de asociado, código de rubro y tipo de auxiliar sean requeridos</span></div><div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;"><span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span> <span>Valida que el asociado exista en <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbAsociados</code></span></div><div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;"><span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span> <span>Valida que el rubro exista en <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbRubros</code></span></div><div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;"><span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span> <span>Valida que el tipo de auxiliar sea válido para el rubro en <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbTiposAuxiliares</code></span></div><p style="margin-bottom: 14px; text-align: justify;">Si <code style="background-color: #fff3cd; padding: 2px 6px; border-radius: 3px; color: #856404; font-size: 14px; font-weight: 500;">@ID = 0</code>, crea un nuevo auxiliar:</p><div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;"><span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span> <span>Genera un consecutivo automático desde <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbControlConsecutivos</code></span></div><div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;"><span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span> <span>Realiza un <strong style="color: #dc3545; font-weight: 600;">INSERT</strong> en <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbAuxiliares</code> con todos los campos (Cuota, Saldo, MontoOriginal, TasaInteres, etc.)</span></div><div style="margin-bottom: 10px; padding-left: 24px; position: relative; padding-top: 2px;"><span style="position: absolute; left: 8px; color: #007bff; font-weight: bold; font-size: 18px; line-height: 1.2;">•</span> <span>Retorna el nuevo ID</span></div><p style="margin-bottom: 14px; text-align: justify;">Si <code style="background-color: #fff3cd; padding: 2px 6px; border-radius: 3px; color: #856404; font-size: 14px; font-weight: 500;">@ID &gt; 0</code>, actualiza el auxiliar existente con un <strong style="color: #dc3545; font-weight: 600;">UPDATE</strong> en <code style="background-color: #f8f9fa; padding: 2px 6px; border-radius: 3px; color: #e83e8c; font-size: 14px; font-weight: 500;">tbAuxiliares</code>.</p><p style="margin-bottom: 14px; text-align: justify;">Utiliza transacciones (<strong style="color: #dc3545; font-weight: 600;">BEGIN TRANSACTION</strong>/<strong style="color: #dc3545; font-weight: 600;">COMMIT</strong>) para garantizar la integridad de los datos. Incluye manejo de excepciones con <strong style="color: #dc3545; font-weight: 600;">TRY-CATCH</strong>. Retorna ''SUCCESS'' o ''ERROR'' con mensaje descriptivo.</p></div>',
NULL, 'tbAuxiliares, tbAsociados, tbRubros, tbTiposAuxiliares, tbControlConsecutivos', GETDATE(), 0),

('spAuxiliares_ObtenerAuxiliares', 'SP',
'Obtiene todos los auxiliares activos con información completa. Consulta la tabla tbAuxiliares haciendo JOIN con tbAsociados (para nombre completo), tbTipoDocumentos (tipo de documento), tbRubros (descripción del rubro), tbTiposAuxiliares (descripción del tipo), y tbUsuarios (usuario creador y modificador). Aplica filtros WHERE para obtener solo auxiliares activos (snEliminado = 0 y snActivo = 1) y asociados no eliminados. Retorna información completa incluyendo ID, cuenta formateada, datos del asociado, rubro, tipo, montos (Cuota, Saldo, MontoOriginal, MontoPignorado), tasas, y fechas formateadas. Ordena por ID descendente.',
NULL, 'tbAuxiliares, tbAsociados, tbTipoDocumentos, tbRubros, tbTiposAuxiliares, tbUsuarios', GETDATE(), 0),

('spAuxiliares_ObtenerRubros', 'SP',
'Obtiene todos los rubros disponibles en el sistema. Consulta la tabla tbRubros filtrando por registros no eliminados (snEliminado = 0). Retorna CodigoRubro y Descripcion. Ordena alfabéticamente por Descripcion. Utilizado para llenar dropdowns de selección de rubros.',
NULL, 'tbRubros', GETDATE(), 0),

('spAuxiliares_ObtenerTiposAuxiliares', 'SP',
'Obtiene todos los tipos de auxiliares disponibles. Consulta la tabla tbTiposAuxiliares filtrando por registros no eliminados (snEliminado = 0). Retorna TipoAuxiliar, Descripcion, CodigoRubro, ID (como IdTipoAuxiliar) y Tasa. Utiliza DISTINCT para evitar duplicados. Ordena alfabéticamente por Descripcion. Utilizado para llenar dropdowns de selección de tipos de auxiliares.',
NULL, 'tbTiposAuxiliares', GETDATE(), 0),

('spAuxiliares_FiltrarAuxiliares', 'SP',
'Filtra auxiliares aplicando criterios de búsqueda opcionales. Consulta tbAuxiliares con múltiples JOINs: tbAsociados, tbTipoDocumentos, tbRubros, tbTiposAuxiliares, y tbUsuarios. Aplica filtros dinámicos WHERE: @Busqueda busca en nombre, apellido, descripción de rubro/tipo, número de identificación, y cuenta formateada usando LIKE con comodines. @TipoAuxiliar filtra por ID del auxiliar. @CodigoRubro filtra por código de rubro. Solo muestra auxiliares y asociados no eliminados (snEliminado = 0). Retorna información completa similar a spAuxiliares_ObtenerAuxiliares. Ordena por ID descendente.',
NULL, 'tbAuxiliares, tbAsociados, tbTipoDocumentos, tbRubros, tbTiposAuxiliares, tbUsuarios', GETDATE(), 0),

('spAuxiliares_EliminarAuxiliar', 'SP',
'Elimina lógicamente un auxiliar (soft delete). Realiza 3 validaciones: verifica que ID y NumeroAsociado sean requeridos, que el auxiliar exista en tbAuxiliares, y que no tenga movimientos asociados en tbMovimientos (si tiene movimientos, no permite eliminar). Utiliza transacciones (BEGIN TRANSACTION/COMMIT) para garantizar integridad. Realiza un UPDATE en tbAuxiliares estableciendo snEliminado = 1, FechaElimina = GETDATE(), UsuarioElimina, y SysLastSessionID. Incluye manejo de excepciones con TRY-CATCH. Retorna ''SUCCESS'' o ''ERROR'' con mensaje descriptivo.',
NULL, 'tbAuxiliares, tbMovimientos', GETDATE(), 0),

('spAuxiliares_ActivarDesactivar', 'SP',
'Activa o desactiva un auxiliar cambiando su estado. Realiza 3 validaciones: verifica que ID y NumeroAsociado sean requeridos, y que el auxiliar exista en tbAuxiliares. Utiliza transacciones (BEGIN TRANSACTION/COMMIT). Realiza un UPDATE en tbAuxiliares estableciendo snActivo = @snActivo (1 para activar, 0 para desactivar), FechaModificacion = GETDATE(), UsuarioModifica, y SysLastSessionID. Incluye manejo de excepciones con TRY-CATCH. Retorna mensaje de éxito indicando si fue activado o desactivado.',
NULL, 'tbAuxiliares', GETDATE(), 0),

('spAuxiliares_ModificarMontoPignorado', 'SP',
'Modifica el monto pignorado de un auxiliar específico. Valida que el auxiliar exista y pertenezca al asociado especificado en tbAuxiliares. Realiza un UPDATE en tbAuxiliares actualizando MontoPignorado = @NuevoMonto, FechaModificacion = GETDATE(), UsuarioModifica, y SysLastSessionID. Verifica que la actualización se realizó correctamente usando @@ROWCOUNT. Incluye manejo de excepciones con TRY-CATCH. Retorna mensaje de éxito.',
NULL, 'tbAuxiliares', GETDATE(), 0),

('spAuxiliares_CalcularIntereses', 'SP',
'Calcula los intereses pendientes de un auxiliar de préstamo. Consulta tbAuxiliares para obtener datos del préstamo (TasaInteres, Saldo, FechaUltCalculoInteres). Calcula los intereses desde la última fecha de cálculo hasta la fecha actual. Actualiza los campos InteresCalculado y FechaUltCalculoInteres en tbAuxiliares. Retorna mensaje de error si hay algún problema. Utilizado por spMovimientos_GuardarMovimiento para calcular intereses antes de procesar un pago.',
NULL, 'tbAuxiliares', GETDATE(), 0),

('spAuxiliares_ObtenerHistorialIntereses', 'SP',
'Obtiene el historial de cálculo de intereses de un auxiliar. Consulta la tabla de historial de intereses o tbAuxiliares para obtener información sobre cuándo se calcularon intereses, montos calculados, y pagos realizados. Utilizado para mostrar el detalle de intereses en la interfaz.',
NULL, 'tbAuxiliares', GETDATE(), 0),

-- Buscar Asociados
('spBuscarAsociadoPorID', 'SP',
'Busca un asociado específico por su número de asociado. Consulta tbAsociados con JOINs a tbTipoAsociado y tbTipoDocumentos. Retorna información básica: NumeroAsociado, NombreCompleto (concatenado), NumeroIdentificacion, tipo de documento, tipo de asociado. Además, cuenta los auxiliares activos del asociado usando subconsulta a tbAuxiliares, y retorna los auxiliares en formato JSON mediante una subconsulta a la vista vwAuxiliaresPorAsociados con FOR JSON AUTO. Solo muestra asociados no eliminados (snEliminado = 0). Ordena por nombre y apellido.',
NULL, 'tbAsociados, tbTipoAsociado, tbTipoDocumentos, tbAuxiliares, vwAuxiliaresPorAsociados', GETDATE(), 0),

('spBuscarAsociados', 'SP',
'Busca asociados aplicando criterios de búsqueda parcial. Consulta tbAsociados con JOINs a tbTipoAsociado y tbTipoDocumentos. Aplica búsqueda con LIKE en múltiples campos: Nombre, SegundoNombre, Apellido, SegundoApellido, NumeroIdentificacion, y NumeroAsociado (convertido a VARCHAR). Retorna TOP 10 resultados con información básica: NumeroAsociado, NombreCompleto, NumeroIdentificacion, tipo de documento, tipo de asociado. Cuenta los auxiliares activos del asociado y retorna los auxiliares en formato JSON mediante subconsulta a la vista vwAuxiliaresPorAsociados. Solo muestra asociados no eliminados (snEliminado = 0). Ordena por nombre y apellido.',
NULL, 'tbAsociados, tbTipoAsociado, tbTipoDocumentos, tbAuxiliares, vwAuxiliaresPorAsociados', GETDATE(), 0),

-- Gestión de Socios
('spGestionSocios_ObtenerSocios', 'SP',
'Obtiene una lista de socios aplicando múltiples filtros opcionales. Consulta tbAsociados con múltiples JOINs LEFT JOIN: tbTipoAsociado, tbUsuarios (creador y modificador), tbEmpresas, tbOcupaciones, tbPaises (trabajo y residencia), tbProvincias (trabajo y residencia), tbDistritos (trabajo y residencia), tbCorregimientos (trabajo y residencia). Aplica filtros dinámicos WHERE: @FiltroNombre busca con LIKE en Nombre, Apellido, SegundoNombre, SegundoApellido. @FiltroTipo filtra por IdTipoAsociado. @FiltroEstatus filtra por Estatus. @FiltroTipoDocumento filtra por TipoIdentificacion. @FiltroIdentificacion busca con LIKE en NumeroIdentificacion. Solo muestra socios no eliminados (snEliminado = 0). Cuenta los auxiliares activos del socio. Retorna información completa del socio incluyendo datos personales, contacto, ubicación, laborales, y descripciones de las entidades relacionadas. Incluye manejo de excepciones con TRY-CATCH. Ordena por NumeroAsociado descendente.',
NULL, 'tbAsociados, tbTipoAsociado, tbUsuarios, tbEmpresas, tbOcupaciones, tbPaises, tbProvincias, tbDistritos, tbCorregimientos, tbAuxiliares', GETDATE(), 0),

('spGestionSocios_ObtenerSocioPorNumero', 'SP',
'Obtiene información completa de un socio específico por su número de asociado. Consulta tbAsociados con los mismos múltiples JOINs LEFT JOIN que spGestionSocios_ObtenerSocios: tbTipoAsociado, tbUsuarios, tbEmpresas, tbOcupaciones, tbPaises, tbProvincias, tbDistritos, tbCorregimientos. Filtra por NumeroAsociado específico y solo muestra socios no eliminados (snEliminado = 0). Retorna información completa del socio incluyendo todos los datos personales, de contacto, ubicación, laborales, y descripciones de las entidades relacionadas. Cuenta los auxiliares activos del socio. Incluye manejo de excepciones con TRY-CATCH.',
NULL, 'tbAsociados, tbTipoAsociado, tbUsuarios, tbEmpresas, tbOcupaciones, tbPaises, tbProvincias, tbDistritos, tbCorregimientos, tbAuxiliares', GETDATE(), 0),

('spGestionSocios_CrearSocio', 'SP',
'Crea un nuevo socio en el sistema. Realiza validación de duplicados: verifica que no exista otro socio con el mismo NumeroIdentificacion y snEliminado = 0 en tbAsociados. Si ya existe, retorna error. Si no existe, realiza un INSERT en tbAsociados con todos los campos: datos personales (IdTipoAsociado, Nombre, Apellidos, Estatus, TipoIdentificacion, NumeroIdentificacion, Sexo, FechaNacimiento), datos de contacto (teléfonos, CorreoElectronico), datos de ubicación (Provincia, Distrito, Corregimiento, Dirección tanto de residencia como de trabajo), datos laborales (LugarTrabajo, Ocupacion, NivelEstudio, Profesion), países de residencia y trabajo. Establece FechaCreacion = GETDATE(), UsuarioCrea, SysLastSessionID, y snEliminado = 0. Utiliza TRY-CATCH para manejo de errores. Retorna el NumeroAsociado creado usando SCOPE_IDENTITY().',
NULL, 'tbAsociados', GETDATE(), 0),

('spGestionSocios_ActualizarSocio', 'SP',
'Actualiza información de un socio existente. Realiza validaciones similares a spGestionSocios_CrearSocio para evitar duplicados de identificación. Realiza un UPDATE en tbAsociados actualizando todos los campos: datos personales, contacto, ubicación, laborales. Establece FechaModificacion = GETDATE() y UsuarioModifica. Utiliza TRY-CATCH para manejo de errores.',
NULL, 'tbAsociados', GETDATE(), 0),

('spGestionSocios_EliminarAsociado', 'SP',
'Elimina lógicamente un asociado del sistema (soft delete). Realiza validaciones para verificar que el asociado exista y no tenga relaciones que impidan su eliminación. Actualiza el campo snEliminado = 1 en tbAsociados. Utiliza transacciones y manejo de excepciones.',
NULL, 'tbAsociados', GETDATE(), 0),

-- Beneficiarios
('spBeneficiarios_ObtenerBeneficiarios', 'SP',
'Obtiene todos los beneficiarios de un socio específico. Consulta tbBeneficiarios con LEFT JOIN a tbParentezcos para obtener la descripción del parentesco. Filtra por NumeroAsociado y solo muestra beneficiarios no eliminados (snEliminado = 0). Retorna IDBeneficiario, NumeroAsociado, Nombre, Apellido, TipoIdentificacion, NumeroIdentificacion, IDParentezco, Porcentaje, y Parentezco. Incluye manejo de excepciones con TRY-CATCH. Ordena por nombre y apellido.',
NULL, 'tbBeneficiarios, tbParentezcos', GETDATE(), 0),

('spBeneficiarios_CrearBeneficiario', 'SP',
'Crea un nuevo beneficiario para un socio. Realiza validación crítica: calcula el porcentaje total de todos los beneficiarios existentes del asociado y verifica que al agregar el nuevo porcentaje no se exceda el 100%. Si excede, retorna error. Si es válido, realiza un INSERT en tbBeneficiarios con todos los campos: NumeroAsociado, Nombre, Apellido, TipoIdentificacion, NumeroIdentificacion, IDParentezco, Porcentaje, UsuarioCrea, FechaHoraCrea = GETDATE(), SysLastSessionID, y snEliminado = 0. Incluye manejo de excepciones con TRY-CATCH. Retorna ''SUCCESS'' o ''ERROR'' con mensaje.',
NULL, 'tbBeneficiarios', GETDATE(), 0),

('spBeneficiarios_ActualizarBeneficiario', 'SP',
'Actualiza información de un beneficiario existente. Similar a spBeneficiarios_CrearBeneficiario, valida que el porcentaje total no exceda 100% considerando el porcentaje actualizado. Realiza un UPDATE en tbBeneficiarios actualizando los campos del beneficiario. Establece campos de auditoría de modificación. Utiliza TRY-CATCH para manejo de errores.',
NULL, 'tbBeneficiarios', GETDATE(), 0),

('spBeneficiarios_EliminarBeneficiario', 'SP',
'Elimina lógicamente un beneficiario (soft delete). Realiza un UPDATE en tbBeneficiarios estableciendo snEliminado = 1. Incluye campos de auditoría. Utiliza TRY-CATCH para manejo de errores.',
NULL, 'tbBeneficiarios', GETDATE(), 0),

('spBeneficiarios_ObtenerParentezcos', 'SP',
'Obtiene todos los tipos de parentesco disponibles. Consulta tbParentezcos filtrando por registros no eliminados. Retorna IDParentezco y Parentezco. Utilizado para llenar dropdowns de selección de parentesco en formularios de beneficiarios.',
NULL, 'tbParentezcos', GETDATE(), 0),

-- Movimientos
('spMovimientos_GuardarMovimiento', 'SP',
'Guarda un nuevo movimiento financiero en el sistema. Este SP tiene lógica compleja: Primero llama a spMovimiento_Validar para validar el movimiento (verifica saldos, límites, estado del auxiliar). Si es un préstamo (CodigoRubro = ''PR''), llama a spAuxiliares_CalcularIntereses para calcular intereses pendientes. Luego inicia una transacción. Si hay intereses pendientes, crea dos movimientos separados: uno para intereses (que no afecta el saldo del auxiliar) y otro para capital (que sí afecta el saldo). Si no hay intereses, crea solo el movimiento de capital. Actualiza el saldo del auxiliar en tbAuxiliares. Crea registros en tbMovimientos con los datos del movimiento. Retorna los IDs de los movimientos creados (CapitalMovimientoID e InteresesMovimientoID). Utiliza transacciones para garantizar integridad. Incluye manejo completo de excepciones.',
'spMovimiento_Validar, spAuxiliares_CalcularIntereses', 'tbMovimientos, tbAuxiliares', GETDATE(), 0),

('spMovimiento_Validar', 'SP',
'Valida si un movimiento puede ser realizado. Verifica que el auxiliar exista, esté activo y no eliminado. Valida que el código de transacción sea válido. Verifica saldos y límites según el tipo de transacción. Retorna @Resultado (BIT) y @Mensaje con el resultado de la validación. Utilizado por spMovimientos_GuardarMovimiento antes de crear el movimiento.',
NULL, 'tbAuxiliares, tbMovimientos', GETDATE(), 0),

('spMovimientos_ListarPorSocio', 'SP',
'Obtiene el historial de movimientos de un socio específico. Consulta tbMovimientos filtrando por NumeroAsociado. Puede aplicar filtros adicionales por auxiliar, rango de fechas, o tipo de movimiento. Retorna información completa de los movimientos incluyendo fechas, montos, códigos de transacción, y saldos. Incluye manejo de excepciones.',
NULL, 'tbMovimientos', GETDATE(), 0),

('spMovimientos_ObtenerDatosComprobante', 'SP',
'Obtiene los datos necesarios para generar un comprobante de movimiento. Consulta tbMovimientos y hace JOINs con tbAsociados, tbAuxiliares, y otras tablas relacionadas para obtener información completa del movimiento, asociado, y auxiliar. Retorna datos formateados para impresión de comprobantes.',
NULL, 'tbMovimientos, tbAsociados, tbAuxiliares', GETDATE(), 0),

-- Asociados
('spAsociados_ObtenerEstadoCuenta', 'SP',
'Obtiene el estado de cuenta completo de un asociado. Consulta tbAsociados, tbAuxiliares, y tbMovimientos para calcular saldos, intereses, y resumen financiero del asociado. Puede incluir información de todos los auxiliares del asociado con sus respectivos saldos y movimientos recientes.',
NULL, 'tbAsociados, tbAuxiliares, tbMovimientos', GETDATE(), 0)

PRINT 'Descripciones de objetos de BD insertadas exitosamente'
GO

