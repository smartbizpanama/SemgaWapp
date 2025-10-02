# Sistema de Gestión de Socios - Cooperativa Segma

## 📋 Descripción

Sistema completo de gestión de socios para la aplicación interna de la Cooperativa Segma. Permite visualizar, crear, editar y gestionar la información completa de los socios de la cooperativa con una interfaz moderna basada en tabs.

## 🚀 Características

### ✨ Funcionalidades Principales
- **Lista de Socios**: Visualización completa con filtros avanzados
- **Ficha Completa**: Formulario modal con 5 tabs organizados por categorías
- **Búsqueda Avanzada**: Filtros por nombre, tipo, estatus e identificación
- **Validaciones**: Verificación de números de identificación únicos
- **Interfaz Moderna**: Diseño responsive con Bootstrap 5 y DataTables
- **WebMethods**: Comunicación AJAX sin postbacks

### 🎨 Interfaz de Usuario
- **Diseño Responsive**: Adaptable a diferentes tamaños de pantalla
- **Modal Elegante**: Formulario en ventana modal con animaciones
- **Tabla Dinámica**: Visualización clara con DataTables
- **Estados Visuales**: Badges de colores para estatus
- **Loading States**: Indicadores de carga durante operaciones
- **Tabs Organizados**: Información categorizada en 5 secciones

### 🔒 Seguridad
- **Validación de Sesión**: Verificación de autenticación
- **Validación de Datos**: Verificación de campos obligatorios
- **Prevención de Duplicados**: Control de números de identificación únicos
- **Auditoría**: Registro de creación y modificación

## 📁 Estructura de Archivos

```
Forms/Socios/
├── GestionSocios.aspx              # Interfaz principal
├── GestionSocios.aspx.vb           # Lógica del servidor
├── GestionSocios.sql               # Estructura de tablas
├── DatosEjemplo_TiposAsociado.sql  # Datos de ejemplo - Tipos
├── DatosEjemplo_Socios.sql         # Datos de ejemplo - Socios
└── README_GestionSocios.md         # Documentación
```

## 🗄️ Base de Datos

### Tablas Principales

#### `tbAsociados`
- **NumeroAsociado**: Identificador único (IDENTITY)
- **IdTipoAsociado**: Referencia a tbTipoAsociado
- **Datos Personales**: Nombre, apellidos, sexo, fecha nacimiento
- **Identificación**: Tipo y número de identificación
- **Contacto**: Teléfonos y correo electrónico
- **Direcciones**: Residencia y trabajo (provincia, distrito, corregimiento, dirección)
- **Profesional**: Ocupación, nivel de estudio, profesión
- **Auditoría**: Fechas y usuarios de creación/modificación
- **Control**: Estatus y eliminación lógica

#### `tbTipoAsociado`
- **IdTipoAsociado**: Identificador único
- **CodTipoAsociado**: Código del tipo
- **TipoAsociado**: Descripción del tipo

### Organización por Tabs

#### 1. **Generales**
- Número de Asociado
- Tipo de Asociado
- Nombres y Apellidos
- Estatus
- Sexo y Fecha de Nacimiento
- Identificación (Tipo y Número)
- Teléfonos de Contacto
- Correo Electrónico
- Ocupación, Nivel de Estudio, Profesión

#### 2. **Trabajo**
- Lugar de Trabajo
- Ocupación
- Provincia, Distrito, Corregimiento de Trabajo
- Dirección de Trabajo

#### 3. **Residencia**
- Provincia, Distrito, Corregimiento de Residencia
- Dirección de Residencia

#### 4. **Beneficiario**
- Módulo preparado para futuras implementaciones
- Información de beneficiarios del socio

#### 5. **Sistemas**
- Fecha de Creación
- Usuario que Creó
- Fecha de Modificación
- Usuario que Modificó
- Estado de Eliminación

## 🛠️ Instalación

### 1. Base de Datos
```sql
-- Ejecutar en orden:
1. GestionSocios.sql (crear tablas)
2. DatosEjemplo_TiposAsociado.sql (tipos de asociado)
3. DatosEjemplo_Socios.sql (socios de ejemplo)
```

