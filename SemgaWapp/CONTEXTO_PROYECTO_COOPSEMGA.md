# Contexto del Proyecto Coopsemga

## 📋 Información General del Proyecto

**Nombre**: Coopsemga - Sistema de Gestión Cooperativa  
**Tecnología**: ASP.NET Web Forms con VB.NET  
**Framework**: .NET Framework 4.8  
**Base de Datos**: SQL Server  
**Año**: 2024-2025

---

## 🎯 Propósito del Sistema

Sistema de gestión completo para Cooperativa de Servicios Múltiples de Guararé Arriba, que incluye:
- Gestión de socios (asociados)
- Gestión de productos financieros (auxiliares)
- Transacciones bancarias
- Auditoría y logs
- Sistema de usuarios con roles
- Reportes y estadísticas

---

## 🏗️ Arquitectura del Proyecto

### Backend
- **Lenguaje**: VB.NET
- **Framework**: ASP.NET Web Forms
- **Métodos**: WebMethods con `ScriptMethod(ResponseFormat:=ResponseFormat.Json)`
- **Comunicación**: AJAX sin postbacks (arquitectura SPA-like)

### Base de Datos
- **Todas las consultas**: A través de stored procedures únicamente
- **NUNCA consultas SQL directas**
- **Patrón**: SBSqlClientInterface para todas las interacciones

### Frontend
- **Framework**: Bootstrap 5
- **JavaScript**: jQuery
- **Tablas**: DataTables
- **Modales**: Bootstrap modals
- **Notificaciones**: Sweet Alert
- **Validación**: Cliente y servidor

---

## 📁 Estructura de Directorios

```
SemgaWapp/
├── Clases/
│   ├── ModGlobal.vb          # Funciones globales, GetDbaObject, EscribirLog
│   └── VariablesSession.vb   # Constantes de sesión
├── Forms/                    # Formularios del sistema
│   ├── Login.aspx            # Autenticación
│   ├── Dashboard.aspx        # Panel principal
│   ├── Socios/               # Gestión de socios
│   ├── Auxiliares/           # Gestión de productos
│   ├── Transacciones/        # Movimientos
│   ├── Mantenimientos/       # Configuración
│   ├── Reportes/             # Reportes
│   └── Logs/                 # Auditoría
├── Scripts/                  # JavaScripts globales
├── DbScripts/               # Scripts SQL (150+ archivos)
└── Web.config               # Configuración
```

---

## 🔑 Módulos Principales Implementados

### 1. Autenticación y Seguridad
- **Login.aspx**: Sistema de login con validación
- **Encriptación**: SBEncryption (SHA256 con salt)
- **Seguridad**: Bloqueo de cuenta tras 3 intentos fallidos
- **Logs**: Registro de todos los accesos y operaciones
- **Sesiones**: Con información completa de contexto

### 2. Dashboard Principal
- **Dashboard.aspx**: Panel principal con métricas
- **Mini-gráficos**: Socios activos, auxiliares, movimientos
- **Mosaicos**: Acceso rápido a cada módulo
- **Monitoreo de inactividad**: Con parámetros configurables

### 3. Gestión de Socios (Forms/Socios/)
- **GestionSocios.aspx**: CRUD completo de socios
- **Modal con tabs**: 5 pestañas organizadas
- **Búsqueda**: Por ID, nombre o texto
- **Validaciones**: Números de identificación únicos

### 4. Gestión de Auxiliares (Forms/Auxiliares/)
- **AuxiliaresAsociados.aspx**: Gestión de productos por socio
- **Tipos**: Ahorros, Préstamos Personales, Vivienda, Vehículos
- **Rubros**: Categorización de productos
- **Busqueda inteligente**: Popup modal para seleccionar socios

### 5. Gestión de Usuarios (Forms/Mantenimientos/)
- **GestionUsuarios.aspx**: CRUD de usuarios
- **Roles**: Sistema de roles con niveles de acceso (0-10)
- **Departamentos**: Organización por departamentos
- **Validaciones**: Usuarios y emails únicos

### 6. Transacciones (Forms/Transacciones/)
- **Transacciones.aspx**: Movimientos de cuentas
- **Comprobantes**: Impresión de comprobantes
- **Códigos de transacción**: Categorización de movimientos

### 7. Auditoría y Logs (Forms/Logs/)
- **LogsAuditoria.aspx**: Registro completo de cambios
- **LogsAplicacion.aspx**: Logs de aplicación
- **LogsAccesos.aspx**: Historial de accesos
- **Triggers**: Automáticos en todas las tablas principales

### 8. Reportes y Configuración
- **Reportes.aspx**: Sistema de reportes
- **appParams.aspx**: Parámetros configurables
- **dashboardSistemas.aspx**: Panel de administración

