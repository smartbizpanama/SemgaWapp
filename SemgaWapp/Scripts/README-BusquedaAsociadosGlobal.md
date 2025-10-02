# Sistema Global de Búsqueda de Asociados

Este componente permite buscar y seleccionar asociados de manera consistente en toda la aplicación, evitando la duplicación de código.

## Características

- ✅ **Reutilizable** - Se puede usar en cualquier formulario
- ✅ **Configurable** - Permite personalizar títulos, mensajes y callbacks
- ✅ **Consistente** - Mismo diseño y comportamiento en toda la app
- ✅ **Responsive** - Funciona en dispositivos móviles y desktop
- ✅ **Inteligente** - Búsqueda por nombre, cédula o número de asociado
- ✅ **Chips visuales** - Muestra identificación con chips inteligentes

## Uso Básico

### 1. Incluir el Script

```html
<script src="Scripts/smart-chips.js"></script>
<script src="Scripts/global-associate-search.js"></script>
```

### 2. Agregar Contenedor

```html
<!-- En el body de tu página -->
<div id="globalModalsContainer"></div>
```

### 3. Inicializar el Componente

```javascript
$(document).ready(function() {
    // Crear y configurar el componente
    var searchConfig = crearBusquedaAsociados('globalModalsContainer', {
        modalId: 'modalBuscarAsociado',
        searchInputId: 'txtBuscarAsociado',
        resultsTableId: 'tbodyAsociados',
        searchButtonId: 'btnBuscarAsociado',
        clearButtonId: 'btnLimpiarBusqueda',
        modalTitle: 'Buscar Asociado',
        searchPlaceholder: 'Ingrese nombre, cédula o número de asociado...',
        onSelect: function(asociado) {
            // Callback cuando se selecciona un asociado
            console.log('Asociado seleccionado:', asociado);
            // asociado.numeroAsociado
            // asociado.nombre
            // asociado.numeroIdentificacion
            // asociado.codTipoDoc
        },
        onCancel: function() {
            // Callback cuando se cancela la búsqueda
            console.log('Búsqueda cancelada');
        }
    });
    
    // Abrir el modal de búsqueda
    $('#miBotonBuscar').on('click', function() {
        abrirBusquedaAsociados(searchConfig);
    });
});
```

## Configuración Avanzada

### Opciones Disponibles

```javascript
var config = {
    modalId: 'modalBuscarAsociado',                    // ID único del modal
    searchInputId: 'txtBuscarAsociado',                // ID del campo de búsqueda
    resultsTableId: 'tbodyAsociados',                  // ID de la tabla de resultados
    searchButtonId: 'btnBuscarAsociado',               // ID del botón buscar
    clearButtonId: 'btnLimpiarBusqueda',               // ID del botón limpiar
    modalTitle: 'Buscar Asociado',                     // Título del modal
    searchPlaceholder: 'Ingrese término de búsqueda...', // Placeholder del campo
    noResultsMessage: 'No se encontraron asociados',    // Mensaje sin resultados
    initialMessage: 'Ingrese un término de búsqueda...', // Mensaje inicial
    onSelect: function(asociado) { /* callback */ },    // Función al seleccionar
    onCancel: function() { /* callback */ }             // Función al cancelar
};
```

### Múltiples Instancias

```javascript
// Búsqueda para formulario de préstamos
var prestamoSearch = crearBusquedaAsociados('globalModalsContainer', {
    modalId: 'modalBuscarAsociadoPrestamo',
    modalTitle: 'Seleccionar Cliente para Préstamo',
    onSelect: function(asociado) {
        llenarDatosClientePrestamo(asociado);
    }
});

// Búsqueda para formulario de ahorros
var ahorroSearch = crearBusquedaAsociados('globalModalsContainer', {
    modalId: 'modalBuscarAsociadoAhorro',
    modalTitle: 'Seleccionar Cliente para Ahorro',
    onSelect: function(asociado) {
        llenarDatosClienteAhorro(asociado);
    }
});
```

## Integración con Formularios Existentes

### Ejemplo: Formulario de Préstamos

```html
<!-- Botón para buscar cliente -->
<button type="button" class="btn btn-primary" id="btnBuscarCliente">
    <i class="fas fa-search me-1"></i>Buscar Cliente
</button>

<!-- Campos que se llenarán -->
<input type="hidden" id="hdnClienteId">
<input type="text" id="txtClienteNombre" readonly>
<input type="text" id="txtClienteCedula" readonly>
```

```javascript
$(document).ready(function() {
    // Inicializar búsqueda
    var clienteSearch = crearBusquedaAsociados('globalModalsContainer', {
        modalId: 'modalBuscarClientePrestamo',
        modalTitle: 'Buscar Cliente para Préstamo',
        onSelect: function(asociado) {
            // Llenar campos del formulario
            $('#hdnClienteId').val(asociado.numeroAsociado);
            $('#txtClienteNombre').val(asociado.nombre);
            $('#txtClienteCedula').val(asociado.numeroIdentificacion);
            
            showToast('success', 'Cliente seleccionado', asociado.nombre + ' ha sido seleccionado');
        }
    });
    
    // Evento del botón
    $('#btnBuscarCliente').on('click', function() {
        abrirBusquedaAsociados(clienteSearch);
    });
});
```

## API del Componente

### Funciones Principales

```javascript
// Crear componente
crearBusquedaAsociados(containerId, config)

// Abrir modal
abrirBusquedaAsociados(config)

// Buscar asociados (interno)
buscarAsociadosGlobal(config)

// Mostrar resultados (interno)
mostrarAsociadosGlobal(asociados, config)

// Limpiar búsqueda (interno)
limpiarBusquedaGlobal(config)

// Seleccionar asociado (global)
seleccionarAsociadoGlobal(numeroAsociado, nombre, numeroIdentificacion, codTipoDoc, modalId)
```

### Objeto Asociado

```javascript
var asociado = {
    numeroAsociado: 123,
    nombre: "Juan Pérez",
    numeroIdentificacion: "1234567890",
    codTipoDoc: "CED"
};
```

## Estilos CSS

El componente usa clases de Bootstrap 5 y estilos personalizados. Los estilos principales incluyen:

- **Modal personalizado** con gradiente en el header
- **Tabla responsive** con scroll vertical
- **Chips inteligentes** para identificación
- **Loading spinner** durante la búsqueda
- **Estados de error** y mensajes informativos

## Dependencias

- **jQuery 3.6+**
- **Bootstrap 5.3+**
- **Font Awesome 6.0+**
- **smart-chips.js** (para chips de identificación)

## Compatibilidad

- ✅ **Navegadores modernos** (Chrome, Firefox, Safari, Edge)
- ✅ **Dispositivos móviles** (responsive design)
- ✅ **Múltiples instancias** en la misma página
- ✅ **Integración fácil** con formularios existentes

## Ejemplos de Uso

### 1. Formulario de Nuevo Préstamo
### 2. Formulario de Apertura de Cuenta
### 3. Formulario de Transferencias
### 4. Formulario de Consultas
### 5. Formulario de Reportes por Cliente

¡El componente está listo para ser usado en toda la aplicación! 🎉













