# Sistema de Gestión de Usuarios - Cooperativa Segma

## 📋 Descripción

Sistema completo de gestión de usuarios para la aplicación interna de la Cooperativa Segma. Permite crear, editar, eliminar y gestionar usuarios del sistema con roles y departamentos.

## 🚀 Características

### ✨ Funcionalidades Principales
- **Gestión Completa de Usuarios**: Crear, editar, eliminar y buscar usuarios
- **Sistema de Roles**: Asignación de roles con diferentes niveles de acceso
- **Departamentos**: Organización por departamentos
- **Búsqueda Avanzada**: Filtros por nombre, usuario, estado y rol
- **Validaciones**: Verificación de usuarios y emails duplicados
- **Interfaz Moderna**: Diseño responsive y elegante
- **Seguridad**: Contraseñas encriptadas y control de intentos fallidos

### 🎨 Interfaz de Usuario
- **Diseño Responsive**: Adaptable a diferentes tamaños de pantalla
- **Modal Elegante**: Formularios en ventanas modales con animaciones
- **Tabla Dinámica**: Visualización clara de usuarios con información detallada
- **Estados Visuales**: Badges de colores para estados activo/inactivo
- **Loading States**: Indicadores de carga durante operaciones

### 🔒 Seguridad
- **Encriptación**: Contraseñas encriptadas con SBEncryption
- **Validación de Sesión**: Verificación de autenticación
- **Control de Acceso**: Prevención de auto-eliminación
- **Auditoría**: Registro de creación y modificación de usuarios

## 📁 Estructura de Archivos

```
Forms/Sistemas/
├── GestionUsuarios.aspx          # Interfaz principal
├── GestionUsuarios.aspx.vb       # Lógica del servidor
└── dashboardSistemas.aspx        # Dashboard de sistemas

Database/
├── Database_StoredProcedures_Usuarios.sql  # Stored Procedures
└── Database_Data_Usuarios.sql              # Datos de ejemplo
```

## 🗄️ Base de Datos

### Tablas Principales

#### `tbUsuarios`
- **Id**: Identificador único
- **Nombre/Apellido**: Datos personales
- **Usuario**: Nombre de usuario único
- **Clave**: Contraseña encriptada
- **Email**: Email único
- **Telefono**: Teléfono opcional
- **Rol**: Referencia a tbRoles
- **Departamento**: Referencia a tbDepartamentos
- **Estado**: Activo/Inactivo
- **UltimoAcceso**: Timestamp del último acceso
- **IntentosFallidos**: Contador de intentos fallidos
- **BloqueadoHasta**: Timestamp de bloqueo temporal
- **Auditoría**: Fechas y usuarios de creación/modificación

#### `tbRoles`
- **Id**: Identificador único
- **Nombre**: Nombre del rol
- **Descripcion**: Descripción del rol
- **NivelAcceso**: Nivel numérico de acceso (1-10)
- **Activo**: Estado del rol

#### `tbDepartamentos`
- **Id**: Identificador único
- **Nombre**: Nombre del departamento
- **Descripcion**: Descripción del departamento
- **Responsable**: Persona responsable
- **Telefono/Email**: Información de contacto
- **Activo**: Estado del departamento

## 🛠️ Instalación

### 1. Base de Datos
```sql
-- Ejecutar en orden:
1. Database_StoredProcedures_Usuarios.sql
2. Database_Data_Usuarios.sql
```

### 2. Configuración Web.config
Asegúrate de que el `Web.config` tenga:
- Connection string configurado
- WebMethods habilitados
- ScriptManager configurado

### 3. Dependencias
- **SBUtility**: Para encriptación de contraseñas
- **Font Awesome**: Para iconos
- **ASP.NET AJAX**: Para WebMethods

## 📖 Uso del Sistema

### Acceso al Sistema
1. Navegar a `Forms/Sistemas/dashboardSistemas.aspx`
2. Hacer clic en "Gestión de Usuarios"
3. El sistema cargará automáticamente los usuarios existentes

### Crear Nuevo Usuario
1. Hacer clic en "Nuevo Usuario"
2. Llenar el formulario con los datos requeridos
3. Seleccionar rol y departamento
4. Hacer clic en "Guardar"