---

## 🗄️ Base de Datos - Tablas Principales

### Tablas de Seguridad
- `tbUsuarios` - Usuarios del sistema
- `tbRoles` - Roles con niveles de acceso
- `tbDepartamentos` - Departamentos organizacionales
- `tbParamsKeys` - Parámetros configurables

### Tablas de Socios
- `tbAsociados` - Información de socios
- `tbTipoAsociado` - Tipos de asociados (Cliente, Proveedor)
- `tbBeneficiarios` - Beneficiarios de socios
- `tbParentezcos` - Tipos de parentesco

### Tablas de Auxiliares
- `tbAuxiliares` - Productos financieros
- `tbRubros` - Rubros (Ahorros, Préstamos, etc.)
- `tbTiposAuxiliares` - Tipos específicos por rubro

### Tablas de Transacciones
- `tbMovimientos` - Movimientos de cuentas
- `tbCodigosTransaccion` - Códigos de transacción

### Tablas de Auditoría
- `tbLogsAuditoria` - Registro de cambios con JSON
- Logs de aplicación (separados)

### Tablas de Referencia
- `tbProfesiones` - Catálogo de profesiones
- `tbOcupaciones` - Catálogo de ocupaciones
- `tbEmpresas` - Catálogo de empresas
- `tbPaises` - Paises
- `tbProvincias` - Provincias de Panamá
- `tbNivelesEstudio` - Niveles educativos

---

## 🔧 Clases y Funciones Clave

### ModGlobal.vb
```vb.net
' Obtener objeto de base de datos (DESENCRIPTA la connection string)
Public Function GetDbaObject(sCnn As String) As SBSqlClientInterface

' Escribir logs (archivo, BD o ambos)
Public Sub EscribirLog(Mensaje As String)

' Iniciar sesión de logs
Public Sub IniciarSesionLog(Usuario As String)

' Obtener valores de configuración
Public Function GetAppKey(KeyName As String) As String
```

### VariablesSession.vb
```vb.net
' Variables de sesión del usuario
Public Const UsuarioId As String = "UsuarioId"
Public Const Nombre As String = "Nombre"
Public Const Apellido As String = "Apellido"
Public Const Rol As String = "Rol"
Public Const NivelAcceso As String = "NivelAcceso"
Public Const logID As String = "LogID"

' Variables de parámetros
Public Const MONITOREAR_INACTIVIDAD As String = "MONITOREAR_INACTIVIDAD"
Public Const TIEMPO_MONITOREAR_INACTIVIDAD As String = "TIEMPO_MONITOREAR_INACTIVIDAD"
```

---

## 📝 Patrones de Código Estándar

### Estructura de WebMethod
```vb.net
<WebMethod(EnableSession:=True)>
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
Public Shared Function NombreMetodo(parametros) As String
    Dim serializer As New JavaScriptSerializer()
    Try
        ' 1. LOG INICIAL
        EscribirLog("Descripción de operación")
        
        ' 2. OBTENER OBJETO BD
        Dim uDBA As SBSqlClientInterface = GetDbaObject(Session(VariablesSesion.ConnectionString))
        
        ' 3. CONFIGURAR SQL (Siempre stored procedures)
        Dim sSql As String = "Exec spNombreProcedimiento"
        
        ' 4. AGREGAR PARÁMETROS CONDICIONALMENTE
        With uDBA.Parametros
            If Not String.IsNullOrEmpty(parametro) Then
                .Add("@Parametro", parametro)
            End If
        End With
        
        ' 5. LOG ANTES DE EJECUTAR
        EscribirLog($"Ejecutando: {sSql} {uDBA.getParamList()}")
        
        ' 6. EJECUTAR
        Dim dt As DataTable = uDBA.GetDataTableSql(sSql)
        
        ' 7. VALIDAR ERROR
        If uDBA.MensajeError <> "" Then
            EscribirLog($"❌ Error: {uDBA.MensajeError}")
            ' Retornar error
        End If
        
        ' 8. PROCESAR DATOS
        ' ...
        
        ' 9. RETORNAR ÉXITO
        Dim result As New Dictionary(Of String, Object)
        result("Success") = True
        result("Data") = datos
        Return serializer.Serialize(result)
        
    Catch ex As Exception
        ' 10. LOG Y RETORNAR ERROR
        EscribirLog($"❌ Error: {ex.Message} | StackTrace: {ex.StackTrace}")
        ' Retornar error
    End Try
End Function
```

### Estructura de Respuesta JSON
```json
{
    "Success": true/false,
    "Data": {...},
    "Message": "..."
}
```

