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
        
        .form-label {
            font-size: 12px;
            font-weight: 500;
            margin-bottom: 4px;
        }
        
        .toast-container {
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

            <!-- Selección de Asociado -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card border-primary">
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
                <div class="col-md-8">
                    <div id="divErrorValidacion" class="alert alert-danger d-none" style="margin-bottom: 0;">
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

            <!-- Formulario de Transacción -->
            <div id="divFormularioTransaccion" class="row mb-4 d-none">
                <div class="col-12">
                    <div class="card border-success">
                        <div class="card-header bg-light">
                            <h6 class="mb-0 text-success">
                                <i class="fas fa-plus-circle me-2"></i>Nueva Transacción
                            </h6>
                        </div>
                        <div class="card-body">
                            <form id="formTransaccion">
                                <div class="row">
                                    <!-- Rubro -->
                                    <div class="col-md-2">
                                        <div class="mb-3">
                                            <label for="ddlRubro" class="form-label fw-bold">Rubro <span class="text-danger">*</span></label>
                                            <select id="ddlRubro" class="form-select" required>
                                                <option value="">Seleccionar rubro...</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Auxiliar -->
                                    <div class="col-md-2">
                                        <div class="mb-3">
                                            <label for="ddlAuxiliar" class="form-label fw-bold">Auxiliar <span class="text-danger">*</span></label>
                                            <select id="ddlAuxiliar" class="form-select" required>
                                                <option value="">Seleccionar auxiliar...</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Cuenta -->
                                    <div class="col-md-2">
                                        <div class="mb-3">
                                            <label for="ddlCuenta" class="form-label fw-bold">Cuenta <span class="text-danger">*</span></label>
                                            <select id="ddlCuenta" class="form-select" required>
                                                <option value="">Seleccionar cuenta...</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Código de Transacción -->
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="ddlCodigoTransaccion" class="form-label fw-bold">Transacción <span class="text-danger">*</span></label>
                                            <select id="ddlCodigoTransaccion" class="form-select" required>
                                                <option value="">Seleccionar código...</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Monto -->
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="txtMonto" class="form-label fw-bold">Monto <span class="text-danger">*</span></label>
                                            <input type="number" id="txtMonto" class="form-control" step="0.01" min="0" placeholder="0.00" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Observaciones -->
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="txtObservaciones" class="form-label fw-bold">Observaciones</label>
                                            <input type="text" id="txtObservaciones" class="form-control" placeholder="">
                                        </div>
                                    </div>

                                    <!-- Botones -->
                                    <div class="col-md-6">
                                        <div class="mb-3 d-flex gap-2 align-items-center h-100">
                                            <!-- Botones originales -->
                                            <button type="button" id="btnGuardarTransaccion" class="btn btn-success">
                                                <i class="fas fa-save me-1"></i>Guardar
                                            </button>
                                            <button type="button" id="btnCancelarTransaccion" class="btn btn-secondary">
                                                <i class="fas fa-times me-1"></i>Cancelar
                                            </button>
                                            
                                            <!-- Botones post-guardado (inicialmente ocultos) -->
                                            <button type="button" id="btnImprimirComprobante" class="btn btn-primary" style="display: none;">
                                                <i class="fas fa-print me-1"></i>Imprimir Comprobante
                                            </button>
                                            <button type="button" id="btnNuevaTransaccion" class="btn btn-success" style="display: none;">
                                                <i class="fas fa-plus me-1"></i>Nueva Transacción
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Toast Container -->
        <div id="toastContainer" class="toast-container"></div>
        
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
                // Verificar si el formulario tiene datos capturados
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

            $('#btnGuardarTransaccion').on('click', function() {
                guardarTransaccion();
            });

            $('#btnCancelarTransaccion').on('click', function() {
                limpiarFormularioTransaccion();
            });

            // Event listeners para botones post-guardado
            $('#btnImprimirComprobante').on('click', function() {
                imprimirComprobante();
            });

            $('#btnNuevaTransaccion').on('click', function() {
                nuevaTransaccion();
            });
            
            // Evento para cerrar el div de error
            $('#btnCerrarError').on('click', function() {
                ocultarErrorValidacion();
            });
            
            // Evento para presionar Enter en el campo monto
            $('#txtMonto').on('keypress', function(e) {
                if (e.which === 13) { // Enter key
                    e.preventDefault();
                    // Quitar el foco del campo para evitar múltiples activaciones
                    $(this).blur();
                    // Pequeño delay para asegurar que el blur se procese
                    setTimeout(function() {
                        guardarTransaccion();
                    }, 50);
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
        var ultimoCapitalMovimientoId = null; // Almacenar el ID del último movimiento de capital guardado
        var ultimoInteresesMovimientoId = null; // Almacenar el ID del último movimiento de intereses guardado
        var guardandoTransaccion = false; // Prevenir múltiples ejecuciones simultáneas

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
            
            // Mostrar formulario de Transacción
            $('#divFormularioTransaccion').removeClass('d-none');
            
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
            $('#lblAsociadoInfo').text('');
            $('#lblAsociadoDetalle').text('');
            
            $('#divAsociadoSeleccionado').addClass('d-none');
            $('#divSinAsociado').removeClass('d-none');
            
            // Ocultar formulario de Transacción
            $('#divFormularioTransaccion').addClass('d-none');
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

        function cargarAuxiliaresPorRubro(codigoRubro) {
            if (!jsonAuxiliares || !jsonAuxiliares.AuxiliaresPorRubro || !jsonAuxiliares.AuxiliaresPorRubro[codigoRubro]) {
                return;
            }
            
            const auxiliaresDelRubro = jsonAuxiliares.AuxiliaresPorRubro[codigoRubro];
            
            $('#ddlAuxiliar').empty();
            
            // Si solo hay un auxiliar, no mostrar opción "Seleccionar..."
            if (auxiliaresDelRubro.length === 1) {
                $('#ddlAuxiliar').append(`<option value="${auxiliaresDelRubro[0].Cuenta}-${auxiliaresDelRubro[0].IdTipoAuxiliar}">${auxiliaresDelRubro[0].DescripcionAuxiliar}</option>`);
                // Cargar cuentas automáticamente
                cargarCuentasPorAuxiliar(`${auxiliaresDelRubro[0].Cuenta}-${auxiliaresDelRubro[0].IdTipoAuxiliar}`);
            } else {
                $('#ddlAuxiliar').append('<option value="">Seleccionar auxiliar...</option>');
                $.each(auxiliaresDelRubro, function(index, auxiliar) {
                    $('#ddlAuxiliar').append(`<option value="${auxiliar.Cuenta}-${auxiliar.IdTipoAuxiliar}">${auxiliar.DescripcionAuxiliar}</option>`);
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
            // Establecer la variable de control AHORA que realmente se procede con el guardado
            guardandoTransaccion = true;
            
            // Validar que haya un asociado seleccionado
            if (!asociadoSeleccionado || !asociadoSeleccionado.numeroAsociado) {
                mostrarErrorValidacion('No hay un asociado seleccionado');
                guardandoTransaccion = false;
                return;
            }
            
            const idAuxiliarSeleccionado = $('#ddlCuenta').val();
            
            // Normalizar el monto para usar punto decimal
            const montoInput = $('#txtMonto').val().replace(',', '.');
            const montoNormalizado = parseFloat(montoInput);
            
            const transaccionData = {
                NumeroAsociado: asociadoSeleccionado.numeroAsociado,
                CodigoRubro: $('#ddlRubro').val(),
                IDAuxiliar: idAuxiliarSeleccionado, // Usar IdAuxiliar del dropdown de cuentas
                CodigoTransaccion: $('#ddlCodigoTransaccion').val(),
                FechaMovimiento: new Date().toISOString().split('T')[0], // Fecha actual
                Monto: montoNormalizado,
                DebCred: 'D', // Por defecto Débito
                Saldo: 0,
                Observaciones: $('#txtObservaciones').val()
            };

            $.ajax({
                type: "POST",
                url: "Transacciones.aspx/GuardarMovimiento",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ movimientoData: JSON.stringify(transaccionData) }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        // Almacenar los IDs de los movimientos para el comprobante
                        ultimoCapitalMovimientoId = response.d.CapitalMovimientoID || null;
                        ultimoInteresesMovimientoId = response.d.InteresesMovimientoID || null;
                        
                        // Construir mensaje de éxito con los IDs formateados
                        let mensajeExito = 'Movimiento guardado correctamente.';
                        if (ultimoCapitalMovimientoId) {
                            const idCapitalFormateado = ultimoCapitalMovimientoId.toString().padStart(12, '0');
                            mensajeExito += ` Capital: ${idCapitalFormateado}`;
                        }
                        if (ultimoInteresesMovimientoId) {
                            const idInteresesFormateado = ultimoInteresesMovimientoId.toString().padStart(12, '0');
                            mensajeExito += ` Intereses: ${idInteresesFormateado}`;
                        }
                        
                        mostrarExitoValidacion(mensajeExito);
                        bloquearFormularioPostGuardado();
                    } else {
                        // Mostrar error en el div de validación en lugar del toast
                        mostrarErrorValidacion(response.d.Mensaje || 'Error al guardar movimiento');
                    }
                    // Resetear la variable de control
                    guardandoTransaccion = false;
                },
                error: function() {
                    mostrarErrorValidacion('Error al guardar movimiento');
                    // Resetear la variable de control
                    guardandoTransaccion = false;
                }
            });
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
            // Resetear la variable de control
            guardandoTransaccion = false;
            
            // Limpiar todas las variables globales
            asociadoSeleccionado = null;
            jsonAuxiliares = null;
            ultimoCapitalMovimientoId = null;
            ultimoInteresesMovimientoId = null;
            
            // Limpiar el formulario
            $('#formTransaccion')[0].reset();
            $('#ddlRubro, #ddlAuxiliar, #ddlCuenta, #ddlCodigoTransaccion').empty().append('<option value="">Seleccionar...</option>');
            $('.form-control, .form-select').removeClass('is-invalid');
            
            // Habilitar todos los campos (por si estaban bloqueados)
            $('#ddlRubro, #ddlAuxiliar, #ddlCuenta, #ddlCodigoTransaccion, #txtMonto, #txtObservaciones').prop('disabled', false);
            
            // Limpiar la UI del asociado
            $('#lblAsociadoInfo').text('');
            $('#lblAsociadoDetalle').text('');
            $('#divAsociadoSeleccionado').addClass('d-none');
            $('#divSinAsociado').removeClass('d-none');
            $('#btnBuscarAsociado').prop('disabled', false).html('<i class="fas fa-search me-1"></i>Buscar Asociado');
            $('#btnEliminarAsociado').show();
            $('#divAsociadoSeleccionado').removeClass('asociado-bloqueado');
            
            // Ocultar formulario de transacción
            $('#divFormularioTransaccion').addClass('d-none');
            
            // Asegurar que los botones de guardar/cancelar estén visibles
            $('#btnGuardarTransaccion, #btnCancelarTransaccion').show();
            
            // Ocultar botones post-guardado
            $('#btnImprimirComprobante, #btnNuevaTransaccion').hide();
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
                        
                        .comprobante-container .separator {
                            display: none;
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
            // Marcar como impreso
            marcarComprobanteComoImpreso(capitalMovimientoId || '', interesesMovimientoId || '');
            
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
                        .separator { display: block !important; }
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

















