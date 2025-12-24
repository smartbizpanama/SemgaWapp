<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AuxiliaresAsociados.aspx.vb" Inherits="SemgaWapp.AuxiliaresAsociados" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Gestión de Auxiliares Asociados - Cooperativa Coopsemga</title>
    
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
        
        .btn-primary {
            background: #2c3e50;
            border: 1px solid #2c3e50;
            border-radius: 4px;
            padding: 6px 12px;
            font-weight: 500;
            color: white;
            font-size: 12px;
        }
        
        .btn-primary:hover {
            background: #34495e;
            border-color: #34495e;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(44, 62, 80, 0.2);
        }
        
        .table {
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .table thead th {
            background: #34495e;
            color: white;
            border: none;
            border-right: 1px solid #5a6c7d;
            font-weight: 600;
            font-size: 12px;
            padding: 8px 6px;
            text-align: center !important;
            vertical-align: middle;
        }
        
        .table thead th:last-child {
            border-right: none;
        }
        
        .table tbody td {
            padding: 6px;
            border-bottom: 1px solid #f1f3f4;
            border-right: 1px solid #dee2e6;
            vertical-align: middle;
            font-size: 12px;
            text-align: center;
        }
        
        /* Asegurar que el campo de fecha tenga el mismo tamaño que los demás */
        .flatpickr-date {
            width: 100% !important;
            height: 38px !important;
            font-size: 14px !important;
            padding: 8px 12px !important;
            border: 1px solid #ced4da !important;
            border-radius: 0.375rem !important;
        }
        
        /* Asegurar que el input de fecha tenga el mismo estilo que otros form-control */
        input.flatpickr-date.form-control {
            display: block !important;
            width: 100% !important;
            padding: 8px 12px !important;
            font-size: 14px !important;
            font-weight: 400 !important;
            line-height: 1.5 !important;
            color: #212529 !important;
            background-color: #fff !important;
            background-clip: padding-box !important;
            border: 1px solid #ced4da !important;
            border-radius: 0.375rem !important;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out !important;
        }
        
        
        .table tbody td:last-child {
            border-right: none;
        }
        
        .table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .modal-content {
            border-radius: 8px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .modal-header {
            background: #2c3e50;
            color: white;
            border-radius: 8px 8px 0 0;
            border: none;
            padding: 20px;
        }
        
        .btn-light {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            color: #495057;
        }
        
        .btn-light:hover {
            background: #e9ecef;
            border-color: #adb5bd;
            color: #495057;
        }
        
        .btn-secondary {
            background: #6c757d;
            border-color: #6c757d;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            border-color: #545b62;
        }
        
        .action-buttons {
            white-space: nowrap;
        }
        
        .form-control, .form-select {
            border-radius: 4px;
            border: 1px solid #ced4da;
            font-size: 12px;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #2c3e50;
            box-shadow: 0 0 0 0.2rem rgba(44, 62, 80, 0.25);
        }
        
        .form-label {
            font-size: 12px;
            font-weight: 600;
            color: #495057;
        }
        
        .numero-asociado-display {
            background: #f8f9fa;
            color: #495057;
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            text-align: center;
            border-left: 2px solid #17a2b8;
            min-height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
            letter-spacing: 0.5px;
        }

        /* Efecto blur para el modal de búsqueda */
        .modal-backdrop.show {
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
        }

        /* Toast Notifications */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }

        .toast {
            min-width: 300px;
            max-width: 400px;
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

        /* Modal de búsqueda con sombra más prominente */
        #modalBuscarAsociado .modal-content {
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            border: 2px solid #007bff;
        }

        /* Header del modal de búsqueda con color distintivo */
        #modalBuscarAsociado .modal-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            border-bottom: 2px solid #0056b3;
        }

        /* Estilos para campos bloqueados */
        .form-control[readonly] {
            background-color: #f8f9fa !important;
            border-color: #dee2e6 !important;
            cursor: not-allowed !important;
        }

        .form-control[readonly]:focus {
            box-shadow: none !important;
            border-color: #dee2e6 !important;
        }

        .bg-light {
            background-color: #f8f9fa !important;
        }

        /* Estilos para switch más grande */
        .form-check.form-switch {
            font-size: 14px;
        }

        .form-check.form-switch .form-check-input {
            width: 2.5em !important;
            height: 1.5em !important;
            cursor: pointer;
        }

        .form-check.form-switch .form-check-label {
            font-size: 14px;
            font-weight: 500;
            margin-left: 6px;
        }

        /* Estilos para menú contextual */
        .context-menu {
            position: absolute;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            z-index: 1000;
            min-width: 200px;
            overflow: hidden;
        }

        .context-menu-item {
            padding: 10px 15px;
            cursor: pointer;
            border-bottom: 1px solid #f1f3f4;
            transition: background-color 0.2s;
            font-size: 14px;
            color: #495057;
        }

        .context-menu-item:last-child {
            border-bottom: none;
        }

        .context-menu-item:hover {
            background-color: #f8f9fa;
            color: #2c3e50;
        }

        .context-menu-item i {
            width: 16px;
            margin-right: 8px;
        }
        
        /* Resaltado de fila seleccionada para menú contextual */
        .fila-seleccionada-contextual {
            background-color: #e3f2fd !important;
            border-left: 3px solid #2196f3 !important;
            transition: all 0.2s ease-in-out;
        }
        
        .fila-seleccionada-contextual td {
            background-color: #e3f2fd !important;
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
                        <h6 class="mb-0" style="font-size: 16px;"><i class="fas fa-users-cog me-2"></i>Gestión de Auxiliares Asociados</h6>
                    </div>
                    <div class="col-md-6 text-end">
                        <button type="button" class="btn btn-light me-2" data-bs-toggle="modal" data-bs-target="#modalAuxiliar">
                            <i class="fas fa-plus me-1"></i>Nuevo Auxiliar
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="volverDashboard()">
                            <i class="fas fa-arrow-left me-1"></i>Volver
                        </button>
                    </div>
                </div>
            </div>

            <!-- Filters Section -->
            <div class="filters-section">
                <div class="row align-items-end">
                    <div class="col-md-3">
                        <label class="form-label">Buscar</label>
                        <input type="text" id="txtBuscar" class="form-control" placeholder="Buscar por asociado, cuenta, identificación, rubro o tipo..."/>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Rubro</label>
                        <select id="ddlRubro" class="form-select">
                            <option value="">Todos los rubros</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Tipo Auxiliar</label>
                        <select id="ddlTipoAuxiliar" class="form-select">
                            <option value="">Todos los tipos</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <div class="d-flex gap-2">
                            <button type="button" id="btnBuscar" class="btn btn-primary flex-fill">
                                <i class="fas fa-search me-1"></i>Buscar
                            </button>
                            <button type="button" id="btnLimpiar" class="btn btn-danger flex-fill">
                                <i class="fas fa-times me-1"></i>Limpiar
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabla de Auxiliares -->
            <div class="table-responsive">
                <table id="tblAuxiliares" class="table table-hover">
                    <thead>
                        <tr>
                            <th class="text-center">ID</th>
                            <th class="text-center">Cuenta</th>
                            <th class="text-center">identificación</th>
                            <th class="text-center">Asociado</th>
                            <th class="text-center">Rubro</th>
                            <th class="text-center">Tipo Auxiliar</th>
                            <th class="text-center">Cuota</th>
                            <th class="text-center">Saldo</th>
                            <th class="text-center">Monto Original</th>
                            <th class="text-center">Monto Pignorado</th>
                            <th class="text-center">Tasa Interés</th>
                            <th class="text-center">Pago Mensual</th>
                            <th class="text-center">Fecha Otorgado</th>
                            <th class="text-center">ÚltimoPago</th>
                            <th class="text-center">Fecha Creación</th>
                            <th class="text-center">Usuario Crea</th>
                            <th class="text-center">Usuario Modifica</th>
                            <th class="text-center">Activo</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyAuxiliares">
                        <tr>
                            <td colspan="19" class="text-center text-muted py-4">
                                <i class="fas fa-spinner fa-spin me-2"></i>Cargando auxiliares...
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        </div>

        <!-- Modal Auxiliar -->
        <div class="modal fade" id="modalAuxiliar" tabindex="-1" aria-labelledby="modalAuxiliarLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalAuxiliarLabel">
                            <i class="fas fa-user-plus me-2"></i>Nuevo Auxiliar
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formAuxiliar">
                            <input type="hidden" id="hdnAuxiliarID" />
                            <input type="hidden" id="hdnModoEdicion" value="false" />
                            <input type="hidden" id="hdnNumeroAsociado" />
                            
                            <!-- Selección de Asociado -->
                            <div class="row mb-4">
                                <div class="col-12">
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
                            </div>

                            <!-- Datos del Auxiliar -->
                            <div id="divDatosAuxiliar" style="display: none;">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="ddlRubroModal" class="form-label fw-bold">Rubro <span class="text-danger">*</span></label>
                                            <select id="ddlRubroModal" class="form-select" required>
                                                <option value="">Seleccionar rubro...</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="ddlTipoAuxiliarModal" class="form-label fw-bold">Tipo de Auxiliar <span class="text-danger">*</span></label>
                                            <select id="ddlTipoAuxiliarModal" class="form-select" required>
                                                <option value="">Seleccionar tipo...</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="txtMontoOriginal" class="form-label fw-bold">Monto Original <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <input type="number" id="txtMontoOriginal" class="form-control" step="0.01" min="0" required/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="txtCuota" class="form-label fw-bold">Cuota <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <input type="number" id="txtCuota" class="form-control" step="0.01" min="0" required/>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="txtPagoMes" class="form-label fw-bold">Pago Mensual</label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <input type="number" id="txtPagoMes" class="form-control" step="0.01" min="0"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="txtFechaOtorgado" class="form-label fw-bold">Fecha Otorgado</label>
                                            <input type="text" id="txtFechaOtorgado" class="form-control flatpickr-date" placeholder="dd/mm/yyyy"/>
                                        </div>
                                    </div>
                                </div>

                                <!-- Campos deshabilitados en la última fila -->
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="txtTasaInteres" class="form-label fw-bold">Tasa de Interés (%)</label>
                                            <div class="input-group">
                                                <input type="number" id="txtTasaInteres" class="form-control" step="0.01" min="0" max="100" readonly/>
                                                <span class="input-group-text">%</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="txtSaldo" class="form-label fw-bold">Saldo Actual</label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <input type="number" id="txtSaldo" class="form-control" step="0.01" min="0" readonly/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="mb-3">
                                            <label for="txtMontoPignorado" class="form-label fw-bold">Monto Pignorado</label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <input type="number" id="txtMontoPignorado" class="form-control" step="0.01" min="0" readonly/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarAuxiliar" class="btn btn-success">
                            <i class="fas fa-save me-1"></i>Guardar Auxiliar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal para búsqueda de Asociados -->
        <div class="modal fade" id="modalBuscarAsociado" tabindex="-1" aria-labelledby="modalBuscarAsociadoLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalBuscarAsociadoLabel">
                            <i class="fas fa-user-search me-2"></i>Buscar Asociado
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- búsqueda -->
                        <div class="row mb-3">
                            <div class="col-12">
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                                    <input type="text" id="txtBuscarAsociadoModal" class="form-control" placeholder="Buscar por nombre, cédula o número de asociado..."/>
                                    <button type="button" id="btnBuscarAsociadoModal" class="btn btn-primary">
                                        <i class="fas fa-search"></i> Buscar
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Lista de Resultados -->
                        <div class="table-responsive" style="max-height: 400px;">
                            <table class="table table-sm table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>N° Asociado</th>
                                        <th>Nombre Completo</th>
                                        <th>identificación</th>
                                        <th>Tipo</th>
                                        <th class="text-center">Auxiliares</th>
                                        <th class="text-center">Acción</th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyAsociadosModal">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">
                                            <i class="fas fa-search me-2"></i>Ingrese un término de búsqueda para comenzar
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>
    
    <!-- Contenedor para modales globales -->
    <div id="globalModalsContainer"></div>

    <!-- Menú contextual para auxiliares -->
    <div id="contextMenu" class="context-menu" style="display: none; position: absolute; background: white; border: 1px solid #ccc; border-radius: 4px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); z-index: 1000; min-width: 200px;">
        <div class="context-menu-item" id="modificarMontoPignorado" style="padding: 8px 12px; cursor: pointer; border-bottom: 1px solid #eee;">
            <i class="fas fa-edit me-2"></i>Modificar Monto Pignorado
        </div>
    </div>

    <!-- Modal para modificar monto pignorado -->
    <div class="modal fade" id="modalModificarMontoPignorado" tabindex="-1" aria-labelledby="modalModificarMontoPignoradoLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalModificarMontoPignoradoLabel">
                        <i class="fas fa-edit me-2"></i>Modificar Monto Pignorado
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formModificarMontoPignorado">
                        <input type="hidden" id="hdnAuxiliarIDModificar" />
                        <input type="hidden" id="hdnNumeroAsociadoModificar" />
                        
                        <div class="mb-3">
                            <label for="txtMontoPignoradoModificar" class="form-label fw-bold">Nuevo Monto Pignorado</label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" id="txtMontoPignoradoModificar" class="form-control" step="0.01" min="0" required/>
                            </div>
                        </div>
                        
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>Información del Auxiliar:</strong>
                            <div id="infoAuxiliarModificar"></div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancelar
                    </button>
                    <button type="button" id="btnGuardarMontoPignorado" class="btn btn-success">
                        <i class="fas fa-save me-1"></i>Guardar Cambios
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../../Scripts/smart-chips.js"></script>
    <script src="../../Scripts/global-associate-search.js"></script>
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    <!-- Flatpickr Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>

    <script>
        $(document).ready(function() {
            // Inicializar monitoreo de inactividad
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }

            // Inicializar Flatpickr para fechas
            flatpickr(".flatpickr-date", {
                locale: "es",
                dateFormat: "d/m/Y",
                allowInput: true,
                clickOpens: true,
                placeholder: "dd/mm/yyyy"
            });


            // Cargar datos iniciales
            cargarRubros();
            cargarTiposAuxiliares();
            cargarAuxiliares();
            
            // Inicializar componente global de búsqueda de asociados
            inicializarBusquedaAsociadosGlobal();

            // Eventos
            $('#txtBuscar').on('input keyup', function() {
                filtrarAuxiliaresCliente();
            });

            $('#ddlTipoAuxiliar, #ddlRubro').on('change', function() {
                filtrarAuxiliaresCliente();
            });

            $('#btnBuscar').on('click', function() {
                filtrarAuxiliaresServidor();
            });

            $('#btnLimpiar').on('click', function() {
                limpiarFiltros();
            });

            // Event listeners para el modal de búsqueda (usando componente global)
            $('#btnBuscarAsociado').on('click', function() {
                abrirBusquedaAsociados(globalSearchConfig);
            });

            $('#btnBuscarAsociadoModal').on('click', function() {
                buscarAsociadosModal();
            });

            $('#txtBuscarAsociadoModal').on('keypress', function(e) {
                if (e.which === 13) {
                    buscarAsociadosModal();
                }
            });

            // Evento para el botón eliminar asociado
            $('#btnEliminarAsociado').on('click', function() {
                var modoEdicion = $('#hdnModoEdicion').val();
                if (modoEdicion === 'true') {
                    // En modo edición, mostrar toast de advertencia
                    showToast('warning', 'No se puede cambiar el asociado', 'En modo edición no se puede cambiar el asociado seleccionado.');
                } else {
                    // En modo crear, eliminar el asociado normalmente
                    eliminarAsociadoSeleccionado();
                }
            });

            $('#btnGuardarAuxiliar').on('click', function() {
                guardarAuxiliar();
            });

            // Event listeners para menú contextual
            $('#modificarMontoPignorado').on('click', function() {
                modificarMontoPignorado();
            });

            $('#btnGuardarMontoPignorado').on('click', function() {
                guardarMontoPignorado();
            });

            // Ocultar menú contextual al hacer click fuera
            $(document).on('click', function(e) {
                if (!$(e.target).closest('#contextMenu, .context-menu-trigger').length) {
                    ocultarMenuContextual();
                }
            });

            // Ocultar menú contextual al hacer scroll
            $(window).on('scroll', function() {
                ocultarMenuContextual();
            });

            // Limpiar clases de Validación cuando se complete un campo
            $('#ddlRubroModal, #ddlTipoAuxiliarModal, #txtMontoOriginal, #txtCuota').on('change input', function() {
                $(this).removeClass('is-invalid');
            });

            // Normalizar valores numéricos en tiempo real
            $('.form-control[type="number"]').on('input blur', function() {
                var valor = $(this).val();
                if (valor && valor.includes(',')) {
                    // Convertir coma a punto automáticamente
                    var valorNormalizado = valor.replace(',', '.');
                    $(this).val(valorNormalizado);
                }
            });

            // Restringir Monto Pignorado a valores >= 0
            $('#txtMontoPignorado').on('input blur', function() {
                var valor = normalizarValorNumerico($(this).val());
                if (valor < 0) {
                    $(this).val(0);
                    showToast('warning', 'Valor inválido', 'El Monto Pignorado no puede ser negativo');
                }
            });

            // Limpiar modal al abrir solo si no está en modo edición
            $('#modalAuxiliar').on('show.bs.modal', function() {
                var modoEdicion = $('#hdnModoEdicion').val();
                if (modoEdicion !== 'true') {
                    limpiarModal();
                    // Asegurar que los campos estén bloqueados para nuevo auxiliar
                    $('#txtSaldo').val('0').prop('readonly', true).addClass('bg-light');
                    $('#txtMontoPignorado').val('0').prop('readonly', true).addClass('bg-light');
                }
            });
            
            // Limpiar modal al cerrar
            $('#modalAuxiliar').on('hidden.bs.modal', function() {
                limpiarModal();
            });

            // Cambiar tipo de auxiliar según rubro
            $('#ddlRubroModal').on('change', function() {
                cargarTiposAuxiliaresModal();
            });

            // Manejar cambio de tipo de auxiliar para cargar tasa automática
            $('#ddlTipoAuxiliarModal').on('change', function() {
                cargarTasaAutomatica();
            });

            // También aplicar cuando se carga el modal
            $('#modalAuxiliar').on('shown.bs.modal', function() {
                // Asegurar que los campos estén bloqueados SIEMPRE
                $('#txtSaldo').prop('readonly', true).addClass('bg-light');
                $('#txtTasaInteres').prop('readonly', true).addClass('bg-light');
                $('#txtPagoMes').prop('readonly', true).addClass('bg-light');
                
                // Monto Pignorado: solo habilitar si el usuario tiene permisos Y el rubro es "AH"
                // Esta lógica se maneja en editarAuxiliar, aquí solo aplicamos bloqueo por defecto
                $('#txtMontoPignorado').prop('readonly', true).addClass('bg-light');
                
                // Aplicar tasa automática si hay un tipo seleccionado
                setTimeout(function() {
                    cargarTasaAutomatica();
                }, 200);
            });
        });

        // Variable global para almacenar todos los tipos de auxiliares
        var todosLosTiposAuxiliares = [];
        var globalSearchConfig = null;
        
        // Variable global para almacenar todos los auxiliares
        var todosLosAuxiliares = [];
        
        // Variables para menú contextual
        var nivelAcceso = <%= If(Session("NivelAcceso") IsNot Nothing, CInt(Session("NivelAcceso")), 999) %>;
        var auxiliarSeleccionado = null;
        
        // El valor ya viene como número desde el servidor, no necesitamos conversión
        // Solo validar que sea un número válido
        if (typeof nivelAcceso !== 'number' || isNaN(nivelAcceso)) {
            nivelAcceso = 999;
        }
        
        // Función para obtener información del equipo
        function obtenerInformacionEquipo() {
            var equipoInfo = {
                timestamp: new Date().toISOString(),
                userAgent: navigator.userAgent,
                language: navigator.language,
                platform: navigator.platform,
                cookieEnabled: navigator.cookieEnabled,
                onLine: navigator.onLine,
                screen: {
                    width: screen.width,
                    height: screen.height,
                    colorDepth: screen.colorDepth,
                    pixelDepth: screen.pixelDepth
                },
                window: {
                    innerWidth: window.innerWidth,
                    innerHeight: window.innerHeight,
                    outerWidth: window.outerWidth,
                    outerHeight: window.outerHeight
                },
                timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
                url: window.location.href,
                referrer: document.referrer,
                // Información adicional del sistema
                hardwareConcurrency: navigator.hardwareConcurrency || 'N/A',
                maxTouchPoints: navigator.maxTouchPoints || 0,
                deviceMemory: navigator.deviceMemory || 'N/A',
                connection: navigator.connection ? {
                    effectiveType: navigator.connection.effectiveType,
                    downlink: navigator.connection.downlink,
                    rtt: navigator.connection.rtt
                } : 'N/A',
                // Información de geolocalización (si está disponible)
                geolocation: 'N/A', // Se puede obtener con permiso del usuario
                // Información del navegador
                browser: {
                    name: getBrowserName(),
                    version: getBrowserVersion(),
                    engine: getBrowserEngine()
                },
                // Información del sistema operativo
                os: getOperatingSystem(),
                // Información de red
                network: {
                    connection: navigator.connection ? navigator.connection.effectiveType : 'N/A',
                    online: navigator.onLine
                }
            };
            
            return JSON.stringify(equipoInfo);
        }
        
        // Función para obtener el nombre del navegador
        function getBrowserName() {
            var userAgent = navigator.userAgent;
            if (userAgent.indexOf('Chrome') > -1) return 'Chrome';
            if (userAgent.indexOf('Firefox') > -1) return 'Firefox';
            if (userAgent.indexOf('Safari') > -1) return 'Safari';
            if (userAgent.indexOf('Edge') > -1) return 'Edge';
            if (userAgent.indexOf('Opera') > -1) return 'Opera';
            return 'Unknown';
        }
        
        // Función para obtener la versión del navegador
        function getBrowserVersion() {
            var userAgent = navigator.userAgent;
            var match = userAgent.match(/(Chrome|Firefox|Safari|Edge|Opera)\/(\d+\.\d+)/);
            return match ? match[2] : 'Unknown';
        }
        
        // Función para obtener el motor del navegador
        function getBrowserEngine() {
            var userAgent = navigator.userAgent;
            if (userAgent.indexOf('WebKit') > -1) return 'WebKit';
            if (userAgent.indexOf('Gecko') > -1) return 'Gecko';
            if (userAgent.indexOf('Trident') > -1) return 'Trident';
            return 'Unknown';
        }
        
        // Función para obtener el sistema operativo
        function getOperatingSystem() {
            var userAgent = navigator.userAgent;
            var platform = navigator.platform;
            
            if (userAgent.indexOf('Windows') > -1) {
                if (userAgent.indexOf('Windows NT 10.0') > -1) return 'Windows 10';
                if (userAgent.indexOf('Windows NT 6.3') > -1) return 'Windows 8.1';
                if (userAgent.indexOf('Windows NT 6.2') > -1) return 'Windows 8';
                if (userAgent.indexOf('Windows NT 6.1') > -1) return 'Windows 7';
                return 'Windows';
            }
            if (userAgent.indexOf('Mac') > -1) return 'macOS';
            if (userAgent.indexOf('Linux') > -1) return 'Linux';
            if (userAgent.indexOf('Android') > -1) return 'Android';
            if (userAgent.indexOf('iOS') > -1) return 'iOS';
            return platform || 'Unknown';
        }
        
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
                validarAuxiliares: false, // Permite seleccionar cualquier asociado para crear auxiliares
                onSelect: function(asociado) {
                    // Callback cuando se selecciona un asociado
                    
                    seleccionarAsociado(asociado.numeroAsociado, asociado.nombre, asociado.numeroIdentificacion, asociado.codTipoDoc);
                },
                onCancel: function() {
                    // Callback cuando se cancela la búsqueda
                    
                }
            });
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
            
            // Remover el toast del DOM después de que se oculte
            document.getElementById(toastId).addEventListener('hidden.bs.toast', function() {
                this.remove();
            });
        }

        function getToastIcon(type) {
            switch(type) {
                case 'success': return 'fas fa-check-circle text-success';
                case 'error': return 'fas fa-exclamation-circle text-danger';
                case 'warning': return 'fas fa-exclamation-triangle text-warning';
                case 'info': return 'fas fa-info-circle text-info';
                default: return 'fas fa-bell text-primary';
            }
        }

        function showConfirmToast(type, title, message, onConfirm, onCancel) {
            const toastId = 'confirm-toast-' + Date.now();
            const iconClass = getToastIcon(type);
            const toastClass = 'toast-' + type;
            
            const toastHtml = `
                <div class="toast ${toastClass}" id="${toastId}" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header">
                        <i class="${iconClass} me-2"></i>
                        <strong class="me-auto">${title}</strong>
                    </div>
                    <div class="toast-body">
                        <div class="mb-3">${message}</div>
                        <div class="d-flex gap-2 justify-content-end">
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="cancelConfirmToast('${toastId}')">
                                <i class="fas fa-times me-1"></i>Cancelar
                            </button>
                            <button type="button" class="btn btn-sm btn-danger" onclick="confirmToast('${toastId}')">
                                <i class="fas fa-check me-1"></i>Confirmar
                            </button>
                        </div>
                    </div>
                </div>
            `;
            
            $('#toastContainer').append(toastHtml);
            
            // Almacenar las funciones de callback en el elemento
            document.getElementById(toastId).onConfirm = onConfirm;
            document.getElementById(toastId).onCancel = onCancel;
            
            const toastElement = new bootstrap.Toast(document.getElementById(toastId), {
                autohide: false,
                delay: 0
            });
            
            toastElement.show();
        }

        function confirmToast(toastId) {
            const toastElement = document.getElementById(toastId);
            if (toastElement && toastElement.onConfirm) {
                toastElement.onConfirm();
            }
            bootstrap.Toast.getInstance(toastElement).hide();
        }

        function cancelConfirmToast(toastId) {
            const toastElement = document.getElementById(toastId);
            if (toastElement && toastElement.onCancel) {
                toastElement.onCancel();
            }
            bootstrap.Toast.getInstance(toastElement).hide();
        }

        function cargarRubros() {
            $.ajax({
                type: "POST",
                url: "AuxiliaresAsociados.aspx/ObtenerRubros",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        var rubros = JSON.parse(response.d.Data);
                        var html = '<option value="">Todos los rubros</option>';
                        $.each(rubros, function(index, item) {
                            html += '<option value="' + item.CodigoRubro + '">' + item.Descripcion + '</option>';
                        });
                        $('#ddlRubro').html(html);
                        
                        var htmlModal = '<option value="">Seleccionar rubro...</option>';
                        $.each(rubros, function(index, item) {
                            htmlModal += '<option value="' + item.CodigoRubro + '">' + item.Descripcion + '</option>';
                        });
                        $('#ddlRubroModal').html(htmlModal);
                    }
                },
                error: function() {
                    
                }
            });
        }

        function cargarTiposAuxiliares() {
            $.ajax({
                type: "POST",
                url: "AuxiliaresAsociados.aspx/ObtenerTiposAuxiliares",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        todosLosTiposAuxiliares = JSON.parse(response.d.Data);
                        
                        
                        var html = '<option value="">Todos los tipos</option>';
                        $.each(todosLosTiposAuxiliares, function(index, item) {
                            
                            // Usar IdTipoAuxiliar como valor único
                            html += '<option value="' + item.IdTipoAuxiliar + '">' + item.Descripcion + '</option>';
                        });
                        $('#ddlTipoAuxiliar').html(html);
                    }
                },
                error: function() {
                    
                }
            });
        }

        function cargarTiposAuxiliaresModal() {
            var codigoRubro = $('#ddlRubroModal').val();
            var html = '<option value="">Seleccionar tipo...</option>';
            
            if (codigoRubro && todosLosTiposAuxiliares.length > 0) {
                // Filtrar tipos de auxiliares por rubro en el cliente
                var tiposFiltrados = todosLosTiposAuxiliares.filter(function(tipo) {
                    return tipo.CodigoRubro === codigoRubro;
                });
                
                $.each(tiposFiltrados, function(index, item) {
                    html += '<option value="' + item.IdTipoAuxiliar + '" data-tasa="' + (item.Tasa || 0) + '">' + item.Descripcion + '</option>';
                });
                
                // Si solo hay un tipo, seleccionarlo automáticamente
                if (tiposFiltrados.length === 1) {
                    html = '<option value="' + tiposFiltrados[0].IdTipoAuxiliar + '" data-tasa="' + (tiposFiltrados[0].Tasa || 0) + '">' + tiposFiltrados[0].Descripcion + '</option>';
                    $('#ddlTipoAuxiliarModal').html(html);
                    $('#ddlTipoAuxiliarModal').val(tiposFiltrados[0].IdTipoAuxiliar);
                    // Cargar tasa automática si hay un solo tipo
                    cargarTasaAutomatica();
                } else {
                    $('#ddlTipoAuxiliarModal').html(html);
                }
            } else {
                $('#ddlTipoAuxiliarModal').html(html);
            }
        }

        function cargarTasaAutomatica() {
            var tipoSeleccionado = $('#ddlTipoAuxiliarModal option:selected');
            var tasa = parseFloat(tipoSeleccionado.data('tasa')) || 0;
            
            // Siempre mantener el campo bloqueado
            $('#txtTasaInteres').prop('readonly', true);
            $('#txtTasaInteres').addClass('bg-light');
            
            if (tasa > 0) {
                $('#txtTasaInteres').val(tasa);
            } else {
                $('#txtTasaInteres').val('');
            }
        }

        function cargarAuxiliares() {
            $.ajax({
                type: "POST",
                url: "AuxiliaresAsociados.aspx/ObtenerTodosAuxiliares",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        var auxiliares = JSON.parse(response.d.Data);
                        todosLosAuxiliares = auxiliares; // Almacenar para búsqueda en cliente
                        mostrarAuxiliares(auxiliares);
                    } else {
                        $('#tbodyAuxiliares').html('<tr><td colspan="19" class="text-center text-danger py-4">Error al cargar auxiliares</td></tr>');
                    }
                },
                error: function() {
                    $('#tbodyAuxiliares').html('<tr><td colspan="19" class="text-center text-danger py-4">Error al cargar auxiliares</td></tr>');
                }
            });
        }

        // Función de compatibilidad - ahora usa la función global
        function crearChipRubroLocal(rubro) {
            return crearChipRubro(rubro);
        }

        // Función de compatibilidad - ahora usa la función global
        function crearChipIdentificacion(codTipoDoc, numeroIdentificacion) {
            return crearChipTipoDocumento(codTipoDoc, numeroIdentificacion);
        }

        function mostrarAuxiliares(auxiliares) {
            
            
            
            
            // NO sobrescribir la variable global - solo mostrar
            // todosLosAuxiliares = auxiliares; // REMOVIDO
            
            if (auxiliares.length === 0) {
                
                $('#tbodyAuxiliares').html('<tr><td colspan="19" class="text-center text-muted py-4">No hay auxiliares registrados</td></tr>');
                return;
            }

            // Verificar nivel de acceso antes de construir la tabla
            // No usar || porque 0 es falsy, usar validación explícita
            var nivelAccesoActual = nivelAcceso;
            if (typeof nivelAccesoActual !== 'number' || isNaN(nivelAccesoActual)) {
                nivelAccesoActual = 999;
            }
            var puedeEliminar = (nivelAccesoActual == 0 || nivelAccesoActual == 1);

            var html = '';
            $.each(auxiliares, function(index, item) {
                html += '<tr data-auxiliar=\'' + JSON.stringify(item).replace(/'/g, "&#39;") + '\'>';
                html += '<td class="text-center">' + item.ID + '</td>';
                html += '<td class="text-center">' + (item.Cuenta || '-') + '</td>';
                html += '<td class="text-start">' + crearChipIdentificacion(item.CodTipoDoc, item.NumeroIdentificacion) + '</td>';
                html += '<td class="text-center">' + item.NombreAsociado + '</td>';
                html += '<td class="text-center">' + crearChipRubroLocal(item.DescripcionRubro) + '</td>';
                html += '<td class="text-center">' + item.DescripcionTipoAuxiliar + '</td>';
                html += '<td class="text-center">$' + parseFloat(item.Cuota || 0).toFixed(2) + '</td>';
                html += '<td class="text-center">$' + parseFloat(item.Saldo || 0).toFixed(2) + '</td>';
                html += '<td class="text-center">$' + parseFloat(item.MontoOriginal || 0).toFixed(2) + '</td>';
                html += '<td class="text-center">$' + parseFloat(item.MontoPignorado || 0).toFixed(2) + '</td>';
                html += '<td class="text-center">' + parseFloat(item.TasaInteres || 0).toFixed(2) + '%</td>';
                html += '<td class="text-center">$' + parseFloat(item.PagoMes || 0).toFixed(2) + '</td>';
                html += '<td class="text-center">' + (item.FechaOtorgado || '-') + '</td>';
                html += '<td class="text-center">' + (item.FechaUltimoPago || '-') + '</td>';
                html += '<td class="text-center">' + (item.FechaCreacion || '-') + '</td>';
                html += '<td class="text-center">' + (item.UsuarioCrea || '-') + '</td>';
                html += '<td class="text-center">' + (item.UsuarioModifica || '-') + '</td>';
                html += '<td class="text-center">';
                // Mostrar switch solo si tiene permisos, sino solo texto
                var snActivo = item.snActivo === true || item.snActivo === 1 || item.snActivo === '1' || item.snActivo === 'true';
                if (puedeEliminar) {
                    var checkedAttr = snActivo ? 'checked' : '';
                    html += '<div class="form-check form-switch d-inline-block">';
                    html += '<input class="form-check-input" type="checkbox" role="switch" id="switchActivo_' + item.ID + '_' + item.NumeroAsociado + '" ' + checkedAttr + ' onchange="cambiarEstadoActivo(' + item.ID + ', ' + item.NumeroAsociado + ', this.checked)">';
                    html += '<label class="form-check-label ms-1" for="switchActivo_' + item.ID + '_' + item.NumeroAsociado + '">' + (snActivo ? 'Sí' : 'No') + '</label>';
                    html += '</div>';
                } else {
                    // Solo mostrar texto sin switch ni badge
                    html += (snActivo ? 'Sí' : 'No');
                }
                html += '</td>';
                html += '<td class="text-center">';
                html += '<button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarAuxiliar(' + item.ID + ', ' + item.NumeroAsociado + ')">';
                html += '<i class="fas fa-edit"></i>';
                html += '</button>';
                // Solo mostrar botón de eliminar si tiene permisos
                if (puedeEliminar) {
                    html += '<button type="button" class="btn btn-sm btn-outline-danger me-1" onclick="eliminarAuxiliar(' + item.ID + ', ' + item.NumeroAsociado + ')">';
                    html += '<i class="fas fa-trash"></i>';
                    html += '</button>';
                }
                
                // No agregar botón de menú contextual - se maneja con clic derecho
                html += '</td>';
                html += '</tr>';
            });
            $('#tbodyAuxiliares').html(html);
            
            // Agregar evento de clic derecho a las filas para menú contextual
            $('#tbodyAuxiliares tr').on('contextmenu', function(e) {
                e.preventDefault();
                var auxiliarDataStr = $(this).attr('data-auxiliar');
                if (auxiliarDataStr && nivelAcceso <= 1) {
                    try {
                        var auxiliarData = JSON.parse(auxiliarDataStr.replace(/&#39;/g, "'"));
                        // Solo mostrar menú contextual para auxiliares con rubro "AH"
                        if (auxiliarData.CodigoRubro === 'AH') {
                            mostrarMenuContextual(e, auxiliarData);
                        }
                    } catch (error) {
                        // Error al parsear datos del auxiliar
                    }
                }
            });
        }

        function buscarAsociadosModal() {
            var busqueda = $('#txtBuscarAsociadoModal').val().trim();
            
            if (busqueda.length < 1) {
                showToast('info', 'Información', 'Ingrese al menos 1 carácter para buscar');
                return;
            }

            // Detectar si es un número (ID) o texto
            var esNumero = !isNaN(busqueda) && !isNaN(parseFloat(busqueda)) && isFinite(busqueda);
            var tipoBusqueda = esNumero ? 'ID' : 'TEXTO';
            

            $.ajax({
                type: "POST",
                url: "AuxiliaresAsociados.aspx/BuscarAsociados",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ busqueda: busqueda }),
                success: function(response) {
                    
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        var asociados = JSON.parse(response.d.Data);
                        mostrarAsociadosModal(asociados);
                    } else {
                        $('#tbodyAsociadosModal').html('<tr><td colspan="6" class="text-center text-muted">No se encontraron asociados</td></tr>');
                    }
                },
                error: function(xhr, status, error) {
                    
                    $('#tbodyAsociadosModal').html('<tr><td colspan="6" class="text-center text-danger">Error al buscar asociados</td></tr>');
                }
            });
        }

        function mostrarAsociadosModal(asociados) {
            if (asociados.length === 0) {
                $('#tbodyAsociadosModal').html('<tr><td colspan="6" class="text-center text-muted">No se encontraron asociados</td></tr>');
            } else {
                var html = '';
                $.each(asociados, function(index, item) {
                    var cantidadAuxiliares = item.CantidadAuxiliares || 0;
                    html += '<tr>';
                    html += '<td>' + item.NumeroAsociado + '</td>';
                    html += '<td>' + item.NombreCompleto + '</td>';
                    html += '<td>' + crearChipTipoDocumento(item.CodTipoDoc, item.NumeroIdentificacion) + '</td>';
                    html += '<td>' + item.TipoAsociado + '</td>';
                    html += '<td class="text-center">';
                    html += '<span class="badge bg-secondary">' + cantidadAuxiliares + '</span>';
                    html += '</td>';
                    html += '<td class="text-center">';
                    html += '<button type="button" class="btn btn-sm btn-primary" onclick="seleccionarAsociado(' + item.NumeroAsociado + ', \'' + item.NombreCompleto + '\', \'' + item.NumeroIdentificacion + '\', \'' + (item.CodTipoDoc || '') + '\')">';
                    html += '<i class="fas fa-check me-1"></i>Seleccionar';
                    html += '</button>';
                    html += '</td>';
                    html += '</tr>';
                });
                $('#tbodyAsociadosModal').html(html);
            }
        }

        function seleccionarAsociado(numeroAsociado, nombre, cedula, tipoDocumento) {
            
            
            $('#hdnNumeroAsociado').val(numeroAsociado);
            $('#lblAsociadoInfo').text(nombre);
            var identificacionHtml = crearChipIdentificacion(tipoDocumento, cedula);
            $('#lblAsociadoDetalle').html(identificacionHtml + ' | N° Asociado: ' + numeroAsociado);
            
            $('#divSinAsociado').addClass('d-none');
            $('#divAsociadoSeleccionado').removeClass('d-none');
            
            // Mostrar los campos del auxiliar cuando se selecciona un asociado
            $('#divDatosAuxiliar').show();
            
            // Asegurar que el botón está habilitado (modo crear nuevo)
            $('#btnEliminarAsociado').prop('disabled', false);
            
            $('#modalBuscarAsociado').modal('hide');
            
        }

        function eliminarAsociadoSeleccionado() {
            // Limpiar campos
            $('#hdnNumeroAsociado').val('');
            $('#lblAsociadoInfo').text('');
            $('#lblAsociadoDetalle').text('');
            
            // Cambiar visibilidad
            $('#divAsociadoSeleccionado').addClass('d-none');
            $('#divSinAsociado').removeClass('d-none');
            
            // Ocultar los campos del auxiliar cuando se elimina el asociado
            $('#divDatosAuxiliar').hide();
            
        }

        function validarCamposObligatorios() {
            var camposObligatorios = [
                { id: '#ddlRubroModal', nombre: 'Rubro' },
                { id: '#ddlTipoAuxiliarModal', nombre: 'Tipo Auxiliar' },
                { id: '#txtMontoOriginal', nombre: 'Monto Original' },
                { id: '#txtCuota', nombre: 'Cuota' }
            ];

            var valido = true;
            var camposFaltantes = [];

            camposObligatorios.forEach(function(campo) {
                var valor = $(campo.id).val();
                if (!valor || valor.trim() === '') {
                    $(campo.id).addClass('is-invalid');
                    camposFaltantes.push(campo.nombre);
                    valido = false;
                } else {
                    $(campo.id).removeClass('is-invalid');
                }
            });

            if (!valido) {
                showToast('warning', 'Campos Requeridos', 'Debe completar los siguientes campos: ' + camposFaltantes.join(', '));
            }

            return valido;
        }

        // Función para normalizar valores numéricos (convertir coma a punto)
        function normalizarValorNumerico(valor) {
            if (!valor || valor === '') return 0;
            
            // Convertir coma a punto para formato decimal
            var valorNormalizado = valor.toString().replace(',', '.');
            
            // Parsear como float
            var valorNumerico = parseFloat(valorNormalizado);
            
            // Si no es un número válido, retornar 0
            if (isNaN(valorNumerico)) return 0;
            
            return valorNumerico;
        }

        function guardarAuxiliar() {
            // Validaciones
            if (!$('#divAsociadoSeleccionado').is(':visible')) {
                showToast('error', 'Error', 'Debe seleccionar un asociado');
                return;
            }

            // Validar campos obligatorios
            if (!validarCamposObligatorios()) {
                return;
            }

            // Normalizar y validar Monto Pignorado (>= 0)
            var montoPignoradoVal = normalizarValorNumerico($('#txtMontoPignorado').val());
            if (montoPignoradoVal < 0) {
                montoPignoradoVal = 0;
                $('#txtMontoPignorado').val(0);
                showToast('warning', 'Valor ajustado', 'El Monto Pignorado no puede ser negativo. Se ajustó a 0.');
            }

            // Obtener el IdTipoAuxiliar del dropdown seleccionado
            var tipoAuxiliarSeleccionado = $('#ddlTipoAuxiliarModal option:selected');
            var idTipoAuxiliar = tipoAuxiliarSeleccionado.val();
            var descripcionTipoAuxiliar = tipoAuxiliarSeleccionado.text();

            var auxiliar = {
                ID: $('#hdnAuxiliarID').val() || 0,
                NumeroAsociado: $('#hdnNumeroAsociado').val(),
                CodigoRubro: $('#ddlRubroModal').val(),
                TipoAuxiliar: idTipoAuxiliar, // Enviar el ID en lugar de la descripción
                DescripcionTipoAuxiliar: descripcionTipoAuxiliar, // Para referencia
                Cuota: normalizarValorNumerico($('#txtCuota').val()),
                Saldo: normalizarValorNumerico($('#txtSaldo').val()),
                MontoOriginal: normalizarValorNumerico($('#txtMontoOriginal').val()),
                MontoPignorado: montoPignoradoVal,
                FechaOtorgado: convertirFechaParaBD($('#txtFechaOtorgado').val()),
                // Campos opcionales - normalizar valores numéricos
                TasaInteres: normalizarValorNumerico($('#txtTasaInteres').val()),
                PagoMes: normalizarValorNumerico($('#txtPagoMes').val())
            };

            $.ajax({
                type: "POST",
                url: "AuxiliaresAsociados.aspx/GuardarAuxiliar",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ auxiliar: auxiliar }),
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', 'Auxiliar guardado correctamente');
                        $('#modalAuxiliar').modal('hide');
                        cargarAuxiliares();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al guardar auxiliar');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al guardar auxiliar');
                }
            });
        }

        function editarAuxiliar(id, numeroAsociado) {
            // Buscar el auxiliar en los datos existentes
            var auxiliar = todosLosAuxiliares.find(function(item) {
                return item.ID == id && item.NumeroAsociado == numeroAsociado;
            });
            
            if (!auxiliar) {
                showToast('error', 'Error', 'No se encontró el auxiliar');
                return;
            }
            
            // Llenar el modal con los datos del auxiliar
            $('#hdnAuxiliarID').val(auxiliar.ID);
            $('#hdnModoEdicion').val('true');
            $('#hdnNumeroAsociado').val(auxiliar.NumeroAsociado);
            
            // Mostrar información del asociado
            $('#lblAsociadoInfo').text(auxiliar.NombreAsociado);
            var identificacionHtml = crearChipIdentificacion(auxiliar.CodTipoDoc, auxiliar.NumeroIdentificacion);
            $('#lblAsociadoDetalle').html(identificacionHtml + ' | N° Asociado: ' + auxiliar.NumeroAsociado);
            $('#divAsociadoSeleccionado').removeClass('d-none');
            $('#divSinAsociado').addClass('d-none');
            
            // Mostrar los campos del auxiliar en modo edición (ya tiene asociado)
            $('#divDatosAuxiliar').show();
            
            // Mantener botón habilitado para mostrar toast en modo edición
            $('#btnEliminarAsociado').prop('disabled', false);
            
            // Llenar campos del auxiliar
            $('#ddlRubroModal').val(auxiliar.CodigoRubro);
            cargarTiposAuxiliaresModal();
            
            setTimeout(function() {
                $('#ddlTipoAuxiliarModal').val(auxiliar.IdTipoAuxiliar);
            }, 500);
            
            $('#txtMontoOriginal').val(auxiliar.MontoOriginal);
            
            // Habilitar Monto Pignorado solo para usuarios con nivel 0 o 1 Y rubro "AH"
            if (parseInt(nivelAcceso) <= 1 && auxiliar.CodigoRubro === 'AH') {
                $('#txtMontoPignorado').val(auxiliar.MontoPignorado).prop('readonly', false).removeClass('bg-light');
            } else {
                $('#txtMontoPignorado').val(auxiliar.MontoPignorado).prop('readonly', true).addClass('bg-light');
            }
            
            $('#txtCuota').val(auxiliar.Cuota);
            $('#txtSaldo').val(auxiliar.Saldo).prop('readonly', true).addClass('bg-light');
            $('#txtTasaInteres').val(auxiliar.TasaInteres).prop('readonly', true).addClass('bg-light');
            $('#txtPagoMes').val(auxiliar.PagoMes).prop('readonly', true).addClass('bg-light');
            $('#txtFechaOtorgado').val(formatearFecha(auxiliar.FechaOtorgado));
            
            // Aplicar tasa automática si corresponde
            setTimeout(function() {
                cargarTasaAutomatica();
            }, 100);
            
            // Cambiar título del modal con cuenta del auxiliar
            $('#modalAuxiliarLabel').html('<i class="fas fa-edit me-2"></i>Editar Auxiliar - Cuenta: ' + (auxiliar.Cuenta || 'Sin cuenta'));
            
            // Abrir modal
            $('#modalAuxiliar').modal('show');
        }

        function eliminarAuxiliar(id, numeroAsociado) {
            // Validar que el usuario tenga permisos (rol 0 o 1)
            var nivelAccesoActual = nivelAcceso;
            if (typeof nivelAccesoActual !== 'number' || isNaN(nivelAccesoActual)) {
                nivelAccesoActual = 999;
            }
            if (nivelAccesoActual !== 0 && nivelAccesoActual !== 1) {
                showToast('error', 'Sin Permisos', 'No tiene permisos para eliminar auxiliares. Solo usuarios con nivel de acceso 0 o 1 pueden realizar esta acción.');
                return;
            }

            // Mostrar toast de confirmación elegante
            showConfirmToast(
                'warning',
                'Confirmar Eliminación',
                '¿Está seguro de que desea eliminar este auxiliar? Esta acción no se puede deshacer.',
                function() {
                    // Función de confirmación - ejecutar eliminación
                    var equipoInfo = obtenerInformacionEquipo();
                    
                    $.ajax({
                        type: "POST",
						url: "AuxiliaresAsociados.aspx/EliminarAuxiliar",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: JSON.stringify({ 
                            id: id, 
                            numeroAsociado: numeroAsociado,
                            equipoElimina: equipoInfo
                        }),
                        success: function(response) {
                            if (response.d && response.d.Resultado === 'SUCCESS') {
                                showToast('success', 'Éxito', 'Auxiliar eliminado correctamente');
                                cargarAuxiliares();
                            } else {
                                showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar auxiliar');
                            }
                        },
                        error: function() {
                            showToast('error', 'Error', 'Error al eliminar auxiliar');
                        }
                    });
                },
                function() {
                    // Función de cancelación - no hacer nada
                    showToast('info', 'Cancelado', 'Eliminación cancelada');
                }
            );
        }

        function cambiarEstadoActivo(id, numeroAsociado, nuevoEstado) {
            // Validar que el usuario tenga permisos (rol 0 o 1)
            var nivelAccesoActual = nivelAcceso;
            if (typeof nivelAccesoActual !== 'number' || isNaN(nivelAccesoActual)) {
                nivelAccesoActual = 999;
            }
            if (nivelAccesoActual !== 0 && nivelAccesoActual !== 1) {
                // Revertir el switch si no tiene permisos
                var switchElement = $('#switchActivo_' + id + '_' + numeroAsociado);
                switchElement.prop('checked', !nuevoEstado);
                showToast('error', 'Sin Permisos', 'No tiene permisos para activar/desactivar auxiliares. Solo usuarios con nivel de acceso 0 o 1 pueden realizar esta acción.');
                return;
            }

            // Determinar el mensaje de confirmación según el nuevo estado
            var accion = nuevoEstado ? 'activar' : 'desactivar';
            var mensajeConfirmacion = '¿Está seguro que desea ' + accion + ' este auxiliar?';

            // Mostrar toast de confirmación elegante
            showConfirmToast(
                'warning',
                'Confirmar Cambio de Estado',
                mensajeConfirmacion,
                function() {
                    // Función de confirmación - ejecutar cambio de estado
                    $.ajax({
                        type: "POST",
                        url: "AuxiliaresAsociados.aspx/ActivarDesactivarAuxiliar",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: JSON.stringify({ 
                            id: id, 
                            numeroAsociado: numeroAsociado,
                            snActivo: nuevoEstado
                        }),
                        success: function(response) {
                            if (response.d && response.d.Resultado === 'SUCCESS') {
                                var mensaje = nuevoEstado ? 'Auxiliar activado correctamente' : 'Auxiliar desactivado correctamente';
                                showToast('success', 'Éxito', mensaje);
                                // Actualizar el label del switch
                                var labelElement = $('label[for="switchActivo_' + id + '_' + numeroAsociado + '"]');
                                labelElement.text(nuevoEstado ? 'Sí' : 'No');
                                cargarAuxiliares();
                            } else {
                                // Revertir el switch si hay error
                                var switchElement = $('#switchActivo_' + id + '_' + numeroAsociado);
                                switchElement.prop('checked', !nuevoEstado);
                                showToast('error', 'Error', response.d.Mensaje || 'Error al cambiar el estado del auxiliar');
                            }
                        },
                        error: function() {
                            // Revertir el switch si hay error
                            var switchElement = $('#switchActivo_' + id + '_' + numeroAsociado);
                            switchElement.prop('checked', !nuevoEstado);
                            showToast('error', 'Error', 'Error al cambiar el estado del auxiliar');
                        }
                    });
                },
                function() {
                    // Función de cancelación - revertir el switch
                    var switchElement = $('#switchActivo_' + id + '_' + numeroAsociado);
                    switchElement.prop('checked', !nuevoEstado);
                    var labelElement = $('label[for="switchActivo_' + id + '_' + numeroAsociado + '"]');
                    labelElement.text(!nuevoEstado ? 'Sí' : 'No');
                    showToast('info', 'Cancelado', 'Cambio de estado cancelado');
                }
            );
        }

        // Función para filtrar en el cliente (búsqueda rápida)
        function filtrarAuxiliaresCliente() {
            var busqueda = $('#txtBuscar').val().trim().toLowerCase();
            var tipoAuxiliar = $('#ddlTipoAuxiliar').val();
            var codigoRubro = $('#ddlRubro').val();

            
            
            
            
            
            
            todosLosAuxiliares.forEach(function(aux, index) {
                
            });

            // Si no hay filtros aplicados, mostrar todos los auxiliares
            if (busqueda === '' && tipoAuxiliar === '' && codigoRubro === '') {
                
                mostrarAuxiliares(todosLosAuxiliares);
                return;
            }

            var auxiliaresFiltrados = todosLosAuxiliares.filter(function(auxiliar) {
                var cumpleBusqueda = true;
                var cumpleTipo = true;
                var cumpleRubro = true;

                // Filtro por búsqueda de texto
                if (busqueda !== '') {
                    cumpleBusqueda = (
                        auxiliar.NombreAsociado.toLowerCase().includes(busqueda) ||
                        auxiliar.NumeroAsociado.toLowerCase().includes(busqueda) ||
                        auxiliar.DescripcionRubro.toLowerCase().includes(busqueda) ||
                        auxiliar.DescripcionTipoAuxiliar.toLowerCase().includes(busqueda) ||
                        auxiliar.NumeroIdentificacion.toLowerCase().includes(busqueda) ||
                        (auxiliar.Cuenta && auxiliar.Cuenta.toLowerCase().includes(busqueda))
                    );
                }

                // Filtro por tipo de auxiliar
                if (tipoAuxiliar !== '') {
                    // Comparar directamente por IdTipoAuxiliar
                    cumpleTipo = auxiliar.IdTipoAuxiliar === tipoAuxiliar;
                }

                // Filtro por rubro
                if (codigoRubro !== '') {
                    
                    
                    
                    cumpleRubro = auxiliar.CodigoRubro === codigoRubro;
                    
                }

                var resultado = cumpleBusqueda && cumpleTipo && cumpleRubro;
                
                return resultado;
            });

            
            mostrarAuxiliares(auxiliaresFiltrados);
        }

        // Función para filtrar en el servidor (búsqueda completa)
        function filtrarAuxiliaresServidor() {
            var busqueda = $('#txtBuscar').val().trim();
            var tipoAuxiliar = $('#ddlTipoAuxiliar').val();
            var codigoRubro = $('#ddlRubro').val();

            $.ajax({
                type: "POST",
                url: "AuxiliaresAsociados.aspx/FiltrarAuxiliares",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 
                    busqueda: busqueda, 
                    tipoAuxiliar: tipoAuxiliar, 
                    codigoRubro: codigoRubro 
                }),
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        var auxiliares = JSON.parse(response.d.Data);
                        todosLosAuxiliares = auxiliares; // Actualizar datos globales
                        mostrarAuxiliares(auxiliares);
                    } else {
                        $('#tbodyAuxiliares').html('<tr><td colspan="19" class="text-center text-danger py-4">Error al filtrar auxiliares</td></tr>');
                    }
                },
                error: function() {
                    $('#tbodyAuxiliares').html('<tr><td colspan="19" class="text-center text-danger py-4">Error al filtrar auxiliares</td></tr>');
                }
            });
        }

        function limpiarFiltros() {
            $('#txtBuscar').val('');
            $('#ddlTipoAuxiliar').val('');
            $('#ddlRubro').val('');
            cargarAuxiliares();
        }

        function limpiarModal() {
            // Limpiar formulario si existe
            var formElement = $('#formAuxiliar')[0];
            if (formElement) {
                formElement.reset();
            }
            
            // Limpiar campos ocultos
            $('#hdnAuxiliarID').val('');
            $('#hdnModoEdicion').val('false');
            $('#hdnNumeroAsociado').val('');
            
            // Limpiar todos los campos del modal
            $('#ddlRubroModal').val('').trigger('change');
            $('#ddlTipoAuxiliarModal').val('').trigger('change');
            $('#txtMontoOriginal').val('');
            $('#txtMontoPignorado').val('0').prop('readonly', true).addClass('bg-light');
            $('#txtCuota').val('');
            $('#txtTasaInteres').val('').prop('readonly', true).addClass('bg-light');
            $('#txtPagoMes').val('').prop('readonly', true).addClass('bg-light');
            $('#txtFechaOtorgado').val('');
            $('#txtSaldo').val('0').prop('readonly', true).addClass('bg-light');
            
            // Limpiar clases de Validación
            $('.form-control, .form-select').removeClass('is-invalid');
            
            // Limpiar estado del asociado
            $('#divAsociadoSeleccionado').addClass('d-none');
            $('#divSinAsociado').removeClass('d-none');
            $('#lblAsociadoInfo').text('');
            $('#lblAsociadoDetalle').text('');
            
            // Ocultar los campos del auxiliar
            $('#divDatosAuxiliar').hide();
            
            // Limpiar modal de búsqueda
            $('#txtBuscarAsociadoModal').val('');
            $('#tbodyAsociadosModal').html('<tr><td colspan="6" class="text-center text-muted py-4"><i class="fas fa-search me-2"></i>Ingrese un término de búsqueda para comenzar</td></tr>');
            
            // Limpiar validaciones
            $('.form-control').removeClass('is-invalid');
            $('.invalid-feedback').remove();
            
            // Restaurar título del modal
            $('#modalAuxiliarLabel').html('<i class="fas fa-user-plus me-2"></i>Nuevo Auxiliar');
            
            // Habilitar botón eliminar asociado (modo crear nuevo)
            $('#btnEliminarAsociado').prop('disabled', false);
            
        }

        function limpiarModalBusqueda() {
            // Limpiar campo de búsqueda
            $('#txtBuscarAsociadoModal').val('');
            
            // Limpiar tabla de resultados
            $('#tbodyAsociadosModal').html(`
                <tr>
                    <td colspan="6" class="text-center text-muted py-4">
                        <i class="fas fa-search me-2"></i>Ingrese un término de búsqueda para comenzar
                    </td>
                </tr>
            `);
        }

        function formatearFecha(fecha) {
            if (!fecha) return '-';
            
            // Si ya está en formato dd/mm/yyyy, devolverlo tal como está
            if (typeof fecha === 'string' && fecha.match(/^\d{2}\/\d{2}\/\d{4}$/)) {
                return fecha;
            }
            
            // Si es una fecha en formato yyyy-mm-dd, convertirla
            if (typeof fecha === 'string' && fecha.match(/^\d{4}-\d{2}-\d{2}$/)) {
                const parts = fecha.split('-');
                const year = parts[0];
                const month = parts[1];
                const day = parts[2];
                return `${day}/${month}/${year}`;
            }
            
            // Si es una fecha ISO o similar, convertirla
            try {
                const date = new Date(fecha);
                if (isNaN(date.getTime())) return '-';
                
                const day = date.getDate().toString().padStart(2, '0');
                const month = (date.getMonth() + 1).toString().padStart(2, '0');
                const year = date.getFullYear();
                
                return `${day}/${month}/${year}`;
            } catch (e) {
                return '-';
            }
        }

        function convertirFechaParaBD(fecha) {
            if (!fecha) return '';
            
            // Si ya está en formato dd/mm/yyyy, convertir a yyyy-mm-dd
            if (typeof fecha === 'string' && fecha.match(/^\d{2}\/\d{2}\/\d{4}$/)) {
                const parts = fecha.split('/');
                return `${parts[2]}-${parts[1]}-${parts[0]}`;
            }
            
            // Si es una fecha ISO, devolverla tal como está
            if (typeof fecha === 'string' && fecha.match(/^\d{4}-\d{2}-\d{2}/)) {
                return fecha.split('T')[0]; // Tomar solo la parte de fecha
            }
            
            return fecha;
        }

        function volverDashboard() {
            window.location.href = '../../Dashboard.aspx';
        }

        // Funciones para menú contextual
        function mostrarMenuContextual(event, auxiliar) {
            // Verificar nivel de acceso
            if (nivelAcceso > 1) {
                return;
            }

            event.preventDefault();
            event.stopPropagation();
            
            auxiliarSeleccionado = auxiliar;
            
            // Resaltar la fila seleccionada
            $('.fila-seleccionada-contextual').removeClass('fila-seleccionada-contextual');
            $(event.currentTarget).addClass('fila-seleccionada-contextual');
            
            // Posicionar menú contextual
            var contextMenu = $('#contextMenu');
            contextMenu.css({
                'left': event.pageX + 'px',
                'top': event.pageY + 'px',
                'display': 'block'
            });
        }

        function ocultarMenuContextual() {
            $('#contextMenu').hide();
            // Quitar resaltado de la fila
            $('.fila-seleccionada-contextual').removeClass('fila-seleccionada-contextual');
        }

        function modificarMontoPignorado() {
            if (!auxiliarSeleccionado) return;
            
            // Llenar información del auxiliar
            $('#hdnAuxiliarIDModificar').val(auxiliarSeleccionado.ID);
            $('#hdnNumeroAsociadoModificar').val(auxiliarSeleccionado.NumeroAsociado);
            $('#txtMontoPignoradoModificar').val(auxiliarSeleccionado.MontoPignorado);
            
            // Mostrar información del auxiliar
            var infoHtml = `
                <strong>Asociado:</strong> ${auxiliarSeleccionado.NombreAsociado}<br>
                <strong>Tipo:</strong> ${auxiliarSeleccionado.DescripcionTipoAuxiliar}<br>
                <strong>Monto Original:</strong> $${parseFloat(auxiliarSeleccionado.MontoOriginal || 0).toFixed(2)}<br>
                <strong>Monto Pignorado Actual:</strong> $${parseFloat(auxiliarSeleccionado.MontoPignorado || 0).toFixed(2)}
            `;
            $('#infoAuxiliarModificar').html(infoHtml);
            
            // Ocultar menú contextual y mostrar modal
            ocultarMenuContextual();
            $('#modalModificarMontoPignorado').modal('show');
            
            // Autofocus en el campo de monto cuando se abre el modal
            $('#modalModificarMontoPignorado').on('shown.bs.modal', function() {
                $('#txtMontoPignoradoModificar').focus();
            });
            
            // Guardar al presionar Enter en el campo de monto
            $('#txtMontoPignoradoModificar').on('keypress', function(e) {
                if (e.which === 13) { // Tecla Enter
                    e.preventDefault();
                    guardarMontoPignorado();
                }
            });
        }

        function guardarMontoPignorado() {
            var nuevoMonto = parseFloat($('#txtMontoPignoradoModificar').val()) || 0;
            var auxiliarID = $('#hdnAuxiliarIDModificar').val();
            var numeroAsociado = $('#hdnNumeroAsociadoModificar').val();
            
            if (nuevoMonto < 0) {
                showToast('error', 'Error', 'El monto pignorado no puede ser negativo');
                return;
            }

            $.ajax({
                type: "POST",
                url: "AuxiliaresAsociados.aspx/ModificarMontoPignorado",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 
                    auxiliarID: auxiliarID, 
                    numeroAsociado: numeroAsociado, 
                    nuevoMonto: nuevoMonto 
                }),
                success: function(response) {
                    var result = response.d;
                    
                    if (result && result.Resultado === 'OK') {
                        showToast('success', 'Éxito', result.Mensaje || 'Monto pignorado actualizado correctamente');
                        $('#modalModificarMontoPignorado').modal('hide');
                        cargarAuxiliares(); // Recargar la tabla
                    } else {
                        showToast('error', 'Error', result.Mensaje || 'Error al actualizar monto pignorado');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al actualizar monto pignorado');
                }
            });
        }
    </script>
</body>
</html>



