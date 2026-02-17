/**
 * Sistema Global de Búsqueda de Asociados
 * Componente reutilizable para buscar y seleccionar asociados en toda la aplicación
 */

// Configuración global del componente
const AssociateSearchConfig = {
    // Configuración por defecto
    defaultConfig: {
        modalId: 'modalBuscarAsociadoGlobal',
        searchInputId: 'txtBuscarAsociadoGlobal',
        resultsTableId: 'tbodyAsociadosGlobal',
        searchButtonId: 'btnBuscarAsociadoGlobal',
        clearButtonId: 'btnLimpiarBusquedaGlobal',
        // Callback cuando se selecciona un asociado
        onSelect: null,
        // Callback cuando se cancela la búsqueda
        onCancel: null,
        // Título del modal
        modalTitle: 'Buscar Asociado',
        // Placeholder del campo de búsqueda
        searchPlaceholder: 'Ingrese nombre, cédula o número de asociado...',
        // Mensaje cuando no hay resultados
        noResultsMessage: 'No se encontraron asociados',
        // Mensaje inicial
        initialMessage: 'Ingrese un término de búsqueda para comenzar',
        // Validar auxiliares - true: solo permite asociados con auxiliares, false: permite todos
        validarAuxiliares: true
    }
};

/**
 * Crea el modal de búsqueda de asociados
 * @param {Object} config - Configuración del componente
 * @returns {string} HTML del modal
 */
function crearModalBusquedaAsociados(config = {}) {
    const cfg = Object.assign({}, AssociateSearchConfig.defaultConfig, config);

    return `
        <!-- Modal de Búsqueda de Asociados -->
        <div class="modal fade" id="${cfg.modalId}" tabindex="-1" aria-labelledby="${cfg.modalId}Label" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-lg">
                <div class="modal-content" style="border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.3);">
                    <div class="modal-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-bottom: none;">
                        <h5 class="modal-title" id="${cfg.modalId}Label">
                            <i class="fas fa-search me-2"></i>${cfg.modalTitle}
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" style="padding: 20px;">
                        <!-- Campo de Búsqueda -->
                        <div class="row mb-3">
                            <div class="col-md-8">
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-search"></i>
                                    </span>
                                    <input type="text" class="form-control" id="${cfg.searchInputId}" 
                                           placeholder="${cfg.searchPlaceholder}" autocomplete="off">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <button type="button" class="btn btn-primary me-2" id="${cfg.searchButtonId}">
                                    <i class="fas fa-search me-1"></i>Buscar
                                </button>
                                <button type="button" class="btn btn-outline-secondary" id="${cfg.clearButtonId}">
                                    <i class="fas fa-times me-1"></i>Limpiar
                                </button>
                            </div>
                        </div>
                        
                        <!-- Lista de Resultados -->
                        <div class="table-responsive" style="max-height: 400px;">
                            <table class="table table-sm table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>N° Asociado</th>
                                        <th>Nombre Completo</th>
                                        <th>Identificación</th>
                                        <th>Tipo</th>
                                        <th class="text-center">Auxiliares</th>
                                        <th class="text-center">Acción</th>
                                    </tr>
                                </thead>
                                <tbody id="${cfg.resultsTableId}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">
                                            <i class="fas fa-search me-2"></i>${cfg.initialMessage}
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer" style="border-top: none; padding: 15px 20px;">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;
}

/**
 * Inicializa el componente de búsqueda de asociados
 * @param {Object} config - Configuración del componente
 */
function inicializarBusquedaAsociados(config = {}) {
    const cfg = Object.assign({}, AssociateSearchConfig.defaultConfig, config);

    // Verificar que el modal existe
    if (!$(`#${cfg.modalId}`).length) {
        return;
    }

    // Event listeners
    $(`#${cfg.searchButtonId}`).on('click', function () {
        buscarAsociadosGlobal(cfg);
    });

    $(`#${cfg.clearButtonId}`).on('click', function () {
        limpiarBusquedaGlobal(cfg);
    });

    // Búsqueda al presionar Enter
    $(`#${cfg.searchInputId}`).on('keydown', function (e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault(); // Prevenir comportamiento por defecto
            e.stopPropagation(); // Prevenir propagación
            buscarAsociadosGlobal(cfg);
            return false; // Prevenir cualquier otro comportamiento
        }
    });

    // Log cuando se hace clic en el campo de búsqueda
    $(`#${cfg.searchInputId}`).on('click', function (e) {
        e.stopPropagation(); // Prevenir propagación del evento
    });

    // Focus automático cuando se abre el modal
    $(`#${cfg.modalId}`).on('shown.bs.modal', function () {
        $(`#${cfg.searchInputId}`).focus();
    });

    // Prevenir cierre accidental del modal
    $(`#${cfg.modalId}`).on('hide.bs.modal', function (e) {
        // No prevenir el cierre, solo loggear
    });

    // Limpiar al cerrar el modal
    $(`#${cfg.modalId}`).on('hidden.bs.modal', function () {
        limpiarBusquedaGlobal(cfg);
        if (cfg.onCancel) {
            cfg.onCancel();
        }
    });

}