### 2. Configuración Web.config
Asegúrate de que el `Web.config` tenga:
- Connection string configurado
- WebMethods habilitados
- ScriptManager configurado
- Newtonsoft.Json referenciado

### 3. Dependencias
- **Bootstrap 5**: Para interfaz moderna
- **jQuery**: Para funcionalidad JavaScript
- **DataTables**: Para tabla interactiva
- **Font Awesome**: Para iconos
- **Newtonsoft.Json**: Para serialización JSON

## 📖 Uso del Sistema

### Acceso al Sistema
1. Navegar a `Forms/Socios/GestionSocios.aspx`
2. El sistema cargará automáticamente los socios existentes
3. Los filtros permiten búsquedas específicas

### Ver Ficha de Socio
1. Hacer clic en el botón "Ver" (👁️) en la fila del socio
2. Se abrirá el modal con la ficha completa
3. Navegar entre tabs para ver toda la información

### Crear Nuevo Socio
1. Hacer clic en "Nuevo Socio"
2. Llenar el formulario en los diferentes tabs
3. Campos obligatorios: Primer nombre, primer apellido, tipo y número de identificación
4. Hacer clic en "Guardar Cambios"

### Editar Socio Existente
1. Abrir la ficha del socio (botón "Ver")
2. Modificar los campos necesarios
3. Hacer clic en "Guardar Cambios"

### Filtros de Búsqueda
- **Nombre**: Busca en nombres y apellidos
- **Tipo**: Filtra por tipo de asociado
- **Estatus**: Activo, Inactivo, Suspendido
- **Identificación**: Busca por número de identificación

## 🔧 WebMethods Implementados

### `ObtenerTiposAsociado()`
- Obtiene la lista de tipos de asociado
- Usado para llenar dropdowns

### `ObtenerSocios(filtrosJson)`
- Obtiene la lista de socios con filtros opcionales
- Parámetros: nombre, tipo, estatus, identificación

### `ObtenerSocioPorNumero(numeroAsociado)`
- Obtiene la información completa de un socio específico
- Usado para mostrar la ficha completa

### `CrearSocio(socioDataJson)`
- Crea un nuevo socio
- Valida duplicados de identificación
- Registra auditoría

### `ActualizarSocio(socioDataJson)`
- Actualiza un socio existente
- Valida duplicados de identificación
- Registra auditoría

## 🎨 Características de Diseño

### Colores y Estilos
- **Gradiente Principal**: #667eea a #764ba2
- **Bootstrap 5**: Framework CSS moderno
- **DataTables**: Tabla interactiva con paginación
- **Font Awesome**: Iconografía consistente
- **Responsive**: Adaptable a móviles y tablets

### Componentes
- **Header**: Título con gradiente y botón de acción
- **Filtros**: Panel de búsqueda con múltiples criterios
- **Tabla**: Lista de socios con información resumida
- **Modal**: Formulario completo con tabs
- **Toast**: Notificaciones de éxito/error

## 🔍 Validaciones

### Frontend (JavaScript)
- Campos obligatorios: nombre, apellido, tipo y número de identificación
- Validación de formato de email
- Mensajes de error claros

### Backend (VB.NET)
- Verificación de duplicados de identificación
- Validación de tipos de datos
- Manejo de errores con mensajes descriptivos
- Auditoría de cambios

## 📱 Responsive Design

El sistema está optimizado para:
- **Desktop**: Experiencia completa con todos los elementos visibles
- **Tablet**: Adaptación de columnas y espaciado
- **Mobile**: Navegación optimizada y formularios adaptados

## 🚀 Próximas Mejoras

- [ ] Módulo de beneficiarios completo
- [ ] Exportación a Excel/PDF
- [ ] Historial de cambios
- [ ] Fotos de perfil
- [ ] Notificaciones por email
- [ ] Dashboard con estadísticas
- [ ] Integración con otros módulos

## 📞 Soporte

Para soporte técnico o consultas sobre el sistema, contactar al equipo de desarrollo de la Cooperativa Segma.

---

**Versión**: 1.0  
**Última actualización**: Diciembre 2024  
**Desarrollado por**: Equipo de Desarrollo Segma