### Editar Usuario
1. Hacer clic en el botón de editar (lápiz) en la fila del usuario
2. Modificar los campos necesarios
3. La contraseña es opcional en edición
4. Hacer clic en "Guardar"

### Eliminar Usuario
1. Hacer clic en el botón de eliminar (basura) en la fila del usuario
2. Confirmar la eliminación
3. **Nota**: No se puede eliminar el propio usuario

### Búsqueda de Usuarios
1. Usar los filtros en la sección de búsqueda:
   - **Nombre/Apellido**: Búsqueda por texto
   - **Usuario**: Búsqueda por nombre de usuario
   - **Estado**: Filtrar por Activo/Inactivo
   - **Rol**: Filtrar por rol específico
2. Hacer clic en "Buscar" o presionar Enter

## 🔧 WebMethods Disponibles

### Cargar Datos
- `CargarUsuarios()`: Obtiene lista de usuarios con filtros
- `CargarRoles()`: Obtiene lista de roles activos
- `CargarDepartamentos()`: Obtiene lista de departamentos activos
- `ObtenerUsuario(usuarioId)`: Obtiene datos de un usuario específico

### Operaciones CRUD
- `GuardarUsuario()`: Crear o actualizar usuario
- `EliminarUsuario()`: Eliminar usuario
- `CambiarEstadoUsuario()`: Cambiar estado activo/inactivo

### Validaciones
- `VerificarUsuarioExistente()`: Verificar duplicados de usuario
- `VerificarEmailExistente()`: Verificar duplicados de email

## 🎯 Roles y Permisos

### Niveles de Acceso
- **10 - Administrador**: Acceso completo
- **7 - Supervisor**: Acceso amplio con supervisión
- **5 - Operador**: Acceso básico para operaciones
- **4 - Auditor**: Acceso para auditorías
- **3 - Consultor**: Acceso de solo lectura

### Restricciones
- Solo usuarios con nivel 0 pueden acceder a configuraciones del sistema
- No se puede eliminar el propio usuario
- No se puede cambiar el estado del propio usuario

## 🎨 Personalización

### Colores del Tema
- **Primario**: #87CEEB (Celeste)
- **Secundario**: #B0E0E6 (Celeste claro)
- **Éxito**: #28a745 (Verde)
- **Peligro**: #dc3545 (Rojo)
- **Advertencia**: #ffc107 (Amarillo)

### CSS Personalizable
El archivo `GestionUsuarios.aspx` contiene todos los estilos CSS que pueden ser modificados para cambiar la apariencia del sistema.

## 🔍 Troubleshooting

### Problemas Comunes

#### Error: "PageMethods no está definido"
- Verificar que `ScriptManager` esté configurado
- Asegurar que `EnablePageMethods="true"`

#### Error: "No se puede cargar usuarios"
- Verificar connection string en `Web.config`
- Comprobar que los stored procedures estén creados
- Revisar permisos de base de datos

#### Error: "Usuario ya existe"
- El sistema valida duplicados automáticamente
- Verificar que el nombre de usuario sea único

#### Error: "Email ya existe"
- El sistema valida duplicados automáticamente
- Verificar que el email sea único

### Logs y Debug
- Los errores se registran en `System.Diagnostics.Debug.WriteLine`
- Revisar la consola del navegador para errores JavaScript
- Verificar el log de eventos de Windows para errores del servidor

## 📞 Soporte

Para soporte técnico o reportar problemas:
- Revisar los logs de error
- Verificar la configuración de base de datos
- Comprobar permisos de usuario

## 🔄 Actualizaciones

### Versión 1.0
- ✅ Gestión completa de usuarios
- ✅ Sistema de roles y departamentos
- ✅ Búsqueda y filtros
- ✅ Validaciones de seguridad
- ✅ Interfaz moderna y responsive

### Próximas Funcionalidades
- 📋 Paginación de resultados
- 📋 Exportación a Excel
- 📋 Historial de cambios
- 📋 Notificaciones por email
- 📋 Dashboard de estadísticas

---

**Desarrollado para Cooperativa Segma**  
*Sistema de Gestión Interna*


