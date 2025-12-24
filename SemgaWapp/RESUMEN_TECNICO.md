# 📋 RESUMEN TÉCNICO - Sistema Coopsemga

**Versión del Documento**: 1.0  
**Fecha**: Enero 2025  
**Aplicación**: SemgaWapp - Sistema de Gestión Cooperativa  
**Organización**: SmartBizDevs  
**Cooperativa**: Cooperativa de Servicios Múltiples de Guararé Arriba

---

## 📌 ÍNDICE

1. [Tecnologías y Frameworks](#tecnologías-y-frameworks)
2. [Requisitos del Sistema](#requisitos-del-sistema)
3. [Dependencias NuGet](#dependencias-nuget)
4. [CDNs y Recursos Externos](#cdns-y-recursos-externos)
5. [Scripts Locales](#scripts-locales)
6. [Base de Datos](#base-de-datos)
7. [Configuración](#configuración)
8. [Arquitectura](#arquitectura)
9. [Seguridad](#seguridad)
10. [Despliegue](#despliegue)

---

## 🛠️ TECNOLOGÍAS Y FRAMEWORKS

### Backend

| Tecnología | Versión | Descripción |
|------------|---------|-------------|
| **.NET Framework** | 4.8 | Framework base de la aplicación |
| **ASP.NET Web Forms** | 4.8 | Framework web para la interfaz |
| **VB.NET** | 4.8 | Lenguaje de programación principal |
| **C#** | 4.8 | Lenguaje secundario (mínimo uso) |

### Frontend

| Tecnología | Versión | Descripción |
|------------|---------|-------------|
| **HTML5** | - | Estructura de páginas |
| **CSS3** | - | Estilos y diseño responsive |
| **JavaScript (ES6+)** | - | Lógica del cliente |
| **jQuery** | 3.6.0 / 3.7.1 | Biblioteca JavaScript principal |
| **Bootstrap** | 5.3.0 | Framework CSS para UI responsive |
| **DataTables** | 1.13.6 | Plugin para tablas interactivas |
| **Font Awesome** | 6.4.0 | Iconos vectoriales |
| **Flatpickr** | Latest | Selector de fechas |
| **Select2** | 4.1.0-rc.0 | Dropdowns mejorados |
| **SweetAlert2** | 11 | Alertas y confirmaciones elegantes |

### Base de Datos

| Tecnología | Versión | Descripción |
|------------|---------|-------------|
| **Microsoft SQL Server** | 2019+ | Motor de base de datos |
| **T-SQL** | - | Lenguaje de consultas |
| **Stored Procedures** | 150+ | Lógica de negocio en BD |

### Librerías y Componentes

| Componente | Versión | Uso |
|------------|---------|-----|
| **SBSqlClient** | Custom | Cliente SQL personalizado |
| **SBUtility** | Custom | Utilidades del sistema |
| **SBEncryption** | Custom | Encriptación de datos |
| **SBLogWriter** | Custom | Sistema de logging |

---

## 💻 REQUISITOS DEL SISTEMA

### Servidor

#### Sistema Operativo
- **Windows Server** 2016 o superior
- **Windows 10/11** (desarrollo)
- **IIS (Internet Information Services)** 10.0 o superior

#### Software Requerido

| Software | Versión Mínima | Descripción |
|----------|----------------|-------------|
| **.NET Framework** | 4.8 | Runtime de .NET |
| **SQL Server** | 2019 | Base de datos |
| **SQL Server Management Studio (SSMS)** | 18.0+ | Administración de BD |
| **Visual Studio** | 2019+ | Desarrollo (opcional) |
| **IIS** | 10.0 | Servidor web |

#### Configuración IIS

- **Application Pool**: .NET Framework v4.0, modo integrado
- **Permisos**: Lectura y ejecución en la carpeta de la aplicación
- **Sesiones**: InProc (en memoria)
- **Timeout**: 1440 minutos (24 horas)

### Cliente (Navegador)

| Navegador | Versión Mínima | Notas |
|-----------|----------------|-------|
| **Google Chrome** | 90+ | Recomendado |
| **Microsoft Edge** | 90+ | Compatible |
| **Mozilla Firefox** | 88+ | Compatible |
| **Safari** | 14+ | Compatible (Mac) |

**Características Requeridas**:
- JavaScript habilitado
- Cookies habilitadas
- Soporte para ES6+
- Resolución mínima: 1024x768

### Red

- **Conexión a Internet**: Requerida para CDNs
- **Puerto HTTP**: 80 (producción)
- **Puerto HTTPS**: 443 (recomendado para producción)
- **Firewall**: Permitir conexión a SQL Server (puerto 1433 por defecto)

---

## 📦 DEPENDENCIAS NUGET

### Paquetes Instalados

| Paquete | Versión | Propósito |
|---------|---------|-----------|
| **ClosedXML** | 0.105.0 | Generación de archivos Excel |
| **ClosedXML.Parser** | 2.0.0 | Parser para ClosedXML |
| **DocumentFormat.OpenXml** | 3.1.1 | Manipulación de archivos Office (Excel, Word) |
| **DocumentFormat.OpenXml.Framework** | 3.1.1 | Framework para OpenXml |
| **ExcelNumberFormat** | 1.1.0 | Formato de números en Excel |
| **Newtonsoft.Json** | 13.0.3 | Serialización JSON |
| **Microsoft.CodeDom.Providers.DotNetCompilerPlatform** | 2.0.1 | Compilador de código dinámico |
| **RBush.Signed** | 4.0.0 | Estructura de datos espacial |
| **SixLabors.Fonts** | 1.0.0 | Manejo de fuentes |
| **System.Buffers** | 4.5.1 | Buffers optimizados |
| **System.Memory** | 4.5.5 | Tipos de memoria |
| **System.Numerics.Vectors** | 4.5.0 | Operaciones vectoriales |
| **System.Runtime.CompilerServices.Unsafe** | 4.7.0 | Operaciones no seguras |
| **Microsoft.Bcl.HashCode** | 1.1.1 | Hash codes |

### Instalación de Dependencias

```bash
# Restaurar paquetes NuGet
nuget restore SemgaWapp.sln

# O desde Visual Studio
# Tools > NuGet Package Manager > Restore NuGet Packages
```

**Ubicación de paquetes**: `packages/` (carpeta raíz del proyecto)

---

## 🌐 CDNs Y RECURSOS EXTERNOS

### CDNs Utilizados

#### Bootstrap 5
```html
<!-- CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>

<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
```
- **Versión**: 5.3.0
- **CDN**: jsdelivr.net
- **Uso**: Framework CSS y componentes UI

#### jQuery
```html
<!-- Versión 3.6.0 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Versión 3.7.1 (en algunos formularios) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
```
- **Versiones**: 3.6.0 y 3.7.1
- **CDNs**: code.jquery.com, cdnjs.cloudflare.com
- **Uso**: Manipulación DOM y AJAX

#### Font Awesome
```html
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
```
- **Versión**: 6.4.0
- **CDN**: cdnjs.cloudflare.com
- **Uso**: Iconos vectoriales

#### DataTables
```html
<!-- CSS -->
<link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>

<!-- JavaScript -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
```
- **Versión**: 1.13.6
- **CDN**: cdn.datatables.net
- **Uso**: Tablas interactivas con paginación, búsqueda y ordenamiento
- **Localización**: `https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json`

#### Flatpickr
```html
<!-- CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"/>

<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>
```
- **Versión**: Latest (última estable)
- **CDN**: jsdelivr.net
- **Uso**: Selector de fechas con localización en español

#### Select2
```html
<!-- CSS -->
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
<link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet"/>

<!-- JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
```
- **Versión**: 4.1.0-rc.0
- **CDN**: jsdelivr.net
- **Tema**: select2-bootstrap-5-theme 1.3.0
- **Uso**: Dropdowns mejorados con búsqueda

#### SweetAlert2
```html
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
```
- **Versión**: 11
- **CDN**: jsdelivr.net
- **Uso**: Alertas y diálogos de confirmación elegantes

### Resumen de CDNs

| CDN | Recursos | Versiones |
|-----|----------|-----------|
| **jsdelivr.net** | Bootstrap, Flatpickr, Select2, SweetAlert2 | Varias |
| **code.jquery.com** | jQuery | 3.6.0 |
| **cdnjs.cloudflare.com** | jQuery, Font Awesome, Bootstrap | Varias |
| **cdn.datatables.net** | DataTables | 1.13.6 |

**Nota**: La aplicación requiere conexión a Internet para cargar estos recursos. Para entornos sin Internet, se recomienda descargar y alojar localmente.

---

## 📁 SCRIPTS LOCALES

### Ubicación
```
Scripts/
```

### Scripts Disponibles

#### 1. `notifications.js`
- **Propósito**: Sistema global de notificaciones Toast
- **Funciones principales**:
  - `showToast(type, title, message, duration)`: Muestra notificaciones
  - `showConfirmToast(type, title, message, onConfirm, onCancel)`: Confirmaciones
  - `getToastIcon(type)`: Obtiene icono según tipo
- **Dependencias**: Bootstrap 5 Toast
- **Uso**: Reemplaza `alert()` nativo del navegador

#### 2. `smart-chips.js`
- **Propósito**: Sistema de chips/badges inteligentes
- **Funciones principales**:
  - `crearChipTipoDocumento(codTipoDoc, numeroIdentificacion)`: Chips para documentos
  - `crearChipRubro(rubro)`: Chips para rubros
  - `crearChipTipoAsociado(tipo)`: Chips para tipos de asociado
- **Configuración**: Colores y iconos predefinidos por tipo
- **Uso**: Visualización consistente de información categorizada

#### 3. `global-associate-search.js`
- **Propósito**: Componente global de búsqueda de asociados
- **Funciones principales**:
  - `crearBusquedaAsociados(containerId, config)`: Crea componente de búsqueda
  - `abrirBusquedaAsociados(config)`: Abre modal de búsqueda
- **Características**:
  - Búsqueda por nombre, cédula o número de asociado
  - Validación de auxiliares (opcional)
  - Callbacks personalizables
- **Uso**: Reutilizable en múltiples formularios

#### 4. `inactivity-monitor-final.js`
- **Propósito**: Monitoreo de inactividad del usuario
- **Versión**: 2.6
- **Características**:
  - Detección de inactividad configurable
  - Advertencias antes de cerrar sesión
  - Integración con parámetros de aplicación
- **Uso**: Seguridad y gestión de sesiones

#### 5. Otros Scripts
- `inactivity-monitor.js`: Versión anterior del monitor
- `inactivity-monitor-fixed.js`: Versión corregida
- `inactivity-monitor-overlay.js`: Versión con overlay
- `inactivity-monitor-standalone.js`: Versión independiente
- `AnalyzeDatabase.vb`: Utilidad de análisis de BD
- `analyze_database.sql`: Script SQL de análisis

### Inclusión de Scripts

Los scripts se incluyen en las páginas según necesidad:

```html
<!-- Ejemplo de inclusión -->
<script src="../../Scripts/notifications.js"></script>
<script src="../../Scripts/smart-chips.js"></script>
<script src="../../Scripts/global-associate-search.js"></script>
<script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
```

---

## 🗄️ BASE DE DATOS

### Información General

| Aspecto | Detalle |
|---------|---------|
| **Motor** | Microsoft SQL Server |
| **Versión Mínima** | SQL Server 2019 |
| **Nombre de BD** | `SegmaDB` |
| **Esquema Principal** | `dbo` |
| **Esquemas Adicionales** | `Security` (si aplica) |

### Cadena de Conexión

**Ubicación**: `Web.config` → `appSettings` → `ConnectionString`

**Formato**: Encriptada (usando SBEncryption)
```
jn81GfjSUuk9wxti1WiS8EuebbL91ABceOg6ePParTIM8Jrok+eAGO5BEn3ZsveFDQ+qn/GnrFg+vsUe8VwFk8qjT5urXfaes+wy5fBxJTr1YTFBj4Vc+COPJQBiQn3jLpSo4T1Zc8Cu8lKbmCuf159Bca6uIGsyN0NAoxwaKFQ=
```

**Desencriptada** (ejemplo):
```
Password=gilberto;Persist Security Info=True;User ID=sa;Initial Catalog=SegmaDB;Data Source=GIL-MAIN-PC\MSSQLSERVER01;
```

### Estructura de Base de Datos

#### Tablas Principales

| Tabla | Descripción |
|-------|-------------|
| `tbUsuarios` | Usuarios del sistema |
| `tbRoles` | Roles y permisos |
| `tbAsociados` | Socios de la cooperativa |
| `tbAuxiliares` | Productos financieros (ahorros, préstamos) |
| `tbMovimientos` | Transacciones financieras |
| `tbBeneficiarios` | Beneficiarios de asociados |
| `tbRubros` | Categorías de productos |
| `tbTiposAuxiliares` | Tipos de productos financieros |
| `tbCodigosTransaccion` | Códigos de transacciones |
| `tbLogsAuditoria` | Logs de auditoría |
| `tbLogsAplicacion` | Logs de aplicación |
| `tbReportesComandos` | Comandos de reportes |
| `tbRespaldos` | Registro de respaldos |
| `tbConfiguraciones` | Parámetros de configuración |
| `tbPaises` | Catálogo de países |
| `tbProvincias` | Catálogo de provincias |
| `tbDistritos` | Catálogo de distritos |
| `tbCorregimientos` | Catálogo de corregimientos |
| `tbTipoDocumentos` | Tipos de documentos de identidad |
| `tbTipoAsociado` | Tipos de asociados |
| `tbStatusAsociado` | Estados de asociados |
| `tbParentezcos` | Relaciones familiares |
| `tbNivelesEstudio` | Niveles educativos |
| `tbProfesiones` | Profesiones |
| `tbOcupaciones` | Ocupaciones |
| `tbEmpresas` | Empresas |
| `tbDepartamentos` | Departamentos organizacionales |

#### Stored Procedures (150+)

**Ubicación**: `DbScripts/`

**Categorías**:

1. **Usuarios y Autenticación**
   - `sp_AutenticarUsuario`
   - `spUsuarios_Listar`
   - `spUsuarios_Obtener`
   - `spUsuarios_Guardar`
   - `spUsuarios_Eliminar`

2. **Roles y Permisos**
   - `spRoles_Listar`
   - `spRoles_Guardar`
   - `spRoles_Eliminar`

3. **Socios (Asociados)**
   - `spGestionSocios_ObtenerSocios`
   - `spGestionSocios_ActualizarSocio_Completo`
   - `spGestionSocios_EliminarAsociado`
   - `spGestionSocios_Update*` (múltiples actualizaciones específicas)

4. **Auxiliares**
   - `spAuxiliares_ObtenerRubros`
   - `spAuxiliares_ObtenerTiposAuxiliares`
   - `spAuxiliares_ObtenerAuxiliares`
   - `spAuxiliares_GuardarAuxiliar`
   - `spAuxiliares_EliminarAuxiliar_ConAuditoria_Final`
   - `spAuxiliares_ModificarMontoPignorado`
   - `spAuxiliares_FiltrarAuxiliares`

5. **Movimientos y Transacciones**
   - `spMovimientos_Listar`
   - `spMovimientos_ListarPorSocio`
   - `spMovimientos_GuardarMovimiento`
   - `spMovimientos_MarcarImpreso`
   - `spMovimientos_ObtenerDatosComprobante`

6. **Beneficiarios**
   - `spBeneficiarios_ObtenerParentezcos`
   - `spBeneficiarios_ObtenerBeneficiarios`
   - `spBeneficiarios_CrearBeneficiario`

7. **Logs y Auditoría**
   - `spLogsAuditoria_ObtenerLogs`
   - `spLogsAuditoria_ObtenerTablas`
   - `spLogs_ObtenerLogAplicacion`
   - `spLogs_ObtenerLogAccesos`
   - `spLogs_ObtenerDetalleLogAplicacion`
   - `spSysAppLogInicioSesion`
   - `spSysAppLogAdd`

8. **Dashboard y Reportes**
   - `spGetDashboard`
   - `spReportes_Listar`
   - `spRespaldos_Listar`
   - `spRespaldos_Guardar`
   - `spRespaldos_Restaurar`

9. **Catálogos**
   - `spRubros_Listar`, `spRubros_Guardar`, `spRubros_Eliminar`
   - `spCodigosTransaccion_Listar`, `spCodigosTransaccion_Guardar`, `spCodigosTransaccion_Eliminar`
   - `spTiposAuxiliares_Listar`, `spTiposAuxiliares_Guardar`, `spTiposAuxiliares_Eliminar`
   - `spPaises_Listar`, `spPaises_Guardar`, `spPaises_Eliminar`
   - `spProvincias_Listar`, `spProvincias_Guardar`, `spProvincias_Eliminar`
   - `spDistritos_Listar`, `spDistritos_Guardar`, `spDistritos_Eliminar`
   - `spCorregimientos_Listar`, `spCorregimientos_Guardar`, `spCorregimientos_Eliminar`
   - `spTipoDocumentos_Listar`, `spTipoDocumentos_Guardar`, `spTipoDocumentos_Eliminar`
   - `spTipoAsociado_Listar`, `spTipoAsociado_Guardar`, `spTipoAsociado_Eliminar`
   - `spStatusAsociado_Listar`, `spStatusAsociado_Guardar`, `spStatusAsociado_Eliminar`
   - `spParentezcos_Listar`, `spParentezcos_Guardar`, `spParentezcos_Eliminar`
   - `spNivelesEstudio_Listar`, `spNivelesEstudio_Guardar`, `spNivelesEstudio_Eliminar`
   - `spOcupaciones_Listar`, `spOcupaciones_Guardar`, `spOcupaciones_Eliminar`
   - `spEmpresas_Listar`, `spEmpresas_Guardar`, `spEmpresas_Eliminar`
   - `spDepartamentos_Listar`, `spDepartamentos_Guardar`, `spDepartamentos_Eliminar`

10. **Parámetros**
    - `spParametrosAplicacion_Listar`
    - `spParametrosAplicacion_ListarGrupos`
    - `spParametrosAplicacion_Guardar`

#### Funciones

- `fnAuditoria_ObtenerDescripciones`: Obtiene descripciones para auditoría
- `fnAuditoria_Beneficiarios_Descripciones`: Descripciones para beneficiarios
- `fnAuditoria_ObtenerSessionInfo`: Información de sesión para auditoría

#### Triggers

- `tr_Auditoria_tbAsociados_ConSessionInfo`: Auditoría de cambios en asociados
- `tr_Auditoria_tbBeneficiarios_ConSessionInfo`: Auditoría de cambios en beneficiarios
- `tr_Auditoria_tbAsociados_JSON_Completo`: Auditoría JSON completa de asociados
- `tr_Auditoria_tbBeneficiarios_JSON_Completo`: Auditoría JSON completa de beneficiarios

### Scripts de Base de Datos

**Ubicación**: `DbScripts/`

**Archivos Principales**:
- `Database_Schema.sql`: Esquema completo de la base de datos
- `Database_StoredProcedures_*.sql`: Stored procedures por módulo
- `Database_Data_*.sql`: Datos iniciales y de prueba
- `sp_*.sql`: Stored procedures individuales
- `tr_*.sql`: Triggers
- `fn_*.sql`: Funciones
- `*.bak`: Archivos de respaldo

### Patrón de Acceso a Datos

**Regla Fundamental**: **TODAS las consultas se realizan mediante Stored Procedures**

- ❌ **NO se permiten consultas SQL directas**
- ✅ **SÍ se usan Stored Procedures exclusivamente**
- **Cliente SQL**: `SBSqlClientInterface` (custom)
- **Método**: `GetDbaObject(connectionString)`

**Ejemplo**:
```vb
Dim objSql As SBSqlClientInterface = GetDbaObject(Session(VariablesSesion.ConnectionString))
Dim sSql As String = "Exec spUsuarios_Listar"
Dim dt As DataTable = objSql.GetDataTableSql(sSql)
```

---

## ⚙️ CONFIGURACIÓN

### Web.config

**Ubicación**: Raíz del proyecto

#### AppSettings Principales

| Clave | Valor | Descripción |
|-------|-------|-------------|
| `appName` | Coopsemga | Nombre de la aplicación |
| `ConnectionString` | (encriptada) | Cadena de conexión a BD |
| `Environment` | prod/dev | Ambiente de ejecución |
| `MaxLoginAttempts` | 3 | Intentos máximos de login |
| `SessionTimeoutMinutes` | 15 | Timeout de sesión (minutos) |
| `PasswordMinLength` | 8 | Longitud mínima de contraseña |
| `RequireSpecialChars` | true | Requiere caracteres especiales |
| `RequireNumbers` | true | Requiere números |
| `RequireUppercase` | true | Requiere mayúsculas |
| `PasswordExpiryDays` | 90 | Días de expiración de contraseña |
| `EnableTwoFactorAuth` | true | Habilitar 2FA |
| `EnableAccountLockout` | true | Habilitar bloqueo de cuenta |
| `LockoutDurationMinutes` | 30 | Duración del bloqueo |
| `EnableAuditLog` | true | Habilitar logs de auditoría |
| `LogLevel` | Information | Nivel de logging |
| `LogFilePath` | C:\Logs\SemgaBank\ | Ruta de archivos de log |
| `LogType` | 2 | Tipo de log (0=File, 1=BD, 2=Ambos) |
| `MaintenanceMode` | false | Modo mantenimiento |
| `SMTP_Server` | smtp.office365.com | Servidor SMTP |
| `SMTP_Port` | 587 | Puerto SMTP |
| `SMTP_Username` | noreply@semgabank.com | Usuario SMTP |
| `SMTP_Password` | (encriptada) | Contraseña SMTP |
| `SMTP_EnableSSL` | true | Habilitar SSL para SMTP |

#### Configuración de Compilación

```xml
<compilation debug="true" strict="false" explicit="true" targetFramework="4.8">
```

#### Configuración de Sesión

```xml
<sessionState cookieless="UseCookies" mode="InProc" timeout="1440" />
```
- **Timeout**: 1440 minutos (24 horas)
- **Modo**: InProc (en memoria del servidor)
- **Cookies**: Habilitadas

#### Configuración de Autenticación

```xml
<authentication mode="Forms">
    <forms loginUrl="Login.aspx" name="secauth" protection="All" timeout="1440" />
</authentication>
```

#### Configuración de Globalización

```xml
<globalization culture="es-US" uiCulture="es-US" requestEncoding="utf-8" responseEncoding="utf-8" />
```
- **Idioma**: Español (Estados Unidos)
- **Codificación**: UTF-8

### Variables de Sesión

**Clase**: `VariablesSesion.vb`

**Constantes definidas**:
- `UsuarioId`: ID del usuario
- `Nombre`: Nombre del usuario
- `Apellido`: Apellido del usuario
- `NombreUsuario`: Nombre de usuario
- `Email`: Email del usuario
- `Rol`: ID del rol
- `Departamento`: ID del departamento
- `NivelAcceso`: Nivel de acceso (0-10)
- `RolNombre`: Nombre del rol
- `DepartamentoNombre`: Nombre del departamento
- `ConnectionString`: Cadena de conexión
- `IsAuthenticated`: Estado de autenticación
- `LoginTime`: Hora de login
- `LastActivity`: Última actividad
- `logID`: ID de sesión para logs

---

## 🏗️ ARQUITECTURA

### Patrón de Arquitectura

**Tipo**: ASP.NET Web Forms con arquitectura SPA-like (Single Page Application)

### Capas de la Aplicación

```
┌─────────────────────────────────────┐
│   PRESENTACIÓN (Frontend)           │
│   - HTML/CSS/JavaScript             │
│   - Bootstrap 5                     │
│   - jQuery + Plugins                │
└─────────────────────────────────────┘
              ↕ AJAX/JSON
┌─────────────────────────────────────┐
│   LÓGICA DE NEGOCIO (Backend)       │
│   - ASP.NET Web Forms (.aspx)       │
│   - Code-Behind (.aspx.vb)          │
│   - WebMethods (JSON)               │
└─────────────────────────────────────┘
              ↕ SBSqlClient
┌─────────────────────────────────────┐
│   ACCESO A DATOS                    │
│   - Stored Procedures               │
│   - SBSqlClientInterface            │
└─────────────────────────────────────┘
              ↕ T-SQL
┌─────────────────────────────────────┐
│   BASE DE DATOS                     │
│   - SQL Server                      │
│   - Stored Procedures               │
│   - Triggers                        │
│   - Funciones                       │
└─────────────────────────────────────┘
```

### Comunicación Cliente-Servidor

**Método**: AJAX con WebMethods

**Formato**: JSON

**Ejemplo de llamada**:
```javascript
$.ajax({
    type: "POST",
    url: "Formulario.aspx/MetodoWeb",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    data: JSON.stringify({ parametro: valor }),
    success: function(response) {
        // Procesar respuesta
    }
});
```

**Ejemplo de WebMethod**:
```vb
<WebMethod()>
<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
Public Shared Function MetodoWeb(parametro As String) As Object
    ' Lógica del método
    Return New With {
        .Resultado = "SUCCESS",
        .Datos = datos,
        .Mensaje = ""
    }
End Function
```

### Estructura de Directorios

```
SemgaWapp/
├── Clases/                          # Clases compartidas
│   ├── ModGlobal.vb                # Funciones globales
│   └── VariablesSession.vb          # Constantes de sesión
├── Forms/                           # Formularios
│   ├── Login.aspx                  # Autenticación
│   ├── Dashboard.aspx              # Panel principal
│   ├── Socios/                     # Gestión de socios
│   ├── Auxiliares/                 # Productos financieros
│   ├── Transacciones/              # Movimientos
│   ├── Mantenimientos/             # Configuración
│   ├── Reportes/                   # Reportes
│   ├── Finanzas/                   # Módulo financiero
│   ├── Logs/                       # Auditoría
│   └── Sistemas/                   # Sistema
├── Scripts/                         # JavaScripts globales
│   ├── notifications.js
│   ├── smart-chips.js
│   ├── global-associate-search.js
│   └── inactivity-monitor-final.js
├── DbScripts/                       # Scripts SQL
│   ├── Database_Schema.sql
│   ├── Database_StoredProcedures_*.sql
│   ├── sp_*.sql
│   └── tr_*.sql
├── bin/                            # Binarios compilados
├── obj/                            # Archivos de compilación
├── packages/                       # Paquetes NuGet
├── Web.config                      # Configuración
└── packages.config                 # Dependencias NuGet
```

### Módulos Principales

1. **Autenticación y Seguridad**
   - Login con validación
   - Encriptación de contraseñas
   - Bloqueo de cuentas
   - Logs de acceso

2. **Dashboard**
   - Métricas y estadísticas
   - Acceso rápido a módulos
   - Monitoreo de actividad

3. **Gestión de Socios**
   - CRUD completo de asociados
   - Beneficiarios
   - Información personal y laboral

4. **Gestión de Auxiliares**
   - Productos financieros
   - Tipos y rubros
   - Montos y tasas

5. **Transacciones**
   - Movimientos financieros
   - Comprobantes
   - Historial

6. **Mantenimientos**
   - Usuarios y roles
   - Catálogos
   - Parámetros del sistema

7. **Reportes**
   - Reportes personalizados
   - Exportación a Excel
   - Filtros avanzados

8. **Logs y Auditoría**
   - Registro de operaciones
   - Trazabilidad completa
   - Consulta de historial

---

## 🔒 SEGURIDAD

### Autenticación

- **Método**: Forms Authentication
- **Encriptación**: SHA256 con salt
- **Sesiones**: Basadas en cookies
- **Timeout**: 1440 minutos (24 horas)

### Autorización

- **Sistema de Roles**: Basado en niveles de acceso (0-10)
- **Niveles definidos**:
  - **0**: Super Usuario
  - **1**: Administrador
  - **2**: Agente
  - **3+**: Usuarios con permisos limitados

### Validaciones

- **Cliente**: JavaScript para UX
- **Servidor**: VB.NET para seguridad
- **Base de Datos**: Stored Procedures con validaciones

### Encriptación

- **Connection String**: Encriptada con SBEncryption
- **Contraseñas**: Hash SHA256 con salt
- **Datos Sensibles**: Encriptados antes de almacenar

### Logs de Seguridad

- **Intentos de Login**: Registrados
- **Operaciones Críticas**: Auditadas
- **Cambios de Datos**: Triggers de auditoría
- **Sesiones**: Rastreadas con ID único

---

## 🚀 DESPLIEGUE

### Requisitos Previos

1. **Servidor Windows** con IIS instalado
2. **SQL Server** configurado y ejecutándose
3. **.NET Framework 4.8** instalado
4. **Permisos** de lectura/escritura en carpetas de logs

### Pasos de Despliegue

#### 1. Preparar Base de Datos

```sql
-- Ejecutar scripts en orden:
-- 1. Database_Schema.sql
-- 2. Database_StoredProcedures_*.sql
-- 3. Database_Data_*.sql (datos iniciales)
```

#### 2. Configurar Web.config

- Actualizar `ConnectionString` (encriptada)
- Configurar `LogFilePath`
- Ajustar `Environment` (prod/dev)
- Configurar SMTP si aplica

#### 3. Publicar Aplicación

**Desde Visual Studio**:
1. Click derecho en proyecto → Publish
2. Seleccionar perfil de publicación
3. Configurar destino (IIS, File System, etc.)
4. Publicar

**Manual**:
1. Compilar solución (Release)
2. Copiar archivos a carpeta de IIS
3. Configurar Application Pool

#### 4. Configurar IIS

1. **Crear Application Pool**:
   - .NET Framework v4.0
   - Modo: Integrated
   - Identity: ApplicationPoolIdentity (o cuenta específica)

2. **Crear Sitio Web**:
   - Asignar Application Pool
   - Configurar ruta física
   - Configurar binding (HTTP/HTTPS)

3. **Permisos**:
   - IIS_IUSRS: Lectura y ejecución
   - Carpeta de logs: Escritura

#### 5. Verificar

- Acceder a `http://servidor/Login.aspx`
- Verificar conexión a BD
- Verificar logs
- Probar funcionalidades principales

### Mantenimiento

#### Respaldos

- **Base de Datos**: Programar respaldos automáticos
- **Aplicación**: Respaldo de archivos antes de actualizaciones
- **Logs**: Rotación periódica

#### Actualizaciones

1. Respaldo completo
2. Detener aplicación (opcional)
3. Copiar nuevos archivos
4. Ejecutar scripts de migración de BD (si aplica)
5. Reiniciar Application Pool
6. Verificar funcionamiento

---

## 📊 MÉTRICAS Y MONITOREO

### Logs

**Ubicación**: `C:\Logs\SemgaBank\` (configurable)

**Tipos**:
- **Archivo**: `LOG.DAT` (texto plano)
- **Base de Datos**: Tablas `tbLogsAplicacion`, `tbLogsAuditoria`

**Niveles**:
- Information
- Warning
- Error
- Critical

### Performance

- **Sesiones**: InProc (rápido, pero no escalable)
- **Conexiones**: Pooling habilitado
- **Stored Procedures**: Optimizados con índices

---

## 🔧 HERRAMIENTAS DE DESARROLLO

### IDE Recomendado

- **Visual Studio 2019+**
- **Visual Studio Code** (para edición de scripts)

### Extensiones Útiles

- SQL Server Management Studio (SSMS)
- SQL Server Data Tools (SSDT)
- NuGet Package Manager

### Debugging

- **Cliente**: DevTools del navegador (F12)
- **Servidor**: Visual Studio Debugger
- **Base de Datos**: SQL Profiler, SSMS

---

## 📝 NOTAS IMPORTANTES

### ⚠️ Consideraciones

1. **Conexión a Internet**: Requerida para CDNs
2. **Encriptación**: Connection String debe estar encriptada
3. **Permisos**: Verificar permisos de carpetas de logs
4. **Sesiones**: InProc no es escalable para múltiples servidores
5. **Stored Procedures**: NUNCA usar SQL directo

### ✅ Buenas Prácticas

1. Siempre usar Stored Procedures
2. Validar en cliente Y servidor
3. Registrar operaciones críticas
4. Mantener respaldos actualizados
5. Revisar logs regularmente

---

## 📞 SOPORTE

Para consultas técnicas o problemas:
- Revisar logs en `C:\Logs\SemgaBank\`
- Consultar `CONTEXTO_PROYECTO_COOPSEMGA.md` para detalles del proyecto
- Revisar documentación de módulos específicos en `Forms/*/README_*.md`

---

**Última actualización**: Enero 2025  
**Versión del Sistema**: 1.0.0  
**Mantenido por**: SmartBizDevs





