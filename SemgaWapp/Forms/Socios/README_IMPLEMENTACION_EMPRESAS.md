# Implementación del Sistema de Empresas - Dropdown

## Resumen
Se ha implementado un sistema completo para cambiar el campo "Lugar de Trabajo" de texto libre a un dropdown con empresas predefinidas.

## Cambios Realizados

### 1. Base de Datos

#### Tabla `tbEmpresas` (Nueva)
```sql
CREATE TABLE dbo.tbEmpresas (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Code INT UNIQUE NOT NULL,
    Descripcion NVARCHAR(100) NOT NULL,
    snEliminado BIT NOT NULL DEFAULT 0
);
```

**Datos iniciales:**
- Code 1: Cooperativa Coopsemga
- Code 2: Banco Nacional de Panamá  
- Code 3: Caja de Ahorros
- Code 4: Banco General
- Code 5: Banistmo

#### Modificación de `tbAsociados`
- Campo `LugarTrabajo` cambiado de `NVARCHAR(50)` a `INT`
- Agregada restricción de clave foránea a `tbEmpresas.Code`
- Todos los registros existentes actualizados a Code = 1

### 2. Stored Procedures Actualizados

#### `spGestionSocios_ObtenerSocios`
- Agregado `LEFT JOIN` con `tbEmpresas`
- Retorna `LugarTrabajo` (Code) y `LugarTrabajoDescripcion` (Descripción)

#### `spGestionSocios_ObtenerSocioPorNumero`
- Agregado `LEFT JOIN` con `tbEmpresas`
- Retorna `LugarTrabajo` (Code) y `LugarTrabajoDescripcion` (Descripción)

#### `spGestionSocios_CrearSocio`
- Parámetro `@LugarTrabajo` cambiado a `INT`
- Validación de existencia de empresa
- Manejo de valores NULL

#### `spGestionSocios_ActualizarSocio`
- Parámetro `@LugarTrabajo` cambiado a `INT`
- Validación de existencia de empresa
- Manejo de valores NULL

### 3. Backend (GestionSocios.aspx.vb)

#### Nuevo WebMethod `ObtenerEmpresas()`
```vb
<WebMethod(EnableSession:=True)>
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
Public Shared Function ObtenerEmpresas() As String
```
- Retorna lista de empresas activas
- Formato JSON con Success, Message, TotalRegistros, Data

#### Modificaciones en WebMethods existentes
- `CrearSocio`: Parámetro `LugarTrabajo` ahora es `Integer`
- `ActualizarSocio`: Parámetro `LugarTrabajo` ahora es `Integer`
- `ObtenerSocios`: Retorna `LugarTrabajo` como Integer
- `ObtenerSocioPorNumero`: Retorna `LugarTrabajo` como Integer

#### Función `AplicarMayusculasAutomaticas`
- Removido `LugarTrabajo` de la lista de campos a convertir a mayúsculas

### 4. Frontend (GestionSocios.aspx)

#### Cambio de Input a Select
```html
<!-- ANTES -->
<input type="text" id="lugarTrabajo" class="form-control">

<!-- DESPUÉS -->
<select id="lugarTrabajo" class="form-select">
    <option value="">Seleccionar empresa...</option>
</select>
```

#### Nuevas funciones JavaScript

##### `cargarEmpresas()`
- Carga empresas desde el WebMethod `ObtenerEmpresas`
- Pobla el dropdown con opciones

##### `cargarDatosAleatorios()`
- Mapeo de nombres de empresas a códigos
- Manejo de datos de desarrollo

#### Modificaciones en funciones existentes
- `llenarFormulario`: Maneja el nuevo campo como Integer
- `guardarSocio`: Envía el Code de empresa
- `limpiarFormulario`: Limpia el select
- `verificarMayusculasAutomaticas`: Excluye el campo de mayúsculas

### 5. Archivos Creados/Modificados

#### Nuevos archivos:
- `DbScripts/tbEmpresas.sql` - Creación de tabla y datos
- `DbScripts/tbAsociados_AlterLugarTrabajo.sql` - Modificación de tabla
- `DbScripts/spGestionSocios_UpdateLugarTrabajo.sql` - Actualización de SPs
- `DbScripts/INSTALACION_COMPLETA_EMPRESAS.sql` - Script completo
- `Forms/Socios/update_asociados_json.py` - Script para actualizar JSON
- `Forms/Socios/README_IMPLEMENTACION_EMPRESAS.md` - Esta documentación

#### Archivos modificados:
- `Forms/Socios/GestionSocios.aspx` - Frontend
- `Forms/Socios/GestionSocios.aspx.vb` - Backend
- `Forms/Socios/asociados.json` - Datos de desarrollo (mantenido como texto)

## Instalación

### Opción 1: Script Completo
```sql
-- Ejecutar en SQL Server Management Studio
-- Archivo: DbScripts/INSTALACION_COMPLETA_EMPRESAS.sql
```

### Opción 2: Scripts Individuales
```sql
-- 1. Crear tabla y datos
-- Archivo: DbScripts/tbEmpresas.sql

-- 2. Modificar tabla tbAsociados
-- Archivo: DbScripts/tbAsociados_AlterLugarTrabajo.sql

-- 3. Actualizar stored procedures
-- Archivo: DbScripts/spGestionSocios_UpdateLugarTrabajo.sql
```

## Verificación

### 1. Base de Datos
```sql
-- Verificar tabla empresas
SELECT * FROM tbEmpresas WHERE snEliminado = 0;

-- Verificar estructura de tbAsociados
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'tbAsociados' AND COLUMN_NAME = 'LugarTrabajo';

-- Verificar restricción de clave foránea
SELECT * FROM sys.foreign_keys WHERE name = 'FK_tbAsociados_tbEmpresas';
```

### 2. Aplicación Web
1. Abrir `GestionSocios.aspx`
2. Verificar que el dropdown de "Lugar de Trabajo" se carga
3. Probar crear un nuevo socio
4. Probar editar un socio existente
5. Verificar que los datos se guardan correctamente

## Consideraciones Adicionales

### 1. Migración de Datos Existentes
- Todos los registros existentes se actualizaron a Code = 1 (Cooperativa Coopsemga)
- Si se necesitan migrar datos específicos, crear un script de mapeo

### 2. Validaciones
- El sistema valida que la empresa existe antes de guardar
- Manejo de valores NULL (empresa opcional)
- Validación de integridad referencial

### 3. Rendimiento
- Los JOINs con `tbEmpresas` son LEFT JOIN para mantener compatibilidad
- Índices en `tbEmpresas.Code` para optimizar consultas

### 4. Mantenimiento
- Para agregar nuevas empresas: INSERT en `tbEmpresas`
- Para eliminar empresas: UPDATE `snEliminado = 1` (no DELETE)
- Para modificar empresas: UPDATE en `tbEmpresas`

## Troubleshooting

### Problema: Dropdown no se carga
**Solución:** Verificar que el WebMethod `ObtenerEmpresas` funciona correctamente

### Problema: Error al guardar socio
**Solución:** Verificar que el Code de empresa existe en `tbEmpresas`

### Problema: Datos no se muestran correctamente
**Solución:** Verificar que los stored procedures están actualizados

## Próximos Pasos

1. **Pruebas de Usuario**: Probar el sistema completo
2. **Migración de Datos**: Si hay datos específicos que migrar
3. **Documentación de Usuario**: Crear guía para usuarios finales
4. **Monitoreo**: Verificar que no hay errores en producción

## Contacto

Para dudas o problemas con la implementación, contactar al equipo de desarrollo.

