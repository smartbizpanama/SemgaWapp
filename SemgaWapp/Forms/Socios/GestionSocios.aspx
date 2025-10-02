<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="GestionSocios.aspx.vb" Inherits="SemgaWapp.GestionSocios" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Gestión de Socios - Cooperativa Segma</title>
    
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
        
        .table tbody td:last-child {
            border-right: none;
        }
        
        .table tbody tr:hover {
            background-color: #f8f9fa;
            cursor: pointer;
        }
        
        /* Forzar centrado en títulos y celdas de DataTables */
        #tablaSocios thead th {
            text-align: center !important;
        }
        
        #tablaSocios tbody td {
            text-align: center !important;
        }
        
        .badge {
            font-size: 0.75em;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: 500;
        }
        
        .badge-success {
            background: #28a745;
            color: white;
        }
        
        .badge-warning {
            background: #ffc107;
            color: #212529;
        }
        
        .badge-danger {
            background: #dc3545;
            color: white;
        }
        
        .badge-secondary {
            background: #6c757d;
            color: white;
        }
        
        .badge-info {
            background: #17a2b8;
            color: white;
        }
        
        .badge-light-blue {
            background: #17a2b8;
            color: white;
            font-weight: bold;
        }
        
        /* Colores más oscuros para el porcentaje restante */
        #porcentajeRestante.text-warning {
            color: #e67e22 !important; /* Naranja oscuro en lugar de amarillo */
            font-weight: bold;
        }
        
        #porcentajeRestante.text-success {
            color: #27ae60 !important; /* Verde más oscuro */
            font-weight: bold;
        }
        
        #porcentajeRestante.text-danger {
            color: #e74c3c !important; /* Rojo más oscuro */
            font-weight: bold;
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
        
        .nav-tabs {
            border-bottom: 1px solid #e9ecef;
            margin-bottom: 20px;
        }
        
        .nav-tabs .nav-link {
            border: none;
            color: #6c757d;
            font-weight: 500;
            padding: 12px 20px;
            border-radius: 0;
        }
        
        .nav-tabs .nav-link.active {
            background: #5a9fd4;
            color: white;
            border-radius: 0;
        }
        
        .nav-tabs .nav-link:hover {
            color: #5a9fd4;
            background: #f8f9fa;
        }
        
        .form-control, .form-select {
            border-radius: 4px;
            border: 1px solid #ced4da;
            padding: 6px 8px;
            font-size: 12px;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #2c3e50;
            box-shadow: 0 0 0 0.2rem rgba(44, 62, 80, 0.15);
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 4px;
            font-size: 12px;
        }
        
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
        }
        
        .spinner-border {
            color: #2c3e50;
        }
        
        .toast-container {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1055;
        }
        
        .toast {
            min-width: 300px;
            max-width: 500px;
        }
        
        /* Toast Confirm Personalizado */
        .toast-confirm {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 1060;
            min-width: 400px;
            max-width: 500px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            border: none;
            overflow: hidden;
        }
        
        .toast-confirm-header {
            padding: 15px 20px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .toast-confirm-body {
            padding: 20px;
        }
        
        .toast-confirm-footer {
            padding: 15px 20px;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        
        .toast-confirm-icon {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 14px;
        }
        
        .toast-confirm-icon.success {
            background-color: #28a745;
        }
        
        .toast-confirm-icon.warning {
            background-color: #ffc107;
        }
        
        .toast-confirm-icon.danger {
            background-color: #dc3545;
        }
        
        .toast-confirm-icon.info {
            background-color: #17a2b8;
        }
        
        .toast-confirm-title {
            font-weight: 600;
            margin: 0;
            color: #333;
        }
        
        .toast-confirm-message {
            margin: 0;
            color: #666;
            line-height: 1.4;
        }
        
        .toast-confirm-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .toast-confirm-btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .toast-confirm-btn-primary:hover {
            background-color: #0056b3;
        }
        
        .toast-confirm-btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .toast-confirm-btn-secondary:hover {
            background-color: #545b62;
        }
        
        .toast-confirm-btn-danger {
            background-color: #dc3545;
            color: white;
        }
        
        .toast-confirm-btn-danger:hover {
            background-color: #c82333;
        }
        
        .toast-confirm-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 1059;
        }
        
        /* Estilo para botón deshabilitado */
        .btn.disabled, .btn:disabled {
            background-color: #6c757d !important;
            border-color: #6c757d !important;
            color: #fff !important;
            opacity: 0.65;
            cursor: not-allowed;
        }
        
        .btn-sm {
            padding: 4px 8px;
            font-size: 11px;
            border-radius: 3px;
        }
        
        .btn-outline-primary {
            color: #2c3e50;
            border-color: #2c3e50;
        }
        
        .btn-outline-primary:hover {
            background: #2c3e50;
            border-color: #2c3e50;
            color: white;
        }
        
        .action-buttons {
            white-space: nowrap;
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
        
        /* Estilos para divs elegantes del tab Sistemas */
        .info-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .info-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transform: translateY(-1px);
        }
        
        .info-label {
            font-size: 11px;
            font-weight: 600;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 14px;
            font-weight: 500;
            color: #2c3e50;
            margin: 0;
        }
        
        .info-icon {
            color: #2c3e50;
            margin-right: 8px;
            font-size: 16px;
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
                        <h6 class="mb-0" style="font-size: 16px;"><i class="fas fa-users me-2"></i>Gestión de Socios</h6>
                    </div>
                    <div class="col-md-6 text-end">
                        <button type="button" class="btn btn-light me-2" onclick="abrirModalNuevoSocio()">
                            <i class="fas fa-plus me-1"></i>Nuevo Socio
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="volverDashboard()">
                            <i class="fas fa-arrow-left me-1"></i>Volver
                        </button>
                    </div>
                </div>
            </div>

            <!-- Filters Section -->
            <div class="filters-section">
                <div class="row">
                    <div class="col-md-2">
                        <label class="form-label fw-bold">Nombre</label>
                        <input type="text" id="filtroNombre" class="form-control" placeholder="Buscar por nombre..."/>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold">Tipo Asociado</label>
                        <select id="filtroTipo" class="form-select">
                            <option value="">Todos los tipos</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold">Estatus</label>
                        <select id="filtroEstatus" class="form-select">
                            <option value="">Todos</option>
                            <option value="A">Activo</option>
                            <option value="I">Inactivo</option>
                            <option value="S">Suspendido</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold">Tipo Documento</label>
                        <select id="filtroTipoDocumento" class="form-select">
                            <option value="">Todos los tipos</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold">identificación</label>
                        <input type="text" id="filtroIdentificacion" class="form-control" placeholder="número de identificación...">
                    </div>
                    <div class="col-md-1 d-flex align-items-end">
                        <button type="button" class="btn btn-primary w-100" onclick="aplicarFiltros()" title="Buscar">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Loading -->
            <div class="loading" id="loadingSocios">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">Cargando...</span>
                </div>
                <p class="mt-2">Cargando socios...</p>
            </div>

            <!-- Table Section -->
            <div class="table-responsive">
                <table id="tablaSocios" class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>N° Asociado</th>
                            <th>Tipo Asociado</th>
                            <th>Nombre Completo</th>
                            <th>Estatus</th>
                            <th>identificación</th>
                            <th>Fecha Creación</th>
                            <th>Usuario Creó</th>
                            <th>Fecha Modificación</th>
                            <th>Usuario Modificó</th>
                            <th>Editar</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Los datos se cargarán diN°micamente -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal para Ficha de Socio -->
        <div class="modal fade" id="modalSocio" tabindex="-1" aria-labelledby="modalSocioLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-xl" style="min-height: 600px; max-width: 1000px;">
                <div class="modal-content" style="min-height: 600px;">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalSocioLabel">
                            <i class="fas fa-user me-2"></i>Ficha de Socio
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Tabs Navigation -->
                        <ul class="nav nav-tabs" id="socioTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="generales-tab" data-bs-toggle="tab" data-bs-target="#generales" type="button" role="tab">
                                    <i class="fas fa-user me-2"></i>Generales
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="trabajo-tab" data-bs-toggle="tab" data-bs-target="#trabajo" type="button" role="tab">
                                    <i class="fas fa-briefcase me-2"></i>Trabajo
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="residencia-tab" data-bs-toggle="tab" data-bs-target="#residencia" type="button" role="tab">
                                    <i class="fas fa-home me-2"></i>Residencia
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="beneficiario-tab" data-bs-toggle="tab" data-bs-target="#beneficiario" type="button" role="tab">
                                    <i class="fa-solid fa-people-arrows me-2"></i>Beneficiarios
                                </button>
                            </li>
                            <li class="nav-item" role="presentation" id="sistemas-tab-item">
                                <button class="nav-link" id="sistemas-tab" data-bs-toggle="tab" data-bs-target="#sistemas" type="button" role="tab">
                                    <i class="fas fa-cog me-2"></i>Sistemas
                                </button>
                            </li>
                        </ul>

                        <!-- Tab Content -->
                        <div class="tab-content mt-4" id="socioTabContent">
                            <!-- Tab Generales -->
                            <div class="tab-pane fade show active" id="generales" role="tabpanel">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">número de Asociado</label>
                                        <div id="numeroAsociado" class="numero-asociado-display" style="
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
                                        ">
                                            <span id="numeroAsociadoText" style="color: #495057;">Generado automáticamente</span>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Tipo de Asociado *</label>
                                        <select id="tipoAsociado" name="tipoAsociado" class="form-select">
                                            <option value="">Seleccionar tipo</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Estatus</label>
                                        <select id="estatus" class="form-select">
                                            <option value="A" selected>Activo</option>
                                            <option value="I">Inactivo</option>
                                            <option value="S">Suspendido</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Sexo</label>
                                        <select id="sexo" class="form-select">
                                            <option value="">Seleccionar</option>
                                            <option value="M">Masculino</option>
                                            <option value="F">Femenino</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Primer Nombre *</label>
                                        <input type="text" id="nombre" name="nombre" class="form-control">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Segundo Nombre</label>
                                        <input type="text" id="segundoNombre" class="form-control">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Primer Apellido *</label>
                                        <input type="text" id="apellido" name="apellido" class="form-control">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Segundo Apellido</label>
                                        <input type="text" id="segundoApellido" class="form-control">
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Tipo de identificación *</label>
                                        <select id="tipoIdentificacion" name="tipoIdentificacion" class="form-select">
                                            <option value="">Seleccionar</option>
                                            <option value="CEDULA">cédula</option>
                                            <option value="PASAPORTE">Pasaporte</option>
                                            <option value="RUC">RUC</option>
                                            <option value="OTRO">Otro</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">número de identificación *</label>
                                        <input type="text" id="numeroIdentificacion" name="numeroIdentificacion" class="form-control">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Fecha de Nacimiento</label>
                                        <input type="text" id="fechaNacimiento" class="form-control flatpickr-date" placeholder="dd/mm/yyyy">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Correo Electrúnico</label>
                                        <input type="email" id="correoElectronico" class="form-control">
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Teléfono Residencia</label>
                                        <input type="text" id="telefonoResidencia" class="form-control">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Teléfono Celular</label>
                                        <input type="text" id="telefonoCelular" class="form-control">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Teléfono Familiar</label>
                                        <input type="text" id="telefonoFamiliar" class="form-control">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Ocupación</label>
                                        <input type="text" id="ocupacion" class="form-control">
                                    </div>
                                </div>
                                <div class="row g-3 mt-2">
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Nivel de Estudio</label>
                                        <input type="text" id="nivelEstudio" class="form-control">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label fw-bold">Profesión</label>
                                        <input type="text" id="profesion" class="form-control">
                                    </div>
                                </div>
                            </div>

                            <!-- Tab Trabajo -->
                            <div class="tab-pane fade" id="trabajo" role="tabpanel">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Lugar de Trabajo</label>
                                        <input type="text" id="lugarTrabajo" class="form-control">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Ocupación</label>
                                        <input type="text" id="ocupacionTrabajo" class="form-control">
                                    </div>
                                </div>
                                <div class="row g-3 mt-2">
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Provincia</label>
                                        <input type="text" id="provinciaTrabajo" class="form-control">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Distrito</label>
                                        <input type="text" id="distritoTrabajo" class="form-control">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Corregimiento</label>
                                        <input type="text" id="corregimientoTrabajo" class="form-control">
                                    </div>
                                </div>
                                <div class="row g-3 mt-2">
                                    <div class="col-12">
                                        <label class="form-label fw-bold">Dirección de Trabajo</label>
                                        <textarea id="direccionTrabajo" class="form-control" rows="3"></textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Tab Residencia -->
                            <div class="tab-pane fade" id="residencia" role="tabpanel">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Provincia de Residencia</label>
                                        <input type="text" id="provinciaResidencia" class="form-control">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Distrito de Residencia</label>
                                        <input type="text" id="distritoResidencia" class="form-control">
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Corregimiento de Residencia</label>
                                        <input type="text" id="corregimientoResidencia" class="form-control">
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-12">
                                        <label class="form-label fw-bold">Dirección de Residencia</label>
                                        <textarea id="direccionResidencia" class="form-control" rows="3"></textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Tab Beneficiarios -->
                            <div class="tab-pane fade" id="beneficiario" role="tabpanel">


                                <!-- Tabla de beneficiarios -->
                                <div class="row">
                                    <div class="col-12">
                                        <div class="card">
                                            <div class="card-header bg-light">
                                                <div class="d-flex align-items-center justify-content-between">
                                                    <div class="d-flex align-items-center">
                                                        <h6 class="mb-0 me-3"><i class="fas fa-users me-2"></i>Beneficiarios Asignados</h6>
                                                        <button type="button" class="btn btn-primary btn-sm" onclick="abrirModalAgregarBeneficiario()" title="Agregar Beneficiario">
                                                            <i class="fas fa-plus me-1"></i>Agregar
                                                        </button>
                                                    </div>
                                                    <div class="d-flex align-items-center">
                                                        <i class="fas fa-percentage me-2"></i>
                                                        <span class="fw-bold">Restante: </span>
                                                        <span id="porcentajeRestante" class="fw-bold fs-6 ms-1">100.00%</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="alert alert-info alert-sm py-2 mb-0 text-center" style="border-radius: 0; border-left: none; border-right: none; background-color: #e3f2fd;">
                                                <i class="fas fa-info-circle me-2" style="color: #1976d2;"></i>
                                                <small style="color: #1565c0;"><strong>Nota:</strong> Los beneficiarios se guardan automáticamente sin necesidad de guardar los datos del asociado.</small>
                                            </div>
                                            <div class="card-body p-0">
                                                <div class="table-responsive">
                                                    <table id="tablaBeneficiarios" class="table table-hover mb-0">
                                                        <thead class="table-dark">
                                                            <tr>
                                                                <th>Nombre Completo</th>
                                                                <th>identificación</th>
                                                                <th>Parentesco</th>
                                                                <th>Porcentaje</th>
                                                                <th>Acciones</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <!-- Los datos se cargarán diN°micamente -->
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Tab Sistemas -->
                            <div class="tab-pane fade" id="sistemas" role="tabpanel">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-label">
                                                <i class="fas fa-calendar-plus info-icon"></i>Fecha de Creación
                                            </div>
                                            <p class="info-value" id="fechaCreacionDisplay">-</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-label">
                                                <i class="fas fa-user-plus info-icon"></i>Usuario que Creó
                                    </div>
                                            <p class="info-value" id="usuarioCreaDisplay">-</p>
                                </div>
                                    </div>
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-label">
                                                <i class="fas fa-calendar-edit info-icon"></i>Fecha de Modificación
                                            </div>
                                            <p class="info-value" id="fechaModificacionDisplay">-</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-label">
                                                <i class="fas fa-user-edit info-icon"></i>Usuario que Modificó
                                            </div>
                                            <p class="info-value" id="usuarioModificaDisplay">-</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-2"></i>Cancelar
                        </button>
                        <button type="button" class="btn btn-primary" onclick="guardarSocio()">
                            <i class="fas fa-save me-2"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Toast Container -->
        <div class="toast-container">
            <div id="toast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="toast-header">
                    <i class="fas fa-info-circle text-primary me-2"></i>
                    <strong class="me-auto">Notificación</strong>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body" id="toastMessage">
                    <!-- Mensaje diN°mico -->
                </div>
            </div>
        </div>
    </form>

    <!-- Modal para Agregar Beneficiario -->
    <div class="modal fade" id="modalAgregarBeneficiario" tabindex="-1" aria-labelledby="modalAgregarBeneficiarioLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" style="margin-top: 100px;">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #28a745; color: white;">
                    <h5 class="modal-title" id="modalAgregarBeneficiarioLabel">
                        <i class="fas fa-user-plus me-2"></i>Agregar Beneficiario
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formAgregarBeneficiario">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Nombre *</label>
                                <input type="text" id="beneficiarioNombre" class="form-control" placeholder="Nombre del beneficiario">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Apellido *</label>
                                <input type="text" id="beneficiarioApellido" class="form-control" placeholder="Apellido del beneficiario">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Tipo ID *</label>
                                <select id="beneficiarioTipoIdentificacion" class="form-select">
                                    <option value="">Seleccionar...</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">número ID *</label>
                                <input type="text" id="beneficiarioNumeroIdentificacion" class="form-control" placeholder="número de identificación">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Parentesco *</label>
                                <select id="beneficiarioParentesco" class="form-select">
                                    <option value="">Seleccionar parentesco...</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Porcentaje *</label>
                                <div class="input-group">
                                    <input type="number" id="beneficiarioPorcentaje" class="form-control" placeholder="0.00" min="0" max="100" step="0.01" oninput="validarPorcentaje(this)">
                                    <span class="input-group-text">%</span>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancelar
                    </button>
                    <button type="button" class="btn btn-primary" onclick="agregarBeneficiario()">
                        <i class="fas fa-plus me-1"></i>Agregar
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal para Editar Beneficiario -->
    <div class="modal fade" id="modalEditarBeneficiario" tabindex="-1" aria-labelledby="modalEditarBeneficiarioLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-dialog-centered" style="margin-top: 100px;">
            <div class="modal-content">
                <div class="modal-header" style="background-color: #007bff; color: white;">
                    <h5 class="modal-title" id="modalEditarBeneficiarioLabel">
                        <i class="fas fa-user-edit me-2"></i>Editar Beneficiario
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formEditarBeneficiario">
                        <input type="hidden" id="editarBeneficiarioId" value="">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Nombre *</label>
                                <input type="text" id="editarBeneficiarioNombre" class="form-control" placeholder="Nombre del beneficiario">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Apellido *</label>
                                <input type="text" id="editarBeneficiarioApellido" class="form-control" placeholder="Apellido del beneficiario">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Tipo ID *</label>
                                <select id="editarBeneficiarioTipoIdentificacion" class="form-select">
                                    <option value="">Seleccionar...</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">número ID *</label>
                                <input type="text" id="editarBeneficiarioNumeroIdentificacion" class="form-control" placeholder="número de identificación">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Parentesco *</label>
                                <select id="editarBeneficiarioParentesco" class="form-select">
                                    <option value="">Seleccionar parentesco...</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Porcentaje *</label>
                                <div class="input-group">
                                    <input type="number" id="editarBeneficiarioPorcentaje" class="form-control" placeholder="0.00" min="0" max="100" step="0.01" oninput="validarPorcentajeEditar(this)">
                                    <span class="input-group-text">%</span>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Cancelar
                    </button>
                    <button type="button" class="btn btn-primary" onclick="guardarEdicionBeneficiario()">
                        <i class="fas fa-save me-1"></i>Guardar Cambios
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <!-- Flatpickr Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>
    
    <script>
        let tablaSocios;
        let esModoEdicion = false;
        let numeroAsociadoActual = null;

        $(document).ready(function() {
            // Inicializar Flatpickr para fechas
            flatpickr(".flatpickr-date", {
                locale: "es",
                dateFormat: "d/m/Y",
                allowInput: true,
                clickOpens: true,
                placeholder: "dd/mm/yyyy"
            });

            inicializarDataTable();
            cargarTiposAsociado();
            cargarStatusAsociado();
            cargarTiposDocumento();
            cargarParentezcos();
            cargarSocios();
            verificarEnvironment();
            
            // Verificar mayúsculas automáticas y aplicar si está habilitado
            verificarMayusculasAutomaticas();
        });

        function volverDashboard() {
            window.location.href = '/Dashboard.aspx';
        }

        function inicializarDataTable() {
            tablaSocios = $('#tablaSocios').DataTable({
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json',
                    emptyTable: "Ningún asociado en la lista",
                    zeroRecords: "Ningún asociado en la lista"
                },
                responsive: true,
                pageLength: 25,
                order: [[0, 'desc']],
                columnDefs: [
                    { targets: [9], orderable: false }
                ],
                dom: 'rtip'
            });

            // Agregar evento de doble clic en las filas
            $('#tablaSocios tbody').on('dblclick', 'tr', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const data = tablaSocios.row(this).data();
                if (data && data[0]) { // Verificar que hay datos y que el primer elemento (N° Asociado) existe
                    const numeroAsociado = parseInt(data[0]);
                    verSocio(numeroAsociado);
                }
            });
        }

        function cargarTiposAsociado() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerTiposAsociado",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const tipos = response.d.Data;
                        const selectFiltro = $('#filtroTipo');
                        const selectModal = $('#tipoAsociado');
                        
                        selectFiltro.empty().append('<option value="">Todos los tipos</option>');
                        selectModal.empty().append('<option value="">Seleccionar tipo</option>');
                        
                        tipos.forEach(function(tipo) {
                            selectFiltro.append(`<option value="${tipo.IdTipoAsociado}">${tipo.TipoAsociado}</option>`);
                            selectModal.append(`<option value="${tipo.IdTipoAsociado}">${tipo.TipoAsociado}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar tipos de asociado', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar tipos de asociado', 'error');
                }
            });
        }

        function cargarStatusAsociado() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerStatusAsociado",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const status = response.d.Data;
                        const selectFiltro = $('#filtroEstatus');
                        const selectModal = $('#estatus');
                        
                        selectFiltro.empty().append('<option value="">Todos los estatus</option>');
                        selectModal.empty().append('<option value="">Seleccionar estatus</option>');
                        
                        status.forEach(function(stat) {
                            selectFiltro.append(`<option value="${stat.CodStatusAsociado}">${stat.StatusAsociado}</option>`);
                            selectModal.append(`<option value="${stat.CodStatusAsociado}">${stat.StatusAsociado}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar status de asociado', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar status de asociado', 'error');
                }
            });
        }

        function cargarTiposDocumento() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerTiposDocumento",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const tiposDoc = response.d.Data;
                        const selectModal = $('#tipoIdentificacion');
                        const selectFiltro = $('#filtroTipoDocumento');
                        
                        // Llenar el select del modal
                        selectModal.empty().append('<option value="">Seleccionar tipo de documento</option>');
                        
                        // Llenar el select del filtro
                        selectFiltro.empty().append('<option value="">Todos los tipos</option>');
                        
                        tiposDoc.forEach(function(tipo) {
                            selectModal.append(`<option value="${tipo.CodTipoDoc}">${tipo.TipoDocumento}</option>`);
                            selectFiltro.append(`<option value="${tipo.CodTipoDoc}">${tipo.TipoDocumento}</option>`);
                            
                            // Llenar también los dropdowns de beneficiarios
                            $('#beneficiarioTipoIdentificacion').append(`<option value="${tipo.CodTipoDoc}">${tipo.TipoDocumento}</option>`);
                            $('#editarBeneficiarioTipoIdentificacion').append(`<option value="${tipo.CodTipoDoc}">${tipo.TipoDocumento}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar tipos de documento', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar tipos de documento', 'error');
                }
            });
        }

        function cargarSocios() {
            $('#loadingSocios').show();
            
            const filtros = {
                FiltroNombre: $('#filtroNombre').val(),
                FiltroTipo: $('#filtroTipo').val(),
                FiltroEstatus: $('#filtroEstatus').val(),
                FiltroTipoDocumento: $('#filtroTipoDocumento').val(),
                FiltroIdentificacion: $('#filtroIdentificacion').val()
            };

            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerSocios",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtrosJson: JSON.stringify(filtros) }),
                dataType: "json",
                success: function(response) {
                    $('#loadingSocios').hide();
                    
					if (typeof response.d === 'string') {
						response.d = JSON.parse(response.d);
					}
                    if (response.d.Success) {
                        const socios = response.d.Data;
                        const totalRegistros = response.d.TotalRegistros;
                        
                        tablaSocios.clear();
                        
                        if (totalRegistros > 0) {
                        socios.forEach(function(socio) {
                            const nombreCompleto = `${socio.Nombre || ''} ${socio.SegundoNombre || ''} ${socio.Apellido || ''} ${socio.SegundoApellido || ''}`.trim();
                                const identificacion = formatearIdentificacion(socio.TipoIdentificacion, socio.NumeroIdentificacion);
                            const estatusBadge = obtenerBadgeEstatus(socio.Estatus);
                                const fechaCreacion = formatearFechaHora(socio.FechaCreacion);
                            const fechaModificacion = formatearFecha(socio.FechaModificacion);
                            
                            tablaSocios.row.add([
                                socio.NumeroAsociado,
                                socio.TipoAsociado || 'N/A',
                                nombreCompleto || 'N/A',
                                estatusBadge,
                                identificacion || 'N/A',
                                fechaCreacion,
                                    socio.UsuarioCrea || 'N/A',
                                fechaModificacion,
                                    socio.UsuarioModifica || 'N/A',
                                `<div class="action-buttons">
                                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="event.preventDefault(); event.stopPropagation(); verSocio(${socio.NumeroAsociado})" title="Editar socio">
                                            <i class="fas fa-edit"></i>
                                    </button>
                                </div>`
                            ]);
                        });
                        } else {
                            // Mostrar mensaje cuando no hay registros
                            mostrarToast('No se encontraron socios.', 'info');
                        }
                        
                        tablaSocios.draw();
                    } else {
                        // Mostrar error del servidor

                        mostrarToast(response.d.Message, 'error');
                    }
                },
                error: function() {
                    $('#loadingSocios').hide();
					

                    mostrarToast('Error al cargar socios', 'error');
                }
            });
        }

        function aplicarFiltros() {
            cargarSocios();
        }

        function obtenerBadgeEstatus(estatus) {
            switch(estatus) {
                case 'A': return '<span class="badge badge-success">Activo</span>';
                case 'I': return '<span class="badge badge-warning">Inactivo</span>';
                case 'S': return '<span class="badge badge-danger">Suspendido</span>';
                default: return '<span class="badge badge-secondary">N/A</span>';
            }
        }

        // Función de compatibilidad - ahora usa la función global
        function formatearIdentificacion(tipoIdentificacion, numeroIdentificacion) {
            return crearChipTipoDocumento(tipoIdentificacion, numeroIdentificacion);
        }

        function formatearFecha(fecha) {
            if (!fecha) return 'N/A';
            
            let date;
            
            // Manejar formato de timestamp de JavaScript (/Date(1757620890457)/)
            if (typeof fecha === 'string' && fecha.includes('/Date(')) {
                const timestamp = parseInt(fecha.match(/\d+/)[0]);
                date = new Date(timestamp);
            } else {
                date = new Date(fecha);
            }
            
            // Verificar si la fecha es válida
            if (isNaN(date.getTime())) {
                return 'N/A';
            }
            
            return date.toLocaleDateString('es-ES', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric'
            });
        }

        function formatearFechaHora(fecha) {
            if (!fecha) return 'N/A';
            
            let date;
            
            // Manejar formato de timestamp de JavaScript (/Date(1757620890457)/)
            if (typeof fecha === 'string' && fecha.includes('/Date(')) {
                const timestamp = parseInt(fecha.match(/\d+/)[0]);
                date = new Date(timestamp);
            } else {
                date = new Date(fecha);
            }
            
            // Verificar si la fecha es válida
            if (isNaN(date.getTime())) {
                return 'N/A';
            }
            
            return date.toLocaleString('es-ES', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            });
        }

        function verSocio(numeroAsociado) {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerSocioPorNumero",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ numeroAsociado: numeroAsociado }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success) {
                        const socio = response.d.Data;
                        llenarFormulario(socio);
                        esModoEdicion = true;
                        numeroAsociadoActual = numeroAsociado;
                        $('#modalSocioLabel').html('<i class="fas fa-user-edit me-2"></i>Editar Socio');
                        
                        // Mostrar tab Sistemas para edición
                        $('#sistemas-tab-item').show();
                        
                        // Activar tab Generales
                        $('#generales-tab').tab('show');
                        
                        // Cargar beneficiarios del socio
                        cargarBeneficiarios(numeroAsociado);
                        
                        $('#modalSocio').modal('show');
                        
                        // Aplicar mayúsculas automáticas cuando se abra el modal
                        setTimeout(function() {
                            if (mayusculasAutomaticasHabilitadas === true) {
                                aplicarMayusculasAutomaticas();
                            }
                        }, 100);
                    } else {
                        mostrarToast(response.d.Message, 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar datos del socio', 'error');
                }
            });
        }

        function abrirModalNuevoSocio() {
            limpiarFormulario();
            esModoEdicion = false;
            numeroAsociadoActual = null;
            $('#modalSocioLabel').html('<i class="fas fa-user-plus me-2"></i>Nuevo Socio');
            
            // Ocultar tab Sistemas para nuevo socio
            $('#sistemas-tab-item').hide();
            
            // Limpiar beneficiarios para nuevo socio
            cargarBeneficiarios(null);
            
            // Activar tab Generales
            $('#generales-tab').tab('show');
            
            // Verificar si estamos en ambiente de desarrollo y llenar datos de prueba
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerParametroSistema",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ paramKey: 'Environment' }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success && response.d.Data === 'dev') {
                        setTimeout(function() {
                            llenarDatosPrueba();
                        }, 500); // Pequeño delay para asegurar que el modal está completamente cargado
                    }
                },
                error: function() {
                    // Si no se puede verificar el environment, no llenar datos
                }
            });
            
            $('#modalSocio').modal('show');
            
            // Aplicar mayúsculas automáticas cuando se abra el modal
            setTimeout(function() {
                if (mayusculasAutomaticasHabilitadas === true) {
                    aplicarMayusculasAutomaticas();
                }
            }, 100);
        }

        function llenarFormulario(socio) {
            $('#numeroAsociadoText').text(socio.NumeroAsociado);
            $('#tipoAsociado').val(socio.IdTipoAsociado);
            $('#estatus').val(socio.Estatus);
            $('#sexo').val(socio.Sexo);
            $('#nombre').val(socio.Nombre);
            $('#segundoNombre').val(socio.SegundoNombre);
            $('#apellido').val(socio.Apellido);
            $('#segundoApellido').val(socio.SegundoApellido);
            $('#tipoIdentificacion').val(socio.TipoIdentificacion);
            $('#numeroIdentificacion').val(socio.NumeroIdentificacion);
            $('#fechaNacimiento').val(formatearFechaParaInput(socio.FechaNacimiento));
            $('#correoElectronico').val(socio.CorreoElectronico);
            $('#telefonoResidencia').val(socio.TelefonoResidencia);
            $('#telefonoCelular').val(socio.TelefonoCelular);
            $('#telefonoFamiliar').val(socio.TelefonoFamiliar);
            $('#ocupacion').val(socio.Ocupacion);
            $('#nivelEstudio').val(socio.NivelEstudio);
            $('#profesion').val(socio.Profesion);
            
            // Tab Trabajo
            $('#lugarTrabajo').val(socio.LugarTrabajo);
            $('#ocupacionTrabajo').val(socio.Ocupacion);
            $('#provinciaTrabajo').val(socio.ProvinciaTrabajo);
            $('#distritoTrabajo').val(socio.DistritoTrabajo);
            $('#corregimientoTrabajo').val(socio.CorregimientoTrabajo);
            $('#direccionTrabajo').val(socio.DireccionTrabajo);
            
            // Tab Residencia
            $('#provinciaResidencia').val(socio.ProvinciaResidencia);
            $('#distritoResidencia').val(socio.DistritoResidencia);
            $('#corregimientoResidencia').val(socio.CorregimientoResidencia);
            $('#direccionResidencia').val(socio.DireccionResidencia);
            
            // Tab Sistemas - Llenar divs elegantes
            $('#fechaCreacionDisplay').text(formatearFechaHora(socio.FechaCreacion) || 'N/A');
            $('#usuarioCreaDisplay').text(socio.UsuarioCrea || 'N/A');
            $('#fechaModificacionDisplay').text(formatearFechaHora(socio.FechaModificacion) || 'N/A');
            $('#usuarioModificaDisplay').text(socio.UsuarioModifica || 'N/A');
        }

        function limpiarFormulario() {
            // Limpiar todos los campos del modal
            $('#numeroAsociadoText').text('Generado automáticamente');
            $('#tipoAsociado').val('');
            $('#estatus').val('A');
            $('#sexo').val('');
            $('#nombre').val('');
            $('#segundoNombre').val('');
            $('#apellido').val('');
            $('#segundoApellido').val('');
            $('#tipoIdentificacion').val('');
            $('#numeroIdentificacion').val('');
            $('#fechaNacimiento').val('');
            $('#correoElectronico').val('');
            $('#telefonoResidencia').val('');
            $('#telefonoCelular').val('');
            $('#telefonoFamiliar').val('');
            $('#ocupacion').val('');
            $('#nivelEstudio').val('');
            $('#profesion').val('');
            
            // Tab Trabajo
            $('#lugarTrabajo').val('');
            $('#ocupacionTrabajo').val('');
            $('#provinciaTrabajo').val('');
            $('#distritoTrabajo').val('');
            $('#corregimientoTrabajo').val('');
            $('#direccionTrabajo').val('');
            
            // Tab Residencia
            $('#provinciaResidencia').val('');
            $('#distritoResidencia').val('');
            $('#corregimientoResidencia').val('');
            $('#direccionResidencia').val('');
            
            // Tab Sistemas - Limpiar divs elegantes
            $('#fechaCreacionDisplay').text('-');
            $('#usuarioCreaDisplay').text('-');
            $('#fechaModificacionDisplay').text('-');
            $('#usuarioModificaDisplay').text('-');
        }

        function formatearFechaParaInput(fecha) {
            if (!fecha) return '';
            
            let date;
            
            // Manejar formato de timestamp de JavaScript (/Date(1757620890457)/)
            if (typeof fecha === 'string' && fecha.includes('/Date(')) {
                const timestamp = parseInt(fecha.match(/\d+/)[0]);
                date = new Date(timestamp);
            } else {
                date = new Date(fecha);
            }
            
            // Verificar si la fecha es válida
            if (isNaN(date.getTime())) {
                return '';
            }
            
            // Formatear como dd/mm/yyyy para input type="text"
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const year = date.getFullYear();
            return `${day}/${month}/${year}`;
        }

        function guardarSocio() {
            if (!validarFormulario()) {
                return;
            }

            const socioData = {
                NumeroAsociado: numeroAsociadoActual,
                IdTipoAsociado: $('#tipoAsociado').val(),
                Estatus: $('#estatus').val(),
                Sexo: $('#sexo').val(),
                Nombre: $('#nombre').val(),
                SegundoNombre: $('#segundoNombre').val(),
                Apellido: $('#apellido').val(),
                SegundoApellido: $('#segundoApellido').val(),
                TipoIdentificacion: $('#tipoIdentificacion').val(),
                NumeroIdentificacion: $('#numeroIdentificacion').val(),
                FechaNacimiento: convertirFechaParaBD($('#fechaNacimiento').val()),
                CorreoElectronico: $('#correoElectronico').val(),
                TelefonoResidencia: $('#telefonoResidencia').val(),
                TelefonoCelular: $('#telefonoCelular').val(),
                TelefonoFamiliar: $('#telefonoFamiliar').val(),
                Ocupacion: $('#ocupacion').val(),
                NivelEstudio: $('#nivelEstudio').val(),
                Profesion: $('#profesion').val(),
                LugarTrabajo: $('#lugarTrabajo').val(),
                ProvinciaTrabajo: $('#provinciaTrabajo').val(),
                DistritoTrabajo: $('#distritoTrabajo').val(),
                CorregimientoTrabajo: $('#corregimientoTrabajo').val(),
                DireccionTrabajo: $('#direccionTrabajo').val(),
                ProvinciaResidencia: $('#provinciaResidencia').val(),
                DistritoResidencia: $('#distritoResidencia').val(),
                CorregimientoResidencia: $('#corregimientoResidencia').val(),
                DireccionResidencia: $('#direccionResidencia').val()
            };

            const url = esModoEdicion ? "GestionSocios.aspx/ActualizarSocio" : "GestionSocios.aspx/CrearSocio";
            const mensajeExito = esModoEdicion ? "Socio actualizado correctamente" : "Socio creado correctamente";

            $.ajax({
                type: "POST",
                url: url,
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ socioDataJson: JSON.stringify(socioData) }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success) {
                        mostrarToast(mensajeExito, 'success');
                        
                        if (!esModoEdicion && response.d.Data && response.d.Data.NumeroAsociado) {
                            // Actualizar el número de asociado en el div
                            $('#numeroAsociadoText').text(response.d.Data.NumeroAsociado);
                            numeroAsociadoActual = response.d.Data.NumeroAsociado;
                            esModoEdicion = true;
                            $('#modalSocioLabel').html('<i class="fas fa-user-edit me-2"></i>Editar Socio');
                            
                            // Mostrar tab Sistemas para edición
                            $('#sistemas-tab-item').show();
                            
                            // Cerrar modal y actualizar lista después de crear socio
                            $('#modalSocio').modal('hide');
                            cargarSocios();
                        } else {
                            // Cerrar modal si es edición
                            $('#modalSocio').modal('hide');
                            cargarSocios();
                        }
                    } else {
                        mostrarToast(response.d.Message, 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al guardar socio', 'error');
                }
            });
        }

        function validarFormulario() {
            const camposObligatorios = [
                { id: 'nombre', nombre: 'Primer Nombre' },
                { id: 'apellido', nombre: 'Primer Apellido' },
                { id: 'tipoAsociado', nombre: 'Tipo de Asociado' },
                { id: 'tipoIdentificacion', nombre: 'Tipo de identificación' },
                { id: 'numeroIdentificacion', nombre: 'número de identificación' }
            ];

            for (let campo of camposObligatorios) {
                if (!$('#' + campo.id).val()) {
                    mostrarToast(`El campo ${campo.nombre} es obligatorio`, 'error');
                    $('#' + campo.id).focus();
                    return false;
                }
            }

            // Validar email si se proporciona
            const email = $('#correoElectronico').val();
            if (email && !validarEmail(email)) {
                mostrarToast('El formato del correo electrúnico no es válido', 'error');
                $('#correoElectronico').focus();
                return false;
            }

            return true;
        }

        function validarEmail(email) {
            const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return regex.test(email);
        }

        // Función para mostrar confirm personalizado
        function mostrarConfirm(opciones) {
            return new Promise((resolve) => {
                // Crear overlay
                const overlay = document.createElement('div');
                overlay.className = 'toast-confirm-overlay';
                
                // Crear modal
                const modal = document.createElement('div');
                modal.className = 'toast-confirm';
                
                // Determinar icono y color
                let iconClass = 'fas fa-question';
                let iconBgClass = 'info';
                
                switch(opciones.tipo) {
                    case 'success':
                        iconClass = 'fas fa-check';
                        iconBgClass = 'success';
                        break;
                    case 'warning':
                        iconClass = 'fas fa-exclamation-triangle';
                        iconBgClass = 'warning';
                        break;
                    case 'danger':
                        iconClass = 'fas fa-times';
                        iconBgClass = 'danger';
                        break;
                    case 'info':
                    default:
                        iconClass = 'fas fa-info';
                        iconBgClass = 'info';
                        break;
                }
                
                // Crear HTML del modal
                modal.innerHTML = `
                    <div class="toast-confirm-header">
                        <div class="toast-confirm-icon ${iconBgClass}">
                            <i class="${iconClass}"></i>
                        </div>
                        <h6 class="toast-confirm-title">${opciones.titulo || 'Confirmar'}</h6>
                    </div>
                    <div class="toast-confirm-body">
                        <p class="toast-confirm-message">${opciones.mensaje}</p>
                    </div>
                    <div class="toast-confirm-footer">
                        <button type="button" class="toast-confirm-btn toast-confirm-btn-secondary" onclick="cerrarConfirm(false)">
                            ${opciones.textoCancelar || 'Cancelar'}
                        </button>
                        <button type="button" class="toast-confirm-btn ${opciones.tipoBoton === 'danger' ? 'toast-confirm-btn-danger' : 'toast-confirm-btn-primary'}" onclick="cerrarConfirm(true)">
                            ${opciones.textoConfirmar || 'Confirmar'}
                        </button>
                    </div>
                `;
                
                // Agregar al DOM
                document.body.appendChild(overlay);
                document.body.appendChild(modal);
                
                // Función para cerrar
                window.cerrarConfirm = function(resultado) {
                    document.body.removeChild(overlay);
                    document.body.removeChild(modal);
                    delete window.cerrarConfirm;
                    resolve(resultado);
                };
                
                // Cerrar con ESC
                const handleEsc = (e) => {
                    if (e.key === 'Escape') {
                        document.removeEventListener('keydown', handleEsc);
                        window.cerrarConfirm(false);
                    }
                };
                document.addEventListener('keydown', handleEsc);
                
                // Cerrar clickeando overlay
                overlay.addEventListener('click', () => {
                    window.cerrarConfirm(false);
                });
            });
        }

        function mostrarToast(mensaje, tipo) {
            const toast = $('#toast');
            const toastMessage = $('#toastMessage');
            const toastHeader = toast.find('.toast-header i');
            
            toastMessage.text(mensaje);
            
            // Cambiar icono según el tipo
            toastHeader.removeClass().addClass('fas me-2');
            if (tipo === 'success') {
                toastHeader.addClass('fa-check-circle text-success');
            } else if (tipo === 'error') {
                toastHeader.addClass('fa-exclamation-circle text-danger');
            } else {
                toastHeader.addClass('fa-info-circle text-primary');
            }
            
            // Configurar opciones según el tipo
            const options = {
                autohide: true, // Todos los toasts se ocultan automáticamente
                delay: tipo === 'error' ? 6000 : (tipo === 'success' ? 4000 : 3000) // Errores 6s, Éxito 4s, info 3s
            };
            
            const bsToast = new bootstrap.Toast(toast[0], options);
            bsToast.show();
            
            // Pausar el toast cuando el mouse está encima
            toast.on('mouseenter', function() {
                bsToast._config.autohide = false;
            });
            
            // Reanudar el toast cuando el mouse salga
            toast.on('mouseleave', function() {
                bsToast._config.autohide = true;
                // Reiniciar el timer
                clearTimeout(bsToast._timeout);
                bsToast._timeout = setTimeout(() => {
                    bsToast.hide();
                }, options.delay);
            });
        }

        // Event listeners para filtros
        $('#filtroNombre, #filtroIdentificacion').on('keypress', function(e) {
            if (e.which === 13) { // Enter
                aplicarFiltros();
            }
        });

        // Variable global para almacenar si las mayúsculas automáticas están habilitadas
        let mayusculasAutomaticasHabilitadas = null;

        // Función para verificar si las mayúsculas automáticas están habilitadas
        function verificarMayusculasAutomaticas() {
            if (mayusculasAutomaticasHabilitadas !== null) {
                return; // Ya se verificó
            }
            
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerParametroSistema",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ paramKey: "MAYUS_AUTOM_CREACION_SOCIOS" }),
                dataType: "json",
                success: function(response) {
                    
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    
                    
                    mayusculasAutomaticasHabilitadas = (response.d.Success && response.d.Data === "1");
                    
                    
                    // Aplicar mayúsculas automáticas si está habilitado
                    if (mayusculasAutomaticasHabilitadas) {
                        aplicarMayusculasAutomaticas();
                    }
                },
                error: function(xhr, status, error) {
                    
                    mayusculasAutomaticasHabilitadas = false;
                }
            });
        }

        // Función para aplicar mayúsculas automáticas en tiempo real
        function aplicarMayusculasAutomaticas() {
            
            
            if (!mayusculasAutomaticasHabilitadas) {
                
                return;
            }
            
            
            
            // Aplicar mayúsculas automáticas a los campos de texto
            const camposTexto = [
                '#nombre', '#segundoNombre', '#apellido', '#segundoApellido',
                '#lugarTrabajo', '#ocupacion', '#provinciaTrabajo', '#distritoTrabajo',
                '#corregimientoTrabajo', '#direccionTrabajo', '#provinciaResidencia',
                '#distritoResidencia', '#corregimientoResidencia', '#direccionResidencia',
                '#nivelEstudio', '#profesion',
                // Campos de beneficiarios
                '#beneficiarioNombre', '#beneficiarioApellido',
                '#editarBeneficiarioNombre', '#editarBeneficiarioApellido'
            ];
            
            camposTexto.forEach(function(selector) {
                // Remover eventos anteriores para evitar duplicados
                $(selector).off('input.mayusculas');
                
                // Agregar el nuevo evento
                $(selector).on('input.mayusculas', function() {
                    
                    const cursorPos = this.selectionStart;
                    const originalValue = $(this).val();
                    const upperValue = originalValue.toUpperCase();
                    
                    if (originalValue !== upperValue) {
                        
                        $(this).val(upperValue);
                        // Mantener la posición del cursor
                        this.setSelectionRange(cursorPos, cursorPos);
                    }
                });
            });
        }

        // Flatpickr maneja automáticamente el formateo y Validación de fechas

        function validarFormatoFecha(fecha) {
            const regex = /^(\d{2})\/(\d{2})\/(\d{4})$/;
            if (!regex.test(fecha)) return false;
            
            const [, day, month, year] = fecha.match(regex);
            const date = new Date(year, month - 1, day);
            
            return date.getDate() == day && 
                   date.getMonth() == month - 1 && 
                   date.getFullYear() == year;
        }

        function convertirFechaParaBD(fecha) {
            if (!fecha) return '';
            const regex = /^(\d{2})\/(\d{2})\/(\d{4})$/;
            if (!regex.test(fecha)) return '';
            
            const [, day, month, year] = fecha.match(regex);
            return `${year}-${month}-${day}`;
        }

        function verificarEnvironment() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerParametroSistema",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ paramKey: 'Environment' }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success && response.d.Data === 'dev') {
                        
                    }
                },
                error: function() {
                    
                }
            });
        }

        function llenarDatosPrueba() {
            // Verificar que estamos en environment dev antes de proceder
            $.ajax({
                url: 'GestionSocios.aspx/ObtenerParametroSistema',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ paramKey: 'Environment' }),
                dataType: 'json',
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    
                    if (response.d && response.d.Success && response.d.Data === 'dev') {
                        // Solo proceder si estamos en environment dev
                        
                        cargarDatosAleatorios();
                    } else {
                        
                    }
                },
                error: function() {
                    
                }
            });
        }

        function cargarDatosAleatorios() {
            // Cargar datos aleatorios desde el WebMethod
            
            $.ajax({
                url: 'GestionSocios.aspx/ObtenerDatosPrueba',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    
                    if (response.d && response.d.Success) {
                        
                        const data = JSON.parse(response.d.Data);
                        
                        
                        if (data && data.asociados && data.asociados.length > 0) {
                            
                        // Obtener registros ya usados del localStorage
                        const registrosUsados = JSON.parse(localStorage.getItem('asociadosUsados') || '[]');
                        
                        // Filtrar solo los registros no usados
                        const registrosDisponibles = data.asociados.filter((asociado, index) => 
                            !registrosUsados.includes(index)
                        );
                        
                        if (registrosDisponibles.length === 0) {
                            mostrarToast('Todos los datos de prueba han sido utilizados. Reiniciando...', 'warning');
                            localStorage.removeItem('asociadosUsados');
                            // Recargar la función para empezar de nuevo
                            setTimeout(() => cargarDatosAleatorios(), 1000);
                            return;
                        }
                        
                        // Seleccionar un asociado aleatorio de los disponibles
                        const indiceAleatorio = Math.floor(Math.random() * registrosDisponibles.length);
                        const datosPrueba = registrosDisponibles[indiceAleatorio];
                        
                        // Encontrar el índice original en el array completo
                        const indiceOriginal = data.asociados.findIndex(asociado => 
                            asociado.numeroIdentificacion === datosPrueba.numeroIdentificacion
                        );
                        
                        // Marcar como usado en localStorage
                        registrosUsados.push(indiceOriginal);
                        localStorage.setItem('asociadosUsados', JSON.stringify(registrosUsados));
                        
                        // Llenar campos del formulario con datos aleatorios
                        $('#tipoAsociado').val(datosPrueba.tipoAsociado);
                        $('#nombre').val(datosPrueba.nombre);
                        $('#segundoNombre').val(datosPrueba.segundoNombre || '');
                        $('#apellido').val(datosPrueba.apellido);
                        $('#segundoApellido').val(datosPrueba.segundoApellido || '');
                        $('#tipoIdentificacion').val(datosPrueba.tipoIdentificacion);
                        $('#numeroIdentificacion').val(datosPrueba.numeroIdentificacion);
                        $('#fechaNacimiento').val(datosPrueba.fechaNacimiento);
                        $('#correoElectronico').val(datosPrueba.correoElectronico);
                        $('#telefonoResidencia').val(datosPrueba.telefonoResidencia);
                        $('#telefonoCelular').val(datosPrueba.telefonoCelular);
                        $('#telefonoFamiliar').val(datosPrueba.telefonoFamiliar || '');
                        $('#ocupacion').val(datosPrueba.ocupacion);
                        $('#nivelEstudio').val(datosPrueba.nivelEstudio);
                        $('#profesion').val(datosPrueba.profesion);
                        $('#lugarTrabajo').val(datosPrueba.lugarTrabajo);
                        $('#ocupacionTrabajo').val(datosPrueba.ocupacion);
                        $('#provinciaTrabajo').val(datosPrueba.provinciaTrabajo);
                        $('#distritoTrabajo').val(datosPrueba.distritoTrabajo);
                        $('#corregimientoTrabajo').val(datosPrueba.corregimientoTrabajo);
                        $('#direccionTrabajo').val(datosPrueba.direccionTrabajo);
                        $('#provinciaResidencia').val(datosPrueba.provinciaResidencia);
                        $('#distritoResidencia').val(datosPrueba.distritoResidencia);
                        $('#corregimientoResidencia').val(datosPrueba.corregimientoResidencia);
                        $('#direccionResidencia').val(datosPrueba.direccionResidencia);
                        
                        mostrarToast(`Datos de prueba cargados: ${datosPrueba.nombre} ${datosPrueba.apellido} (${registrosDisponibles.length - 1} restantes)`, 'success');
                        
                            
                        } else {
                            mostrarToast('Error: No se encontraron asociados en los datos de prueba', 'error');
                        }
                    } else {
                        mostrarToast('Error: ' + (response.d ? response.d.Message : 'No se pudieron cargar los datos de prueba'), 'error');
                    }
                },
                error: function(xhr, status, error) {
                    
                    mostrarToast('Error al cargar los datos de prueba: ' + error, 'error');
                }
            });
        }

        // ===== FUNCIONES PARA BENEFICIARIOS =====

        function cargarParentezcos() {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerParentezcos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const parentezcos = response.d.Data;
                        const select = $('#beneficiarioParentesco');
                        
                        select.empty().append('<option value="">Seleccionar parentesco</option>');
                        
                        parentezcos.forEach(function(parentezco) {
                            select.append(`<option value="${parentezco.IDParentezco}">${parentezco.Parentezco}</option>`);
                        });
                    } else {
                        mostrarToast(response.d.Message || 'Error al cargar parentezcos', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar parentezcos', 'error');
                }
            });
        }

        function cargarBeneficiarios(numeroAsociado) {
            if (!numeroAsociado) {
                $('#tablaBeneficiarios tbody').empty();
                actualizarPorcentajeRestante(0);
                return;
            }

            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerBeneficiarios",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ numeroAsociado: numeroAsociado }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const beneficiarios = response.d.Data;
                        const tbody = $('#tablaBeneficiarios tbody');
                        tbody.empty();

                        let porcentajeTotal = 0;

                        if (beneficiarios && beneficiarios.length > 0) {
                            beneficiarios.forEach(function(beneficiario) {
                                const nombreCompleto = `${beneficiario.Nombre || ''} ${beneficiario.Apellido || ''}`.trim();
                                const identificacion = formatearIdentificacion(beneficiario.TipoIdentificacion, beneficiario.NumeroIdentificacion);
                                const porcentaje = parseFloat(beneficiario.Porcentaje || 0);
                                porcentajeTotal += porcentaje;

                                tbody.append(`
                                    <tr ondblclick="editarBeneficiario(${beneficiario.IDBeneficiario})" style="cursor: pointer;">
                                        <td>${nombreCompleto || 'N/A'}</td>
                                        <td>${identificacion}</td>
                                        <td>${beneficiario.Parentezco || 'N/A'}</td>
                                        <td><span class="badge" style="background-color: #1976d2; color: white;">${porcentaje.toFixed(2)}%</span></td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarBeneficiario(${beneficiario.IDBeneficiario})" title="Editar beneficiario">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarBeneficiario(${beneficiario.IDBeneficiario})" title="Eliminar beneficiario">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                `);
                            });
                        } else {
                            tbody.append(`
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-3">
                                        <i class="fas fa-users fa-2x mb-2"></i><br>
                                        No hay beneficiarios asignados
                                    </td>
                                </tr>
                            `);
                        }

                        actualizarPorcentajeRestante(porcentajeTotal);
                    } else {
                        mostrarToast(response.d.Message, 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar beneficiarios', 'error');
                }
            });
        }

        function actualizarPorcentajeRestante(porcentajeAsignado) {
            const porcentajeRestante = 100 - porcentajeAsignado;
            const elemento = $('#porcentajeRestante');
            const botonAgregar = $('button[onclick="abrirModalAgregarBeneficiario()"]');
            
            elemento.text(porcentajeRestante.toFixed(2) + '%');
            
            // Cambiar color según el porcentaje con colores más oscuros
            elemento.removeClass('text-success text-warning text-danger text-info');
            if (porcentajeRestante > 50) {
                elemento.addClass('text-success'); // Verde oscuro
            } else if (porcentajeRestante > 0) {
                elemento.addClass('text-warning'); // Naranja/amarillo oscuro
            } else {
                elemento.addClass('text-danger'); // Rojo oscuro
            }
            
            // Habilitar/deshabilitar botón agregar según porcentaje restante
            if (porcentajeRestante <= 0) {
                botonAgregar.prop('disabled', true).addClass('disabled');
                botonAgregar.attr('title', 'No se puede agregar más beneficiarios - Porcentaje completo');
            } else {
                botonAgregar.prop('disabled', false).removeClass('disabled');
                botonAgregar.attr('title', 'Agregar Beneficiario');
            }
        }

        function agregarBeneficiario() {
            // Validar campos obligatorios
            const camposObligatorios = [
                { id: 'beneficiarioNombre', nombre: 'Nombre' },
                { id: 'beneficiarioApellido', nombre: 'Apellido' },
                { id: 'beneficiarioTipoIdentificacion', nombre: 'Tipo de identificación' },
                { id: 'beneficiarioNumeroIdentificacion', nombre: 'número de identificación' },
                { id: 'beneficiarioParentesco', nombre: 'Parentesco' },
                { id: 'beneficiarioPorcentaje', nombre: 'Porcentaje' }
            ];

            for (let campo of camposObligatorios) {
                if (!$('#' + campo.id).val()) {
                    mostrarToast(`El campo ${campo.nombre} es obligatorio`, 'error');
                    $('#' + campo.id).focus();
                    return;
                }
            }

            // Validar porcentaje
            const porcentaje = parseFloat($('#beneficiarioPorcentaje').val());
            if (porcentaje <= 0 || porcentaje > 100) {
                mostrarToast('El porcentaje debe estar entre 0.01 y 100', 'error');
                $('#beneficiarioPorcentaje').focus();
                return;
            }

            // Verificar que no exceda el 100% total
            const porcentajeActual = parseFloat($('#porcentajeRestante').text().replace('%', ''));
            if (porcentaje > porcentajeActual) {
                mostrarToast(`El porcentaje no puede exceder el ${porcentajeActual.toFixed(2)}% disponible`, 'error');
                $('#beneficiarioPorcentaje').focus();
                return;
            }

            if (!numeroAsociadoActual) {
                mostrarToast('Debe guardar el socio primero antes de agregar beneficiarios', 'error');
                return;
            }

            // Confirmar antes de agregar
            const nombre = $('#beneficiarioNombre').val().trim();
            const apellido = $('#beneficiarioApellido').val().trim();
            const parentesco = $('#beneficiarioParentesco option:selected').text();
            
            mostrarConfirm({
                tipo: 'success',
                titulo: 'Agregar Beneficiario',
                mensaje: `¿Está seguro de agregar a ${nombre} ${apellido} como beneficiario?\n\nParentesco: ${parentesco}\nPorcentaje: ${porcentaje}%`,
                textoConfirmar: 'Sí, Agregar',
                textoCancelar: 'Cancelar'
            }).then((confirmado) => {
                if (confirmado) {
                    // Continuar con el proceso de agregar beneficiario
                    procesarAgregarBeneficiario();
                }
            });
            
            return; // Salir de la función aquí, el resto se ejecutará en el callback
        }

        function procesarAgregarBeneficiario() {
            const porcentaje = parseFloat($('#beneficiarioPorcentaje').val());
            
            const beneficiarioData = {
                NumeroAsociado: numeroAsociadoActual,
                Nombre: $('#beneficiarioNombre').val(),
                Apellido: $('#beneficiarioApellido').val(),
                TipoIdentificacion: $('#beneficiarioTipoIdentificacion').val(),
                NumeroIdentificacion: $('#beneficiarioNumeroIdentificacion').val(),
                IDParentezco: parseInt($('#beneficiarioParentesco').val()),
                Porcentaje: porcentaje
            };

            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/CrearBeneficiario",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ beneficiarioDataJson: JSON.stringify(beneficiarioData) }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success) {
                        mostrarToast('Beneficiario agregado correctamente', 'success');
                        limpiarFormularioBeneficiario();
                        cargarBeneficiarios(numeroAsociadoActual);
                        // Cerrar la modal
                        const modal = bootstrap.Modal.getInstance(document.getElementById('modalAgregarBeneficiario'));
                        if (modal) {
                            modal.hide();
                        }
                    } else {
                        mostrarToast(response.d.Message, 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al agregar beneficiario', 'error');
                }
            });
        }

        function eliminarBeneficiario(idBeneficiario) {
            mostrarConfirm({
                tipo: 'danger',
                titulo: 'Eliminar Beneficiario',
                mensaje: '¿Está seguro de que desea eliminar este beneficiario? Esta acción no se puede deshacer.',
                textoConfirmar: 'Sí, Eliminar',
                textoCancelar: 'Cancelar',
                tipoBoton: 'danger'
            }).then((confirmado) => {
                if (confirmado) {
                    $.ajax({
                        type: "POST",
                        url: "GestionSocios.aspx/EliminarBeneficiario",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ idBeneficiario: idBeneficiario }),
                        dataType: "json",
                        success: function(response) {
                            if (typeof response.d === 'string') {
                                response.d = JSON.parse(response.d);
                            }
                            if (response.d.Success) {
                                mostrarToast('Beneficiario eliminado correctamente', 'success');
                                cargarBeneficiarios(numeroAsociadoActual);
                            } else {
                                mostrarToast(response.d.Message, 'error');
                            }
                        },
                        error: function() {
                            mostrarToast('Error al eliminar beneficiario', 'error');
                        }
                    });
                }
            });
        }

        function limpiarFormularioBeneficiario() {
            $('#beneficiarioNombre').val('');
            $('#beneficiarioApellido').val('');
            $('#beneficiarioTipoIdentificacion').val('');
            $('#beneficiarioNumeroIdentificacion').val('');
            $('#beneficiarioParentesco').val('');
            $('#beneficiarioPorcentaje').val('');
        }

        function abrirModalAgregarBeneficiario() {
            if (!numeroAsociadoActual) {
                mostrarToast('Debe guardar el socio primero antes de agregar beneficiarios', 'error');
                return;
            }
            
            limpiarFormularioBeneficiario();
            const modal = new bootstrap.Modal(document.getElementById('modalAgregarBeneficiario'));
            modal.show();
        }

        function validarPorcentaje(input) {
            let valor = parseFloat(input.value);
            
            // Si el valor es mayor a 100, lo limita a 100
            if (valor > 100) {
                input.value = 100;
                mostrarToast('El porcentaje no puede ser mayor a 100%', 'warning');
            }
            
            // Si el valor es menor a 0, lo limita a 0
            if (valor < 0) {
                input.value = 0;
                mostrarToast('El porcentaje no puede ser menor a 0%', 'warning');
            }
            
            // Si el valor no es un número válido, lo limpia
            if (isNaN(valor) && input.value !== '') {
                input.value = '';
                mostrarToast('Por favor ingrese un valor numérico válido', 'warning');
            }
        }

        function validarPorcentajeEditar(input) {
            let valor = parseFloat(input.value);
            
            // Si el valor es mayor a 100, lo limita a 100
            if (valor > 100) {
                input.value = 100;
                mostrarToast('El porcentaje no puede ser mayor a 100%', 'warning');
            }
            
            // Si el valor es menor a 0, lo limita a 0
            if (valor < 0) {
                input.value = 0;
                mostrarToast('El porcentaje no puede ser menor a 0%', 'warning');
            }
            
            // Si el valor no es un número válido, lo limpia
            if (isNaN(valor) && input.value !== '') {
                input.value = '';
                mostrarToast('Por favor ingrese un valor numérico válido', 'warning');
            }
        }

        function editarBeneficiario(idBeneficiario) {
            // Buscar el beneficiario en la tabla actual
            const beneficiarios = [];
            $('#tablaBeneficiarios tbody tr').each(function() {
                const row = $(this);
                const editButton = row.find('button[onclick*="editarBeneficiario"]');
                if (editButton.length > 0) {
                    const onclickAttr = editButton.attr('onclick');
                    const match = onclickAttr.match(/editarBeneficiario\((\d+)\)/);
                    if (match && match[1] == idBeneficiario) {
                        const nombreCompleto = row.find('td:eq(0)').text();
                        const identificacion = row.find('td:eq(1)').text();
                        const parentesco = row.find('td:eq(2)').text();
                        const porcentaje = parseFloat(row.find('td:eq(3) .badge').text().replace('%', ''));
                        
                        // Extraer nombre y apellido del nombre completo
                        const partes = nombreCompleto.split(' ');
                        const nombre = partes[0] || '';
                        const apellido = partes.slice(1).join(' ') || '';
                        
                        // Extraer tipo y número de identificación
                        // La identificación viene como "cédula 123456789" o similar
                        const identificacionText = identificacion.trim();
                        let tipoIdentificacion = '';
                        let numeroIdentificacion = '';
                        
                        // Buscar el tipo de identificación por nombre completo
                        if (identificacionText.includes('cédula')) {
                            tipoIdentificacion = 'CED';
                            numeroIdentificacion = identificacionText.replace('cédula', '').trim();
                        } else if (identificacionText.includes('Pasaporte')) {
                            tipoIdentificacion = 'PAS';
                            numeroIdentificacion = identificacionText.replace('Pasaporte', '').trim();
                        } else if (identificacionText.includes('RUC')) {
                            tipoIdentificacion = 'RUC';
                            numeroIdentificacion = identificacionText.replace('RUC', '').trim();
                        } else if (identificacionText.includes('Otro')) {
                            tipoIdentificacion = 'OTR';
                            numeroIdentificacion = identificacionText.replace('Otro', '').trim();
                        } else {
                            // Si no encuentra el tipo, asumir que es solo el número
                            numeroIdentificacion = identificacionText;
                        }
                        
                        
                        
                        beneficiarios.push({
                            IDBeneficiario: idBeneficiario,
                            Nombre: nombre,
                            Apellido: apellido,
                            TipoIdentificacion: tipoIdentificacion,
                            NumeroIdentificacion: numeroIdentificacion,
                            Parentesco: parentesco,
                            Porcentaje: porcentaje
                        });
                    }
                }
            });
            
            if (beneficiarios.length > 0) {
                const beneficiario = beneficiarios[0];
                
                // Llenar el formulario de edición
                
                
                $('#editarBeneficiarioId').val(beneficiario.IDBeneficiario);
                $('#editarBeneficiarioNombre').val(beneficiario.Nombre);
                $('#editarBeneficiarioApellido').val(beneficiario.Apellido);
                $('#editarBeneficiarioTipoIdentificacion').val(beneficiario.TipoIdentificacion);
                $('#editarBeneficiarioNumeroIdentificacion').val(beneficiario.NumeroIdentificacion);
                $('#editarBeneficiarioPorcentaje').val(beneficiario.Porcentaje);
                
                .val(),
                    numeroIdentificacion: $('#editarBeneficiarioNumeroIdentificacion').val()
                });
                
                // Cargar parentezcos y seleccionar el correcto
                cargarParentezcosEditar(beneficiario.Parentesco);
                
                // Abrir la modal
                const modal = new bootstrap.Modal(document.getElementById('modalEditarBeneficiario'));
                modal.show();
            } else {
                mostrarToast('No se pudo encontrar la información del beneficiario', 'error');
            }
        }

        function cargarParentezcosEditar(parentescoSeleccionado) {
            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ObtenerParentezcos",
                contentType: "application/json; charset=utf-8",
                data: "{}",
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }

                    if (response.d.Success) {
                        const parentezcos = response.d.Data;
                        const select = $('#editarBeneficiarioParentesco');
                        
                        select.empty().append('<option value="">Seleccionar parentesco</option>');
                        
                        parentezcos.forEach(function(parentezco) {
                            const option = $('<option></option>')
                                .attr('value', parentezco.IDParentezco)
                                .text(parentezco.Parentezco);
                            
                            // Seleccionar el parentesco actual
                            if (parentezco.Parentezco === parentescoSeleccionado) {
                                option.attr('selected', true);
                            }
                            
                            select.append(option);
                        });
                    } else {
                        mostrarToast('Error al cargar parentezcos', 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al cargar parentezcos', 'error');
                }
            });
        }

        function guardarEdicionBeneficiario() {
            // Validar campos obligatorios
            const camposObligatorios = [
                { id: 'editarBeneficiarioNombre', nombre: 'Nombre' },
                { id: 'editarBeneficiarioApellido', nombre: 'Apellido' },
                { id: 'editarBeneficiarioTipoIdentificacion', nombre: 'Tipo de identificación' },
                { id: 'editarBeneficiarioNumeroIdentificacion', nombre: 'número de identificación' },
                { id: 'editarBeneficiarioParentesco', nombre: 'Parentesco' },
                { id: 'editarBeneficiarioPorcentaje', nombre: 'Porcentaje' }
            ];

            for (let campo of camposObligatorios) {
                if (!$('#' + campo.id).val()) {
                    mostrarToast(`El campo ${campo.nombre} es obligatorio`, 'error');
                    $('#' + campo.id).focus();
                    return;
                }
            }

            // Validar porcentaje
            const porcentaje = parseFloat($('#editarBeneficiarioPorcentaje').val());
            if (porcentaje <= 0 || porcentaje > 100) {
                mostrarToast('El porcentaje debe estar entre 0.01 y 100', 'error');
                $('#editarBeneficiarioPorcentaje').focus();
                return;
            }

            // Confirmar antes de actualizar
            const nombre = $('#editarBeneficiarioNombre').val().trim();
            const apellido = $('#editarBeneficiarioApellido').val().trim();
            const parentesco = $('#editarBeneficiarioParentesco option:selected').text();
            
            mostrarConfirm({
                tipo: 'info',
                titulo: 'Confirmar Cambios',
                mensaje: `¿Está seguro de actualizar a ${nombre} ${apellido}?\n\nParentesco: ${parentesco}\nPorcentaje: ${porcentaje}%`,
                textoConfirmar: 'Sí, Guardar',
                textoCancelar: 'Cancelar'
            }).then((confirmado) => {
                if (confirmado) {
                    procesarActualizarBeneficiario();
                }
            });
        }

        function procesarActualizarBeneficiario() {
            const beneficiarioData = {
                IDBeneficiario: parseInt($('#editarBeneficiarioId').val()),
                Nombre: $('#editarBeneficiarioNombre').val(),
                Apellido: $('#editarBeneficiarioApellido').val(),
                TipoIdentificacion: $('#editarBeneficiarioTipoIdentificacion').val(),
                NumeroIdentificacion: $('#editarBeneficiarioNumeroIdentificacion').val(),
                IDParentezco: parseInt($('#editarBeneficiarioParentesco').val()),
                Porcentaje: parseFloat($('#editarBeneficiarioPorcentaje').val())
            };

            $.ajax({
                type: "POST",
                url: "GestionSocios.aspx/ActualizarBeneficiario",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ beneficiarioDataJson: JSON.stringify(beneficiarioData) }),
                dataType: "json",
                success: function(response) {
                    if (typeof response.d === 'string') {
                        response.d = JSON.parse(response.d);
                    }
                    if (response.d.Success) {
                        mostrarToast('Beneficiario actualizado correctamente', 'success');
                        cargarBeneficiarios(numeroAsociadoActual);
                        // Cerrar la modal
                        const modal = bootstrap.Modal.getInstance(document.getElementById('modalEditarBeneficiario'));
                        if (modal) {
                            modal.hide();
                        }
                    } else {
                        mostrarToast(response.d.Message, 'error');
                    }
                },
                error: function() {
                    mostrarToast('Error al actualizar beneficiario', 'error');
                }
            });
        }
    </script>
    
    <!-- Script de monitoreo de inactividad -->
    <script src="../../Scripts/smart-chips.js?v=1.3"></script>
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
</body>
</html>