### Métodos SBSqlClientInterface
- `GetDataTableSql(sSql)` - Para SELECT
- `ExecuteNonQuerySql(sSql)` - Para INSERT/UPDATE/DELETE
- `MensajeError` - Verificar errores de BD
- `Parametros.Add(nombre, valor)` - Agregar parámetros
- `getParamList()` - Para logging

---

## 🎨 Características Frontend

### Controles HTML Nativos
- Los formularios usan controles HTML nativos
- Comunicación via WebMethods/AJAX
- Sin postbacks tradicionales

### Librerías Principales
- **Bootstrap 5.3.0** - Framework CSS
- **jQuery 3.7.0** - Manipulación DOM y AJAX
- **DataTables 1.13.6** - Tablas dinámicas
- **Font Awesome 6.0** - Iconos
- **Sweet Alert 2** - Confirmaciones

### Patrones de UI
- **Modales**: Bootstrap modals con `data-bs-backdrop="static"`
- **Tablas**: DataTables con paginación, búsqueda, ordenamiento
- **Validación**: Cliente + Servidor
- **Loading**: Spinners durante operaciones
- **Notificaciones**: Toast notifications

---

## 🔒 Seguridad Implementada

### Autenticación
- **Hash**: SHA256 con salt único por usuario
- **Cookies**: HttpOnly, Secure, SameSite
- **Sesiones**: Timeout de 15 minutos (configurable)
- **Bloqueo**: Después de 3 intentos fallidos

### Validaciones
- **SQL Injection**: Parámetros siempre tipados
- **XSS**: Encoding de datos de usuario
- **CSRF**: SameSite cookies
- **Acceso**: Verificación de nivel de acceso

### Logs de Auditoría
- **Triggers**: Automáticos en tablas principales
- **JSON**: Guarda valores antes y después
- **Sesión**: ID de sesión en cada operación
- **Información completa**: Server, Browser, Network

---

## 📊 Flujo de Datos

### 1. Autenticación
```
Login.aspx → PageMethod ValidateLogin → SBSqlClientInterface → spUsuarios_ValidarLogin
```

### 2. Consultas
```
Cliente → AJAX → WebMethod → GetDbaObject → SBSqlClientInterface → SP → DataTable → JSON → Cliente
```

### 3. Operaciones CRUD
```
Cliente → AJAX → WebMethod → Validar Sesión → GetDbaObject → SP → Ejecutar → Log Auditoría → JSON → Cliente
```

---

## 🛠️ Funcionalidades Especiales

### Monitoreo de Inactividad
- **Parámetro**: `MONITOREAR_INACTIVIDAD` (1/0)
- **Timeout**: `TIEMPO_MONITOREAR_INACTIVIDAD` (minutos)
- **Script**: `Scripts/inactivity-monitor-final.js`
- **Modal**: Advertencia antes de cerrar sesión

### Busqueda Global de Asociados
- **Script**: `Scripts/global-associate-search.js`
- **Popup**: Búsqueda inteligente con chips
- **Filtros**: Por ID o texto

### Dashboard Dinámico
- **Carga**: Métricas en tiempo real
- **Mini-gráficos**: Distribución visual de datos
- **Contadores**: Socios activos, auxiliares, movimientos

---

## 🎯 Reglas de Desarrollo

### NUNCA HACER
- ❌ Consultas SQL directas (solo stored procedures)
- ❌ Postbacks tradicionales (solo WebMethods)
- ❌ Agregar parámetros sin validar si son null
- ❌ Olvidar verificar `MensajeError` después de ejecutar
- ❌ Crear WebMethods sin logging

### SIEMPRE HACER
- ✅ Usar SBSqlClientInterface para toda interacción con BD
- ✅ Validar parámetros antes de agregar a `Parametros`
- ✅ Verificar `uDBA.MensajeError` inmediatamente
- ✅ Loggear antes y después de operaciones
- ✅ Incluir StackTrace en excepciones
- ✅ Retornar JSON consistente `{Success, Data, Message}`
- ✅ Usar emojis en logs (🔍 ✅ ❌ 📊 etc.)

---

## 📦 Dependencias Principales

### DLLs en /bin
- `SBSqlClient.dll` - Cliente SQL
- `SBUtility.dll` - Utilidades (encriptación)
- `ClosedXML.dll` - Generación Excel
- `Newtonsoft.Json.dll` - Serialización JSON
- `DocumentFormat.OpenXml.dll` - Manipulación XML

---

## 🔍 Ubicación de Archivos Clave

### Configuración
- `Web.config` - Configuración principal y connection string
- `Clases/ModGlobal.vb` - Funciones globales
- `Clases/VariablesSession.vb` - Constantes