/**
 * Abre el modal de búsqueda de asociados
 * @param {Object} config - Configuración del componente
 */
function abrirBusquedaAsociados(config = {}) {
    const cfg = Object.assign({}, AssociateSearchConfig.defaultConfig, config);
    $(`#${cfg.modalId}`).modal('show');
}

/**
 * Busca asociados usando el WebMethod
 * @param {Object} config - Configuración del componente
 */
function buscarAsociadosGlobal(config) {
    const cfg = Object.assign({}, AssociateSearchConfig.defaultConfig, config);
    const busqueda = $(`#${cfg.searchInputId}`).val().trim();

    if (busqueda.length < 1) {
        showToast('warning', 'Búsqueda requerida', 'Por favor ingrese un término de búsqueda');
        return;
    }

    // Mostrar loading
    $(`#${cfg.resultsTableId}`).html(`
        <tr>
            <td colspan="5" class="text-center py-4">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Buscando...</span>
                </div>
                <div class="mt-2">Buscando asociados...</div>
            </td>
        </tr>
    `);

    // Determinar la ruta del WebMethod
    const pathname = window.location.pathname.toLowerCase();
    const href = window.location.href.toLowerCase();
    
    console.log('[global-associate-search.js] Pathname:', pathname);
    console.log('[global-associate-search.js] Href:', href);
    
    let webMethodUrl = 'AuxiliaresAsociados.aspx/BuscarAsociados';
    
    // Verificar si estamos en Movimientos.aspx específicamente
    if (pathname.includes('movimientos.aspx') || href.includes('movimientos.aspx')) {
        webMethodUrl = 'Movimientos.aspx/BuscarAsociados';
        console.log('[global-associate-search.js] Detectado: Movimientos.aspx directamente');
    } else if (pathname.includes('/forms/socios/')) {
        webMethodUrl = '../Auxiliares/AuxiliaresAsociados.aspx/BuscarAsociados';
        console.log('[global-associate-search.js] Detectado: Socios');
    } else if (pathname.includes('/forms/auxiliares/')) {
        webMethodUrl = 'AuxiliaresAsociados.aspx/BuscarAsociados';
        console.log('[global-associate-search.js] Detectado: Auxiliares');
    } else if (pathname.includes('/forms/transacciones/')) {
        webMethodUrl = 'Transacciones.aspx/BuscarAsociados';
        console.log('[global-associate-search.js] Detectado: Transacciones');
    } else if (pathname.includes('/forms/reportes/')) {
        webMethodUrl = 'Movimientos.aspx/BuscarAsociados';
        console.log('[global-associate-search.js] Detectado: Reportes -> Movimientos.aspx');
    } else {
        console.log('[global-associate-search.js] No se detectó ruta específica, usando default:', webMethodUrl);
    }
    
    console.log('[global-associate-search.js] URL final del WebMethod:', webMethodUrl);

    console.log('[global-associate-search.js] Buscando asociados');
    console.log('[global-associate-search.js] Búsqueda:', busqueda);
    console.log('[global-associate-search.js] URL del WebMethod:', webMethodUrl);
    console.log('[global-associate-search.js] Pathname actual:', window.location.pathname);
    console.log('[global-associate-search.js] URL completa:', window.location.href);
    console.log('[global-associate-search.js] jQuery disponible:', typeof $ !== 'undefined');
    console.log('[global-associate-search.js] Configuración:', cfg);

    $.ajax({
        type: "POST",
        url: webMethodUrl,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: JSON.stringify({ busqueda: busqueda }),
        beforeSend: function(xhr) {
            console.log('[global-associate-search.js] Enviando petición AJAX a:', webMethodUrl);
            console.log('[global-associate-search.js] Datos enviados:', { busqueda: busqueda });
        },
        success: function (response) {
            console.log('[global-associate-search.js] Respuesta recibida:', response);
            console.log('[global-associate-search.js] response.d:', response.d);
            console.log('[global-associate-search.js] Tipo de response.d:', typeof response.d);
            
            if (response.d && response.d.Resultado === 'SUCCESS') {
                console.log('[global-associate-search.js] Resultado: SUCCESS');
                console.log('[global-associate-search.js] Data:', response.d.Data);
                const asociados = JSON.parse(response.d.Data);
                console.log('[global-associate-search.js] Asociados parseados:', asociados.length);
                mostrarAsociadosGlobal(asociados, cfg);
            } else {
                console.log('[global-associate-search.js] Resultado no es SUCCESS:', response.d);
                mostrarErrorBusqueda(cfg, response.d?.Mensaje || 'Error al buscar asociados');
            }
        },
        error: function (xhr, status, error) {
            console.error('[global-associate-search.js] Error en AJAX:');
            console.error('Status:', xhr.status);
            console.error('StatusText:', xhr.statusText);
            console.error('ResponseText:', xhr.responseText);
            console.error('URL intentada:', webMethodUrl);
            console.error('Error:', error);
            console.error('ReadyState:', xhr.readyState);
            console.error('Headers:', xhr.getAllResponseHeaders());
            
            let mensajeError = 'Error de conexión al buscar asociados';
            if (xhr.status === 404) {
                mensajeError = 'No se encontró el servicio (404). Verifique la ruta: ' + webMethodUrl;
                console.error('[global-associate-search.js] ERROR 404 - El WebMethod no se encontró');
                console.error('[global-associate-search.js] Verifique que el método BuscarAsociados esté correctamente definido en Movimientos.aspx.vb');
            } else if (xhr.status === 500) {
                mensajeError = 'Error en el servidor (500): ' + (xhr.responseText || error);
                console.error('[global-associate-search.js] ERROR 500 - Error en el servidor');
            } else if (xhr.status === 0) {
                mensajeError = 'No se pudo conectar al servidor. Verifique la conexión.';
                console.error('[global-associate-search.js] ERROR 0 - No se pudo conectar');
            }
            mostrarErrorBusqueda(cfg, mensajeError);
        }
    });
}

