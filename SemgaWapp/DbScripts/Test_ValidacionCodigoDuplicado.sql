-- Script de prueba para verificar la validación de códigos duplicados
-- Este script simula los casos que pueden ocurrir

PRINT '=== PRUEBA DE VALIDACIÓN DE CÓDIGOS DUPLICADOS ==='
PRINT ''

-- Mostrar registros actuales
PRINT 'Registros actuales:'
SELECT ID, Code, Descripcion FROM tbNivelesEstudio WHERE snEliminado = 0 ORDER BY Code
PRINT ''

-- Caso 1: Intentar insertar un código que ya existe (debería fallar)
PRINT 'Caso 1: Intentando insertar código duplicado (8)...'
BEGIN TRY
    INSERT INTO tbNivelesEstudio (Code, Descripcion, snEliminado) VALUES (8, 'Test Duplicado', 0)
    PRINT '❌ ERROR: No debería permitir insertar código duplicado'
END TRY
BEGIN CATCH
    PRINT '✅ CORRECTO: Error capturado - ' + ERROR_MESSAGE()
END CATCH
PRINT ''

-- Caso 2: Intentar actualizar un registro con un código que ya existe en otro registro
PRINT 'Caso 2: Intentando actualizar registro ID=1 (código 1) a código 8...'
BEGIN TRY
    UPDATE tbNivelesEstudio SET Code = 8 WHERE ID = 1
    PRINT '❌ ERROR: No debería permitir actualizar a código duplicado'
END TRY
BEGIN CATCH
    PRINT '✅ CORRECTO: Error capturado - ' + ERROR_MESSAGE()
END CATCH
PRINT ''

-- Caso 3: Actualizar un registro sin cambiar el código (debería funcionar)
PRINT 'Caso 3: Actualizando descripción sin cambiar código (debería funcionar)...'
BEGIN TRY
    UPDATE tbNivelesEstudio SET Descripcion = 'Primaria Actualizada' WHERE ID = 1
    PRINT '✅ CORRECTO: Actualización exitosa'
    -- Revertir cambio
    UPDATE tbNivelesEstudio SET Descripcion = 'Primaria' WHERE ID = 1
    PRINT '✅ Cambio revertido'
END TRY
BEGIN CATCH
    PRINT '❌ ERROR: ' + ERROR_MESSAGE()
END CATCH
PRINT ''

-- Caso 4: Insertar un código nuevo (debería funcionar)
PRINT 'Caso 4: Insertando código nuevo (9)...'
BEGIN TRY
    INSERT INTO tbNivelesEstudio (Code, Descripcion, snEliminado) VALUES (9, 'Test Nuevo', 0)
    PRINT '✅ CORRECTO: Inserción exitosa'
    -- Limpiar
    DELETE FROM tbNivelesEstudio WHERE Code = 9
    PRINT '✅ Registro de prueba eliminado'
END TRY
BEGIN CATCH
    PRINT '❌ ERROR: ' + ERROR_MESSAGE()
END CATCH
PRINT ''

PRINT '=== FIN DE PRUEBAS ==='