### Formularios Principales
- `Login.aspx` - Autenticación
- `Dashboard.aspx` - Panel principal
- `Forms/Socios/GestionSocios.aspx` - Socios
- `Forms/Auxiliares/AuxiliaresAsociados.aspx` - Auxiliares
- `Forms/Mantenimientos/GestionUsuarios.aspx` - Usuarios
- `Forms/Logs/LogsAuditoria.aspx` - Auditoría

### Scripts
- `Scripts/inactivity-monitor-final.js` - Monitoreo
- `Scripts/global-associate-search.js` - Búsqueda
- `Scripts/smart-chips.js` - Chips interactivos

### Documentación
- `PATRONES_CODIGO_PROYECTO.md` - Patrones de código
- `README.md` - Documentación general
- `SECURITY_FEATURES.md` - Características de seguridad

---

## 🎨 Configuración de Logs

### Tipos de Logs
```
LogType en Web.config:
- 0 = Solo archivo (Logs\LOG.DAT)
- 1 = Solo base de datos
- 2 = Ambos (archivo + BD)
```

### Estructura de Logs
```
Log Format: [Usr:ID Usuario ID:SessionID] - Mensaje
Ejemplo: [Usr:5 ID: A1B2C3D4] - 🔍 Buscando socio...
```

### Stored Procedures de Logs
- `spSysAppLogInicioSesion` - Inicio de sesión
- `spSysAppLogAdd` - Agregar log
- `spLogsAuditoria_ObtenerLogs` - Consultar auditoría

---

## 💾 Memoria del Proyecto (Reglas del Usuario)

Según las memorias guardadas:
- Preferencia de SBSqlClientInterface para BD [[memory:8856593]]
- Todos los queries por stored procedures [[memory:8856585]]
- WebMethods/AJAX sin postbacks [[memory:7043932]] [[memory:7043927]]
- Sweet Alert para confirmaciones [[memory:8862006]]
- Estado 'R' = 'READY' en azul [[memory:8856600]]
- Colores oscuros para porcentajes en imágenes [[memory:8862001]]
- Consultar antes de hacer cambios [[memory:8856609]]

---

## 📞 Información de Contacto del Proyecto

**Proyecto**: Coopsemga  
**Desarrollador**: Gilbe (usuario)  
**Organización**: SmartBizDevs  
**Cooperativa**: Cooperativa de Servicios Múltiples de Guararé Arriba

---

**Última actualización**: Enero 2025  
**Estado del proyecto**: En desarrollo activo

---

## 🔗 CONEXIÓN A BASE DE DATOS

### Connection String (Actual - Enero 2025)
```
Password=gilberto;Persist Security Info=True;User ID=sa;Initial Catalog=SegmaDB;Data Source=GIL-MAIN-PC\MSSQLSERVER01;
```

### Base de Datos
- **Nombre**: `SegmaDB`
- **Servidor**: `GIL-MAIN-PC\MSSQLSERVER01`
- **Usuario**: sa
- **Password**: gilberto

---

## 🗄️ ESTRUCTURA COMPLETA DE BASE DE DATOS

### ⚙️ PROCEDIMIENTOS ALMACENADOS (150+ Stored Procedures)

#### Gestión de Usuarios
- `spUsuarios_Listar`, `spUsuarios_Obtener`, `spUsuarios_Guardar`, `spUsuarios_Eliminar`

#### Gestión de Socios
- `spGestionSocios_ObtenerSocios`, `spGestionSocios_ActualizarSocio_Completo`
- `spGestionSocios_EliminarAsociado`, `spGestionSocios_Update*` (múltiples actualizaciones)

#### Gestión de Auxiliares
- `spAuxiliares_ObtenerRubros`, `spAuxiliares_ObtenerTiposAuxiliares`
- `spAuxiliares_ObtenerAuxiliares`, `spAuxiliares_GuardarAuxiliar`
- `spAuxiliares_EliminarAuxiliar_ConAuditoria_Final`

#### Gestión de Beneficiarios
- `spBeneficiarios_ObtenerParentezcos`, `spBeneficiarios_ObtenerBeneficiarios`
- `spBeneficiarios_CrearBeneficiario`

#### Logs y Auditoría
- `spLogsAuditoria_ObtenerLogs`, `spLogsAuditoria_ObtenerTablas`
- `spLogs_ObtenerLogAplicacion`, `spLogs_ObtenerLogAccesos`

#### Dashboard, Reportes, Respaldos
- `spGetDashboard`, `spReportes_Listar`
- `spRespaldos_Listar`, `spRespaldos_Guardar`, `spRespaldos_Restaurar`

#### Gestión de Países y Provincias
- `spPaises_Listar`, `spPaises_Guardar`, `spPaises_Eliminar`
- `spProvincias_Listar`, `spProvincias_Guardar`, `spProvincias_Eliminar`

