# Módulo de Gestión de Auxiliares Asociados

## Descripción
Este módulo permite gestionar los auxiliares (productos financieros) asociados a los socios de la cooperativa, incluyendo ahorros, préstamos personales, de vivienda y vehículos.

## Archivos del Módulo

### Frontend
- **`AuxiliaresAsociados.aspx`** - Interfaz de usuario con tabla, filtros y modal
- **`AuxiliaresAsociados.aspx.vb`** - WebMethods para comunicación con la base de datos

### Base de Datos
- **`StoredProcedures_Auxiliares.sql`** - Todos los procedimientos almacenados
- **`Datos_Prueba_Auxiliares.sql`** - Datos de prueba para el módulo
- **`Tablas.sql`** - Estructura de las tablas relacionadas

## Stored Procedures Implementados

### 1. Consultas (SELECT)
- **`spAuxiliares_ObtenerRubros`** - Obtiene todos los rubros disponibles
- **`spAuxiliares_ObtenerTiposAuxiliares`** - Obtiene todos los tipos de auxiliares
- **`spAuxiliares_ObtenerTiposAuxiliaresPorRubro`** - Obtiene tipos por rubro específico
- **`spAuxiliares_ObtenerAuxiliares`** - Lista todos los auxiliares con información completa
- **`spAuxiliares_FiltrarAuxiliares`** - Filtra auxiliares por criterios de búsqueda
- **`spAuxiliares_BuscarAsociados`** - Busca asociados para selección
- **`spAuxiliares_ObtenerAuxiliar`** - Obtiene un auxiliar específico para edición

### 2. Operaciones CRUD
- **`spAuxiliares_GuardarAuxiliar`** - Crea o actualiza un auxiliar
- **`spAuxiliares_EliminarAuxiliar`** - Elimina lógicamente un auxiliar

## Características del Sistema

### ✅ Funcionalidades Implementadas
- **Tabla de Auxiliares**: Muestra todos los auxiliares con información completa
- **Filtros Avanzados**: Por búsqueda, tipo de auxiliar y rubro
- **Modal de Gestión**: Para crear y editar auxiliares
- **Búsqueda de Asociados**: Sistema de búsqueda inteligente
- **Validaciones**: Tanto del lado cliente como servidor
- **Monitoreo de Inactividad**: Integrado con el sistema general

### ✅ Seguridad
- **Sin SELECT directos**: Todos los queries van por stored procedures
- **Validaciones de datos**: En procedimientos almacenados
- **Eliminación lógica**: No se eliminan registros físicamente
- **Transacciones**: Operaciones atómicas con rollback automático

### ✅ Tablas Relacionadas
- **`tbAuxiliares`** - Tabla principal de auxiliares
- **`tbAsociados`** - Información de los socios
- **`tbRubros`** - Catálogo de rubros (Ahorros, Préstamos, etc.)
- **`tbTiposAuxiliares`** - Tipos específicos por rubro
- **`tbTipoAsociado`** - Tipos de asociados (Cliente, Proveedor)

## Datos de Prueba Incluidos

### Rubros
- **AHOR** - Ahorros
- **PERS** - Préstamos Personales
- **VIVI** - Préstamos de Vivienda
- **AUTO** - Préstamos de Vehículos

### Tipos de Auxiliares por Rubro
- **Ahorros**: Regular, Plazo Fijo
- **Préstamos Personales**: Estándar, Express
- **Préstamos de Vivienda**: Social, Comercial
- **Préstamos de Vehículos**: Nuevo, Usado

### Asociados de Prueba
- Juan Carlos Pérez González (1001)
- María Elena Rodríguez López (1002)
- Carlos Alberto García Morales (1003)

## Instalación

1. **Ejecutar Stored Procedures**:
   ```sql
   -- Ejecutar el archivo StoredProcedures_Auxiliares.sql
   ```

2. **Insertar Datos de Prueba** (opcional):
   ```sql
   -- Ejecutar el archivo Datos_Prueba_Auxiliares.sql
   ```

3. **Acceder al Módulo**:
   - URL: `/Forms/Auxiliares/AuxiliaresAsociados.aspx`

## WebMethods Disponibles

### Consultas
- `ObtenerRubros()` - Carga rubros en dropdowns
- `ObtenerTiposAuxiliares()` - Carga tipos de auxiliares
- `ObtenerTiposAuxiliaresPorRubro(codigoRubro)` - Tipos por rubro
- `ObtenerAuxiliares()` - Lista todos los auxiliares
- `FiltrarAuxiliares(busqueda, tipoAuxiliar, codigoRubro)` - Filtros
- `BuscarAsociados(busqueda)` - Búsqueda de asociados
- `ObtenerAuxiliar(id, numeroAsociado)` - Auxiliar específico

### Operaciones
- `GuardarAuxiliar(auxiliar)` - Crear/actualizar
- `EliminarAuxiliar(id, numeroAsociado)` - Eliminar

### Sistema
- `ObtenerParametrosInactividad()` - Parámetros de monitoreo
- `CerrarSesionPorInactividad()` - Cerrar sesión

## Notas Técnicas

- **Arquitectura**: WebMethods + Stored Procedures
- **Frontend**: Bootstrap 5 + jQuery + Sweet Alert
- **Base de Datos**: SQL Server con procedimientos almacenados
- **Seguridad**: Validaciones en SP, sin SQL injection
- **Performance**: Índices recomendados en tablas principales

## Mantenimiento

Para agregar nuevos tipos de auxiliares:
1. Insertar en `tbTiposAuxiliares`
2. Los dropdowns se actualizarán automáticamente

Para agregar nuevos rubros:
1. Insertar en `tbRubros`
2. Crear tipos asociados en `tbTiposAuxiliares`

































