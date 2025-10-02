# SemgaBank - Aplicación Bancaria Segura

## Descripción

SemgaBank es una aplicación web bancaria desarrollada en ASP.NET Web Forms con VB.NET, diseñada con múltiples capas de seguridad para proteger la información sensible de los usuarios y cumplir con los estándares de la industria bancaria.

## Características Principales

### 🔒 Seguridad Implementada
- **Autenticación Forms** con SSL requerido
- **Headers de seguridad HTTP** (X-Frame-Options, XSS Protection, HSTS, CSP)
- **Cookies seguras** (HttpOnly, Secure, SameSite)
- **Hash SHA256** con salt único para contraseñas
- **Bloqueo automático** de cuentas después de 3 intentos fallidos
- **Validación de entrada** robusta
- **Logging completo** de auditoría
- **Protección contra ataques** (SQL Injection, XSS, CSRF, Brute Force)

### 🎨 Interfaz Moderna
- **Diseño responsivo** y elegante
- **Controles HTML nativos** con WebMethods
- **Validación en tiempo real** con JavaScript
- **Animaciones suaves** y efectos visuales
- **Indicadores de fortaleza** de contraseña
- **Barras de progreso** para validación

### 📊 Funcionalidades
- **Login seguro** con WebMethods
- **Dashboard** con información de cuenta
- **Gestión de sesiones** segura
- **Logout** con limpieza de cookies
- **Modo mantenimiento** configurable

## Instalación y Configuración

### Prerrequisitos
- Visual Studio 2019 o superior
- .NET Framework 4.8
- SQL Server 2016 o superior
- IIS (para producción)

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd SemgaWapp
   ```

2. **Configurar la base de datos**
   - Ejecutar el script `Database_Schema.sql` en SQL Server
   - Crear la base de datos `SemgaBankDB`
   - Verificar que se creen todas las tablas del esquema `Security`

3. **Configurar Web.config**
   - Actualizar la cadena de conexión en `appSettings`
   - Configurar las rutas de logs
   - Ajustar configuraciones de seguridad según necesidades

4. **Crear usuario de prueba**
   ```sql
   -- Ejecutar en SQL Server Management Studio
   USE SemgaBankDB;
   
   -- Insertar usuario de prueba (contraseña: Test123!)
   INSERT INTO Security.Users (Username, PasswordHash, Salt, IsActive, LastPasswordChange)
   VALUES ('admin', 'HASH_GENERADO', 'SALT_GENERADO', 1, GETDATE());
   ```

5. **Compilar y ejecutar**
   - Abrir la solución en Visual Studio
   - Restaurar paquetes NuGet si es necesario
   - Compilar la solución
   - Ejecutar en modo debug

## Estructura del Proyecto

```
SemgaWapp/
├── Login.aspx              # Página de login principal
├── Login.aspx.vb           # Código behind del login
├── Dashboard.aspx          # Página de dashboard
├── Dashboard.aspx.vb       # Código behind del dashboard
├── Web.config              # Configuración de la aplicación
├── Database_Schema.sql     # Script de base de datos
├── SECURITY_FEATURES.md    # Documentación de seguridad
└── README.md              # Este archivo
```

## Configuración de Seguridad

### Web.config - AppSettings
```xml
<appSettings>
    <!-- Configuraciones de seguridad -->
    <add key="MaxLoginAttempts" value="3" />
    <add key="SessionTimeoutMinutes" value="15" />
    <add key="PasswordMinLength" value="8" />
    <add key="RequireSpecialChars" value="true" />
    <add key="RequireNumbers" value="true" />
    <add key="RequireUppercase" value="true" />
    <add key="PasswordExpiryDays" value="90" />
    <add key="EnableTwoFactorAuth" value="true" />
    <add key="EnableAccountLockout" value="true" />
    <add key="LockoutDurationMinutes" value="30" />
    
    <!-- Configuraciones de conexión -->
    <add key="ConnectionString" value="..." />
    <add key="EncryptionKey" value="..." />
    
    <!-- Configuraciones de logging -->
    <add key="EnableAuditLog" value="true" />
    <add key="LogLevel" value="Information" />
    <add key="LogFilePath" value="C:\Logs\SemgaBank\" />