### 🎯 TRIGGERS
- `tr_Auditoria_tbAsociados_JSON_Completo`
- `tr_Auditoria_tbBeneficiarios_JSON_Completo`
- `tr_Auditoria_tbAsociados_ConSessionInfo`
- `tr_Auditoria_tbBeneficiarios_ConSessionInfo`

### 🔧 FUNCIONES
- `fnAuditoria_ObtenerDescripciones`
- `fnAuditoria_Beneficiarios_Descripciones`
- `fnAuditoria_Corregidas_ConIDs`

---

## 📝 ACTUALIZACIONES RECIENTES

### Enero 2025
- ✅ Documentado patrón de uso de SBSqlClientInterface
- ✅ Documentado patrón de uso de WebMethods y respuestas JSON
- ✅ Documentado sistema de logs completo
- ✅ Agregada estructura completa de base de datos
- ✅ Agregada conexión actual a base de datos
- ✅ Analizados triggers de auditoría para tbAsociados y tbBeneficiarios
- ✅ Documentado manejo de encoding en archivos SQL (UTF-8 con BOM, NVARCHAR, N'...')
- ✅ Creado script de compilación con encoding UTF-8 (`COMPILAR_STORED_PROCEDURES.bat`)
- ✅ Implementado mantenimiento de Países y Provincias

---

## 🎯 TRIGGERS DE AUDITORÍA (Último Trabajo Realizado)

### Características de los Triggers

#### Tablas con Triggers de Auditoría
1. **tbAsociados** - Trigger: `tr_Auditoria_tbAsociados`
2. **tbBeneficiarios** - Trigger: `tr_Auditoria_tbBeneficiarios`

### Funcionalidad de los Triggers

#### Tipos de Operaciones Detectadas
- **'I'** - INSERT (Crear registro)
- **'U'** - UPDATE (Actualizar registro normal)
- **'D'** - SOFT DELETE (Eliminación lógica: snEliminado cambia de 0 a 1)
- **'X'** - DELETE físico (Eliminación física del registro)

#### Información Capturada
1. **JsonPrevio**: Estado anterior del registro (NULL para INSERT)
2. **JsonPosterior**: Estado nuevo del registro (NULL para DELETE físico)
3. **ServidorInfo**: Información de sesión desde `tbLogSesionHdr`
4. **Operación**: Código de operación (I, U, D, X)
5. **UsuarioId**: ID del usuario que realizó la operación
6. **FechaHora**: Timestamp de la operación
7. **Comentarios**: Descripción de la operación

### Proceso de los Triggers

#### 1. Determinación de Operación
```sql
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
BEGIN
    -- Verificar si es soft delete
    IF d.snEliminado = 0 AND i.snEliminado = 1
        SET @Operacion = 'D' -- SOFT DELETE
    ELSE
        SET @Operacion = 'U' -- UPDATE normal
END
ELSE IF EXISTS (SELECT * FROM inserted)
    SET @Operacion = 'I' -- INSERT
ELSE
    SET @Operacion = 'X' -- DELETE físico
```

#### 2. Obtención de SessionInfo
```sql
-- Obtener SessionInfo desde tbLogSesionHdr usando SysLastSessionID
SELECT @SessionInfo = ISNULL(SessionInfo, '') 
FROM tbLogSesionHdr 
WHERE IDSesion = @IdSession

-- Si no se encuentra, usar información básica
IF @SessionInfo = ''
BEGIN
    SET @SessionInfo = '{"Usuario":"' + CAST(@UsuarioId AS NVARCHAR(10)) + '",...}'
END
```

#### 3. Serialización a JSON
- **Campos serializados**: Todos los campos de la tabla
- **Funciones de traducción**: Usa funciones `fnAuditoria_Obtener*` para traducir IDs a descripciones
- **Formato**: JSON completo con valores descriptivos

#### 4. Uso de Cursors
- **Razón**: Procesar múltiples registros afectados en una sola operación
- **Tipos de cursors**:
  - `insert_cursor` - Para INSERT
  - `update_cursor` - Para UPDATE
  - `soft_delete_cursor` - Para SOFT DELETE
  - `delete_cursor` - Para DELETE físico

### Funciones de Traducción Utilizadas

#### Para tbAsociados
- `fnAuditoria_ObtenerTipoAsociado(IdTipoAsociado)` - Tipo de asociado
- `fnAuditoria_ObtenerTipoDocumento(TipoIdentificacion)` - Tipo de documento
- `fnAuditoria_ObtenerProvincia(Provincia)` - Provincia
- `fnAuditoria_ObtenerDistrito(Distrito)` - Distrito
- `fnAuditoria_ObtenerCorregimiento(Corregimiento)` - Corregimiento
- `fnAuditoria_ObtenerLugarTrabajo(LugarTrabajo)` - Lugar de trabajo
- `fnAuditoria_ObtenerOcupacion(Ocupacion)` - Ocupación
- `fnAuditoria_ObtenerPais(Pais)` - País
- `fnAuditoria_ObtenerNivelEstudio(NivelEstudio)` - Nivel de estudio
- `fnAuditoria_ObtenerProfesion(Profesion)` - Profesión
- `fnAuditoria_ObtenerUsuario(UsuarioId)` - Usuario