/**
 * Muestra los resultados de la búsqueda
 * @param {Array} asociados - Array de asociados encontrados
 * @param {Object} config - Configuración del componente
 */
function mostrarAsociadosGlobal(asociados, config) {
    const cfg = Object.assign({}, AssociateSearchConfig.defaultConfig, config);

    if (!asociados || asociados.length === 0) {
        $(`#${cfg.resultsTableId}`).html(`
            <tr>
                <td colspan="6" class="text-center text-muted py-4">
                    <i class="fas fa-search me-2"></i>${cfg.noResultsMessage}
                </td>
            </tr>
        `);
    } else {

        // Almacenar datos de asociados globalmente para evitar problemas con HTML
        window.asociadosGlobales = asociados;

        let html = '';
        $.each(asociados, function (index, item) {
            // El campo viene como "CantidadAuxiliares" desde el servidor
            const cantAuxiliares = parseInt(item.CantidadAuxiliares || item.CantAuxiliares) || 0;
            console.log('[mostrarAsociadosGlobal] Asociado:', item.NombreCompleto, 'CantidadAuxiliares:', item.CantidadAuxiliares, 'CantAuxiliares:', item.CantAuxiliares, 'cantAuxiliares final:', cantAuxiliares);
            const tieneAuxiliares = cantAuxiliares > 0;

            // Log para verificar si JsonAuxiliares está disponible

            html += '<tr>';
            html += '<td>' + item.NumeroAsociado + '</td>';
            html += '<td>' + item.NombreCompleto + '</td>';
            html += '<td>' + crearChipTipoDocumento(item.CodTipoDoc, item.NumeroIdentificacion) + '</td>';
            html += '<td>' + item.TipoAsociado + '</td>';

            // Columna de auxiliares con badge
            html += '<td class="text-center">';
            if (tieneAuxiliares) {
                html += '<span class="badge bg-success">' + cantAuxiliares + '</span>';
            } else {
                html += '<span class="badge bg-secondary">0</span>';
            }
            html += '</td>';

            // Botón de acción
            html += '<td class="text-center">';

            // Determinar si se debe validar auxiliares basado en la configuración
            const debeValidarAuxiliares = cfg.validarAuxiliares !== false; // Por defecto true si no se especifica

            if (tieneAuxiliares || !debeValidarAuxiliares) {
                // Usar solo el índice para evitar problemas con datos complejos
                html += '<button type="button" class="btn btn-sm btn-primary btn-seleccionar-asociado" ';
                html += 'data-index="' + index + '" ';
                html += 'data-modal-id="' + cfg.modalId + '">';
                html += '<i class="fas fa-check me-1"></i>Seleccionar';
                html += '</button>';
            } else {
                html += '<button type="button" class="btn btn-sm btn-secondary" disabled title="Este asociado no tiene auxiliares registrados">';
                html += '<i class="fas fa-ban me-1"></i>Sin Auxiliares';
                html += '</button>';
            }
            html += '</td>';
            html += '</tr>';
        });
        $(`#${cfg.resultsTableId}`).html(html);

        // Agregar event listener para los botones de seleccionar
        $(`#${cfg.resultsTableId} .btn-seleccionar-asociado`).on('click', function () {
            const $btn = $(this);
            const index = $btn.data('index');
            const modalId = $btn.data('modal-id');


            // Obtener datos del asociado desde la variable global
            if (window.asociadosGlobales && window.asociadosGlobales[index]) {
                const item = window.asociadosGlobales[index];

                const numeroAsociado = item.NumeroAsociado;
                const nombre = item.NombreCompleto;
                const numeroIdentificacion = item.NumeroIdentificacion;
                const codTipoDoc = item.CodTipoDoc;
                // El campo viene como "CantidadAuxiliares" desde el servidor
                const cantAuxiliares = item.CantidadAuxiliares || item.CantAuxiliares || 0;
                const rubros = item.Rubros;
                const auxiliaresPorRubro = item.AuxiliaresPorRubro;
                const transaccionesPorRubro = item.TransaccionesPorRubro;


                // Llamar a la función de selección
                seleccionarAsociadoGlobal(numeroAsociado, nombre, numeroIdentificacion, codTipoDoc, modalId, cantAuxiliares, {
                    Rubros: rubros,
                    AuxiliaresPorRubro: auxiliaresPorRubro,
                    TransaccionesPorRubro: transaccionesPorRubro
                });
            } else {
            }
        });
    }
}

