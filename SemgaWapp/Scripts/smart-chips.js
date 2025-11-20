/**
 * Sistema de Chips Inteligentes - Configuración Global
 * Proporciona funciones para crear chips consistentes en toda la aplicación
 */

// Configuración global de chips
const SmartChipsConfig = {
    // Configuración para tipos de documento
    tiposDocumento: {
        'CED': { color: 'bg-primary', icono: 'fas fa-id-card', nombre: 'Cédula' },
        'PAS': { color: 'bg-info', icono: 'fas fa-passport', nombre: 'Pasaporte' },
        'RUC': { color: 'bg-success', icono: 'fas fa-building', nombre: 'RUC' },
        'OTR': { color: 'bg-warning', icono: 'fas fa-file-alt', nombre: 'Otro' }
    },

    // Configuración para rubros
    rubros: {
        'AHORRO': { color: 'bg-success', icono: 'fas fa-piggy-bank', nombre: 'Ahorro' },
        'PRESTAMO': { color: 'bg-warning', icono: 'fas fa-hand-holding-usd', nombre: 'Préstamo' },
        'APORTE': { color: 'bg-info', icono: 'fas fa-coins', nombre: 'Aporte' },
        'CREDITO': { color: 'bg-danger', icono: 'fas fa-credit-card', nombre: 'Crédito' },
        'INVERSION': { color: 'bg-purple', icono: 'fas fa-chart-line', nombre: 'Inversión' }
    },

    // Configuración para tipos de asociado
    tiposAsociado: {
        'CLIENTE': { color: 'bg-primary', icono: 'fas fa-user', nombre: 'Cliente' },
        'PROVEEDOR': { color: 'bg-success', icono: 'fas fa-truck', nombre: 'Proveedor' },
        'EMPLEADO': { color: 'bg-info', icono: 'fas fa-user-tie', nombre: 'Empleado' },
        'SOCIO': { color: 'bg-warning', icono: 'fas fa-handshake', nombre: 'Socio' }
    },

    // Configuración para estados
    estados: {
        'ACTIVO': { color: 'bg-success', icono: 'fas fa-check-circle', nombre: 'Activo' },
        'INACTIVO': { color: 'bg-secondary', icono: 'fas fa-times-circle', nombre: 'Inactivo' },
        'PENDIENTE': { color: 'bg-warning', icono: 'fas fa-clock', nombre: 'Pendiente' },
        'SUSPENDIDO': { color: 'bg-danger', icono: 'fas fa-ban', nombre: 'Suspendido' },
        'READY': { color: 'bg-primary', icono: 'fas fa-check', nombre: 'Ready' }
    },

    // Configuración para tipos de auxiliar
    tiposAuxiliar: {
        'FIJO': { color: 'bg-primary', icono: 'fas fa-anchor', nombre: 'Fijo' },
        'VARIABLE': { color: 'bg-info', icono: 'fas fa-chart-bar', nombre: 'Variable' },
        'MIXTO': { color: 'bg-success', icono: 'fas fa-balance-scale', nombre: 'Mixto' },
        'ESPECIAL': { color: 'bg-warning', icono: 'fas fa-star', nombre: 'Especial' }
    },

    // Configuración para niveles de prioridad
    prioridades: {
        'ALTA': { color: 'bg-danger', icono: 'fas fa-exclamation-triangle', nombre: 'Alta' },
        'MEDIA': { color: 'bg-warning', icono: 'fas fa-minus-circle', nombre: 'Media' },
        'BAJA': { color: 'bg-success', icono: 'fas fa-arrow-down', nombre: 'Baja' },
        'CRITICA': { color: 'bg-dark', icono: 'fas fa-skull', nombre: 'Crítica' }
    },

    // Configuración por defecto para valores no encontrados
    default: {
        color: 'bg-secondary',
        icono: 'fas fa-tag',
        nombre: 'N/A'
    }
};