#### Para tbBeneficiarios
- `fnAuditoria_ObtenerTipoDocumento(TipoIdentificacion)` - Tipo de documento
- `fnAuditoria_ObtenerParentesco(IDParentezco)` - Parentesco
- `fnAuditoria_ObtenerUsuario(UsuarioId)` - Usuario

### Campos Especiales

#### tbAsociados
- **SysLastSessionID**: ID de sesión para obtener SessionInfo
- **UsuarioCrea**: Usuario que crea (para INSERT)
- **UsuarioModifica**: Usuario que modifica (para UPDATE)
- **UsuarioElimina**: Usuario que elimina (para SOFT DELETE)
- **snEliminado**: Flag de eliminación lógica

#### tbBeneficiarios
- **SysLastSessionID**: ID de sesión para obtener SessionInfo
- **UsuarioCrea**: Usuario que crea
- **UsuarioModifica**: Usuario que modifica
- **UsuarioElimina**: Usuario que elimina
- **Porcentaje**: Porcentaje de herencia
- **snEliminado**: Flag de eliminación lógica

### Tabla de Auditoría (tbLogsAuditoria)

#### Estructura
```sql
CREATE TABLE tbLogsAuditoria(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    TablaAfectada NVARCHAR(100),      -- 'tbAsociados' o 'tbBeneficiarios'
    RegistroId NVARCHAR(50),           -- NumeroAsociado o IDBeneficiario
    Operacion CHAR(1),                 -- I, U, D, X
    UsuarioId INT,
    FechaHora DATETIME2(7),
    JsonPrevio NVARCHAR(MAX),          -- NULL para INSERT
    JsonPosterior NVARCHAR(MAX),       -- NULL para DELETE físico
    ServidorInfo NVARCHAR(MAX),        -- SessionInfo desde tbLogSesionHdr
    Comentarios NVARCHAR(500)
)
```

#### Índices
- `IX_tbLogsAuditoria_TablaAfectada` - Filtrado por tabla
- `IX_tbLogsAuditoria_FechaHora` - Ordenamiento temporal
- `IX_tbLogsAuditoria_UsuarioId` - Filtrado por usuario

### Consulta de Logs de Auditoría

#### Stored Procedure
```sql
EXEC spLogsAuditoria_ObtenerLogs
    @TablaAfectada = 'tbAsociados',    -- opcional
    @UsuarioId = 5,                     -- opcional
    @FechaDesde = '2025-01-01',        -- opcional
    @FechaHasta = '2025-01-31',        -- opcional
    @Operacion = 'U'                    -- opcional
```

### Formato JSON de los Logs

#### Ejemplo de JsonPrevio/JsonPosterior
```json
{
  "NumeroAsociado": 1001,
  "IdTipoAsociado": "Socio Ordinario (1)",
  "Nombre": "Juan",
  "Apellido": "Pérez",
  "TipoIdentificacion": "Cédula (C)",
  "NumeroIdentificacion": "8-1234-5678",
  "ProvinciaResidencia": "Panamá (8)",
  "DistritoResidencia": "Panamá (1)",
  "LugarTrabajo": "Empresa ABC (5)",
  "Ocupacion": "Ingeniero (1)",
  "snEliminado": false,
  "UsuarioCrea": "John Doe (5)"
}
```

### SessionInfo desde tbLogSesionHdr

#### Contenido
- Información del usuario que realiza la operación
- ID de sesión único
- Información del servidor
- Información del navegador
- Información de red (IP, hostname)
- Timestamp de la operación

#### Ejemplo
```json
{
  "Usuario": "admin",
  "IdSesion": "A1B2C3D4-E5F6-7890",
  "HoraInicioSesion": "2025-01-01T08:00:00.000Z",
  "Servidor": {
    "ServerName": "GIL-MAIN-PC",
    "ServerTime": "2025-01-01T10:30:00.000Z",
    "TimeZone": "Central Standard Time",
    "OSVersion": "Microsoft Windows NT 10.0.26100.0"
  },
  "Request": {
    "UserAgent": "Mozilla/5.0...",
    "UserHostAddress": "192.168.1.100"
  }
}
```

### Función de SessionInfo desde SQL Server