/**
 * Muestra error en la búsqueda
 * @param {Object} config - Configuración del componente
 * @param {string} mensaje - Mensaje de error
 */
function mostrarErrorBusqueda(config, mensaje) {
    const cfg = Object.assign({}, AssociateSearchConfig.defaultConfig, config);
    $(`#${cfg.resultsTableId}`).html(`
        <tr>
            <td colspan="5" class="text-center text-danger py-4">
                <i class="fas fa-exclamation-triangle me-2"></i>${mensaje}
            </td>
        </tr>
    `);
}

/**
 * Limpia la búsqueda
 * @param {Object} config - Configuración del componente
 */
function limpiarBusquedaGlobal(config) {
    const cfg = Object.assign({}, AssociateSearchConfig.defaultConfig, config);

    // Limpiar campo de búsqueda
    $(`#${cfg.searchInputId}`).val('');

    // Limpiar tabla de resultados
    $(`#${cfg.resultsTableId}`).html(`
        <tr>
            <td colspan="5" class="text-center text-muted py-4">
                <i class="fas fa-search me-2"></i>${cfg.initialMessage}
            </td>
        </tr>
    `);
}

/**
 * Función global para seleccionar un asociado
 * @param {number} numeroAsociado - Número del asociado
 * @param {string} nombre - Nombre del asociado
 * @param {string} numeroIdentificacion - Número de identificación
 * @param {string} codTipoDoc - Código del tipo de documento
 * @param {string} modalId - ID del modal
 */