/**
 * Crea un chip inteligente genérico
 * @param {string} tipo - Tipo de chip (tiposDocumento, rubros, etc.)
 * @param {string} valor - Valor del chip
 * @param {string} textoAdicional - Texto adicional opcional
 * @param {boolean} mostrarNombre - Si mostrar el nombre completo o solo el código
 * @returns {string} HTML del chip
 */
function crearChipInteligente(tipo, valor, textoAdicional = '', mostrarNombre = false) {
    
    if (!valor || !tipo) {
        return crearChipDefault(textoAdicional);
    }

    const config = SmartChipsConfig[tipo];
    if (!config) {
        return crearChipDefault(textoAdicional);
    }

    const itemConfig = config[valor.toUpperCase()];
    if (!itemConfig) {
        return crearChipDefault(textoAdicional);
    }


    // Para tipos de documento, siempre mostrar el código del tipo, no el nombre
    const textoMostrar = (tipo === 'tiposDocumento') ? valor : (mostrarNombre ? itemConfig.nombre : valor);

    let contenido = `<i class="${itemConfig.icono} me-1"></i>${textoMostrar}`;
    if (textoAdicional) {
        contenido += `<span class="ms-2 fw-semibold">${textoAdicional}</span>`;
    }

    return `<span class="badge ${itemConfig.color} me-1 d-inline-flex align-items-center">${contenido}</span>`;
}

/**
 * Crea un chip por defecto para valores no encontrados
 * @param {string} texto - Texto a mostrar
 * @returns {string} HTML del chip por defecto
 */
function crearChipDefault(texto = 'N/A') {
    const config = SmartChipsConfig.default;
    return `<span class="badge ${config.color}"><i class="${config.icono} me-1"></i>${texto}</span>`;
}

/**
 * Funciones específicas para cada tipo de chip
 */

// Chips para tipos de documento
function crearChipTipoDocumento(codTipoDoc, numeroIdentificacion) {
    const resultado = crearChipInteligente('tiposDocumento', codTipoDoc, numeroIdentificacion);
    return resultado;
}

// Chips para rubros
function crearChipRubro(rubro) {
    return crearChipInteligente('rubros', rubro, '', true);
}

// Chips para tipos de asociado
function crearChipTipoAsociado(tipoAsociado) {
    return crearChipInteligente('tiposAsociado', tipoAsociado, '', true);
}

// Chips para estados
function crearChipEstado(estado) {
    return crearChipInteligente('estados', estado, '', true);
}

// Chips para tipos de auxiliar
function crearChipTipoAuxiliar(tipoAuxiliar) {
    return crearChipInteligente('tiposAuxiliar', tipoAuxiliar, '', true);
}

// Chips para prioridades
function crearChipPrioridad(prioridad) {
    return crearChipInteligente('prioridades', prioridad, '', true);
}

/**
 * Función para agregar nuevos tipos de chips dinámicamente
 * @param {string} tipo - Nombre del nuevo tipo
 * @param {Object} configuracion - Configuración del nuevo tipo
 */
function agregarTipoChip(tipo, configuracion) {
    SmartChipsConfig[tipo] = configuracion;
}

/**
 * Función para obtener la configuración de un chip específico
 * @param {string} tipo - Tipo de chip
 * @param {string} valor - Valor del chip
 * @returns {Object|null} Configuración del chip o null si no se encuentra
 */
function obtenerConfiguracionChip(tipo, valor) {
    const config = SmartChipsConfig[tipo];
    if (!config || !valor) return null;
    return config[valor.toUpperCase()] || null;
}

/**
 * Función para validar si un tipo de chip existe
 * @param {string} tipo - Tipo de chip a validar
 * @returns {boolean} True si el tipo existe
 */
function existeTipoChip(tipo) {
    return SmartChipsConfig.hasOwnProperty(tipo);
}

/**
 * Función para obtener todos los tipos de chips disponibles
 * @returns {Array} Array con los nombres de todos los tipos disponibles
 */
function obtenerTiposChipsDisponibles() {
    return Object.keys(SmartChipsConfig).filter(key => key !== 'default');
}

// Log de inicialización