#### Nombre: `fnAuditoria_ObtenerSessionInfo()`
- **Propósito**: Obtener información de sesión SQL cuando no hay SessionInfo en `tbLogSesionHdr`
- **Uso**: Especialmente útil para borrados físicos (tipo X)
- **Retorna**: JSON con información completa de la sesión SQL

#### Información Incluida en el JSON
```json
{
  "Tipo": "SessionInfoSQL",
  "Timestamp": "2025-01-29T15:19:55.033",
  "SPID": 56,
  "ServerName": "GIL-MAIN-PC",
  "DatabaseName": "SegmaDB",
  "LoginName": "sa",
  "UserName": "dbo",
  "HostName": "GIL-MAIN-PC",
  "AppName": "SQLCMD",
  "ProgramName": "SQLCMD",
  "ClientNetAddress": "<local machine>",
  "LoginTime": "2025-01-29T15:19:55.027",
  "CPU": 0,
  "MemoryUsage": 4,
  "Reads": 0,
  "Writes": 0,
  "ServerVersion": "16.0.1000.6",
  "ServerEdition": "Developer Edition (64-bit)",
  "ServerBuild": "RTM",
  "Language": "",
  "IsClustered": false,
  "IsIntegratedSecurityOnly": false,
  "MachineName": "GIL-MAIN-PC",
  "Nota": "Información obtenida directamente de la sesión SQL Server"
}
```

#### Uso en Triggers
Se debe usar cuando no hay SessionInfo disponible desde `tbLogSesionHdr`:
```sql
-- En borrados físicos o cuando no hay SessionInfo
SET @ServidorInfo = dbo.fnAuditoria_ObtenerSessionInfo()
```

#### Archivos
- **Script**: `DbScripts/fnAuditoria_ObtenerSessionInfo.sql`
- **Prueba**: `DbScripts/test_fnAuditoria_ObtenerSessionInfo.sql`
- **Estado**: ✅ Compilado y probado exitosamente

**Última actualización del documento**: Enero 2025 - Triggers actualizados para usar fnAuditoria_ObtenerSessionInfo en borrados físicos

---

## 📝 MANEJO DE ENCODING EN ARCHIVOS SQL

### 🔑 Reglas Importantes

Los archivos SQL deben estar correctamente codificados para manejar caracteres especiales del español (ñ, tildes, etc.).

### ✅ Configuración Requerida

#### 1. Encoding del Archivo
- **Formato**: UTF-8 con BOM (Byte Order Mark)
- **Razón**: SQL Server y `sqlcmd` requieren este formato para leer correctamente caracteres especiales
- **Verificación**: El archivo debe tener BOM (primeros bytes: `EF BB BF`)

#### 2. Tipos de Datos en Stored Procedures
- **Variables de mensaje**: Usar `NVARCHAR` en lugar de `VARCHAR`
- **Strings literales**: Usar prefijo `N'...'` para strings con caracteres especiales
- **Ejemplo**:
```sql
-- ❌ INCORRECTO
DECLARE @Mensaje VARCHAR(500) = 'El código es requerido'

-- ✅ CORRECTO
DECLARE @Mensaje NVARCHAR(500) = N'El código es requerido'
```

#### 3. Compilación con sqlcmd
- **Siempre usar**: `-f 65001` (UTF-8)
- **Formato**:
```batch
sqlcmd -S "SERVER\INSTANCE" -d DATABASE -U USER -P PASSWORD -f 65001 -i "archivo.sql"
```

### 📋 Estructura Estándar

```sql
CREATE PROCEDURE [dbo].[spEjemplo_Guardar]
    @ID INT = NULL,
    @Descripcion NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Variables (SIEMPRE NVARCHAR)
        DECLARE @Resultado NVARCHAR(20) = N'SUCCESS'
        DECLARE @Mensaje NVARCHAR(500) = N''
        
        -- Validaciones (usar N'...' para strings con caracteres especiales)
        IF @Descripcion IS NULL OR LTRIM(RTRIM(@Descripcion)) = ''
        BEGIN
            SET @Resultado = N'ERROR';
            SET @Mensaje = N'La descripción es requerida';
            ROLLBACK TRANSACTION;
            SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
            RETURN;
        END
        
        -- Lógica...
        
        SET @Mensaje = N'Registro guardado correctamente';
        COMMIT TRANSACTION;
        
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT N'ERROR' AS Resultado, N'Error: ' + ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO
```

### 🔧 Script de Compilación

**Ubicación**: `DbScripts/COMPILAR_STORED_PROCEDURES.bat`

El script compila todos los stored procedures con encoding UTF-8 automáticamente usando `-f 65001`.

### ⚠️ Problemas Comunes

