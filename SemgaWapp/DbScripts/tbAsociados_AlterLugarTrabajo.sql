-- =============================================
-- MODIFICAR TABLA tbAsociados PARA LUGAR DE TRABAJO
-- =============================================

USE SegmaDB;
GO

-- Primero, crear una columna temporal para migrar los datos
ALTER TABLE dbo.tbAsociados 
ADD LugarTrabajoTemp INT NULL;

-- Actualizar todos los registros existentes con Code = 1 (Cooperativa Coopsemga)
UPDATE dbo.tbAsociados 
SET LugarTrabajoTemp = 1 
WHERE LugarTrabajo IS NOT NULL AND LugarTrabajo != '';

-- Eliminar la columna original
ALTER TABLE dbo.tbAsociados 
DROP COLUMN LugarTrabajo;

-- Renombrar la columna temporal
EXEC sp_rename 'dbo.tbAsociados.LugarTrabajoTemp', 'LugarTrabajo', 'COLUMN';

-- Agregar restricción de clave foránea
ALTER TABLE dbo.tbAsociados 
ADD CONSTRAINT FK_tbAsociados_tbEmpresas 
FOREIGN KEY (LugarTrabajo) REFERENCES dbo.tbEmpresas(Code);

PRINT 'Tabla tbAsociados modificada exitosamente';
PRINT 'Campo LugarTrabajo ahora referencia tbEmpresas.Code';
PRINT 'Todos los registros existentes asignados a Code = 1 (Cooperativa Coopsemga)';

-- Verificar los cambios
SELECT 
    NumeroAsociado, 
    Nombre, 
    Apellido, 
    LugarTrabajo,
    e.Descripcion as EmpresaDescripcion
FROM dbo.tbAsociados a
LEFT JOIN dbo.tbEmpresas e ON a.LugarTrabajo = e.Code
WHERE a.snEliminado = 0;