</appSettings>
```

### Headers de Seguridad
La aplicación incluye headers de seguridad automáticos:
- **X-Frame-Options**: DENY
- **X-Content-Type-Options**: nosniff
- **X-XSS-Protection**: 1; mode=block
- **Strict-Transport-Security**: HSTS forzado
- **Content-Security-Policy**: Política de seguridad de contenido
- **Referrer-Policy**: strict-origin-when-cross-origin

## WebMethods Disponibles

### Login.aspx
- `ValidateLogin(username, password)` - Validar credenciales
- `GetApplicationStatus()` - Obtener estado de la aplicación
- `ValidatePasswordStrength(password)` - Validar fortaleza de contraseña
- `GetSecurityInfo()` - Obtener información de seguridad

## Uso de la Aplicación

### 1. Acceso al Login
- Navegar a `http://localhost:port/Login.aspx`
- La página mostrará un formulario de login elegante

### 2. Proceso de Login
- Ingresar usuario y contraseña
- La validación se realiza en tiempo real
- Los WebMethods manejan la autenticación
- En caso de éxito, redirección al dashboard

### 3. Dashboard
- Muestra información de la cuenta
- Opciones de configuración
- Estado de seguridad
- Botón de logout

### 4. Logout
- Cerrar sesión de forma segura
- Limpieza de cookies
- Redirección al login

## Características de Seguridad Detalladas

### Validación de Entrada
- **Longitud mínima** de usuario (3 caracteres)
- **Longitud mínima** de contraseña (8 caracteres)
- **Caracteres permitidos** en usuario (solo alfanuméricos y guiones bajos)
- **Validación de fortaleza** de contraseña en tiempo real

### Gestión de Sesiones
- **Timeout configurable** (15 minutos por defecto)
- **Cookies seguras** (HttpOnly, Secure, SameSite)
- **Regeneración de IDs** de sesión
- **Limpieza automática** de sesiones expiradas

### Protección contra Ataques
- **SQL Injection**: Uso de parámetros en todas las consultas
- **XSS**: Validación y encoding de entrada
- **CSRF**: Tokens y SameSite cookies
- **Brute Force**: Bloqueo automático de cuentas
- **Session Hijacking**: Cookies seguras y timeout

### Logging y Auditoría
- **Logs de autenticación** detallados
- **Logs de errores** del sistema
- **Logs de auditoría** de usuarios
- **Almacenamiento seguro** de logs

## Mantenimiento

### Logs
Los logs se almacenan en la ruta configurada en `LogFilePath`:
- `SemgaBank_Errors.log` - Errores del sistema
- `SemgaBank_Audit.log` - Logs de auditoría

### Base de Datos
- Ejecutar `sp_CleanupOldLogs` diariamente para limpiar logs antiguos
- Monitorear el tamaño de las tablas de logs
- Realizar backups regulares

### Configuración
- Revisar configuraciones de seguridad regularmente
- Actualizar claves de encriptación periódicamente
- Monitorear intentos de acceso fallidos

## Troubleshooting

### Problemas Comunes

1. **Error de conexión a base de datos**
   - Verificar cadena de conexión en Web.config
   - Confirmar que SQL Server esté ejecutándose
   - Verificar permisos del usuario de aplicación

2. **Error de autenticación**
   - Verificar que el usuario exista en la base de datos
   - Confirmar que la cuenta esté activa
   - Revisar logs de errores

3. **Problemas de SSL**
   - Configurar certificado SSL en IIS
   - Verificar que `requireSSL="true"` esté configurado
   - Confirmar que el sitio use HTTPS

### Logs de Debug
Para habilitar logs detallados, configurar:
```xml
<add key="LogLevel" value="Debug" />
<add key="EnableAuditLog" value="true" />
```

## Cumplimiento y Estándares

La aplicación está diseñada para cumplir con:
- **PCI DSS** - Estándar de seguridad de datos de la industria de tarjetas de pago
- **SOX** - Ley Sarbanes-Oxley
- **GLBA** - Ley Gramm-Leach-Bliley
- **OWASP Top 10** - Principales vulnerabilidades web
- **NIST Cybersecurity Framework** - Marco de ciberseguridad

## Soporte

Para soporte técnico o preguntas sobre la implementación:
- Revisar la documentación de seguridad en `SECURITY_FEATURES.md`
- Consultar los logs de la aplicación
- Contactar al equipo de desarrollo

## Licencia

Este proyecto está desarrollado para uso interno de SemgaBank. Todos los derechos reservados.

---

**Nota**: Esta aplicación está diseñada para entornos bancarios y debe ser revisada por el equipo de seguridad antes de su despliegue en producción.




