-- Script para verificar el estado de la tabla tbTiposAuxiliares y sus dependencias

-- 1. Verificar si la tabla existe
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'tbTiposAuxiliares')
    PRINT '✅ Tabla tbTiposAuxiliares existe'
ELSE
    PRINT '❌ Tabla tbTiposAuxiliares NO existe'

-- 2. Verificar si la tabla tbRubros existe
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'tbRubros')
    PRINT '✅ Tabla tbRubros existe'
ELSE
    PRINT '❌ Tabla tbRubros NO existe'

-- 3. Verificar si el stored procedure existe
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spTiposAuxiliares_Listar]') AND type in (N'P', N'PC'))
    PRINT '✅ Stored procedure spTiposAuxiliares_Listar existe'
ELSE
    PRINT '❌ Stored procedure spTiposAuxiliares_Listar NO existe'

-- 4. Contar registros en tbRubros
SELECT COUNT(*) as TotalRubros FROM tbRubros WHERE snEliminado = 0

-- 5. Contar registros en tbTiposAuxiliares
SELECT COUNT(*) as TotalTiposAuxiliares FROM tbTiposAuxiliares WHERE snEliminado = 0

-- 6. Mostrar algunos rubros
SELECT TOP 5 CodigoRubro, Descripcion FROM tbRubros WHERE snEliminado = 0

-- 7. Mostrar algunos tipos auxiliares
SELECT TOP 5 * FROM tbTiposAuxiliares WHERE snEliminado = 0

-- 8. Probar el stored procedure
EXEC spTiposAuxiliares_Listar