function seleccionarAsociadoGlobal(numeroAsociado, nombre, numeroIdentificacion, codTipoDoc, modalId, cantAuxiliares, jsonAuxiliares) {

    // Cerrar el modal
    $(`#${modalId}`).modal('hide');

    // Buscar la configuración del modal en el elemento data
    let config = null;
    const modalElement = document.getElementById(modalId);
    if (modalElement && modalElement.dataset.searchConfig) {
        try {
            config = JSON.parse(modalElement.dataset.searchConfig);
        } catch (e) {
        }
    }


    // Si no se encuentra la configuración, usar la por defecto
    if (!config) {
        config = AssociateSearchConfig.defaultConfig;
        config.modalId = modalId;
    }

    // Recuperar las funciones del objeto window
    const onSelectFunction = window[`${modalId}_onSelect`];
    const onCancelFunction = window[`${modalId}_onCancel`];

    // Ejecutar callback de selección si existe
    if (onSelectFunction) {
        onSelectFunction({
            numeroAsociado: numeroAsociado,
            nombre: nombre,
            numeroIdentificacion: numeroIdentificacion,
            codTipoDoc: codTipoDoc,
            cantAuxiliares: cantAuxiliares,
            Rubros: jsonAuxiliares.Rubros,
            AuxiliaresPorRubro: jsonAuxiliares.AuxiliaresPorRubro,
            TransaccionesPorRubro: jsonAuxiliares.TransaccionesPorRubro
        });
    } else {
    }
}

/**
 * Crea e inicializa un componente de búsqueda de asociados
 * @param {string} containerId - ID del contenedor donde insertar el modal
 * @param {Object} config - Configuración personalizada
 * @returns {Object} Configuración del componente creado
 */
function crearBusquedaAsociados(containerId, config = {}) {
    const cfg = Object.assign({}, AssociateSearchConfig.defaultConfig, config);

    // Crear modal único si no existe
    if (!$(`#${cfg.modalId}`).length) {
        const modalHtml = crearModalBusquedaAsociados(cfg);
        $(`#${containerId}`).append(modalHtml);

        // Almacenar la configuración en el elemento del modal
        const modalElement = document.getElementById(cfg.modalId);
        if (modalElement) {
            // Crear una copia de la configuración sin funciones para serialización
            const configToStore = Object.assign({}, cfg);
            delete configToStore.onSelect; // No se puede serializar funciones
            delete configToStore.onCancel;

            modalElement.dataset.searchConfig = JSON.stringify(configToStore);

            // Almacenar las funciones por separado
            if (cfg.onSelect) {
                window[`${cfg.modalId}_onSelect`] = cfg.onSelect;
            }
            if (cfg.onCancel) {
                window[`${cfg.modalId}_onCancel`] = cfg.onCancel;
            }
        }
    }

    // Inicializar el componente
    inicializarBusquedaAsociados(cfg);

    return cfg;
}

// Log de inicialización

