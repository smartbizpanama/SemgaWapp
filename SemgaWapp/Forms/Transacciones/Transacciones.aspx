<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Transacciones.aspx.vb" Inherits="SemgaWapp.Transacciones" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Gestión de Transacciones - Cooperativa Coopsemga</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"/>
    <!-- Toasts: posición con clase global .toast-container + modificador --top-end o --center -->
    <link href="../../Scripts/toast-global.css" rel="stylesheet" />
    
    <style>
        body {
            background: #f8f9fa;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .main-container {
            background: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin: 15px;
            padding: 15px;
            border: 1px solid #e9ecef;
        }
        
        .header-section {
            background: #2c3e50;
            color: white;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
        }
        
        .filters-section {
            background: #ffffff;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            border: 1px solid #e9ecef;
        }
        
        .table th {
            background-color: #2c3e50;
            color: white;
            border: none;
            font-weight: 500;
            font-size: 13px;
            padding: 12px 8px;
        }
        
        .table td {
            padding: 10px 8px;
            vertical-align: middle;
            border-top: 1px solid #dee2e6;
            font-size: 13px;
        }
        
        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .btn-sm {
            padding: 4px 8px;
            font-size: 11px;
        }
        
        .badge {
            font-size: 10px;
            padding: 4px 8px;
        }
        
        .form-control, .form-select {
            font-size: 13px;
            border-radius: 4px;
        }
        
        /* Campo monto: prefijo $ con fondo gris y separador (estilo tipo @ username) */
        .input-group-monto {
            border-radius: 4px;
        }
        .input-group-monto .input-group-text-monto {
            background-color: #e9ecef;
            color: #495057;
            border: 1px solid #ced4da;
            border-right: 1px solid #dee2e6;
            border-radius: 4px 0 0 4px;
            padding-left: 0.75rem;
            padding-right: 0.5rem;
        }
        .input-group-monto .form-control {
            border-radius: 0 4px 4px 0;
            border-left: none;
        }
        .input-group-monto .form-control:focus {
            outline: none;
            box-shadow: none;
        }
        .input-group-monto:focus-within .input-group-text-monto {
            border-color: #86b7fe;
            box-shadow: none;
        }
        .input-group-monto:focus-within .form-control {
            border-color: #86b7fe;
            box-shadow: none;
        }
        .input-group-monto:focus-within {
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        
        .form-label {
            font-size: 12px;
            font-weight: 500;
            margin-bottom: 4px;
        }
        
        /* Solo el contenedor de toasts informativos (top-end). No aplicar al de confirms (--center). */
        .toast-container.toast-container--top-end {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1055;
        }
        
        .toast {
            min-width: 300px;
            margin-bottom: 10px;
            border: none;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        .toast-success {
            background-color: #d4edda;
            border-left: 4px solid #28a745;
        }
        
        .toast-error {
            background-color: #f8d7da;
            border-left: 4px solid #dc3545;
        }
        
        .toast-warning {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
        }
        
        .toast-info {
            background-color: #d1ecf1;
            border-left: 4px solid #17a2b8;
        }
        
        .toast-header {
            background: transparent;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            font-weight: 600;
        }
        
        .toast-body {
            padding: 12px 16px;
        }
        
        /* Estilos para asociado bloqueado */
        .asociado-bloqueado {
            background: linear-gradient(135deg, #e8f5e8, #d4edda) !important;
            border: 2px solid #28a745 !important;
            position: relative;
        }
        
        .asociado-bloqueado::before {
            content: "✓ TRANSACCIÓN GUARDADA - ID: " attr(data-transaction-id);
            position: absolute;
            top: -10px;
            right: 10px;
            background: #28a745;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
            z-index: 10;
            white-space: nowrap;
        }
        
        .asociado-bloqueado .fas.fa-user-check {
            color: #28a745 !important;
        }
        
        .asociado-bloqueado strong {
            color: #155724 !important;
        }
        
        .asociado-bloqueado small {
            color: #155724 !important;
        }
        
        /* Estilos para el div de mensajes (error/éxito) */
        #divErrorValidacion {
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            animation: slideInError 0.3s ease-out;
        }
        
        #divErrorValidacion.alert-danger {
            border-left: 4px solid #dc3545;
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.15);
        }
        
        #divErrorValidacion.alert-success {
            border-left: 4px solid #28a745;
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.15);
        }
        
        @keyframes slideInError {
            from {
                opacity: 0;
                transform: translateX(20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        #divErrorValidacion .btn-outline-danger {
            border-color: #dc3545;
            color: #dc3545;
        }
        
        #divErrorValidacion .btn-outline-danger:hover {
            background-color: #dc3545;
            color: white;
        }
        
        #divErrorValidacion.alert-success .btn-outline-danger {
            border-color: #28a745;
            color: #28a745;
        }
        
        #divErrorValidacion.alert-success .btn-outline-danger:hover {
            background-color: #28a745;
            color: white;
        }
        
        /* Asegurar que el botón de cerrar se muestre correctamente */
        #btnCerrarError {
            display: inline-block !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        /* Asegurar que el ícono de cerrar sea una X */
        #btnCerrarError span {
            font-size: 16px !important;
            font-weight: bold !important;
            color: inherit !important;
        }
        
        /* Ajustar altura de botones para que coincida con form-control */
        #btnGuardarTransaccion, #btnCancelarTransaccion {
            height: 38px !important;
            padding: 8px 16px !important;
            font-size: 14px !important;
            line-height: 1.5 !important;
        }
        
        /* Asegurar que el botón Volver siempre esté a la derecha */
        .header-section .col-md-6.text-end {
            display: flex !important;
            justify-content: flex-end !important;
            align-items: center !important;
        }
        
        .header-section .col-md-6.text-end button {
            flex-shrink: 0 !important;
        }
        
        /* Asegurar que el header mantenga su layout */
        .header-section {
            position: relative !important;
            z-index: 1 !important;
        }
        
        .header-section .row {
            display: flex !important;
            align-items: center !important;
            justify-content: space-between !important;
        }
        
        /* Fila doble: mismo ancho 50% / 50% para asociado y para formulario+lista */
        .row-fila-doble {
            display: flex !important;
            flex-wrap: nowrap;
            justify-content: space-between;
            gap: 0 1%;
        }
        
        .row-fila-doble .columna-izq,
        .row-fila-doble .columna-der {
            flex: 0 0 49.5%;
            max-width: 50%;
            min-width: 0;
        }
        
        .row-fila-doble .columna-izq .card {
            width: 100%;
        }
        
        /* Dos columnas 50% para formulario y lista de lote (solo cuando está visible, sin .d-none) */
        #divFormularioTransaccion:not(.d-none) {
            display: flex !important;
            flex-wrap: nowrap;
            justify-content: space-between;
        }
        
        #divFormularioTransaccion.d-none {
            display: none !important;
        }
        
        #divFormularioTransaccion .card {
            min-width: 0;
        }
        
        #tblTransaccionesLote td, #tblTransaccionesLote th {
            font-size: 12px;
            padding: 6px 8px;
        }
        
        /* Botones Añadir y Cancelar del formulario: mismo tamaño y alto */
        #btnAnadirTransaccion, #btnCancelarTransaccion {
            height: 38px !important;
            min-height: 38px !important;
            width: 135px;
            min-width: 135px;
            max-width: 135px;
            padding: 0.375rem 12px !important;
            line-height: 1.5 !important;
            box-sizing: border-box;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        
        /* Ocultar barra global cuando no hay asociado */
        #divBotonesGlobales.d-none {
            display: none !important;
        }
        
        /* Barra de botones globales: mismo ancho que las columnas de arriba */
        .barra-botones-globales {
            background: rgba(13, 110, 253, 0.08);
            border-radius: 8px;
            padding: 14px 20px;
            margin: 0 0 15px 0;
            border: 1px solid rgba(13, 110, 253, 0.15);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Header Section -->
            <div class="header-section">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h6 class="mb-0" style="font-size: 16px;"><i class="fas fa-exchange-alt me-2"></i>Gestión de Transacciones</h6>
                    </div>
                    <div class="col-md-6 text-end">
                        <button type="button" class="btn btn-secondary" onclick="volverDashboard()">
                            <i class="fas fa-arrow-left me-1"></i>Volver
                        </button>
                    </div>
                </div>
            </div>

            <!-- Selección de Asociado: misma anchura y alineación que el div izquierdo (50%) -->
            <div id="rowAsociado" class="row-fila-doble mb-4">
                <div class="columna-izq">
                    <div class="card border-primary h-100">
                        <div class="card-header bg-light">
                            <h6 class="mb-0 text-primary">
                                <i class="fas fa-user me-2"></i>Asociado Seleccionado
                            </h6>
                        </div>
                        <div class="card-body py-3">
                            <div id="divSinAsociado" class="text-center py-2">
                                <div class="d-flex align-items-center justify-content-between">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-user-plus fa-lg text-muted me-3"></i>
                                        <span class="text-muted">No hay asociado seleccionado</span>
                                    </div>
                                    <button type="button" id="btnBuscarAsociado" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-search me-1"></i>Buscar
                                    </button>
                                </div>
                            </div>
                            
                            <div id="divAsociadoSeleccionado" class="alert alert-success d-none py-2 mb-0">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-user-check fa-lg text-success me-3"></i>
                                        <div>
                                            <strong id="lblAsociadoInfo" class="d-block"></strong>
                                            <small id="lblAsociadoDetalle" class="text-muted"></small>
                                        </div>
                                    </div>
                                    <button type="button" id="btnEliminarAsociado" class="btn btn-outline-success btn-sm">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Div de Error de Validación -->
                <div class="columna-der">
                    <div id="divErrorValidacion" class="alert alert-danger d-none h-100" style="margin-bottom: 0;">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-exclamation-triangle fa-lg text-danger me-3"></i>
                                <div>
                                    <strong class="d-block">Error de Validación</strong>
                                    <span id="lblMensajeError" class="text-muted"></span>
                                </div>
                            </div>
                            <button type="button" id="btnCerrarError" class="btn btn-outline-danger btn-sm">
                                <span style="font-size: 16px; font-weight: bold;">×</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dos columnas: solo visibles cuando hay asociado seleccionado -->
            <div id="divFormularioTransaccion" class="mb-3 d-none" style="gap: 0 1%; display: none !important;">
                <!-- Izquierda: formulario de datos de la transacción -->
                <div class="card border-success" style="flex: 0 0 49.5%; max-width: 50%;">
                    <div class="card-header bg-light">
                        <h6 class="mb-0 text-success">
                            <i class="fas fa-plus-circle me-2"></i>Datos de la transacción
                        </h6>
                    </div>
                    <div class="card-body">
                        <form id="formTransaccion">
                            <div class="row mb-2">
                                <div class="col-6">
                                    <label for="ddlRubro" class="form-label fw-bold">Rubro <span class="text-danger">*</span></label>
                                    <select id="ddlRubro" class="form-select form-select-sm">
                                        <option value="">Seleccionar rubro...</option>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label for="ddlAuxiliar" class="form-label fw-bold">Auxiliar <span class="text-danger">*</span></label>
                                    <select id="ddlAuxiliar" class="form-select form-select-sm">
                                        <option value="">Seleccionar auxiliar...</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-6">
                                    <label for="ddlCuenta" class="form-label fw-bold">Cuenta <span class="text-danger">*</span></label>
                                    <select id="ddlCuenta" class="form-select form-select-sm">
                                        <option value="">Seleccionar cuenta...</option>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label for="ddlCodigoTransaccion" class="form-label fw-bold">Transacción <span class="text-danger">*</span></label>
                                    <select id="ddlCodigoTransaccion" class="form-select form-select-sm">
                                        <option value="">Seleccionar código...</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-12">
                                    <label for="txtMonto" class="form-label fw-bold">Monto <span class="text-danger">*</span></label>
                                    <div class="input-group input-group-sm input-group-monto">
                                        <span class="input-group-text input-group-text-monto">$</span>
                                        <input type="text" id="txtMonto" class="form-control form-control-sm" inputmode="decimal" placeholder="0.00" autocomplete="off" maxlength="14">
                                    </div>
                                </div>
                            </div>
                            <div class="row mb-2">
                                <div class="col-12">
                                    <label for="txtObservaciones" class="form-label fw-bold">Observaciones</label>
                                    <input type="text" id="txtObservaciones" class="form-control form-control-sm" placeholder="">
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-12 d-flex gap-2 align-items-center">
                                    <button type="button" id="btnAnadirTransaccion" class="btn btn-primary">
                                        <i class="fas fa-plus me-1"></i>Añadir
                                    </button>
                                    <button type="button" id="btnCancelarTransaccion" class="btn btn-secondary">
                                        <i class="fas fa-times me-1"></i>Cancelar
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- Derecha: lista de transacciones del lote -->
                <div class="card border-primary" style="flex: 0 0 49.5%; max-width: 50%;">
                    <div class="card-header bg-light">
                        <h6 class="mb-0 text-primary" id="tituloTransaccionesLote">
                            <i class="fas fa-list me-2"></i>Transacciones del lote (máx. <%= CantTransLoteMax %>)
                        </h6>
                    </div>
                    <div class="card-body p-2">
                        <input type="hidden" id="cantTransLoteMax" value="<%= CantTransLoteMax %>" />
                        <input type="hidden" id="jsonTransaccionesLote" value="[]" />
                        <div class="table-responsive" style="max-height: 320px; overflow-y: auto;">
                            <table class="table table-sm table-hover mb-0" id="tblTransaccionesLote" style="display: none;">
                                <thead class="table-light sticky-top">
                                    <tr>
                                        <th style="width: 50px;">Línea</th>
                                        <th>Auxiliar</th>
                                        <th>Cuenta</th>
                                        <th>Transacción</th>
                                        <th class="text-end">Monto</th>
                                        <th>Mensaje</th>
                                        <th style="width: 70px;"></th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyTransaccionesLote">
                                    <!-- Filas generadas por JS -->
                                </tbody>
                            </table>
                        </div>
                        <div id="divListaVacia" class="text-center text-muted py-3 small">No hay transacciones añadidas. Use "Añadir" para agregar.</div>
                    </div>
                </div>
            </div>

            <!-- Botones globales: solo visibles cuando hay asociado seleccionado -->
            <div id="divBotonesGlobales" class="d-none" style="display: none !important;">
                <div class="barra-botones-globales">
                    <div class="d-flex justify-content-center gap-3 align-items-center">
                        <button type="button" id="btnGuardarLote" class="btn btn-success">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                        <button type="button" id="btnImprimirLote" class="btn btn-primary" style="display: none;">
                            <i class="fas fa-print me-1"></i>Imprimir
                        </button>
                        <button type="button" id="btnCancelarGlobal" class="btn btn-secondary">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                    </div>
                </div>
            </div>

            <!-- Prueba comprobante lote: solo para probar formato sin hacer transacción (oculto) -->
            <div class="mt-3 p-2 border rounded bg-light d-none" id="divPruebaComprobanteLote" style="max-width: 320px;">
                <label class="form-label small text-muted mb-1">Prueba comprobante lote</label>
                <div class="d-flex gap-2 align-items-center">
                    <input type="number" id="txtPruebaIDTransaccion" class="form-control form-control-sm" placeholder="ID Transacción" min="1" style="width: 100px;" />
                    <button type="button" id="btnPruebaImprimirLote" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-print me-1"></i>Imprimir
                    </button>
                </div>
            </div>

        </div>

        <!-- Toast: informativos (top-end) y confirms (centro) -->
        <div id="toastContainer" class="toast-container toast-container--top-end"></div>
        <div id="confirmToastContainer" class="toast-container toast-container--center" aria-hidden="true"></div>
        
        <!-- Global Modals Container -->
        <div id="globalModalsContainer"></div>
    </form>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../../Scripts/smart-chips.js"></script>
    <script src="../../Scripts/global-associate-search.js?v=1.3"></script>
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    <script src="../../Scripts/notifications.js"></script>
    <!-- Flatpickr Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>

    <script>
        $(document).ready(function() {
            // Ocultar sección de transacción y botones globales hasta que se elija un asociado
            $('#divFormularioTransaccion, #divBotonesGlobales').addClass('d-none').css('display', 'none');

            // Inicializar monitoreo de inactividad
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }

            // Inicializar componente global de búsqueda de asociados
            inicializarBusquedaAsociadosGlobal();

            // Escuchar mensajes de la ventana del comprobante
            window.addEventListener('message', function(event) {
                if (event.data && event.data.tipo === 'marcarImpreso') {
                    marcarComprobanteComoImpreso(
                        event.data.capitalMovimientoId || '',
                        event.data.interesesMovimientoId || ''
                    );
                }
            });

            // Eventos
            $('#btnBuscarAsociado').on('click', function() {
                abrirBusquedaAsociados(globalSearchConfig);
            });

            $('#btnEliminarAsociado').on('click', function() {
                if (listaTransaccionesPendientes.length > 0) {
                    mostrarErrorValidacion('Vacíe el lote de transacciones (elimine todas las filas) antes de cambiar de asociado.');
                    return;
                }
                if (tieneDatosCapturados()) {
                    mostrarConfirmEliminarAsociado();
                } else {
                    eliminarAsociadoSeleccionado();
                }
            });

            // Eventos del formulario de Transacción
            $('#ddlRubro').on('change', function() {
                const codigoRubro = $(this).val();
                if (codigoRubro) {
                    cargarAuxiliaresPorRubro(codigoRubro);
                    cargarTransaccionesPorRubro(codigoRubro);
                } else {
                    limpiarDropdowns(['#ddlAuxiliar', '#ddlCuenta', '#ddlCodigoTransaccion']);
                }
            });

            $('#ddlAuxiliar').on('change', function() {
                const auxiliarId = $(this).val();
                if (auxiliarId) {
                    cargarCuentasPorAuxiliar(auxiliarId);
                } else {
                    limpiarDropdowns(['#ddlCuenta']);
                }
            });

            $('#btnAnadirTransaccion').on('click', function() {
                añadirTransaccionALista();
            });

            $('#btnCancelarTransaccion').on('click', function() {
                limpiarFormularioTransaccion();
            });

            $('#btnGuardarLote').on('click', function() {
                guardarLote();
            });

            $('#btnCancelarGlobal').on('click', function() {
                cancelarGlobal();
            });

            $('#btnImprimirLote').on('click', function() {
                if (ultimoIDTransaccion == null || ultimoIDTransaccion === undefined) {
                    showToast('info', 'Imprimir', 'No hay comprobante de lote para imprimir.');
                    return;
                }
                imprimirComprobanteLotePorId(ultimoIDTransaccion);
            });

            $('#btnPruebaImprimirLote').on('click', function() {
                var idTrans = parseInt($('#txtPruebaIDTransaccion').val(), 10);
                if (isNaN(idTrans) || idTrans < 1) {
                    showToast('warning', 'Prueba', 'Ingrese un ID Transacción válido (número mayor a 0).');
                    return;
                }
                imprimirComprobanteLotePorId(idTrans);
            });

            function imprimirComprobanteLotePorId(idTrans) {
                $.ajax({
                    type: 'POST',
                    url: 'Transacciones.aspx/GenerarComprobanteLote',
                    data: JSON.stringify({ idTrans: idTrans }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function(response) {
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            mostrarModalComprobante(response.d.Html, '', '');
                        } else {
                            showToast('error', 'Error', (response.d && response.d.Mensaje) || 'Error al generar comprobante.');
                        }
                    },
                    error: function(xhr, status, err) {
                        showToast('error', 'Error', 'Error al generar comprobante: ' + (err || xhr.statusText));
                    }
                });
            }
            
            // Evento para cerrar el div de error
            $('#btnCerrarError').on('click', function() {
                ocultarErrorValidacion();
            });
            
            // Campo monto: solo dos decimales y formato con $
            (function() {
                var $monto = $('#txtMonto');
                $monto.on('input', function() {
                    var v = $(this).val();
                    var dot = v.indexOf('.');
                    if (dot >= 0) {
                        var before = v.substring(0, dot).replace(/[^0-9]/g, '');
                        var after = v.substring(dot + 1).replace(/[^0-9]/g, '').substring(0, 2);
                        v = (before || '') + '.' + after;
                    } else {
                        v = v.replace(/[^0-9.]/g, '');
                        if (v.split('.').length > 2) v = v.replace(/\.+$/, '');
                    }
                    $(this).val(v);
                });
                $monto.on('blur', function() {
                    var v = $(this).val().replace(',', '.').trim();
                    if (v === '' || v === '.') {
                        $(this).val('');
                        return;
                    }
                    var n = parseFloat(v);
                    if (!isNaN(n) && n >= 0) {
                        $(this).val(n.toFixed(2));
                    }
                });
            })();
            
            // Evento para presionar Enter en el campo monto -> Añadir a la lista
            $('#txtMonto').on('keypress', function(e) {
                if (e.which === 13) {
                    e.preventDefault();
                    $(this).blur();
                    setTimeout(function() { añadirTransaccionALista(); }, 50);
                }
            });
            
            // Ocultar mensajes de error/éxito cuando el usuario interactúe con cualquier control
            $('input, select, button').on('focus click change input', function() {
                ocultarMensajes();
            });
        });

        // Variable global para almacenar datos
        var asociadoSeleccionado = null;
        var globalSearchConfig = null;
        var jsonAuxiliares = null; // Almacenar el JSON de auxiliares del asociado
        var listaTransaccionesPendientes = []; // Lote de transacciones (mismo asociado). Cada ítem: { CodigoRubro, AuxiliarKey, IDAuxiliar, CodigoTransaccion, Monto, Observaciones, textoAuxiliar, textoCuenta, textoTransaccion }
        var guardandoTransaccion = false; // Usado por flujo legacy (guardar una sola transacción)

        // Función para inicializar el componente global de búsqueda
        function inicializarBusquedaAsociadosGlobal() {
            globalSearchConfig = crearBusquedaAsociados('globalModalsContainer', {
                modalId: 'modalBuscarAsociadoGlobal',
                searchInputId: 'txtBuscarAsociadoGlobal',
                resultsTableId: 'tbodyAsociadosGlobal',
                searchButtonId: 'btnBuscarAsociadoGlobal',
                clearButtonId: 'btnLimpiarBusquedaGlobal',
                modalTitle: 'Buscar Asociado',
                searchPlaceholder: 'Ingrese nombre, cédula o número de asociado...',
                validarAuxiliares: true, // Validar que el asociado tenga auxiliares
                onSelect: function(asociado) {
                    // Callback cuando se selecciona un asociado
                    seleccionarAsociado(asociado.numeroAsociado, asociado.nombre, asociado.numeroIdentificacion, asociado.codTipoDoc, asociado.cantAuxiliares, {
                        Rubros: asociado.Rubros,
                        AuxiliaresPorRubro: asociado.AuxiliaresPorRubro,
                        TransaccionesPorRubro: asociado.TransaccionesPorRubro
                    });
                },
                onCancel: function() {
                    // Callback cuando se cancela la búsqueda
                }
            });
        }


        function seleccionarAsociado(numeroAsociado, nombre, cedula, tipoDocumento, cantAuxiliares, datosAuxiliares) {
            // Almacenar los datos procesados del servidor
            if (datosAuxiliares && typeof datosAuxiliares === 'object') {
                jsonAuxiliares = datosAuxiliares;
            } else {
                jsonAuxiliares = null;
            }
            
            // Procesar selección del asociado
            procesarSeleccionAsociado(numeroAsociado, nombre, cedula, tipoDocumento);
        }

        function procesarSeleccionAsociado(numeroAsociado, nombre, cedula, tipoDocumento) {
            asociadoSeleccionado = {
                numeroAsociado: numeroAsociado,
                nombre: nombre,
                cedula: cedula,
                tipoDocumento: tipoDocumento
            };
            
            $('#lblAsociadoInfo').text(nombre);
            var identificacionHtml = crearChipIdentificacion(tipoDocumento, cedula);
            $('#lblAsociadoDetalle').html(identificacionHtml + ' | N° Asociado: ' + numeroAsociado);
            
            $('#divSinAsociado').addClass('d-none');
            $('#divAsociadoSeleccionado').removeClass('d-none');
            
            // Mostrar formulario y botones globales (solo cuando hay asociado)
            $('#divFormularioTransaccion').removeClass('d-none').css('display', 'flex');
            $('#divBotonesGlobales').removeClass('d-none').css('display', 'block');
            
            // Reiniciar lote para el nuevo asociado
            listaTransaccionesPendientes = [];
            actualizarJsonYTablaLote();
            actualizarEstadoBotonAsociado();
            
            // Ocultar cualquier error de validación previo
            ocultarErrorValidacion();
            
            // Cargar datos para el formulario usando JsonAuxiliares
            cargarDatosFormulario();
        }


        function tieneDatosCapturados() {
            // Verificar si hay datos en los campos del formulario
            const rubro = $('#ddlRubro').val();
            const auxiliar = $('#ddlAuxiliar').val();
            const cuenta = $('#ddlCuenta').val();
            const transaccion = $('#ddlCodigoTransaccion').val();
            const monto = $('#txtMonto').val();
            const observaciones = $('#txtObservaciones').val();
            
            return rubro || auxiliar || cuenta || transaccion || monto || observaciones;
        }

        function mostrarConfirmEliminarAsociado() {
            // Usar el sistema global de notificaciones
            showConfirmToast(
                'warning',
                'Advertencia',
                'Eliminar al asociado borrará los datos de la transacción.<br><strong>¿Desea continuar?</strong>',
                function() {
                    // Función de confirmación - redirigir para reiniciar todo
                    window.location.href = 'Transacciones.aspx';
                },
                function() {
                    // Función de cancelación - no hacer nada
                    showToast('info', 'Operación cancelada', 'El asociado no fue eliminado.');
                }
            );
        }

        function eliminarAsociadoSeleccionado() {
            asociadoSeleccionado = null;
            jsonAuxiliares = null;
            listaTransaccionesPendientes = [];
            $('#lblAsociadoInfo').text('');
            $('#lblAsociadoDetalle').text('');
            
            $('#divAsociadoSeleccionado').addClass('d-none');
            $('#divSinAsociado').removeClass('d-none');
            
            $('#divFormularioTransaccion').addClass('d-none').css('display', 'none');
            $('#divBotonesGlobales').addClass('d-none').css('display', 'none');
            $('#jsonTransaccionesLote').val('[]');
        }

        // Funciones para el formulario de Transacción basadas en JsonAuxiliares
        function cargarDatosFormulario() {
            if (!jsonAuxiliares) {
                return;
            }
            
            // 1. Cargar rubros únicos
            cargarRubrosDesdeJson();
            
            // 2. Si solo hay un rubro, seleccionarlo automáticamente
            if (jsonAuxiliares && jsonAuxiliares.Rubros && jsonAuxiliares.Rubros.length === 1) {
                $('#ddlRubro').val(jsonAuxiliares.Rubros[0].CodigoRubro).trigger('change');
            }
        }

        function cargarRubrosDesdeJson() {
            if (!jsonAuxiliares || !jsonAuxiliares.Rubros) {
                return;
            }
            
            $('#ddlRubro').empty();
            
            // Si solo hay un rubro, no mostrar opción "Seleccionar..."
            if (jsonAuxiliares.Rubros.length === 1) {
                $('#ddlRubro').append(`<option value="${jsonAuxiliares.Rubros[0].CodigoRubro}">${jsonAuxiliares.Rubros[0].DescripcionRubro}</option>`);
            } else {
                $('#ddlRubro').append('<option value="">Seleccionar rubro...</option>');
                $.each(jsonAuxiliares.Rubros, function(index, rubro) {
                    $('#ddlRubro').append(`<option value="${rubro.CodigoRubro}">${rubro.DescripcionRubro}</option>`);
                });
            }
        }

        /** Obtiene el value para el option del auxiliar: "Cuenta-IdTipoAuxiliar". El servidor envía Cuentas[] y no Cuenta, por eso se usa la primera cuenta. */
        function auxiliarOptionValue(auxiliar) {
            var idTipo = auxiliar.IdTipoAuxiliar || '';
            if (auxiliar.Cuentas && auxiliar.Cuentas.length > 0) {
                var prim = auxiliar.Cuentas[0];
                var cuenta = (typeof prim === 'object' && prim.Cuenta != null) ? prim.Cuenta : String(prim);
                return cuenta + '-' + idTipo;
            }
            return idTipo;
        }

        function cargarAuxiliaresPorRubro(codigoRubro) {
            if (!jsonAuxiliares || !jsonAuxiliares.AuxiliaresPorRubro || !jsonAuxiliares.AuxiliaresPorRubro[codigoRubro]) {
                return;
            }
            
            const auxiliaresDelRubro = jsonAuxiliares.AuxiliaresPorRubro[codigoRubro];
            
            $('#ddlAuxiliar').empty();
            
            // Si solo hay un auxiliar, no mostrar opción "Seleccionar..."
            if (auxiliaresDelRubro.length === 1) {
                var val1 = auxiliarOptionValue(auxiliaresDelRubro[0]);
                $('#ddlAuxiliar').append(`<option value="${val1}">${auxiliaresDelRubro[0].DescripcionAuxiliar}</option>`);
                cargarCuentasPorAuxiliar(val1);
            } else {
                $('#ddlAuxiliar').append('<option value="">Seleccionar auxiliar...</option>');
                $.each(auxiliaresDelRubro, function(index, auxiliar) {
                    var val = auxiliarOptionValue(auxiliar);
                    $('#ddlAuxiliar').append(`<option value="${val}">${auxiliar.DescripcionAuxiliar}</option>`);
                });
            }
        }

		function cargarCuentasPorAuxiliar(auxiliarId) {
			const [cuenta, idTipoAuxiliar] = auxiliarId.split('-');

			$('#ddlCuenta').empty();

			// Buscar el auxiliar en los datos para obtener todas sus cuentas
			if (jsonAuxiliares && jsonAuxiliares.AuxiliaresPorRubro) {
				let todasLasCuentas = [];

				// Buscar en todos los rubros
				Object.keys(jsonAuxiliares.AuxiliaresPorRubro).forEach(codigoRubro => {
					const auxiliares = jsonAuxiliares.AuxiliaresPorRubro[codigoRubro];
					auxiliares.forEach(auxiliar => {
						if (auxiliar.IdTipoAuxiliar === idTipoAuxiliar) {
							// Si tiene lista de cuentas, usar todas
							if (auxiliar.Cuentas && Array.isArray(auxiliar.Cuentas)) {
								auxiliar.Cuentas.forEach(cuentaItem => {
									if (typeof cuentaItem === 'object' && cuentaItem.IdAuxiliar && cuentaItem.Cuenta) {
										// Ya es un objeto con IdAuxiliar y Cuenta
										todasLasCuentas.push(cuentaItem);
									} else if (typeof cuentaItem === 'string') {
										// Es un string, crear objeto
										const cuentaObj = {
											IdAuxiliar: auxiliar.IdAuxiliar,
											Cuenta: cuentaItem
										};
										todasLasCuentas.push(cuentaObj);
									}
								});
							} else if (auxiliar.Cuenta) {
								// Si tiene una sola cuenta, agregarla con IdAuxiliar
								const cuentaObj = {
									IdAuxiliar: auxiliar.IdAuxiliar,
									Cuenta: auxiliar.Cuenta
								};
								todasLasCuentas.push(cuentaObj);
							}
						}
					});
				});
				
				// Eliminar duplicados por IdAuxiliar
				const cuentasUnicas = [];
				const idsVistos = new Set();
				todasLasCuentas.forEach(cuentaItem => {
					if (typeof cuentaItem === 'object' && cuentaItem.IdAuxiliar && !idsVistos.has(cuentaItem.IdAuxiliar)) {
						cuentasUnicas.push(cuentaItem);
						idsVistos.add(cuentaItem.IdAuxiliar);
					} else if (typeof cuentaItem === 'string' && !idsVistos.has(cuentaItem)) {
						cuentasUnicas.push({ IdAuxiliar: null, Cuenta: cuentaItem });
						idsVistos.add(cuentaItem);
					}
				});

				if (cuentasUnicas.length === 1) {
					// Si solo hay una cuenta, seleccionarla automáticamente
					const cuentaItem = cuentasUnicas[0];
					$('#ddlCuenta').append(`<option value="${cuentaItem.IdAuxiliar}">${cuentaItem.Cuenta}</option>`);
					$('#ddlCuenta').val(cuentaItem.IdAuxiliar);
				} else {
					// Si hay múltiples cuentas, mostrar opción de seleccionar
					$('#ddlCuenta').append('<option value="">Seleccionar cuenta...</option>');
					cuentasUnicas.forEach(cuentaItem => {
						$('#ddlCuenta').append(`<option value="${cuentaItem.IdAuxiliar}">${cuentaItem.Cuenta}</option>`);
					});
					// Seleccionar automáticamente la opción "Seleccionar cuenta..."
					$('#ddlCuenta').val('');
				}
			} else {
				// Fallback: usar la cuenta original
				$('#ddlCuenta').append(`<option value="${cuenta}">${cuenta}</option>`);
				$('#ddlCuenta').val(cuenta);
			}
		}

        function cargarTransaccionesPorRubro(codigoRubro) {
            if (!jsonAuxiliares || !jsonAuxiliares.TransaccionesPorRubro || !jsonAuxiliares.TransaccionesPorRubro[codigoRubro]) {
                return;
            }
            
            const transacciones = jsonAuxiliares.TransaccionesPorRubro[codigoRubro];
            $('#ddlCodigoTransaccion').empty();
            
            // Si solo hay una Transacción, no mostrar opción "Seleccionar..."
            if (transacciones.length === 1) {
                $('#ddlCodigoTransaccion').append(`<option value="${transacciones[0].CodigoTransaccion}">${transacciones[0].DescripcionTransaccion}</option>`);
            } else {
                $('#ddlCodigoTransaccion').append('<option value="">Seleccionar código...</option>');
                $.each(transacciones, function(index, transaccion) {
                    $('#ddlCodigoTransaccion').append(`<option value="${transaccion.CodigoTransaccion}">${transaccion.DescripcionTransaccion}</option>`);
                });
            }
        }

        function limpiarDropdowns(selectores) {
            $.each(selectores, function(index, selector) {
                $(selector).empty().append('<option value="">Seleccionar...</option>');
            });
        }

        function crearChipIdentificacion(codTipoDoc, numeroIdentificacion) {
            return crearChipTipoDocumento(codTipoDoc, numeroIdentificacion);
        }

        // --- Lote de transacciones (mismo asociado) ---
        function actualizarEstadoBotonAsociado() {
            var hayItems = listaTransaccionesPendientes.length > 0;
            $('#btnEliminarAsociado').prop('disabled', hayItems);
            $('#btnBuscarAsociado').prop('disabled', hayItems);
            if (hayItems) {
                $('#btnEliminarAsociado').attr('title', 'Vacíe el lote de transacciones antes de cambiar de asociado');
            } else {
                $('#btnEliminarAsociado').removeAttr('title');
            }
        }

        /** Devuelve el índice (0-based) de la primera transacción duplicada, o -1 si no hay duplicado. No se considera el monto (rubro+auxiliar+cuenta+transacción). */
        function indiceDuplicadoEnLote(codigoRubro, auxiliarKey, idAuxiliar, codigoTransaccion) {
            for (var i = 0; i < listaTransaccionesPendientes.length; i++) {
                var it = listaTransaccionesPendientes[i];
                if (it.CodigoRubro === codigoRubro &&
                    it.AuxiliarKey === auxiliarKey &&
                    String(it.IDAuxiliar) === String(idAuxiliar) &&
                    it.CodigoTransaccion === codigoTransaccion) {
                    return i;
                }
            }
            return -1;
        }

        function añadirTransaccionALista() {
            if (!validarFormularioTransaccion()) return;
            if (!asociadoSeleccionado || !asociadoSeleccionado.numeroAsociado) {
                mostrarErrorValidacion('No hay un asociado seleccionado');
                return;
            }
            var cantMax = parseInt($('#cantTransLoteMax').val(), 10) || 10;
            if (listaTransaccionesPendientes.length >= cantMax) {
                showToast('warning', 'Lote lleno', 'El lote admite como máximo ' + cantMax + ' transacciones. Debe guardar o eliminar líneas para añadir más.');
                return;
            }
            var codigoRubro = $('#ddlRubro').val();
            var auxiliarKey = $('#ddlAuxiliar').val();
            var idAuxiliar = $('#ddlCuenta').val();
            var codigoTransaccion = $('#ddlCodigoTransaccion').val();
            var montoInput = $('#txtMonto').val().replace(',', '.');
            var monto = parseFloat(montoInput);
            if (!isNaN(monto)) monto = Math.round(monto * 100) / 100;
            var item = {
                CodigoRubro: codigoRubro,
                AuxiliarKey: auxiliarKey,
                IDAuxiliar: idAuxiliar,
                CodigoTransaccion: codigoTransaccion,
                Monto: monto,
                Observaciones: $('#txtObservaciones').val() || '',
                textoAuxiliar: $('#ddlAuxiliar option:selected').text(),
                textoCuenta: $('#ddlCuenta option:selected').text(),
                textoTransaccion: $('#ddlCodigoTransaccion option:selected').text()
            };
            var idxDup = indiceDuplicadoEnLote(codigoRubro, auxiliarKey, idAuxiliar, codigoTransaccion);
            if (idxDup >= 0) {
                var numLinea = idxDup + 1;
                var cantMaxDup = parseInt($('#cantTransLoteMax').val(), 10) || 10;
                if (listaTransaccionesPendientes.length >= cantMaxDup) {
                    showToast('warning', 'Lote lleno', 'El lote admite como máximo ' + cantMaxDup + ' transacciones.');
                    return;
                }
                showConfirmToast(
                    'warning',
                    'Posible duplicado',
                    'Ya hay en la lista una transacción idéntica en la línea ' + numLinea + '.<br><strong>¿Seguro desea duplicarla?</strong>',
                    function() {
                        if (listaTransaccionesPendientes.length >= cantMaxDup) {
                            showToast('warning', 'Lote lleno', 'No se puede añadir: el lote ya tiene el máximo de ' + cantMaxDup + ' transacciones.');
                            return;
                        }
                        listaTransaccionesPendientes.push(item);
                        actualizarJsonYTablaLote();
                        actualizarEstadoBotonAsociado();
                        limpiarFormularioTransaccion();
                        ocultarErrorValidacion();
                    },
                    function() {
                        showToast('info', 'Operación cancelada', 'No se añadió la transacción.');
                    }
                );
                return;
            }
            listaTransaccionesPendientes.push(item);
            actualizarJsonYTablaLote();
            actualizarEstadoBotonAsociado();
            limpiarFormularioTransaccion();
            ocultarErrorValidacion();
        }

        function actualizarJsonYTablaLote() {
            $('#jsonTransaccionesLote').val(JSON.stringify(listaTransaccionesPendientes));
            var tbody = $('#tbodyTransaccionesLote');
            tbody.empty();
            if (listaTransaccionesPendientes.length === 0) {
                $('#divListaVacia').show();
                $('#tblTransaccionesLote').hide();
            } else {
                $('#divListaVacia').hide();
                $('#tblTransaccionesLote').show();
                $.each(listaTransaccionesPendientes, function(i, it) {
                    var montoFmt = it.Monto.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                    var tr = $('<tr></tr>').attr('data-numero-linea', i + 1);
                    tr.append($('<td class="text-center"></td>').text(i + 1));
                    tr.append($('<td></td>').text(it.textoAuxiliar || ''));
                    tr.append($('<td></td>').text(it.textoCuenta || ''));
                    tr.append($('<td></td>').text(it.textoTransaccion || ''));
                    tr.append($('<td class="text-end"></td>').text(montoFmt));
                    tr.append($('<td class="td-mensaje-lote small"></td>').text(it.Mensaje || ''));
                    var acc = $('<td class="text-nowrap"></td>');
                    acc.append($('<button type="button" class="btn btn-outline-primary btn-sm py-0 px-1" title="Editar"><i class="fas fa-edit"></i></button>').on('click', function() { editarEnLista(i); }));
                    acc.append(' ');
                    acc.append($('<button type="button" class="btn btn-outline-danger btn-sm py-0 px-1" title="Eliminar"><i class="fas fa-trash-alt"></i></button>').on('click', function() {
                        var idx = i;
                        showConfirmToast('warning', 'Eliminar línea', '¿Eliminar esta transacción del lote?', function() {
                            eliminarDeLista(idx);
                            showToast('success', 'Línea eliminada', 'Se quitó la transacción del lote.');
                        }, function() {
                            showToast('info', 'Operación cancelada', 'No se eliminó la línea.');
                        });
                    }));
                    tr.append(acc);
                    tbody.append(tr);
                });
            }
        }

        function eliminarDeLista(index) {
            listaTransaccionesPendientes.splice(index, 1);
            actualizarJsonYTablaLote();
            actualizarEstadoBotonAsociado();
        }

        function editarEnLista(index) {
            if (tieneDatosCapturados()) {
                showConfirmToast(
                    'warning',
                    'Advertencia',
                    'Hay datos capturados en el formulario de la transacción. Al editar esta fila se perderán.<br><strong>¿Desea continuar?</strong>',
                    function() {
                        procederConEditarEnLista(index);
                    },
                    function() {
                        showToast('info', 'Operación cancelada', 'No se cargaron los datos de la fila.');
                    }
                );
                return;
            }
            procederConEditarEnLista(index);
        }

        function procederConEditarEnLista(index) {
            var it = listaTransaccionesPendientes[index];
            $('#ddlRubro').val(it.CodigoRubro).trigger('change');
            setTimeout(function() {
                $('#ddlAuxiliar').val(it.AuxiliarKey || '').trigger('change');
                setTimeout(function() {
                    $('#ddlCuenta').val(it.IDAuxiliar);
                    $('#ddlCodigoTransaccion').val(it.CodigoTransaccion);
                    $('#txtMonto').val(typeof it.Monto === 'number' && !isNaN(it.Monto) ? it.Monto.toFixed(2) : it.Monto);
                    $('#txtObservaciones').val(it.Observaciones || '');
                    eliminarDeLista(index);
                }, 150);
            }, 150);
        }

        function cancelarGlobal() {
            showConfirmToast('warning', 'Cancelar todo', 'Se borrará el asociado y todas las transacciones del lote.<br><strong>¿Continuar?</strong>',
                function() {
                    eliminarAsociadoSeleccionado();
                    window.location.href = 'Transacciones.aspx';
                },
                function() { showToast('info', 'Operación cancelada', ''); }
            );
        }

        /** Construye un ítem de transacción desde el formulario actual (misma estructura que el lote). */
        function construirItemDesdeFormulario() {
            var codigoRubro = $('#ddlRubro').val();
            var auxiliarKey = $('#ddlAuxiliar').val();
            var idAuxiliar = $('#ddlCuenta').val();
            var codigoTransaccion = $('#ddlCodigoTransaccion').val();
            var montoInput = $('#txtMonto').val().replace(',', '.');
            var monto = parseFloat(montoInput);
            if (!isNaN(monto)) monto = Math.round(monto * 100) / 100;
            return {
                CodigoRubro: codigoRubro,
                AuxiliarKey: auxiliarKey,
                IDAuxiliar: idAuxiliar,
                CodigoTransaccion: codigoTransaccion,
                Monto: monto,
                Observaciones: $('#txtObservaciones').val() || '',
                textoAuxiliar: $('#ddlAuxiliar option:selected').text(),
                textoCuenta: $('#ddlCuenta option:selected').text(),
                textoTransaccion: $('#ddlCodigoTransaccion option:selected').text()
            };
        }

        /** Arma el arreglo de transacciones a guardar: lista del lote o, si está vacía, una transacción desde el formulario si está completo. */
        function obtenerTransaccionesParaGuardar() {
            if (listaTransaccionesPendientes.length > 0) {
                return listaTransaccionesPendientes.slice();
            }
            if (validarFormularioTransaccion() && asociadoSeleccionado && asociadoSeleccionado.numeroAsociado) {
                return [construirItemDesdeFormulario()];
            }
            return null;
        }

        /** Convierte un ítem interno a payload para el SP: NumeroLinea, NumeroAsociado, CodigoRubro, IDAuxiliar, CodigoTransaccion, Monto, Observaciones. NumeroLinea permite asociar el resultado del servidor con la fila de la tabla. */
        function itemAPayload(it, index) {
            return {
                NumeroLinea: (index != null ? index + 1 : 1),
                NumeroAsociado: asociadoSeleccionado ? asociadoSeleccionado.numeroAsociado : null,
                CodigoRubro: it.CodigoRubro,
                IDAuxiliar: it.IDAuxiliar,
                CodigoTransaccion: it.CodigoTransaccion,
                Monto: it.Monto,
                Observaciones: it.Observaciones || ''
            };
        }

        var loteGuardadoExito = false;
        var ultimoLoteDetalles = [];
        var ultimoIDTransaccion = null;

        function guardarLote() {
            if (loteGuardadoExito) return;
            if (listaTransaccionesPendientes.length === 0 && validarFormularioTransaccion() && asociadoSeleccionado && asociadoSeleccionado.numeroAsociado) {
                añadirTransaccionALista();
            }
            var transacciones = obtenerTransaccionesParaGuardar();
            if (!transacciones || transacciones.length === 0) {
                mostrarErrorValidacion('Añada al menos una transacción al lote o complete el formulario de datos de la transacción antes de guardar.');
                return;
            }
            var numeroAsociado = asociadoSeleccionado ? parseInt(asociadoSeleccionado.numeroAsociado, 10) : 0;
            if (!numeroAsociado) {
                mostrarErrorValidacion('No hay asociado seleccionado.');
                return;
            }
            var n = transacciones.length;
            var textoCantidad = n === 1 ? '1 transacción' : n + ' transacciones';
            showConfirmToast('warning', 'Confirmar guardado', '¿Seguro desea guardar estas ' + textoCantidad + '?', function() {
                enviarLoteAlServidor(transacciones, numeroAsociado);
            }, function() {
                showToast('info', 'Operación cancelada', 'No se guardó el lote.');
            });
        }

        function enviarLoteAlServidor(transacciones, numeroAsociado) {
            var payload = transacciones.map(function(it, i) { return itemAPayload(it, i); });
            var jsonLote = JSON.stringify(payload);
            $('#btnGuardarLote').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');
            $.ajax({
                type: 'POST',
                url: 'Transacciones.aspx/GuardarLote',
                data: JSON.stringify({ numeroAsociado: numeroAsociado, jsonLote: jsonLote }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    var d = response.d;
                    if (!d) {
                        showToast('error', 'Error', 'No se recibió respuesta del servidor.');
                        $('#btnGuardarLote').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
                        return;
                    }
                    var detalles = d.Detalles || [];
                    ultimoLoteDetalles = detalles;
                    if (d.IDTransaccion != null && d.IDTransaccion !== undefined) ultimoIDTransaccion = d.IDTransaccion;
                    actualizarMensajesEnTablaLote(detalles);
                    if (d.Resultado === 'SUCCESS') {
                        showToast('success', 'Guardado', d.Mensaje || 'Lote procesado correctamente.');
                        congelarLoteExitoso();
                        loteGuardadoExito = true;
                    } else {
                        showToast('error', 'Error', d.Mensaje || 'Hubo errores en el lote.');
                    }
                    $('#btnGuardarLote').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
                },
                error: function(xhr, status, err) {
                    showToast('error', 'Error', 'Error al guardar el lote: ' + (err || xhr.statusText));
                    $('#btnGuardarLote').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
                }
            });
        }

        /** Rellena la columna Mensaje de la tabla del lote con los Detalles devueltos por el SP (por NumeroLinea). */
        function actualizarMensajesEnTablaLote(detalles) {
            if (!detalles || !detalles.length) return;
            var map = {};
            for (var i = 0; i < detalles.length; i++) {
                var num = detalles[i].NumeroLinea;
                if (num != null) map[num] = detalles[i];
            }
            $('#tbodyTransaccionesLote tr').each(function() {
                var num = parseInt($(this).attr('data-numero-linea'), 10);
                var det = map[num];
                var $td = $(this).find('.td-mensaje-lote');
                if ($td.length && det) {
                    $td.text(det.Mensaje || '').removeClass('text-success text-danger');
                    if ((det.Mensaje || '').toUpperCase() === 'OK') $td.addClass('text-success');
                    else if (det.Mensaje) $td.addClass('text-danger');
                }
            });
        }

        /** Deshabilita formulario y tabla de lote, oculta Guardar y muestra Imprimir. */
        function congelarLoteExitoso() {
            $('#divFormularioTransaccion input, #divFormularioTransaccion select').prop('disabled', true);
            $('#btnAnadirTransaccion, #btnCancelarTransaccion').prop('disabled', true);
            $('#tbodyTransaccionesLote .btn').prop('disabled', true).addClass('disabled');
            $('#btnGuardarLote').hide();
            $('#btnImprimirLote').show();
        }

        function escapeHtml(text) {
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function guardarTransaccion() {
            // Prevenir múltiples ejecuciones simultáneas
            if (guardandoTransaccion) {
                return;
            }
            
            if (!validarFormularioTransaccion()) {
                guardandoTransaccion = false;
                return;
            }
            
            // NO establecer guardandoTransaccion = true aquí, solo cuando realmente se proceda con el guardado

            try {
            const idAuxiliarSeleccionado = $('#ddlCuenta').val();

            // Obtener datos para el confirm
            const datosConfirm = obtenerDatosParaConfirm();
            
            // Mostrar confirm dialog con los datos
            mostrarConfirmGuardado(datosConfirm);
            } catch (error) {
                mostrarErrorValidacion(error.message || 'Error al preparar los datos para guardar');
                guardandoTransaccion = false;
            }
        }

        function obtenerDatosParaConfirm() {
            // Validar que haya un asociado seleccionado
            if (!asociadoSeleccionado || !asociadoSeleccionado.numeroAsociado) {
                throw new Error('No hay un asociado seleccionado');
            }
            
            const rubroSeleccionado = $('#ddlRubro option:selected').text();
            const auxiliarSeleccionado = $('#ddlAuxiliar option:selected').text();
            const cuentaSeleccionada = $('#ddlCuenta option:selected').text();
            const transaccionSeleccionada = $('#ddlCodigoTransaccion option:selected').text();
            // Normalizar el monto para usar punto decimal
            const montoInput = $('#txtMonto').val().replace(',', '.');
            const monto = parseFloat(montoInput);
            
            const datos = {
                asociado: asociadoSeleccionado.nombre,
                numeroAsociado: asociadoSeleccionado.numeroAsociado,
                rubro: rubroSeleccionado,
                auxiliar: auxiliarSeleccionado,
                cuenta: cuentaSeleccionada,
                transaccion: transaccionSeleccionada,
                monto: monto,
                observaciones: $('#txtObservaciones').val()
            };
            
            return datos;
        }

        function mostrarConfirmGuardado(datos) {
            const montoFormateado = datos.monto.toLocaleString('en-US', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            });

            // Crear el modal personalizado
            const modalHtml = `
                <div id="modalConfirm" class="custom-modal-overlay">
                    <div class="custom-modal">
                        <div class="custom-modal-header">
                            <h5><i class="fas fa-check-circle text-primary"></i> Confirmar Transacción</h5>
                            <button type="button" class="btn-close-custom" onclick="cerrarConfirmModal()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="custom-modal-body">
                            <div class="datos-transaccion">
                                <div class="campo-dato">
                                    <span class="label">Asociado:</span>
                                    <span class="valor">${datos.asociado} (${datos.numeroAsociado})</span>
                                </div>
                                <div class="campo-dato">
                                    <span class="label">Rubro:</span>
                                    <span class="valor">${datos.rubro}</span>
                                </div>
                                <div class="campo-dato">
                                    <span class="label">Auxiliar:</span>
                                    <span class="valor">${datos.auxiliar}</span>
                                </div>
                                <div class="campo-dato">
                                    <span class="label">Cuenta:</span>
                                    <span class="valor">${datos.cuenta}</span>
                                </div>
                                <div class="campo-dato">
                                    <span class="label">Transacción:</span>
                                    <span class="valor">${datos.transaccion}</span>
                                </div>
                                <div class="campo-dato monto">
                                    <span class="label">Monto:</span>
                                    <span class="valor monto-valor">${montoFormateado}</span>
                                </div>
                                ${datos.observaciones ? `
                                <div class="campo-dato">
                                    <span class="label">Observaciones:</span>
                                    <span class="valor">${datos.observaciones}</span>
                                </div>
                                ` : ''}
                            </div>
                        </div>
                        <div class="custom-modal-footer">
                            <button type="button" class="btn btn-cancel" onclick="cerrarConfirmModal()">
                                <i class="fas fa-times"></i> Cancelar
                            </button>
                            <button type="button" class="btn btn-confirm" onclick="procederConGuardado(); cerrarConfirmModal();">
                                <i class="fas fa-save"></i> Guardar
                            </button>
                        </div>
                    </div>
                </div>
            `;

            // Agregar el modal al body
            $('body').append(modalHtml);
            
            // Agregar estilos si no existen
            if (!$('#customModalStyles').length) {
                $('head').append(`
                    <style id="customModalStyles">
                        .custom-modal-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.5);
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            z-index: 9999;
                            backdrop-filter: blur(2px);
                        }
                        
                        .custom-modal {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                            width: 90%;
                            max-width: 500px;
                            max-height: 90vh;
                            overflow: hidden;
                            animation: modalSlideIn 0.3s ease-out;
                        }
                        
                        @keyframes modalSlideIn {
                            from {
                                opacity: 0;
                                transform: translateY(-50px) scale(0.9);
                            }
                            to {
                                opacity: 1;
                                transform: translateY(0) scale(1);
                            }
                        }
                        
                        .custom-modal-header {
                            background: linear-gradient(135deg, #2c3e50, #34495e);
                            color: white;
                            padding: 20px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }
                        
                        .custom-modal-header h5 {
                            margin: 0;
                            font-size: 18px;
                            font-weight: 600;
                        }
                        
                        .btn-close-custom {
                            background: none;
                            border: none;
                            color: white;
                            font-size: 18px;
                            cursor: pointer;
                            padding: 5px;
                            border-radius: 4px;
                            transition: background-color 0.2s;
                        }
                        
                        .btn-close-custom:hover {
                            background-color: rgba(255, 255, 255, 0.1);
                        }
                        
                        .custom-modal-body {
                            padding: 15px 20px;
                        }
                        
                        .datos-transaccion {
                            background: #f8f9fa;
                            border-radius: 8px;
                            padding: 15px;
                            margin-bottom: 0;
                        }
                        
                        .campo-dato {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: 6px 0;
                            border-bottom: 1px solid #e9ecef;
                        }
                        
                        .campo-dato:last-child {
                            border-bottom: none;
                        }
                        
                        .campo-dato.monto {
                            background: #e8f5e8;
                            margin: 8px -8px -8px -8px;
                            padding: 10px 8px;
                            border-radius: 6px;
                            border-bottom: none;
                        }
                        
                        .campo-dato .label {
                            font-weight: 600;
                            color: #495057;
                            flex: 1;
                        }
                        
                        .campo-dato .valor {
                            color: #212529;
                            text-align: right;
                            flex: 2;
                        }
                        
                        .monto-valor {
                            color: #27ae60 !important;
                            font-weight: bold;
                            font-size: 16px;
                        }
                        
                        .pregunta-confirm {
                            text-align: center;
                            color: #6c757d;
                            font-size: 15px;
                            padding: 15px;
                            background: #e3f2fd;
                            border-radius: 6px;
                            border-left: 4px solid #2196f3;
                        }
                        
                        .custom-modal-footer {
                            padding: 20px;
                            background: #f8f9fa;
                            display: flex;
                            justify-content: flex-end;
                            gap: 10px;
                        }
                        
                        .btn {
                            padding: 10px 20px;
                            border: none;
                            border-radius: 6px;
                            font-weight: 500;
                            cursor: pointer;
                            transition: all 0.2s;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }
                        
                        .btn-cancel {
                            background: #6c757d;
                            color: white;
                        }
                        
                        .btn-cancel:hover {
                            background: #5a6268;
                        }
                        
                        .btn-confirm {
                            background: #28a745;
                            color: white;
                        }
                        
                        .btn-confirm:hover {
                            background: #218838;
                        }
                    </style>
                `);
            }
        }

        function cerrarConfirmModal() {
            $('#modalConfirm').remove();
            // Resetear la variable de control si el usuario cancela
            guardandoTransaccion = false;
        }

        function procederConGuardado() {
            cerrarConfirmModal();
            guardandoTransaccion = false;
            // Redirigir al flujo de lote: añadir la transacción actual al lote (si no está) y guardar lote
            if (listaTransaccionesPendientes.length === 0 && validarFormularioTransaccion() && asociadoSeleccionado && asociadoSeleccionado.numeroAsociado) {
                añadirTransaccionALista();
            }
            guardarLote();
        }

        function validarFormularioTransaccion() {
            // Validar que haya un asociado seleccionado
            if (!asociadoSeleccionado || !asociadoSeleccionado.numeroAsociado) {
                mostrarErrorValidacion('Por favor seleccione un asociado');
                return false;
            }
            
            const camposRequeridos = ['#ddlRubro', '#ddlAuxiliar', '#ddlCuenta', '#ddlCodigoTransaccion', '#txtMonto'];
            let valido = true;

            camposRequeridos.forEach(function(campo) {
                const valor = $(campo).val();
                if (!valor) {
                    $(campo).addClass('is-invalid');
                    valido = false;
                } else {
                    $(campo).removeClass('is-invalid');
                }
            });

            if (!valido) {
                mostrarErrorValidacion('Por favor complete todos los campos requeridos');
            }

            return valido;
        }

        function limpiarFormularioTransaccion() {
            // Solo limpia los campos del formulario de datos (no toca asociado ni lista del lote)
            $('#txtMonto').val('');
            $('#txtObservaciones').val('');
            $('.form-control, .form-select').removeClass('is-invalid');
            if (jsonAuxiliares && jsonAuxiliares.Rubros) {
                $('#ddlRubro').empty();
                if (jsonAuxiliares.Rubros.length === 1) {
                    $('#ddlRubro').append('<option value="' + jsonAuxiliares.Rubros[0].CodigoRubro + '">' + jsonAuxiliares.Rubros[0].DescripcionRubro + '</option>');
                } else {
                    $('#ddlRubro').append('<option value="">Seleccionar rubro...</option>');
                    $.each(jsonAuxiliares.Rubros, function(i, r) {
                        $('#ddlRubro').append('<option value="' + r.CodigoRubro + '">' + r.DescripcionRubro + '</option>');
                    });
                }
                $('#ddlAuxiliar').empty().append('<option value="">Seleccionar auxiliar...</option>');
                $('#ddlCuenta').empty().append('<option value="">Seleccionar cuenta...</option>');
                $('#ddlCodigoTransaccion').empty().append('<option value="">Seleccionar código...</option>');
            }
            ocultarErrorValidacion();
        }

        function bloquearFormularioPostGuardado() {
            // Bloquear todos los campos del formulario
            $('#ddlRubro, #ddlAuxiliar, #ddlCuenta, #ddlCodigoTransaccion, #txtMonto, #txtObservaciones').prop('disabled', true);
            
            // Bloquear la sección del asociado
            $('#btnBuscarAsociado, #btnEliminarAsociado').prop('disabled', true);
            $('#btnBuscarAsociado').html('<i class="fas fa-lock me-1"></i>Bloqueado');
            $('#btnEliminarAsociado').hide(); // Ocultar el botón de eliminar
            
            // Cambiar el estilo visual para indicar que está bloqueado
            $('#divAsociadoSeleccionado').addClass('asociado-bloqueado');
            
            // Actualizar el badge con el ID formateado (usar capital si existe, sino intereses)
            let idParaBadge = '';
            if (ultimoCapitalMovimientoId) {
                idParaBadge = ultimoCapitalMovimientoId.toString().padStart(12, '0');
            } else if (ultimoInteresesMovimientoId) {
                idParaBadge = ultimoInteresesMovimientoId.toString().padStart(12, '0');
            }
            if (idParaBadge) {
                $('#divAsociadoSeleccionado').attr('data-transaction-id', idParaBadge);
            }
            
            // Ocultar botones de guardar/cancelar
            $('#btnGuardarTransaccion, #btnCancelarTransaccion').hide();
            
            // Mostrar botones post-guardado
            $('#btnImprimirComprobante, #btnNuevaTransaccion').show();
        }

        function nuevaTransaccion() {
            // Redirigir a la misma página para limpiar completamente el estado
            window.location.href = 'Transacciones.aspx';
        }

        function imprimirComprobante() {
            // Validar que al menos uno de los IDs exista
            if ((typeof ultimoCapitalMovimientoId === 'undefined' || !ultimoCapitalMovimientoId) &&
                (typeof ultimoInteresesMovimientoId === 'undefined' || !ultimoInteresesMovimientoId)) {
                alert('No se encontraron IDs de movimientos para imprimir');
                return;
            }

            const capitalIdParaEnviar = ultimoCapitalMovimientoId ? ultimoCapitalMovimientoId.toString() : '';
            const interesesIdParaEnviar = ultimoInteresesMovimientoId ? ultimoInteresesMovimientoId.toString() : '';

            // Llamar al WebMethod para generar el comprobante
            $.ajax({
                type: 'POST',
                url: 'Transacciones.aspx/GenerarComprobante',
                data: JSON.stringify({ 
                    capitalMovimientoId: capitalIdParaEnviar,
                    interesesMovimientoId: interesesIdParaEnviar
                }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    if (response.d.Resultado === 'SUCCESS') {
                        // Mostrar el comprobante en un modal
                        mostrarModalComprobante(response.d.Html, capitalIdParaEnviar, interesesIdParaEnviar);
                    } else {
                        alert('Error al generar el comprobante: ' + response.d.Mensaje);
                    }
                },
                error: function(xhr, status, error) {
                    alert('Error al generar el comprobante: ' + error);
                }
            });
        }

        function mostrarModalComprobante(htmlContent, capitalMovimientoId, interesesMovimientoId) {
            // Crear el modal del comprobante
            const modalHtml = `
                <div id="modalComprobante" class="comprobante-modal-overlay">
                    <div class="comprobante-modal">
                        <div class="comprobante-modal-header">
                            <h5><i class="fas fa-receipt text-primary"></i> Comprobante de Transacción</h5>
                            <button type="button" class="btn-close-custom" onclick="cerrarModalComprobante()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="comprobante-modal-body">
                            <div class="comprobante-container">
                                ${htmlContent}
                            </div>
                        </div>
                        <div class="comprobante-modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="cerrarModalComprobante()">
                                <i class="fas fa-times"></i> Cerrar
                            </button>
                            <button type="button" class="btn btn-primary" onclick="imprimirDesdeModal('${capitalMovimientoId || ''}', '${interesesMovimientoId || ''}')">
                                <i class="fas fa-print"></i> Imprimir
                            </button>
                        </div>
                    </div>
                </div>
            `;

            // Agregar el modal al body
            $('body').append(modalHtml);
            
            // Agregar estilos si no existen
            if (!$('#comprobanteModalStyles').length) {
                $('head').append(`
                    <style id="comprobanteModalStyles">
                        .comprobante-modal-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.7);
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            z-index: 10000;
                            backdrop-filter: blur(3px);
                        }
                        
                        .comprobante-modal {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
                            width: 95%;
                            max-width: 900px;
                            max-height: 95vh;
                            overflow: hidden;
                            animation: modalSlideIn 0.3s ease-out;
                            display: flex;
                            flex-direction: column;
                        }
                        
                        .comprobante-modal-header {
                            background: linear-gradient(135deg, #2c3e50, #34495e);
                            color: white;
                            padding: 15px 20px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            flex-shrink: 0;
                        }
                        
                        .comprobante-modal-header h5 {
                            margin: 0;
                            font-size: 18px;
                            font-weight: 600;
                        }
                        
                        .comprobante-modal-body {
                            flex: 1;
                            overflow: auto;
                            padding: 20px;
                            background: #f8f9fa;
                        }
                        
                        .comprobante-container {
                            background: white;
                            border-radius: 8px;
                            padding: 20px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                            /* Removido max-height y overflow-y para evitar doble scroll */
                        }
                        
                        .comprobante-modal-footer {
                            padding: 15px 20px;
                            background: #f8f9fa;
                            border-top: 1px solid #dee2e6;
                            display: flex;
                            justify-content: flex-end;
                            gap: 10px;
                            flex-shrink: 0;
                        }
                        
                        /* Ocultar botones del comprobante en el modal */
                        .comprobante-container .no-print {
                            display: none !important;
                        }
                        
                        /* Ajustar el tamaño del comprobante en el modal */
                        .comprobante-container .comprobante {
                            height: auto !important;
                            margin-bottom: 10px;
                        }
                        
                        /* Botones del modal */
                        .comprobante-modal-footer .btn {
                            padding: 10px 20px;
                            border: none;
                            border-radius: 6px;
                            font-weight: 500;
                            cursor: pointer;
                            transition: all 0.2s;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }
                        
                        .comprobante-modal-footer .btn-secondary {
                            background: #6c757d;
                            color: white;
                        }
                        
                        .comprobante-modal-footer .btn-secondary:hover {
                            background: #5a6268;
                        }
                        
                        .comprobante-modal-footer .btn-primary {
                            background: #007bff;
                            color: white;
                        }
                        
                        .comprobante-modal-footer .btn-primary:hover {
                            background: #0056b3;
                        }
                    </style>
                `);
            }
        }

        function cerrarModalComprobante() {
            $('#modalComprobante').remove();
        }

        function imprimirDesdeModal(capitalMovimientoId, interesesMovimientoId) {
            // Crear una ventana temporal para imprimir
            const ventanaImpresion = window.open('', '_blank', 'width=800,height=600');
            
            // Obtener el contenido del comprobante del modal
            const contenidoComprobante = $('#modalComprobante .comprobante-container').html();
            
            // Escribir el contenido en la ventana de impresión
            ventanaImpresion.document.write(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Comprobante de Transacción</title>
                    <style>
                        body { margin: 0; padding: 20px; font-family: Arial, sans-serif; }
                        .comprobante { height: auto !important; }
                        .no-print { display: none !important; }
                    </style>
                </head>
                <body>
                    ${contenidoComprobante}
                </body>
                </html>
            `);
            
            ventanaImpresion.document.close();
            
            // Imprimir cuando la ventana esté lista
            ventanaImpresion.onload = function() {
                setTimeout(() => {
                    ventanaImpresion.print();
                    ventanaImpresion.close();
                }, 500);
            };
            
            // Cerrar el modal
            cerrarModalComprobante();
        }

        function volverDashboard() {
            window.location.href = '../../Dashboard.aspx';
        }
        
        // Funciones para manejar el div de mensajes (error/éxito)
        function mostrarErrorValidacion(mensaje) {
            $('#lblMensajeError').html(mensaje); // Usar html() en lugar de text() para interpretar HTML
            $('#divErrorValidacion').removeClass('d-none alert-success').addClass('alert-danger');
            $('#divErrorValidacion i').removeClass('fa-check-circle fa-lg text-success').addClass('fa-exclamation-triangle fa-lg text-danger');
            $('#divErrorValidacion strong').text('Error de Validación');
        }
        
        function mostrarExitoValidacion(mensaje) {
            $('#lblMensajeError').html(mensaje); // Usar html() en lugar de text() para interpretar HTML
            $('#divErrorValidacion').removeClass('d-none alert-danger').addClass('alert-success');
            $('#divErrorValidacion i').removeClass('fa-exclamation-triangle fa-lg text-danger').addClass('fa-check-circle fa-lg text-success');
            $('#divErrorValidacion strong').text('Éxito');
        }
        
        function ocultarMensajes() {
            $('#divErrorValidacion').addClass('d-none');
        }
        
        function ocultarErrorValidacion() {
            ocultarMensajes();
        }

        // Funciones de Toast Notifications
        function showToast(type, title, message, duration = 4000) {
            const toastId = 'toast-' + Date.now();
            const iconClass = getToastIcon(type);
            const toastClass = 'toast-' + type;
            
            const toastHtml = `
                <div class="toast ${toastClass}" id="${toastId}" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header">
                        <i class="${iconClass} me-2"></i>
                        <strong class="me-auto">${title}</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body">
                        ${message}
                    </div>
                </div>
            `;
            
            $('#toastContainer').append(toastHtml);
            
            const toastElement = new bootstrap.Toast(document.getElementById(toastId), {
                delay: duration
            });
            
            toastElement.show();
        }

        function getToastIcon(type) {
            switch(type) {
                case 'success': return 'fas fa-check-circle text-success';
                case 'error': return 'fas fa-exclamation-circle text-danger';
                case 'warning': return 'fas fa-exclamation-triangle text-warning';
                case 'info': return 'fas fa-info-circle text-info';
                default: return 'fas fa-info-circle text-info';
            }
        }

        /** Confirm centrado en pantalla (overlay propio, no depende de notifications.js ni caché). */
        function showConfirmToast(type, title, message, onConfirm, onCancel) {
            var overlay = document.createElement('div');
            overlay.setAttribute('role', 'dialog');
            overlay.setAttribute('aria-modal', 'true');
            overlay.style.cssText = 'position:fixed;inset:0;width:100%;height:100%;display:flex;justify-content:center;align-items:center;z-index:99999;background:rgba(0,0,0,0.3);padding:1rem;box-sizing:border-box;';
            var iconClass = getToastIcon(type);
            var toastClass = 'toast-' + type;
            var boxId = 'confirmBox-' + Date.now();
            var boxHtml = '<div id="' + boxId + '" class="toast show ' + toastClass + ' shadow" style="min-width:320px;max-width:90vw;opacity:1;">' +
                '<div class="toast-header"><i class="' + iconClass + ' me-2"></i><strong class="me-auto">' + (title || '') + '</strong></div>' +
                '<div class="toast-body">' +
                '<div class="mb-3">' + (message || '') + '</div>' +
                '<div class="d-flex gap-2 justify-content-end">' +
                '<button type="button" class="btn btn-sm btn-outline-secondary btn-cancel-confirm"><i class="fas fa-times me-1"></i>Cancelar</button>' +
                '<button type="button" class="btn btn-sm btn-primary btn-ok-confirm"><i class="fas fa-check me-1"></i>Confirmar</button>' +
                '</div></div></div>';
            overlay.innerHTML = boxHtml;
            document.body.appendChild(overlay);
            var box = document.getElementById(boxId);
            function closeConfirm() {
                if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
            }
            overlay.querySelector('.btn-ok-confirm').addEventListener('click', function() {
                if (typeof onConfirm === 'function') onConfirm();
                closeConfirm();
            });
            overlay.querySelector('.btn-cancel-confirm').addEventListener('click', function() {
                if (typeof onCancel === 'function') onCancel();
                closeConfirm();
            });
            overlay.addEventListener('click', function(e) {
                if (e.target === overlay) {
                    if (typeof onCancel === 'function') onCancel();
                    closeConfirm();
                }
            });
        }

        // Función para marcar el comprobante como impreso
        function marcarComprobanteComoImpreso(capitalMovimientoId, interesesMovimientoId) {
            $.ajax({
                type: 'POST',
                url: 'Transacciones.aspx/MarcarComprobanteImpreso',
                data: JSON.stringify({ 
                    capitalMovimientoId: capitalMovimientoId || '',
                    interesesMovimientoId: interesesMovimientoId || ''
                }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    if (response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', 'Comprobante marcado como impreso');
                    } else {
                        showToast('error', 'Error', 'Error al marcar comprobante como impreso: ' + response.d.Mensaje);
                    }
                },
                error: function(xhr, status, error) {
                    showToast('error', 'Error', 'Error al marcar comprobante como impreso: ' + error);
                }
            });
        }
    </script>
</body>
</html>

