#### Problema 1: Caracteres se ven mal en la consola de sqlcmd
- **Causa**: La consola de Windows no muestra correctamente caracteres Unicode
- **Solución**: Los datos en la base de datos están correctos. Es solo un problema de visualización
- **Verificación**: Consultar desde SQL Server Management Studio o desde la aplicación

#### Problema 2: Error "Bad escaped character"
- **Causa**: El archivo no está en UTF-8 con BOM
- **Solución**: Convertir el archivo a UTF-8 con BOM usando PowerShell:
```powershell
$content = Get-Content 'archivo.sql' -Raw -Encoding UTF8
$utf8WithBom = New-Object System.Text.UTF8Encoding $true
[System.IO.File]::WriteAllText('archivo.sql', $content, $utf8WithBom)
```

#### Problema 3: Mensajes en la BD muestran caracteres raros
- **Causa**: Variables de tipo `VARCHAR` en lugar de `NVARCHAR`
- **Solución**: Cambiar todas las variables de mensaje a `NVARCHAR` y usar `N'...'` para strings

### ✅ Checklist para Archivos SQL

- [ ] Archivo guardado en UTF-8 con BOM
- [ ] Variables de mensaje usan `NVARCHAR` en lugar de `VARCHAR`
- [ ] Strings literales con caracteres especiales usan prefijo `N'...'`
- [ ] Compilación realizada con `sqlcmd -f 65001`
- [ ] Verificación de mensajes desde la aplicación o SSMS

### 📚 Referencias

- **Script de compilación**: `DbScripts/COMPILAR_STORED_PROCEDURES.bat`
- **Code page UTF-8**: 65001
- **SQL Server Unicode**: `NVARCHAR` y prefijo `N'...'`
- **Documentación completa**: Ver `PATRONES_CODIGO_PROYECTO.md` sección 4

**Última actualización**: Enero 2025 - Configuración de encoding para archivos SQL

---

## 🧩 Estilos y Componentes Globales de UI

### Smart Chips (`Scripts/smart-chips.js`)
- `crearChipInteligente(tipo, valor, textoAdicional, mostrarNombre)` construye el HTML base a partir de `SmartChipsConfig`.
- Tipos principales: `tiposDocumento`, `rubros`, `tiposAsociado`, `estados`, `tiposAuxiliar`, `prioridades`.
- `crearChipTipoDocumento(codTipoDoc, numeroIdentificacion)` reutiliza la lógica para incrustar código + número en el mismo `badge`.
- Para nuevos chips se usa `agregarTipoChip(tipo, configuracion)` y `obtenerConfiguracionChip`.
- Todos los chips devuelven `<span class="badge ...">` listo para insertar en vistas o DataTables.

### Paneles/Divs de Confirmación Globales
- Estilos definidos en `Forms/...` (ej. `global-panel`, `global-panel-header`, `global-panel-body`, `global-panel-footer`, `global-card`).
- Cabeceras usan gradientes amarillos (`#facc15 → #fbbf24`), tipografía seguidora de confirmaciones estándar, y botones alineados con separación consistente.
- Cualquier modal que adopte `global-panel` hereda sombra, borde y radios uniformes.

### Toasts Globales (`Scripts/notifications.js`)
- `showToast(options)` y `showConfirmToast(options)` centralizan estilo y comportamiento (modalidad, backdrop).
- Clases comunes: `toast-confirm-neutral`, `toast-dialog`, `toast-confirm-backdrop`.
- Confirmaciones traen header neutro (amarillo suave), body blanco y botones con spacing uniforme.
- Todos los formularios eliminan implementaciones locales y llaman a estas funciones para garantizar consistencia.

---

## 📚 Referencias

- **Script de compilación**: `DbScripts/COMPILAR_STORED_PROCEDURES.bat`
- **Code page UTF-8**: 65001
- **SQL Server Unicode**: `NVARCHAR` y prefijo `N'...'`
- **Documentación completa**: Ver `PATRONES_CODIGO_PROYECTO.md` sección 4

**Última actualización**: Enero 2025 - Configuración de encoding para archivos SQL

### Cadena de conexión
- Cadena de conexión: `Password=gilberto;Persist Security Info=True;User ID=wappuser;Initial Catalog=SegmaDB;Data Source=GIL-MAIN-PC\MSSQLSERVER01;`
- Estándar de acceso a datos: todas las operaciones deben ejecutarse mediante procedimientos almacenados (sin consultas `SELECT` directas en el código). Para los catálogos de cuentas utilizar `spCuentas_ListarParaDropdown`.
- Para controles de fecha en la interfaz usamos el componente **Flatpickr** (formato visual `dd/MM/yyyy`, valor ISO para el servidor).
- Siempre que se envíe una fecha hacia un stored procedure, debe enviarse en formato `yyyyMMdd`.