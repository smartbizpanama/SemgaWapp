<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Mantenimientos.aspx.vb" Inherits="SemgaWapp.Mantenimientos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Mantenimientos - Cooperativa Segma</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <!-- Script de monitoreo de inactividad -->
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    
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
        
        .nav-tabs {
            border-bottom: 2px solid #dee2e6;
            margin-bottom: 20px;
        }
        
        .nav-tabs .nav-link {
            border: none;
            border-bottom: 3px solid transparent;
            color: #6c757d;
            font-weight: 500;
            padding: 12px 20px;
            margin-right: 5px;
            border-radius: 6px 6px 0 0;
            transition: all 0.3s ease;
        }
        
        .nav-tabs .nav-link:hover {
            border-color: transparent;
            background-color: #f8f9fa;
            color: #495057;
        }
        
        .nav-tabs .nav-link.active {
            color: #2c3e50;
            background-color: #ffffff;
            border: 2px solid #2c3e50 !important;
            border-bottom: 2px solid #ffffff !important;
            font-weight: 600;
            position: relative;
        }
        
        .nav-tabs .nav-link.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            right: 0;
            height: 2px;
            background-color: #ffffff;
            z-index: 1;
        }
        
        .tab-content {
            background: #ffffff;
            border: 1px solid #dee2e6;
            border-top: none;
            border-radius: 0 0 6px 6px;
            padding: 10px;
        }
        
        .table th {
            background-color: #2c3e50;
            color: white;
            border: none;
            font-weight: 500;
            font-size: 13px;
            padding: 8px 6px;
        }
        
        .table td {
            padding: 6px 6px;
            vertical-align: middle;
            border-top: 1px solid #dee2e6;
            font-size: 13px;
        }
        
        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        /* Reducir espacio entre filas */
        .table tbody tr {
            line-height: 1.2;
        }
        
        .table tbody tr td {
            padding-top: 4px;
            padding-bottom: 4px;
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
        
        .tab-icon {
            margin-right: 8px;
        }
        
        .tab-content .card {
            border: none;
            box-shadow: none;
        }
        
        .tab-content .card-header {
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            font-weight: 600;
            color: #495057;
        }
        
        /* Estilos para chips inteligentes de estatus */
        .status-chip {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        
        .status-chip:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        .status-chip .icon {
            margin-right: 0.25rem;
            font-size: 0.75rem;
        }
        
        .status-chip.status-A {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }
        
        .status-chip.status-I {
            background: linear-gradient(135deg, #6c757d, #495057);
            color: white;
        }
        
        .status-chip.status-S {
            background: linear-gradient(135deg, #ffc107, #fd7e14);
            color: #212529;
        }
        
        .status-chip.status-U {
            background: linear-gradient(135deg, #17a2b8, #007bff);
            color: white;
        }
        

        /* Estilos para chips inteligentes de tipos de documentos */
        .tipo-doc-chip {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        
        .tipo-doc-chip:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        .tipo-doc-chip .icon {
            margin-right: 0.25rem;
            font-size: 0.75rem;
        }
        
        .tipo-doc-chip.tipo-doc-CED {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
        }
        
        .tipo-doc-chip.tipo-doc-PAS {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            color: white;
        }
        
        .tipo-doc-chip.tipo-doc-RUC {
            background: linear-gradient(135deg, #17a2b8, #117a8b);
            color: white;
        }
        
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Header Section -->
            <div style="background: linear-gradient(135deg, #1e3a8a, #3b82f6); color: white; padding: 10px 15px; margin: -15px -15px 15px -15px; display: flex; justify-content: space-between; align-items: center;">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <button type="button" onclick="volverDashboard()" style="background: rgba(255,255,255,0.2); border: none; color: white; padding: 8px 12px; border-radius: 5px; cursor: pointer; display: flex; align-items: center; gap: 5px;">
                        <i class="fas fa-arrow-left"></i>
                        Volver
                    </button>
                    <h2 style="margin: 0; font-size: 18px;">
                        <i class="fas fa-cogs" style="margin-right: 8px;"></i>
                        Mantenimientos del Sistema
                    </h2>
                </div>
            </div>

            <!-- Tabs Navigation -->
            <ul class="nav nav-tabs" id="mantenimientosTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="codigos-transacciones-tab" data-bs-toggle="tab" data-bs-target="#codigos-transacciones" type="button" role="tab">
                        <i class="fas fa-exchange-alt tab-icon"></i>Códigos Transacciones
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="departamentos-tab" data-bs-toggle="tab" data-bs-target="#departamentos" type="button" role="tab">
                        <i class="fas fa-building tab-icon"></i>Departamentos
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="parentezcos-tab" data-bs-toggle="tab" data-bs-target="#parentezcos" type="button" role="tab">
                        <i class="fas fa-users tab-icon"></i>Parentezcos
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="roles-tab" data-bs-toggle="tab" data-bs-target="#roles" type="button" role="tab">
                        <i class="fas fa-user-tag tab-icon"></i>Roles
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="rubros-tab" data-bs-toggle="tab" data-bs-target="#rubros" type="button" role="tab">
                        <i class="fas fa-list-alt tab-icon"></i>Rubros
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="estatus-asociados-tab" data-bs-toggle="tab" data-bs-target="#estatus-asociados" type="button" role="tab">
                        <i class="fas fa-user-check tab-icon"></i>Estatus Asociados
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="tipo-asociados-tab" data-bs-toggle="tab" data-bs-target="#tipo-asociados" type="button" role="tab">
                        <i class="fas fa-user-friends tab-icon"></i>Tipo Asociados
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="tipo-identificacion-tab" data-bs-toggle="tab" data-bs-target="#tipo-identificacion" type="button" role="tab">
                        <i class="fas fa-id-card tab-icon"></i>Tipo Identificación
                    </button>
                </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="tipos-auxiliares-tab" data-bs-toggle="tab" data-bs-target="#tipos-auxiliares" type="button" role="tab">
                                <i class="fas fa-tools tab-icon"></i>Tipos Auxiliares
                            </button>
                        </li>
            </ul>

            <!-- Tab Content -->
            <div class="tab-content" id="mantenimientosTabContent">
                <!-- Códigos Transacciones Tab -->
                <div class="tab-pane fade show active" id="codigos-transacciones" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Rubro:</label>
                                        <select id="ddlFiltroRubro" class="form-select">
                                            <option value="">Todos los rubros</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="text" id="txtFiltroCodigo" class="form-control" placeholder="Buscar código..."/>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Descripción:</label>
                                        <input type="text" id="txtFiltroDescripcion" class="form-control" placeholder="Buscar descripción..."/>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Estado:</label>
                                        <select id="ddlFiltroEstado" class="form-select">
                                            <option value="">Todos</option>
                                            <option value="1">Activo</option>
                                            <option value="0">Inactivo</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoCodigo" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo Código
                                        </button>
                                        <button type="button" id="btnBuscarCodigos" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltros" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblCodigosTransaccion" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Rubro</th>
                                            <th>Código</th>
                                            <th>Descripción</th>
                                            <th>Tipo</th>
                                            <th>Cuenta Contable</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="8" class="text-center text-muted">
                                                <i class="fas fa-spinner fa-spin me-2"></i>Cargando datos...
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Departamentos Tab -->
                <div class="tab-pane fade" id="departamentos" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Nombre:</label>
                                        <input type="text" id="txtFiltroNombreDepartamento" class="form-control" placeholder="Buscar nombre..."/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Responsable:</label>
                                        <input type="text" id="txtFiltroResponsableDepartamento" class="form-control" placeholder="Buscar responsable..."/>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Estado:</label>
                                        <select id="ddlFiltroEstadoDepartamento" class="form-select">
                                            <option value="">Todos</option>
                                            <option value="1">Activo</option>
                                            <option value="0">Inactivo</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoDepartamento" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo Departamento
                                        </button>
                                        <button type="button" id="btnBuscarDepartamentos" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosDepartamento" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblDepartamentos" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Nombre</th>
                                            <th>Descripción</th>
                                            <th>Responsable</th>
                                            <th>Teléfono</th>
                                            <th>Email</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Los datos se cargarán dinámicamente -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Parentezcos Tab -->
                <div class="tab-pane fade" id="parentezcos" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones alineados con la tabla -->
                            <div class="row mb-2">
                                <div class="col-md-4">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Parentezco:</label>
                                        <input type="text" id="txtFiltroParentezco" class="form-control" placeholder="Buscar parentezco..."/>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoParentezco" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo Parentezco
                                        </button>
                                        <button type="button" id="btnBuscarParentezcos" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosParentezco" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla alineada a la izquierda -->
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="table-responsive">
                                        <table id="tblParentezcos" class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Parentezco</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- Los datos se cargarán dinámicamente -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Roles Tab -->
                <div class="tab-pane fade" id="roles" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Nombre:</label>
                                        <input type="text" id="txtFiltroNombreRol" class="form-control" placeholder="Buscar nombre..."/>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Nivel:</label>
                                        <select id="ddlFiltroNivelAcceso" class="form-select">
                                            <option value="">Todos</option>
                                            <option value="0">Super Usuario</option>
                                            <option value="1">Administrador</option>
                                            <option value="2">Agente</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Estado:</label>
                                        <select id="ddlFiltroEstadoRol" class="form-select">
                                            <option value="">Todos</option>
                                            <option value="1">Activo</option>
                                            <option value="0">Inactivo</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-5">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoRol" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo Rol
                                        </button>
                                        <button type="button" id="btnBuscarRoles" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosRol" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblRoles" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Nombre</th>
                                            <th>Descripción</th>
                                            <th>Nivel de Acceso</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Los datos se cargarán dinámicamente -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Rubros Tab -->
                <div class="tab-pane fade" id="rubros" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="text" id="txtFiltroCodigoRubro" class="form-control" placeholder="Buscar código..."/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Descripción:</label>
                                        <input type="text" id="txtFiltroDescripcionRubro" class="form-control" placeholder="Buscar descripción..."/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoRubro" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo Rubro
                                        </button>
                                        <button type="button" id="btnBuscarRubros" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosRubro" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla alineada a la izquierda -->
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="table-responsive">
                                        <table id="tblRubros" class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Rubro</th>
                                                    <th>Acciones</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- Los datos se cargarán dinámicamente -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Estatus Asociados Tab -->
                <div class="tab-pane fade" id="estatus-asociados" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="text" id="txtFiltroCodigoStatus" class="form-control" placeholder="Buscar código..." maxlength="1"/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Descripción:</label>
                                        <input type="text" id="txtFiltroDescripcionStatus" class="form-control" placeholder="Buscar descripción..."/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoStatus" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo Estatus
                                        </button>
                                        <button type="button" id="btnBuscarStatus" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosStatus" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblStatus" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Código</th>
                                            <th>Descripción</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Los datos se cargarán dinámicamente -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tipo Asociados Tab -->
                <div class="tab-pane fade" id="tipo-asociados" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="text" id="txtFiltroCodigoTipoAsociado" class="form-control" placeholder="Buscar código..."/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Tipo:</label>
                                        <input type="text" id="txtFiltroTipoAsociado" class="form-control" placeholder="Buscar tipo..."/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoTipoAsociado" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo Tipo
                                        </button>
                                        <button type="button" id="btnBuscarTipoAsociado" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosTipoAsociado" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblTipoAsociado" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Código</th>
                                            <th>Tipo</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Los datos se cargarán dinámicamente -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tipos Auxiliares Tab -->
                <div class="tab-pane fade" id="tipos-auxiliares" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Rubro:</label>
                                        <select id="ddlFiltroRubroAuxiliar" class="form-select">
                                            <option value="">Todos los rubros</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Tipo:</label>
                                        <input type="number" id="txtFiltroTipoAuxiliar" class="form-control" placeholder="Buscar tipo..."/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Descripción:</label>
                                        <input type="text" id="txtFiltroDescripcionAuxiliar" class="form-control" placeholder="Buscar descripción..."/>
                                    </div>
                                </div>
                                <div class="col-md-5">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoTipoAuxiliar" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo Tipo Auxiliar
                                        </button>
                                        <button type="button" id="btnBuscarTiposAuxiliares" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosAuxiliar" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblTiposAuxiliares" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Rubro</th>
                                            <th>Tipo</th>
                                            <th>Descripción</th>
                                            <th>Tasa</th>
                                            <th>Plazo (meses)</th>
                                            <th>Monto Mín.</th>
                                            <th>Monto Máx.</th>
                                            <th>% Manejo</th>
                                            <th>% Capital.</th>
                                            <th>% Protec.</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Los datos se cargarán dinámicamente -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tipo Identificación Tab -->
                <div class="tab-pane fade" id="tipo-identificacion" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="text" id="txtFiltroCodigoTipoDoc" class="form-control" placeholder="Buscar código..."/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Tipo:</label>
                                        <input type="text" id="txtFiltroTipoDocumento" class="form-control" placeholder="Buscar tipo..."/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoTipoDoc" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo Tipo
                                        </button>
                                        <button type="button" id="btnBuscarTipoDoc" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosTipoDoc" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblTipoDocumentos" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Código</th>
                                            <th>Tipo de Documento</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Los datos se cargarán dinámicamente -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tipos Auxiliares Tab -->
                <div class="tab-pane fade" id="tipos-auxiliares" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <div class="row mb-2">
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-primary">
                                        <i class="fas fa-plus me-1"></i>Nuevo Tipo
                                    </button>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="Buscar tipo..."/>
                                        <button class="btn btn-outline-secondary" type="button">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Código</th>
                                            <th>Descripción</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="4" class="text-center text-muted">No hay datos disponibles</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>



            </div>
        </div>

        <!-- Toast Container -->
        <div id="toastContainer" class="toast-container"></div>
        
        <!-- Modal Código Transacción -->
        <div class="modal fade" id="modalCodigoTransaccion" tabindex="-1" aria-labelledby="modalCodigoTransaccionLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalCodigoTransaccionLabel">
                            <i class="fas fa-exchange-alt me-2"></i>Nuevo Código de Transacción
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formCodigoTransaccion">
                            <input type="hidden" id="txtCodigoTransaccionID" value="0">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="ddlCodigoRubro" class="form-label">Rubro <span class="text-danger">*</span></label>
                                        <select id="ddlCodigoRubro" class="form-select">
                                            <option value="">Seleccionar rubro...</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoTransaccion" class="form-label">Código de Transacción <span class="text-danger">*</span></label>
                                        <input type="text" id="txtCodigoTransaccion" class="form-control" maxlength="10">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label for="txtDescripcion" class="form-label">Descripción <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcion" class="form-control" maxlength="150">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="ddlDebCred" class="form-label">Tipo <span class="text-danger">*</span></label>
                                        <select id="ddlDebCred" class="form-select">
                                            <option value="">Seleccionar tipo...</option>
                                            <option value="D">Débito</option>
                                            <option value="C">Crédito</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCuentaContable" class="form-label">Cuenta Contable</label>
                                        <input type="text" id="txtCuentaContable" class="form-control" maxlength="50">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="chkSnActivo" checked>
                                            <label class="form-check-label" for="chkSnActivo">
                                                Activo
                                            </label>
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
                        <button type="button" id="btnGuardarCodigoTransaccion" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Departamento -->
        <div class="modal fade" id="modalDepartamento" tabindex="-1" aria-labelledby="modalDepartamentoLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalDepartamentoLabel">
                            <i class="fas fa-building me-2"></i>Nuevo Departamento
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formDepartamento">
                            <input type="hidden" id="txtDepartamentoID" value="0">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtNombreDepartamento" class="form-label">Nombre <span class="text-danger">*</span></label>
                                        <input type="text" id="txtNombreDepartamento" class="form-control" maxlength="100">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtResponsableDepartamento" class="form-label">Responsable</label>
                                        <input type="text" id="txtResponsableDepartamento" class="form-control" maxlength="100">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label for="txtDescripcionDepartamento" class="form-label">Descripción</label>
                                        <textarea id="txtDescripcionDepartamento" class="form-control" rows="3" maxlength="500"></textarea>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtTelefonoDepartamento" class="form-label">Teléfono</label>
                                        <input type="text" id="txtTelefonoDepartamento" class="form-control" maxlength="20">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtEmailDepartamento" class="form-label">Email</label>
                                        <input type="email" id="txtEmailDepartamento" class="form-control" maxlength="100">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="chkActivoDepartamento" checked>
                                            <label class="form-check-label" for="chkActivoDepartamento">
                                                Activo
                                            </label>
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
                        <button type="button" id="btnGuardarDepartamento" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Parentezco -->
        <div class="modal fade" id="modalParentezco" tabindex="-1" aria-labelledby="modalParentezcoLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalParentezcoLabel">
                            <i class="fas fa-users me-2"></i>Nuevo Parentezco
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formParentezco">
                            <input type="hidden" id="txtParentezcoID" value="0">
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label for="txtParentezco" class="form-label">Parentezco <span class="text-danger">*</span></label>
                                        <input type="text" id="txtParentezco" class="form-control" maxlength="50">
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarParentezco" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Rol -->
        <div class="modal fade" id="modalRol" tabindex="-1" aria-labelledby="modalRolLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalRolLabel">
                            <i class="fas fa-user-shield me-2"></i>Nuevo Rol
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formRol">
                            <input type="hidden" id="txtRolID" value="0">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtNombreRol" class="form-label">Nombre <span class="text-danger">*</span></label>
                                        <input type="text" id="txtNombreRol" class="form-control" maxlength="50">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="ddlNivelAcceso" class="form-label">Nivel de Acceso <span class="text-danger">*</span></label>
                                        <select id="ddlNivelAcceso" class="form-select">
                                            <option value="">Seleccionar nivel...</option>
                                            <option value="0">Super Usuario</option>
                                            <option value="1">Administrador</option>
                                            <option value="2">Agente</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label for="txtDescripcionRol" class="form-label">Descripción</label>
                                        <textarea id="txtDescripcionRol" class="form-control" rows="3" maxlength="200"></textarea>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="chkActivoRol" checked>
                                            <label class="form-check-label" for="chkActivoRol">
                                                Activo
                                            </label>
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
                        <button type="button" id="btnGuardarRol" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Rubro -->
        <div class="modal fade" id="modalRubro" tabindex="-1" aria-labelledby="modalRubroLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalRubroLabel">
                            <i class="fas fa-tags me-2"></i>Nuevo Rubro
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formRubro">
                            <input type="hidden" id="txtRubroID" value="0">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoRubro" class="form-label">Código <span class="text-danger">*</span></label>
                                        <input type="text" id="txtCodigoRubro" class="form-control" maxlength="5">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtDescripcionRubro" class="form-label">Descripción <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcionRubro" class="form-control" maxlength="100">
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarRubro" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Estatus Asociado -->
        <div class="modal fade" id="modalStatus" tabindex="-1" aria-labelledby="modalStatusLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalStatusLabel">
                            <i class="fas fa-user-check me-2"></i>Nuevo Estatus
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formStatus">
                            <input type="hidden" id="txtStatusID" value="0">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoStatus" class="form-label">Código <span class="text-danger">*</span></label>
                                        <input type="text" id="txtCodigoStatus" class="form-control" maxlength="1">
                                        <div class="form-text">Un solo carácter (ej: A, I, S)</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtDescripcionStatus" class="form-label">Descripción <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcionStatus" class="form-control" maxlength="50">
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarStatus" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Tipo Asociado -->
        <div class="modal fade" id="modalTipoAsociado" tabindex="-1" aria-labelledby="modalTipoAsociadoLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTipoAsociadoLabel">
                            <i class="fas fa-users me-2"></i>Nuevo Tipo Asociado
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formTipoAsociado">
                            <input type="hidden" id="txtTipoAsociadoID" value="0">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoTipoAsociado" class="form-label">Código <span class="text-danger">*</span></label>
                                        <input type="text" id="txtCodigoTipoAsociado" class="form-control" maxlength="50">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtTipoAsociado" class="form-label">Tipo <span class="text-danger">*</span></label>
                                        <input type="text" id="txtTipoAsociado" class="form-control" maxlength="50">
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarTipoAsociado" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Tipo Documento -->
        <div class="modal fade" id="modalTipoDoc" tabindex="-1" aria-labelledby="modalTipoDocLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTipoDocLabel">
                            <i class="fas fa-id-card me-2"></i>Nuevo Tipo de Documento
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formTipoDoc">
                            <input type="hidden" id="txtTipoDocID" value="0">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoTipoDoc" class="form-label">Código <span class="text-danger">*</span></label>
                                        <input type="text" id="txtCodigoTipoDoc" class="form-control" maxlength="10">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtTipoDocumento" class="form-label">Tipo de Documento <span class="text-danger">*</span></label>
                                        <input type="text" id="txtTipoDocumento" class="form-control" maxlength="50">
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarTipoDoc" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Tipo Auxiliar -->
        <div class="modal fade" id="modalTipoAuxiliar" tabindex="-1" aria-labelledby="modalTipoAuxiliarLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTipoAuxiliarLabel">
                            <i class="fas fa-tools me-2"></i>Nuevo Tipo Auxiliar
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formTipoAuxiliar">
                            <input type="hidden" id="hdnIDTipoAuxiliar" />
                            <!-- Fila 1: Rubro y Descripción -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="ddlCodigoRubroAuxiliar" class="form-label">Rubro <span class="text-danger">*</span></label>
                                        <select id="ddlCodigoRubroAuxiliar" class="form-select">
                                            <option value="">Seleccionar rubro...</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtDescripcionAuxiliar" class="form-label">Descripción <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcionAuxiliar" class="form-control" placeholder="Descripción del tipo auxiliar" maxlength="150">
                                    </div>
                                </div>
                                <!-- Campo Tipo Auxiliar oculto -->
                                <input type="hidden" id="txtTipoAuxiliar" />
                            </div>
                            
                            <!-- Fila 2: Tasa, Plazo, Monto Mínimo y Monto Máximo -->
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="mb-3">
                                        <label for="txtTasaAuxiliar" class="form-label">Tasa (%)</label>
                                        <input type="number" id="txtTasaAuxiliar" class="form-control" placeholder="0.00" step="0.01" min="0" max="100">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="mb-3">
                                        <label for="txtPlazoAuxiliar" class="form-label">Plazo (meses)</label>
                                        <input type="number" id="txtPlazoAuxiliar" class="form-control" placeholder="0" min="0">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="mb-3">
                                        <label for="txtMontoMinimoAuxiliar" class="form-label">Monto Mínimo</label>
                                        <div class="input-group">
                                            <span class="input-group-text">$</span>
                                            <input type="number" id="txtMontoMinimoAuxiliar" class="form-control" placeholder="0.00" step="0.01" min="0">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="mb-3">
                                        <label for="txtMontoMaximoAuxiliar" class="form-label">Monto Máximo</label>
                                        <div class="input-group">
                                            <span class="input-group-text">$</span>
                                            <input type="number" id="txtMontoMaximoAuxiliar" class="form-control" placeholder="0.00" step="0.01" min="0">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Fila 3: Porcentajes -->
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="txtPorManejoAuxiliar" class="form-label">% Manejo</label>
                                        <input type="number" id="txtPorManejoAuxiliar" class="form-control" placeholder="0.00" step="0.01" min="0" max="100">
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="txtPorCapitalizacionAuxiliar" class="form-label">% Capitalización</label>
                                        <input type="number" id="txtPorCapitalizacionAuxiliar" class="form-control" placeholder="0.00" step="0.01" min="0" max="100">
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="txtPorProteccionAuxiliar" class="form-label">% Protección</label>
                                        <input type="number" id="txtPorProteccionAuxiliar" class="form-control" placeholder="0.00" step="0.01" min="0" max="100">
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarTipoAuxiliar" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="../../Scripts/smart-chips.js"></script>

    <script>
        $(document).ready(function() {
            // Inicializar monitoreo de inactividad
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }

            // Inicializar tabs
            var triggerTabList = [].slice.call(document.querySelectorAll('#mantenimientosTabs button'))
            triggerTabList.forEach(function (triggerEl) {
                var tabTrigger = new bootstrap.Tab(triggerEl)
                
                triggerEl.addEventListener('click', function (event) {
                    event.preventDefault()
                    tabTrigger.show()
                })
            });
            
            // Inicializar eventos de tabs para carga bajo demanda
            inicializarTabsLazyLoading();
            
            // Cargar el tab activo por defecto
            setTimeout(function() {
                // Por defecto, cargar el primer tab (Códigos de Transacciones)
                mostrarLoading('tblCodigosTransaccion');
                inicializarCodigosTransaccion();
                window.codigosTransaccionInicializado = true;
            }, 100);
        });

        function volverDashboard() {
            window.location.href = 'dashboardSistemas.aspx';
        }

        // ===== CARGA BAJO DEMANDA DE TABS =====
        function inicializarTabsLazyLoading() {
            // Eventos para tabs
            $('#codigos-transaccion-tab').on('click', function() {
                if (!window.codigosTransaccionInicializado) {
                    mostrarLoading('tblCodigosTransaccion');
                    inicializarCodigosTransaccion();
                    window.codigosTransaccionInicializado = true;
                }
            });
            
            $('#departamentos-tab').on('click', function() {
                if (!window.departamentosInicializado) {
                    mostrarLoading('tblDepartamentos');
                    inicializarDepartamentos();
                    window.departamentosInicializado = true;
                }
            });
            
            $('#parentezcos-tab').on('click', function() {
                if (!window.parentezcosInicializado) {
                    mostrarLoading('tblParentezcos');
                    inicializarParentezcos();
                    window.parentezcosInicializado = true;
                }
            });
            
            $('#roles-tab').on('click', function() {
                if (!window.rolesInicializado) {
                    mostrarLoading('tblRoles');
                    inicializarRoles();
                    window.rolesInicializado = true;
                }
            });
            
            $('#rubros-tab').on('click', function() {
                if (!window.rubrosInicializado) {
                    mostrarLoading('tblRubros');
                    inicializarRubros();
                    window.rubrosInicializado = true;
                }
            });
            
            $('#estatus-asociados-tab').on('click', function() {
                if (!window.statusAsociadosInicializado) {
                    mostrarLoading('tblStatus');
                    inicializarStatusAsociados();
                    window.statusAsociadosInicializado = true;
                }
            });
            
            $('#tipo-asociados-tab').on('click', function() {
                if (!window.tipoAsociadosInicializado) {
                    mostrarLoading('tblTipoAsociado');
                    inicializarTipoAsociados();
                    window.tipoAsociadosInicializado = true;
                }
            });
            
            $('#tipo-identificacion-tab').on('click', function() {
                if (!window.tipoDocumentosInicializado) {
                    mostrarLoading('tblTipoDocumentos');
                    inicializarTipoDocumentos();
                    window.tipoDocumentosInicializado = true;
                }
            });
            
            $('#tipos-auxiliares-tab').on('click', function() {
                if (!window.tiposAuxiliaresInicializado) {
                    mostrarLoading('tblTiposAuxiliares');
                    inicializarTiposAuxiliares();
                    window.tiposAuxiliaresInicializado = true;
                }
            });
            
            $('#usuarios-tab').on('click', function() {
                if (!window.usuariosInicializado) {
                    mostrarLoading('tblUsuarios');
                    inicializarUsuarios();
                    window.usuariosInicializado = true;
                }
            });
        }

        function mostrarLoading(tablaId) {
            const tbody = $(`#${tablaId} tbody`);
            tbody.html(`
                <tr>
                    <td colspan="3" class="text-center py-4">
                        <div class="d-flex justify-content-center align-items-center">
                            <div class="spinner-border spinner-border-sm text-primary me-2" role="status">
                                <span class="visually-hidden">Cargando...</span>
                            </div>
                            <span class="text-muted">Cargando datos...</span>
                        </div>
                    </td>
                </tr>
            `);
        }

        // ===== FUNCIONES DE CONFIGURACIÓN DE EVENTOS =====
        function configurarEventosCodigosTransaccion() {
            $('#btnNuevoCodigo').on('click', function() {
                abrirModalCodigoTransaccion();
            });
            
            $('#btnBuscarCodigos').on('click', function() {
                cargarCodigosTransaccion();
            });
            
            $('#btnLimpiarFiltros').on('click', function() {
                limpiarFiltros();
            });
            
            $('#btnGuardarCodigoTransaccion').on('click', function() {
                guardarCodigoTransaccion();
            });
            
            // Búsqueda en tiempo real
            $('#txtFiltroCodigo, #txtFiltroDescripcion').on('keyup', function() {
                clearTimeout(window.busquedaTimeout);
                window.busquedaTimeout = setTimeout(function() {
                    cargarCodigosTransaccion();
                }, 500);
            });
        }

        function configurarEventosDepartamentos() {
            $('#btnNuevoDepartamento').on('click', function() {
                abrirModalDepartamento();
            });
            
            $('#btnBuscarDepartamentos').on('click', function() {
                cargarDepartamentos();
            });
            
            $('#btnLimpiarFiltrosDepartamento').on('click', function() {
                limpiarFiltrosDepartamento();
            });
            
            $('#btnGuardarDepartamento').on('click', function() {
                guardarDepartamento();
            });
            
            // Búsqueda en tiempo real
            $('#txtFiltroNombreDepartamento, #txtFiltroResponsableDepartamento').on('keyup', function() {
                clearTimeout(window.busquedaDepartamentoTimeout);
                window.busquedaDepartamentoTimeout = setTimeout(function() {
                    cargarDepartamentos();
                }, 500);
            });
        }

        function configurarEventosParentezcos() {
            $('#btnNuevoParentezco').on('click', function() {
                abrirModalParentezco();
            });
            
            $('#btnBuscarParentezcos').on('click', function() {
                cargarParentezcos();
            });
            
            $('#btnLimpiarFiltrosParentezco').on('click', function() {
                limpiarFiltrosParentezco();
            });
            
            $('#btnGuardarParentezco').on('click', function() {
                guardarParentezco();
            });
            
            // Búsqueda en tiempo real
            $('#txtFiltroParentezco').on('keyup', function() {
                clearTimeout(window.busquedaParentezcoTimeout);
                window.busquedaParentezcoTimeout = setTimeout(function() {
                    cargarParentezcos();
                }, 500);
            });
        }

        function configurarEventosRoles() {
            $('#btnNuevoRol').on('click', function() {
                abrirModalRol();
            });
            
            $('#btnBuscarRoles').on('click', function() {
                cargarRoles();
            });
            
            $('#btnLimpiarFiltrosRol').on('click', function() {
                limpiarFiltrosRol();
            });
            
            $('#btnGuardarRol').on('click', function() {
                guardarRol();
            });
            
            // Búsqueda en tiempo real
            $('#txtFiltroNombreRol, #ddlFiltroNivelAcceso, #ddlFiltroEstadoRol').on('keyup change', function() {
                clearTimeout(window.busquedaRolTimeout);
                window.busquedaRolTimeout = setTimeout(function() {
                    cargarRoles();
                }, 500);
            });
        }

        function configurarEventosRubros() {
            $('#btnNuevoRubro').on('click', function() {
                abrirModalRubro();
            });
            
            $('#btnBuscarRubros').on('click', function() {
                cargarRubrosTab();
            });
            
            $('#btnLimpiarFiltrosRubro').on('click', function() {
                limpiarFiltrosRubro();
            });
            
            $('#btnGuardarRubro').on('click', function() {
                guardarRubro();
            });
            
            // Búsqueda en tiempo real
            $('#txtFiltroCodigoRubro, #txtFiltroDescripcionRubro').on('keyup', function() {
                clearTimeout(window.busquedaRubroTimeout);
                window.busquedaRubroTimeout = setTimeout(function() {
                    cargarRubrosTab();
                }, 500);
            });
        }

        function configurarEventosStatusAsociados() {
            $('#btnNuevoStatus').on('click', function() {
                abrirModalStatus();
            });
            
            $('#btnBuscarStatus').on('click', function() {
                cargarStatusAsociados();
            });
            
            $('#btnLimpiarFiltrosStatus').on('click', function() {
                limpiarFiltrosStatus();
            });
            
            $('#btnGuardarStatus').on('click', function() {
                guardarStatus();
            });
            
            // Búsqueda en tiempo real
            $('#txtFiltroCodigoStatus, #txtFiltroDescripcionStatus').on('keyup', function() {
                clearTimeout(window.busquedaStatusTimeout);
                window.busquedaStatusTimeout = setTimeout(function() {
                    cargarStatusAsociados();
                }, 500);
            });
        }

        function configurarEventosTipoAsociados() {
            $('#btnNuevoTipoAsociado').on('click', function() {
                abrirModalTipoAsociado();
            });
            
            $('#btnBuscarTipoAsociado').on('click', function() {
                cargarTipoAsociados();
            });
            
            $('#btnLimpiarFiltrosTipoAsociado').on('click', function() {
                limpiarFiltrosTipoAsociado();
            });
            
            $('#btnGuardarTipoAsociado').on('click', function() {
                guardarTipoAsociado();
            });
            
            // Búsqueda en tiempo real
            $('#txtFiltroCodigoTipoAsociado, #txtFiltroTipoAsociado').on('keyup', function() {
                clearTimeout(window.busquedaTipoAsociadoTimeout);
                window.busquedaTipoAsociadoTimeout = setTimeout(function() {
                    cargarTipoAsociados();
                }, 500);
            });
        }

        function configurarEventosTipoDocumentos() {
            $('#btnNuevoTipoDoc').on('click', function() {
                abrirModalTipoDoc();
            });
            
            $('#btnBuscarTipoDoc').on('click', function() {
                cargarTipoDocumentos();
            });
            
            $('#btnLimpiarFiltrosTipoDoc').on('click', function() {
                limpiarFiltrosTipoDoc();
            });
            
            $('#btnGuardarTipoDoc').on('click', function() {
                guardarTipoDoc();
            });
            
            // Búsqueda en tiempo real
            $('#txtFiltroCodigoTipoDoc, #txtFiltroTipoDocumento').on('keyup', function() {
                clearTimeout(window.busquedaTipoDocTimeout);
                window.busquedaTipoDocTimeout = setTimeout(function() {
                    cargarTipoDocumentos();
                }, 500);
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

        // ===== FUNCIONALIDAD CÓDIGOS DE TRANSACCIÓN =====
        function inicializarCodigosTransaccion() {
            console.log('🔍 Iniciando inicializarCodigosTransaccion...');
            // Cargar rubros para filtro y modal
            console.log('🔍 Llamando a cargarRubros()...');
            cargarRubros();
            
            // Cargar datos iniciales
            cargarCodigosTransaccion();
            
            // Configurar eventos
            configurarEventosCodigosTransaccion();
            
            $('#ddlFiltroRubro, #ddlFiltroEstado').on('change', function() {
                cargarCodigosTransaccion();
            });
            
            console.log('✅ Inicialización de Códigos de Transacción completada');
        }

        function cargarRubros() {
            console.log('🔍 Iniciando carga de rubros...');
            console.log('🔍 URL:', 'Mantenimientos.aspx/ObtenerRubros');
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerRubros",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                beforeSend: function() {
                    console.log('📤 Enviando petición AJAX para obtener rubros...');
                },
                success: function(response) {
                    console.log('📥 Respuesta recibida:', response);
                    
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const rubros = JSON.parse(response.d.Datos);
                        console.log('📋 Rubros cargados:', rubros);
                        
                        // Llenar dropdown de filtro
                        $('#ddlFiltroRubro').empty().append('<option value="">Todos los rubros</option>');
                        $.each(rubros, function(index, rubro) {
                            console.log('📝 Agregando rubro a filtro:', rubro.CodigoRubro, rubro.Descripcion);
                            $('#ddlFiltroRubro').append(`<option value="${rubro.CodigoRubro}">${rubro.CodigoRubro} - ${rubro.Descripcion}</option>`);
                        });
                        
                        // Llenar dropdown del modal
                        $('#ddlCodigoRubro').empty().append('<option value="">Seleccionar rubro...</option>');
                        $.each(rubros, function(index, rubro) {
                            console.log('📝 Agregando rubro a modal:', rubro.CodigoRubro, rubro.Descripcion);
                            $('#ddlCodigoRubro').append(`<option value="${rubro.CodigoRubro}">${rubro.CodigoRubro} - ${rubro.Descripcion}</option>`);
                        });
                    } else {
                        console.log('❌ Error en respuesta:', response);
                    }
                },
                error: function(xhr, status, error) {
                    console.log('❌ Error AJAX al cargar rubros:');
                    console.log('❌ Status:', status);
                    console.log('❌ Error:', error);
                    console.log('❌ Response:', xhr.responseText);
                    showToast('error', 'Error', 'Error al cargar rubros: ' + error);
                }
            });
        }

        function cargarCodigosTransaccion() {
            
            const filtros = {
                CodigoRubro: $('#ddlFiltroRubro').val(),
                CodigoTransaccion: $('#txtFiltroCodigo').val(),
                Descripcion: $('#txtFiltroDescripcion').val(),
                SnActivo: $('#ddlFiltroEstado').val() === '' ? null : $('#ddlFiltroEstado').val() === '1'
            };
            
            console.log('📋 Filtros:', filtros);
            console.log('🌐 Enviando petición AJAX...');
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarCodigosTransaccion",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: filtros }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const codigos = JSON.parse(response.d.Datos);
                        mostrarCodigosTransaccion(codigos);
                    } else {
                        mostrarCodigosTransaccion([]);
                        showToast('warning', 'Advertencia', response.d.Mensaje || 'No se encontraron datos');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarCodigosTransaccion([]);
                    showToast('error', 'Error', 'Error al cargar códigos de transacción');
                }
            });
        }

        function mostrarCodigosTransaccion(codigos) {
            const tbody = $('#tblCodigosTransaccion tbody');
            tbody.empty();
            
            if (codigos.length === 0) {
                tbody.append(`
                    <tr>
                        <td colspan="8" class="text-center text-muted">
                            <i class="fas fa-info-circle me-2"></i>No hay datos disponibles
                        </td>
                    </tr>
                `);
                return;
            }
            
            $.each(codigos, function(index, codigo) {
                const estadoBadge = codigo.SnActivo ? 
                    '<span class="badge bg-success">Activo</span>' : 
                    '<span class="badge bg-secondary">Inactivo</span>';
                
                const tipoBadge = codigo.DebCred === 'D' ? 
                    '<span class="badge bg-primary">Débito</span>' : 
                    '<span class="badge bg-info">Crédito</span>';
                
                const row = `
                    <tr>
                        <td>${codigo.ID}</td>
                        <td>${crearChipRubroInteligente(codigo.CodigoRubro, codigo.DescripcionRubro)}</td>
                        <td><strong>${codigo.CodigoTransaccion}</strong></td>
                        <td>${codigo.Descripcion}</td>
                        <td>${tipoBadge}</td>
                        <td>${codigo.CuentaContable || '-'}</td>
                        <td>${estadoBadge}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="editarCodigoTransaccion(${codigo.ID})" title="Editar">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarCodigoTransaccion(${codigo.ID})" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        }

        function limpiarFiltros() {
            $('#ddlFiltroRubro').val('');
            $('#txtFiltroCodigo').val('');
            $('#txtFiltroDescripcion').val('');
            $('#ddlFiltroEstado').val('');
            cargarCodigosTransaccion();
        }

        function abrirModalCodigoTransaccion() {
            // Limpiar formulario
            limpiarFormularioCodigoTransaccion();
            
            // Cambiar título del modal
            $('#modalCodigoTransaccionLabel').html('<i class="fas fa-exchange-alt me-2"></i>Nuevo Código de Transacción');
            
            // Mostrar modal
            const modal = new bootstrap.Modal(document.getElementById('modalCodigoTransaccion'));
            modal.show();
        }

        function editarCodigoTransaccion(id) {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerCodigoTransaccion",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ id: id }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const codigo = JSON.parse(response.d.Datos);
                        llenarFormularioCodigoTransaccion(codigo);
                        $('#modalCodigoTransaccionLabel').html('<i class="fas fa-exchange-alt me-2"></i>Editar Código de Transacción');
                        
                        // Mostrar modal
                        const modal = new bootstrap.Modal(document.getElementById('modalCodigoTransaccion'));
                        modal.show();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar datos');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar datos del código de transacción');
                }
            });
        }

        function llenarFormularioCodigoTransaccion(codigo) {
            console.log('📝 Llenando formulario con código:', codigo);
            
            // Verificar que los elementos existen antes de llenarlos
            if ($('#txtCodigoTransaccionID').length > 0) {
                $('#txtCodigoTransaccionID').val(codigo.ID);
                console.log('✅ ID establecido:', codigo.ID);
            }
            if ($('#ddlCodigoRubro').length > 0) {
                $('#ddlCodigoRubro').val(codigo.CodigoRubro);
                console.log('✅ Rubro establecido:', codigo.CodigoRubro, 'Valor actual del dropdown:', $('#ddlCodigoRubro').val());
            }
            if ($('#txtCodigoTransaccion').length > 0) {
                $('#txtCodigoTransaccion').val(codigo.CodigoTransaccion);
                console.log('✅ Código transacción establecido:', codigo.CodigoTransaccion);
            }
            if ($('#txtDescripcion').length > 0) {
                $('#txtDescripcion').val(codigo.Descripcion);
                console.log('✅ Descripción establecida:', codigo.Descripcion);
            }
            if ($('#ddlDebCred').length > 0) {
                $('#ddlDebCred').val(codigo.DebCred);
                console.log('✅ Débito/Crédito establecido:', codigo.DebCred);
            }
            if ($('#txtCuentaContable').length > 0) {
                $('#txtCuentaContable').val(codigo.CuentaContable);
                console.log('✅ Cuenta contable establecida:', codigo.CuentaContable);
            }
            if ($('#chkSnActivo').length > 0) {
                $('#chkSnActivo').prop('checked', codigo.SnActivo);
                console.log('✅ Estado activo establecido:', codigo.SnActivo);
            }
        }

        function limpiarFormularioCodigoTransaccion() {
            // Verificar que el formulario existe antes de hacer reset
            if ($('#formCodigoTransaccion').length > 0) {
                $('#formCodigoTransaccion')[0].reset();
            }
            $('#txtCodigoTransaccionID').val('0');
            $('#ddlCodigoRubro').val('');
            $('#chkSnActivo').prop('checked', true);
        }

        function guardarCodigoTransaccion() {
            if (!validarFormularioCodigoTransaccion()) {
                return;
            }
            
            // Obtener valores del formulario
            const codigoRubro = $('#ddlCodigoRubro').val();
            const codigoTransaccion = $('#txtCodigoTransaccion').val();
            const descripcion = $('#txtDescripcion').val();
            const debCred = $('#ddlDebCred').val();
            const cuentaContable = $('#txtCuentaContable').val();
            const snActivo = $('#chkSnActivo').is(':checked');
            
            console.log('🔍 Datos a enviar:', {
                CodigoRubro: codigoRubro,
                CodigoTransaccion: codigoTransaccion,
                Descripcion: descripcion,
                DebCred: debCred,
                CuentaContable: cuentaContable,
                SnActivo: snActivo
            });
            
            const codigoData = {
                ID: parseInt($('#txtCodigoTransaccionID').val()) || 0,
                CodigoRubro: codigoRubro,
                CodigoTransaccion: codigoTransaccion,
                Descripcion: descripcion,
                DebCred: debCred,
                CuentaContable: cuentaContable,
                SnActivo: snActivo
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/GuardarCodigoTransaccion",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ codigoData: codigoData }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', response.d.Mensaje);
                        $('#modalCodigoTransaccion').modal('hide');
                        cargarCodigosTransaccion();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al guardar código de transacción');
                }
            });
        }

        function validarFormularioCodigoTransaccion() {
            let valido = true;
            
            // Limpiar validaciones anteriores
            $('.form-control, .form-select').removeClass('is-invalid');
            
            // Validar campos requeridos
            if (!$('#ddlCodigoRubro').val()) {
                $('#ddlCodigoRubro').addClass('is-invalid');
                valido = false;
            }
            
            if (!$('#txtCodigoTransaccion').val()) {
                $('#txtCodigoTransaccion').addClass('is-invalid');
                valido = false;
            }
            
            if (!$('#txtDescripcion').val()) {
                $('#txtDescripcion').addClass('is-invalid');
                valido = false;
            }
            
            if (!$('#ddlDebCred').val()) {
                $('#ddlDebCred').addClass('is-invalid');
                valido = false;
            }
            
            if (!valido) {
                showToast('warning', 'Validación', 'Por favor complete todos los campos requeridos');
            }
            
            return valido;
        }

        function eliminarCodigoTransaccion(id) {
            mostrarConfirmEliminar('Código de Transacción', function() {
                $.ajax({
                    type: "POST",
                    url: "Mantenimientos.aspx/EliminarCodigoTransaccion",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            showToast('success', 'Éxito', response.d.Mensaje);
                            cargarCodigosTransaccion();
                        } else {
                            showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
                        }
                    },
                    error: function() {
                        showToast('error', 'Error', 'Error al eliminar código de transacción');
                    }
                });
            });
        }

        // ===== FUNCIONES DE CONFIRMACIÓN PERSONALIZADAS =====
        function mostrarConfirmEliminar(entidad, callback) {
            // Asegurar que los estilos de modales estén disponibles
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
                            backdrop-filter: blur(3px);
                        }
                        
                        .custom-modal {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
                            width: 90%;
                            max-width: 450px;
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
                            background: linear-gradient(135deg, #dc3545, #c82333);
                            color: white;
                            padding: 20px;
                            border-radius: 12px 12px 0 0;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }
                        
                        .custom-modal-header h5 {
                            margin: 0;
                            font-weight: 600;
                            font-size: 18px;
                        }
                        
                        .btn-close-custom {
                            background: rgba(255, 255, 255, 0.2);
                            border: none;
                            color: white;
                            width: 30px;
                            height: 30px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            cursor: pointer;
                            transition: background 0.3s;
                        }
                        
                        .btn-close-custom:hover {
                            background: rgba(255, 255, 255, 0.3);
                        }
                        
                        .custom-modal-body {
                            padding: 25px;
                        }
                        
                        .pregunta-confirm {
                            text-align: center;
                            font-size: 16px;
                            color: #495057;
                            margin-bottom: 15px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 10px;
                        }
                        
                        .pregunta-confirm i {
                            font-size: 24px;
                            color: #dc3545;
                        }
                        
                        .texto-adicional {
                            text-align: center;
                            font-size: 14px;
                            color: #6c757d;
                            font-weight: 500;
                        }
                        
                        .custom-modal-footer {
                            padding: 20px 25px;
                            background: #f8f9fa;
                            border-radius: 0 0 12px 12px;
                            display: flex;
                            gap: 10px;
                            justify-content: flex-end;
                        }
                        
                        .btn-cancel, .btn-confirm {
                            padding: 10px 20px;
                            border-radius: 6px;
                            border: none;
                            font-weight: 500;
                            cursor: pointer;
                            transition: all 0.3s;
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
                            background: #dc3545;
                            color: white;
                        }
                        
                        .btn-confirm:hover {
                            background: #c82333;
                        }
                    </style>
                `);
            }

            const modalHtml = `
                <div id="modalConfirmEliminar" class="custom-modal-overlay">
                    <div class="custom-modal">
                        <div class="custom-modal-header">
                            <h5>Confirmar Eliminación</h5>
                            <button type="button" class="btn-close-custom" onclick="cerrarConfirmEliminarModal()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="custom-modal-body">
                            <div class="pregunta-confirm">
                                <i class="fas fa-exclamation-triangle"></i>
                                ¿Está seguro de eliminar el ${entidad}?
                            </div>
                            <div class="texto-adicional">
                                Esta acción no se puede deshacer.
                            </div>
                        </div>
                        <div class="custom-modal-footer">
                            <button type="button" class="btn btn-cancel" onclick="cerrarConfirmEliminarModal()">
                                <i class="fas fa-times"></i> Cancelar
                            </button>
                            <button type="button" class="btn btn-confirm" onclick="confirmarEliminar()">
                                <i class="fas fa-trash"></i> Eliminar
                            </button>
                        </div>
                    </div>
                </div>
            `;

            // Guardar el callback para usarlo después
            window.confirmEliminarCallback = callback;

            // Agregar el modal al body
            $('body').append(modalHtml);
        }

        function cerrarConfirmEliminarModal() {
            $('#modalConfirmEliminar').remove();
            window.confirmEliminarCallback = null;
        }

        function confirmarEliminar() {
            // Cerrar el modal
            cerrarConfirmEliminarModal();
            
            // Ejecutar el callback si existe
            if (window.confirmEliminarCallback) {
                window.confirmEliminarCallback();
            }
        }

        // ===== FUNCIONALIDAD DEPARTAMENTOS =====
        function inicializarDepartamentos() {
            // Cargar datos iniciales
            cargarDepartamentos();
            
            // Configurar eventos
            configurarEventosDepartamentos();
            
            $('#ddlFiltroEstadoDepartamento').on('change', function() {
                cargarDepartamentos();
            });
        }

        function cargarDepartamentos() {
            const filtros = {
                Nombre: $('#txtFiltroNombreDepartamento').val(),
                Responsable: $('#txtFiltroResponsableDepartamento').val(),
                Activo: $('#ddlFiltroEstadoDepartamento').val() ? $('#ddlFiltroEstadoDepartamento').val() === '1' : null
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarDepartamentos",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: filtros }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const departamentos = JSON.parse(response.d.Datos);
                        mostrarDepartamentos(departamentos);
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar departamentos');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar departamentos');
                }
            });
        }

        function mostrarDepartamentos(departamentos) {
            const tbody = $('#tblDepartamentos tbody');
            tbody.empty();
            
            if (departamentos.length === 0) {
                tbody.append('<tr><td colspan="7" class="text-center text-muted">No hay departamentos disponibles</td></tr>');
                return;
            }
            
            departamentos.forEach(function(departamento) {
                const row = `
                    <tr>
                        <td>${departamento.Nombre}</td>
                        <td>${departamento.Descripcion || '-'}</td>
                        <td>${departamento.Responsable || '-'}</td>
                        <td>${departamento.Telefono || '-'}</td>
                        <td>${departamento.Email || '-'}</td>
                        <td>
                            <span class="badge ${departamento.Activo ? 'bg-success' : 'bg-danger'}">
                                ${departamento.DescripcionEstado}
                            </span>
                        </td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarDepartamento(${departamento.Id})" title="Editar">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarDepartamento(${departamento.Id})" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        }

        function limpiarFiltrosDepartamento() {
            $('#txtFiltroNombreDepartamento').val('');
            $('#txtFiltroResponsableDepartamento').val('');
            $('#ddlFiltroEstadoDepartamento').val('');
            cargarDepartamentos();
        }

        function abrirModalDepartamento() {
            // Limpiar formulario
            limpiarFormularioDepartamento();
            
            // Cambiar título del modal
            $('#modalDepartamentoLabel').html('<i class="fas fa-building me-2"></i>Nuevo Departamento');
            
            // Mostrar modal
            const modal = new bootstrap.Modal(document.getElementById('modalDepartamento'));
            modal.show();
        }

        function editarDepartamento(id) {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerDepartamento",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ id: id }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const departamento = JSON.parse(response.d.Datos);
                        llenarFormularioDepartamento(departamento);
                        $('#modalDepartamentoLabel').html('<i class="fas fa-building me-2"></i>Editar Departamento');
                        
                        // Mostrar modal
                        const modal = new bootstrap.Modal(document.getElementById('modalDepartamento'));
                        modal.show();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar datos');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar datos del departamento');
                }
            });
        }

        function llenarFormularioDepartamento(departamento) {
            console.log('📝 Llenando formulario con departamento:', departamento);
            
            // Verificar que los elementos existen antes de llenarlos
            if ($('#txtDepartamentoID').length > 0) {
                $('#txtDepartamentoID').val(departamento.Id);
                console.log('✅ ID establecido:', departamento.Id);
            }
            if ($('#txtNombreDepartamento').length > 0) {
                $('#txtNombreDepartamento').val(departamento.Nombre);
                console.log('✅ Nombre establecido:', departamento.Nombre);
            }
            if ($('#txtDescripcionDepartamento').length > 0) {
                $('#txtDescripcionDepartamento').val(departamento.Descripcion);
                console.log('✅ Descripción establecida:', departamento.Descripcion);
            }
            if ($('#txtResponsableDepartamento').length > 0) {
                $('#txtResponsableDepartamento').val(departamento.Responsable);
                console.log('✅ Responsable establecido:', departamento.Responsable);
            }
            if ($('#txtTelefonoDepartamento').length > 0) {
                $('#txtTelefonoDepartamento').val(departamento.Telefono);
                console.log('✅ Teléfono establecido:', departamento.Telefono);
            }
            if ($('#txtEmailDepartamento').length > 0) {
                $('#txtEmailDepartamento').val(departamento.Email);
                console.log('✅ Email establecido:', departamento.Email);
            }
            if ($('#chkActivoDepartamento').length > 0) {
                $('#chkActivoDepartamento').prop('checked', departamento.Activo);
                console.log('✅ Estado activo establecido:', departamento.Activo);
            }
        }

        function limpiarFormularioDepartamento() {
            // Verificar que el formulario existe antes de hacer reset
            if ($('#formDepartamento').length > 0) {
                $('#formDepartamento')[0].reset();
            }
            $('#txtDepartamentoID').val('0');
            $('#chkActivoDepartamento').prop('checked', true);
        }

        function guardarDepartamento() {
            if (!validarFormularioDepartamento()) {
                return;
            }
            
            // Obtener valores del formulario
            const nombre = $('#txtNombreDepartamento').val();
            const descripcion = $('#txtDescripcionDepartamento').val();
            const responsable = $('#txtResponsableDepartamento').val();
            const telefono = $('#txtTelefonoDepartamento').val();
            const email = $('#txtEmailDepartamento').val();
            const activo = $('#chkActivoDepartamento').is(':checked');
            
            console.log('🔍 Datos a enviar:', {
                Nombre: nombre,
                Descripcion: descripcion,
                Responsable: responsable,
                Telefono: telefono,
                Email: email,
                Activo: activo
            });
            
            const departamentoData = {
                Id: parseInt($('#txtDepartamentoID').val()) || 0,
                Nombre: nombre,
                Descripcion: descripcion,
                Responsable: responsable,
                Telefono: telefono,
                Email: email,
                Activo: activo
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/GuardarDepartamento",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ departamentoData: departamentoData }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', response.d.Mensaje);
                        $('#modalDepartamento').modal('hide');
                        cargarDepartamentos();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al guardar departamento');
                }
            });
        }

        function validarFormularioDepartamento() {
            let esValido = true;
            
            // Limpiar mensajes de error previos
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').remove();
            
            // Validar nombre (requerido)
            if (!$('#txtNombreDepartamento').val().trim()) {
                $('#txtNombreDepartamento').addClass('is-invalid');
                $('#txtNombreDepartamento').after('<div class="invalid-feedback">El nombre es requerido</div>');
                esValido = false;
            }
            
            // Validar email si se proporciona
            const email = $('#txtEmailDepartamento').val().trim();
            if (email && !isValidEmail(email)) {
                $('#txtEmailDepartamento').addClass('is-invalid');
                $('#txtEmailDepartamento').after('<div class="invalid-feedback">El formato del email no es válido</div>');
                esValido = false;
            }
            
            return esValido;
        }

        function eliminarDepartamento(id) {
            mostrarConfirmEliminar('Departamento', function() {
                $.ajax({
                    type: "POST",
                    url: "Mantenimientos.aspx/EliminarDepartamento",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            showToast('success', 'Éxito', response.d.Mensaje);
                            cargarDepartamentos();
                        } else {
                            showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
                        }
                    },
                    error: function() {
                        showToast('error', 'Error', 'Error al eliminar departamento');
                    }
                });
            });
        }

        // ===== FUNCIONALIDAD PARENTEZCOS =====
        function inicializarParentezcos() {
            // Cargar datos iniciales
            cargarParentezcos();
            
            // Configurar eventos
            configurarEventosParentezcos();
        }

        function cargarParentezcos() {
            const filtros = {
                Parentezco: $('#txtFiltroParentezco').val()
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarParentezcos",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: filtros }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const parentezcos = JSON.parse(response.d.Datos);
                        mostrarParentezcos(parentezcos);
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar parentezcos');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar parentezcos');
                }
            });
        }

        function mostrarParentezcos(parentezcos) {
            const tbody = $('#tblParentezcos tbody');
            tbody.empty();
            
            if (parentezcos.length === 0) {
                tbody.append('<tr><td colspan="2" class="text-center text-muted">No hay parentezcos disponibles</td></tr>');
                return;
            }
            
            parentezcos.forEach(function(parentezco) {
                const row = `
                    <tr>
                        <td>${parentezco.Parentezco}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarParentezco(${parentezco.IDParentezco})" title="Editar">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarParentezco(${parentezco.IDParentezco})" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        }

        function limpiarFiltrosParentezco() {
            $('#txtFiltroParentezco').val('');
            cargarParentezcos();
        }

        function abrirModalParentezco() {
            // Limpiar formulario
            limpiarFormularioParentezco();
            
            // Cambiar título del modal
            $('#modalParentezcoLabel').html('<i class="fas fa-users me-2"></i>Nuevo Parentezco');
            
            // Mostrar modal
            const modal = new bootstrap.Modal(document.getElementById('modalParentezco'));
            modal.show();
        }

        function editarParentezco(id) {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerParentezco",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ id: id }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const parentezco = JSON.parse(response.d.Datos);
                        llenarFormularioParentezco(parentezco);
                        $('#modalParentezcoLabel').html('<i class="fas fa-users me-2"></i>Editar Parentezco');
                        
                        // Mostrar modal
                        const modal = new bootstrap.Modal(document.getElementById('modalParentezco'));
                        modal.show();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar datos');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar datos del parentezco');
                }
            });
        }

        function llenarFormularioParentezco(parentezco) {
            console.log('📝 Llenando formulario con parentezco:', parentezco);
            
            // Verificar que los elementos existen antes de llenarlos
            if ($('#txtParentezcoID').length > 0) {
                $('#txtParentezcoID').val(parentezco.IDParentezco);
                console.log('✅ ID establecido:', parentezco.IDParentezco);
            }
            if ($('#txtParentezco').length > 0) {
                $('#txtParentezco').val(parentezco.Parentezco);
                console.log('✅ Parentezco establecido:', parentezco.Parentezco);
            }
        }

        function limpiarFormularioParentezco() {
            // Verificar que el formulario existe antes de hacer reset
            if ($('#formParentezco').length > 0) {
                $('#formParentezco')[0].reset();
            }
            $('#txtParentezcoID').val('0');
        }

        function guardarParentezco() {
            if (!validarFormularioParentezco()) {
                return;
            }
            
            // Obtener valores del formulario
            const parentezco = $('#txtParentezco').val();
            
            console.log('🔍 Datos a enviar:', {
                Parentezco: parentezco
            });
            
            const parentezcoData = {
                IDParentezco: parseInt($('#txtParentezcoID').val()) || 0,
                Parentezco: parentezco
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/GuardarParentezco",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ parentezcoData: parentezcoData }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', response.d.Mensaje);
                        $('#modalParentezco').modal('hide');
                        cargarParentezcos();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al guardar parentezco');
                }
            });
        }

        function validarFormularioParentezco() {
            let esValido = true;
            
            // Limpiar mensajes de error previos
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').remove();
            
            // Validar parentezco (requerido)
            if (!$('#txtParentezco').val().trim()) {
                $('#txtParentezco').addClass('is-invalid');
                $('#txtParentezco').after('<div class="invalid-feedback">El parentezco es requerido</div>');
                esValido = false;
            }
            
            return esValido;
        }

        function eliminarParentezco(id) {
            mostrarConfirmEliminar('Parentezco', function() {
                $.ajax({
                    type: "POST",
                    url: "Mantenimientos.aspx/EliminarParentezco",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            showToast('success', 'Éxito', response.d.Mensaje);
                            cargarParentezcos();
                        } else {
                            showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
                        }
                    },
                    error: function() {
                        showToast('error', 'Error', 'Error al eliminar parentezco');
                    }
                });
            });
        }

        // ===== FUNCIONALIDAD ROLES =====
        function inicializarRoles() {
            // Cargar datos iniciales
            cargarRoles();
            
            // Configurar eventos
            configurarEventosRoles();
            
            $('#ddlFiltroNivelAcceso, #ddlFiltroEstadoRol').on('change', function() {
                cargarRoles();
            });
        }

        function cargarRoles() {
            const filtros = {
                Nombre: $('#txtFiltroNombreRol').val(),
                NivelAcceso: $('#ddlFiltroNivelAcceso').val() ? parseInt($('#ddlFiltroNivelAcceso').val()) : null,
                Activo: $('#ddlFiltroEstadoRol').val() ? $('#ddlFiltroEstadoRol').val() === '1' : null
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarRoles",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: filtros }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const roles = JSON.parse(response.d.Datos);
                        mostrarRoles(roles);
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar roles');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar roles');
                }
            });
        }

        function mostrarRoles(roles) {
            const tbody = $('#tblRoles tbody');
            tbody.empty();
            
            if (roles.length === 0) {
                tbody.append('<tr><td colspan="5" class="text-center text-muted">No hay roles disponibles</td></tr>');
                return;
            }
            
            roles.forEach(function(rol) {
                const nivelBadge = getNivelAccesoBadge(rol.NivelAcceso);
                const estadoBadge = rol.Activo ? 'bg-success' : 'bg-danger';
                
                const row = `
                    <tr>
                        <td>${rol.Nombre}</td>
                        <td>${rol.Descripcion || '-'}</td>
                        <td>${nivelBadge}</td>
                        <td>
                            <span class="badge ${estadoBadge}">
                                ${rol.DescripcionEstado}
                            </span>
                        </td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarRol(${rol.Id})" title="Editar">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarRol(${rol.Id})" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        }

        function getNivelAccesoBadge(nivelAcceso) {
            switch(nivelAcceso) {
                case 0:
                    return '<span class="badge bg-danger">Super Usuario</span>';
                case 1:
                    return '<span class="badge bg-warning">Administrador</span>';
                case 2:
                    return '<span class="badge bg-info">Agente</span>';
                default:
                    return '<span class="badge bg-secondary">Desconocido</span>';
            }
        }

        function limpiarFiltrosRol() {
            $('#txtFiltroNombreRol').val('');
            $('#ddlFiltroNivelAcceso').val('');
            $('#ddlFiltroEstadoRol').val('');
            cargarRoles();
        }

        function abrirModalRol() {
            // Limpiar formulario
            limpiarFormularioRol();
            
            // Cambiar título del modal
            $('#modalRolLabel').html('<i class="fas fa-user-shield me-2"></i>Nuevo Rol');
            
            // Mostrar modal
            const modal = new bootstrap.Modal(document.getElementById('modalRol'));
            modal.show();
        }

        function editarRol(id) {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerRol",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ id: id }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const rol = JSON.parse(response.d.Datos);
                        llenarFormularioRol(rol);
                        $('#modalRolLabel').html('<i class="fas fa-user-shield me-2"></i>Editar Rol');
                        
                        // Mostrar modal
                        const modal = new bootstrap.Modal(document.getElementById('modalRol'));
                        modal.show();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar datos');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar datos del rol');
                }
            });
        }

        function llenarFormularioRol(rol) {
            console.log('📝 Llenando formulario con rol:', rol);
            
            // Verificar que los elementos existen antes de llenarlos
            if ($('#txtRolID').length > 0) {
                $('#txtRolID').val(rol.Id);
                console.log('✅ ID establecido:', rol.Id);
            }
            if ($('#txtNombreRol').length > 0) {
                $('#txtNombreRol').val(rol.Nombre);
                console.log('✅ Nombre establecido:', rol.Nombre);
            }
            if ($('#txtDescripcionRol').length > 0) {
                $('#txtDescripcionRol').val(rol.Descripcion);
                console.log('✅ Descripción establecida:', rol.Descripcion);
            }
            if ($('#ddlNivelAcceso').length > 0) {
                $('#ddlNivelAcceso').val(rol.NivelAcceso);
                console.log('✅ Nivel de acceso establecido:', rol.NivelAcceso);
            }
            if ($('#chkActivoRol').length > 0) {
                $('#chkActivoRol').prop('checked', rol.Activo);
                console.log('✅ Estado activo establecido:', rol.Activo);
            }
        }

        function limpiarFormularioRol() {
            // Verificar que el formulario existe antes de hacer reset
            if ($('#formRol').length > 0) {
                $('#formRol')[0].reset();
            }
            $('#txtRolID').val('0');
            $('#ddlNivelAcceso').val('');
            $('#chkActivoRol').prop('checked', true);
        }

        function guardarRol() {
            if (!validarFormularioRol()) {
                return;
            }
            
            // Obtener valores del formulario
            const nombre = $('#txtNombreRol').val();
            const descripcion = $('#txtDescripcionRol').val();
            const nivelAcceso = parseInt($('#ddlNivelAcceso').val());
            const activo = $('#chkActivoRol').is(':checked');
            
            console.log('🔍 Datos a enviar:', {
                Nombre: nombre,
                Descripcion: descripcion,
                NivelAcceso: nivelAcceso,
                Activo: activo
            });
            
            const rolData = {
                Id: parseInt($('#txtRolID').val()) || 0,
                Nombre: nombre,
                Descripcion: descripcion,
                NivelAcceso: nivelAcceso,
                Activo: activo
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/GuardarRol",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ rolData: rolData }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', response.d.Mensaje);
                        $('#modalRol').modal('hide');
                        cargarRoles();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al guardar rol');
                }
            });
        }

        function validarFormularioRol() {
            let esValido = true;
            
            // Limpiar mensajes de error previos
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').remove();
            
            // Validar nombre (requerido)
            if (!$('#txtNombreRol').val().trim()) {
                $('#txtNombreRol').addClass('is-invalid');
                $('#txtNombreRol').after('<div class="invalid-feedback">El nombre es requerido</div>');
                esValido = false;
            }
            
            // Validar nivel de acceso (requerido)
            if (!$('#ddlNivelAcceso').val()) {
                $('#ddlNivelAcceso').addClass('is-invalid');
                $('#ddlNivelAcceso').after('<div class="invalid-feedback">El nivel de acceso es requerido</div>');
                esValido = false;
            }
            
            return esValido;
        }

        function eliminarRol(id) {
            mostrarConfirmEliminar('Rol', function() {
                $.ajax({
                    type: "POST",
                    url: "Mantenimientos.aspx/EliminarRol",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            showToast('success', 'Éxito', response.d.Mensaje);
                            cargarRoles();
                        } else {
                            showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
                        }
                    },
                    error: function() {
                        showToast('error', 'Error', 'Error al eliminar rol');
                    }
                });
            });
        }

        // ===== FUNCIONALIDAD RUBROS =====
        function inicializarRubros() {
            // Cargar datos iniciales
            cargarRubrosTab();
            
            // Configurar eventos
            configurarEventosRubros();
        }

        function cargarRubrosTab() {
            const filtros = {
                CodigoRubro: $('#txtFiltroCodigoRubro').val(),
                Descripcion: $('#txtFiltroDescripcionRubro').val()
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarRubros",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: filtros }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const rubros = JSON.parse(response.d.Datos);
                        mostrarRubros(rubros);
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar rubros');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar rubros');
                }
            });
        }

        function mostrarRubros(rubros) {
            const tbody = $('#tblRubros tbody');
            tbody.empty();
            
            if (rubros.length === 0) {
                tbody.append('<tr><td colspan="2" class="text-center text-muted">No hay rubros disponibles</td></tr>');
                return;
            }
            
            rubros.forEach(function(rubro) {
                const row = `
                    <tr>
                        <td>${crearChipRubroInteligente(rubro.CodigoRubro, rubro.Descripcion)}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarRubro(${rubro.IDRubro})" title="Editar">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarRubro(${rubro.IDRubro})" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        }

        function limpiarFiltrosRubro() {
            $('#txtFiltroCodigoRubro').val('');
            $('#txtFiltroDescripcionRubro').val('');
            cargarRubrosTab();
        }

        function abrirModalRubro() {
            // Limpiar formulario
            limpiarFormularioRubro();
            
            // Cambiar título del modal
            $('#modalRubroLabel').html('<i class="fas fa-tags me-2"></i>Nuevo Rubro');
            
            // Mostrar modal
            const modal = new bootstrap.Modal(document.getElementById('modalRubro'));
            modal.show();
        }

        function editarRubro(id) {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerRubro",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ id: id }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const rubro = JSON.parse(response.d.Datos);
                        llenarFormularioRubro(rubro);
                        $('#modalRubroLabel').html('<i class="fas fa-tags me-2"></i>Editar Rubro');
                        
                        // Mostrar modal
                        const modal = new bootstrap.Modal(document.getElementById('modalRubro'));
                        modal.show();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar datos');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar datos del rubro');
                }
            });
        }

        function llenarFormularioRubro(rubro) {
            console.log('📝 Llenando formulario con rubro:', rubro);
            
            // Verificar que los elementos existen antes de llenarlos
            if ($('#txtRubroID').length > 0) {
                $('#txtRubroID').val(rubro.IDRubro);
                console.log('✅ ID establecido:', rubro.IDRubro);
            }
            if ($('#txtCodigoRubro').length > 0) {
                $('#txtCodigoRubro').val(rubro.CodigoRubro);
                console.log('✅ Código establecido:', rubro.CodigoRubro);
            }
            if ($('#txtDescripcionRubro').length > 0) {
                $('#txtDescripcionRubro').val(rubro.Descripcion);
                console.log('✅ Descripción establecida:', rubro.Descripcion);
            }
        }

        function limpiarFormularioRubro() {
            // Verificar que el formulario existe antes de hacer reset
            if ($('#formRubro').length > 0) {
                $('#formRubro')[0].reset();
            }
            $('#txtRubroID').val('0');
        }

        function guardarRubro() {
            if (!validarFormularioRubro()) {
                return;
            }
            
            // Obtener valores del formulario
            const codigoRubro = $('#txtCodigoRubro').val();
            const descripcion = $('#txtDescripcionRubro').val();
            
            console.log('🔍 Datos a enviar:', {
                CodigoRubro: codigoRubro,
                Descripcion: descripcion
            });
            
            const rubroData = {
                IDRubro: parseInt($('#txtRubroID').val()) || 0,
                CodigoRubro: codigoRubro,
                Descripcion: descripcion
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/GuardarRubro",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ rubroData: rubroData }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', response.d.Mensaje);
                        $('#modalRubro').modal('hide');
                        cargarRubrosTab();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al guardar rubro');
                }
            });
        }

        function validarFormularioRubro() {
            let esValido = true;
            
            // Limpiar mensajes de error previos
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').remove();
            
            // Validar código (requerido)
            if (!$('#txtCodigoRubro').val().trim()) {
                $('#txtCodigoRubro').addClass('is-invalid');
                $('#txtCodigoRubro').after('<div class="invalid-feedback">El código es requerido</div>');
                esValido = false;
            }
            
            // Validar descripción (requerido)
            if (!$('#txtDescripcionRubro').val().trim()) {
                $('#txtDescripcionRubro').addClass('is-invalid');
                $('#txtDescripcionRubro').after('<div class="invalid-feedback">La descripción es requerida</div>');
                esValido = false;
            }
            
            return esValido;
        }

        function eliminarRubro(id) {
            mostrarConfirmEliminar('Rubro', function() {
                $.ajax({
                    type: "POST",
                    url: "Mantenimientos.aspx/EliminarRubro",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            showToast('success', 'Éxito', response.d.Mensaje);
                            cargarRubrosTab();
                        } else {
                            showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
                        }
                    },
                    error: function() {
                        showToast('error', 'Error', 'Error al eliminar rubro');
                    }
                });
            });
        }

        // ===== FUNCIONALIDAD ESTATUS ASOCIADOS =====
        function inicializarStatusAsociados() {
            // Cargar datos iniciales
            cargarStatusAsociados();
            
            // Configurar eventos
            configurarEventosStatusAsociados();
        }

        function cargarStatusAsociados() {
            const filtros = {
                CodStatusAsociado: $('#txtFiltroCodigoStatus').val(),
                StatusAsociado: $('#txtFiltroDescripcionStatus').val()
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarStatusAsociados",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: filtros }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const statusList = JSON.parse(response.d.Datos);
                        mostrarStatusAsociados(statusList);
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar estatus');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar estatus');
                }
            });
        }

        function mostrarStatusAsociados(statusList) {
            const tbody = $('#tblStatus tbody');
            tbody.empty();
            
            if (statusList.length === 0) {
                tbody.append('<tr><td colspan="3" class="text-center text-muted">No hay estatus disponibles</td></tr>');
                return;
            }
            
            statusList.forEach(function(status) {
                const statusChip = getStatusChip(status.CodStatusAsociado, status.StatusAsociado);
                const row = `
                    <tr>
                        <td>${statusChip}</td>
                        <td>${status.StatusAsociado}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarStatus(${status.IDStatus})" title="Editar">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarStatus(${status.IDStatus})" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        }

        function getStatusChip(codigo, descripcion) {
            // Mapeo de códigos a iconos y estilos
            const statusConfig = {
                'A': { icon: 'fa-check-circle' },
                'I': { icon: 'fa-times-circle' },
                'S': { icon: 'fa-pause-circle' },
                'U': { icon: 'fa-question-circle' }
            };
            
            const config = statusConfig[codigo] || { icon: 'fa-circle' };
            
            return `
                <span class="status-chip status-${codigo}">
                    <i class="fas ${config.icon} icon"></i>${codigo}
                </span>
            `;
        }

        function limpiarFiltrosStatus() {
            $('#txtFiltroCodigoStatus').val('');
            $('#txtFiltroDescripcionStatus').val('');
            cargarStatusAsociados();
        }

        function abrirModalStatus() {
            // Limpiar formulario
            limpiarFormularioStatus();
            
            // Cambiar título del modal
            $('#modalStatusLabel').html('<i class="fas fa-user-check me-2"></i>Nuevo Estatus');
            
            // Mostrar modal
            const modal = new bootstrap.Modal(document.getElementById('modalStatus'));
            modal.show();
        }

        function editarStatus(id) {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerStatusAsociado",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ id: id }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const status = JSON.parse(response.d.Datos);
                        llenarFormularioStatus(status);
                        $('#modalStatusLabel').html('<i class="fas fa-user-check me-2"></i>Editar Estatus');
                        
                        // Mostrar modal
                        const modal = new bootstrap.Modal(document.getElementById('modalStatus'));
                        modal.show();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar datos');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar datos del estatus');
                }
            });
        }

        function llenarFormularioStatus(status) {
            console.log('📝 Llenando formulario con estatus:', status);
            
            // Verificar que los elementos existen antes de llenarlos
            if ($('#txtStatusID').length > 0) {
                $('#txtStatusID').val(status.IDStatus);
                console.log('✅ ID establecido:', status.IDStatus);
            }
            if ($('#txtCodigoStatus').length > 0) {
                $('#txtCodigoStatus').val(status.CodStatusAsociado);
                console.log('✅ Código establecido:', status.CodStatusAsociado);
            }
            if ($('#txtDescripcionStatus').length > 0) {
                $('#txtDescripcionStatus').val(status.StatusAsociado);
                console.log('✅ Descripción establecida:', status.StatusAsociado);
            }
        }

        function limpiarFormularioStatus() {
            // Verificar que el formulario existe antes de hacer reset
            if ($('#formStatus').length > 0) {
                $('#formStatus')[0].reset();
            }
            $('#txtStatusID').val('0');
        }

        function guardarStatus() {
            if (!validarFormularioStatus()) {
                return;
            }
            
            // Obtener valores del formulario
            const codigoStatus = $('#txtCodigoStatus').val();
            const descripcionStatus = $('#txtDescripcionStatus').val();
            
            console.log('🔍 Datos a enviar:', {
                CodStatusAsociado: codigoStatus,
                StatusAsociado: descripcionStatus
            });
            
            const statusData = {
                IDStatus: parseInt($('#txtStatusID').val()) || 0,
                CodStatusAsociado: codigoStatus,
                StatusAsociado: descripcionStatus
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/GuardarStatusAsociado",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ statusData: statusData }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', response.d.Mensaje);
                        $('#modalStatus').modal('hide');
                        cargarStatusAsociados();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al guardar estatus');
                }
            });
        }

        function validarFormularioStatus() {
            let esValido = true;
            
            // Limpiar mensajes de error previos
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').remove();
            
            // Validar código (requerido, exactamente 1 carácter)
            const codigo = $('#txtCodigoStatus').val().trim();
            if (!codigo) {
                $('#txtCodigoStatus').addClass('is-invalid');
                $('#txtCodigoStatus').after('<div class="invalid-feedback">El código es requerido</div>');
                esValido = false;
            } else if (codigo.length !== 1) {
                $('#txtCodigoStatus').addClass('is-invalid');
                $('#txtCodigoStatus').after('<div class="invalid-feedback">El código debe ser exactamente un carácter</div>');
                esValido = false;
            }
            
            // Validar descripción (requerido)
            if (!$('#txtDescripcionStatus').val().trim()) {
                $('#txtDescripcionStatus').addClass('is-invalid');
                $('#txtDescripcionStatus').after('<div class="invalid-feedback">La descripción es requerida</div>');
                esValido = false;
            }
            
            return esValido;
        }

        function eliminarStatus(id) {
            mostrarConfirmEliminar('Estatus', function() {
                $.ajax({
                    type: "POST",
                    url: "Mantenimientos.aspx/EliminarStatusAsociado",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            showToast('success', 'Éxito', response.d.Mensaje);
                            cargarStatusAsociados();
                        } else {
                            showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
                        }
                    },
                    error: function() {
                        showToast('error', 'Error', 'Error al eliminar estatus');
                    }
                });
            });
        }

        // ===== FUNCIONALIDAD TIPO ASOCIADO =====
        function inicializarTipoAsociados() {
            // Cargar datos iniciales
            cargarTipoAsociados();
            
            // Configurar eventos
            configurarEventosTipoAsociados();
        }

        function cargarTipoAsociados() {
            const filtros = {
                CodTipoAsociado: $('#txtFiltroCodigoTipoAsociado').val(),
                TipoAsociado: $('#txtFiltroTipoAsociado').val()
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarTipoAsociados",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: filtros }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const tipoAsociados = JSON.parse(response.d.Datos);
                        mostrarTipoAsociados(tipoAsociados);
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar tipos de asociado');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar tipos de asociado');
                }
            });
        }

        function mostrarTipoAsociados(tipoAsociados) {
            const tbody = $('#tblTipoAsociado tbody');
            tbody.empty();
            
            if (tipoAsociados.length === 0) {
                tbody.append('<tr><td colspan="3" class="text-center text-muted">No hay tipos de asociado disponibles</td></tr>');
                return;
            }
            
            tipoAsociados.forEach(function(tipoAsociado) {
                const row = `
                    <tr>
                        <td><span class="badge bg-info">${tipoAsociado.CodTipoAsociado}</span></td>
                        <td>${tipoAsociado.TipoAsociado}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarTipoAsociado(${tipoAsociado.IdTipoAsociado})" title="Editar">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarTipoAsociado(${tipoAsociado.IdTipoAsociado})" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        }

        function limpiarFiltrosTipoAsociado() {
            $('#txtFiltroCodigoTipoAsociado').val('');
            $('#txtFiltroTipoAsociado').val('');
            cargarTipoAsociados();
        }

        function abrirModalTipoAsociado() {
            // Limpiar formulario
            limpiarFormularioTipoAsociado();
            
            // Cambiar título del modal
            $('#modalTipoAsociadoLabel').html('<i class="fas fa-users me-2"></i>Nuevo Tipo Asociado');
            
            // Mostrar modal
            const modal = new bootstrap.Modal(document.getElementById('modalTipoAsociado'));
            modal.show();
        }

        function editarTipoAsociado(id) {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerTipoAsociado",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ id: id }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const tipoAsociado = JSON.parse(response.d.Datos);
                        llenarFormularioTipoAsociado(tipoAsociado);
                        $('#modalTipoAsociadoLabel').html('<i class="fas fa-users me-2"></i>Editar Tipo Asociado');
                        
                        // Mostrar modal
                        const modal = new bootstrap.Modal(document.getElementById('modalTipoAsociado'));
                        modal.show();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar datos');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar datos del tipo de asociado');
                }
            });
        }

        function llenarFormularioTipoAsociado(tipoAsociado) {
            console.log('📝 Llenando formulario con tipo de asociado:', tipoAsociado);
            
            // Verificar que los elementos existen antes de llenarlos
            if ($('#txtTipoAsociadoID').length > 0) {
                $('#txtTipoAsociadoID').val(tipoAsociado.IdTipoAsociado);
                console.log('✅ ID establecido:', tipoAsociado.IdTipoAsociado);
            }
            if ($('#txtCodigoTipoAsociado').length > 0) {
                $('#txtCodigoTipoAsociado').val(tipoAsociado.CodTipoAsociado);
                console.log('✅ Código establecido:', tipoAsociado.CodTipoAsociado);
            }
            if ($('#txtTipoAsociado').length > 0) {
                $('#txtTipoAsociado').val(tipoAsociado.TipoAsociado);
                console.log('✅ Tipo establecido:', tipoAsociado.TipoAsociado);
            }
        }

        function limpiarFormularioTipoAsociado() {
            // Verificar que el formulario existe antes de hacer reset
            if ($('#formTipoAsociado').length > 0) {
                $('#formTipoAsociado')[0].reset();
            }
            $('#txtTipoAsociadoID').val('0');
        }

        function guardarTipoAsociado() {
            if (!validarFormularioTipoAsociado()) {
                return;
            }
            
            // Obtener valores del formulario
            const codigoTipoAsociado = $('#txtCodigoTipoAsociado').val();
            const tipoAsociado = $('#txtTipoAsociado').val();
            
            console.log('🔍 Datos a enviar:', {
                CodTipoAsociado: codigoTipoAsociado,
                TipoAsociado: tipoAsociado
            });
            
            const tipoAsociadoData = {
                IdTipoAsociado: parseInt($('#txtTipoAsociadoID').val()) || 0,
                CodTipoAsociado: codigoTipoAsociado,
                TipoAsociado: tipoAsociado
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/GuardarTipoAsociado",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ tipoAsociadoData: tipoAsociadoData }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', response.d.Mensaje);
                        $('#modalTipoAsociado').modal('hide');
                        cargarTipoAsociados();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al guardar tipo de asociado');
                }
            });
        }

        function validarFormularioTipoAsociado() {
            let esValido = true;
            
            // Limpiar mensajes de error previos
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').remove();
            
            // Validar código (requerido)
            if (!$('#txtCodigoTipoAsociado').val().trim()) {
                $('#txtCodigoTipoAsociado').addClass('is-invalid');
                $('#txtCodigoTipoAsociado').after('<div class="invalid-feedback">El código es requerido</div>');
                esValido = false;
            }
            
            // Validar tipo (requerido)
            if (!$('#txtTipoAsociado').val().trim()) {
                $('#txtTipoAsociado').addClass('is-invalid');
                $('#txtTipoAsociado').after('<div class="invalid-feedback">El tipo es requerido</div>');
                esValido = false;
            }
            
            return esValido;
        }

        function eliminarTipoAsociado(id) {
            mostrarConfirmEliminar('Tipo de Asociado', function() {
                $.ajax({
                    type: "POST",
                    url: "Mantenimientos.aspx/EliminarTipoAsociado",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            showToast('success', 'Éxito', response.d.Mensaje);
                            cargarTipoAsociados();
                        } else {
                            showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
                        }
                    },
                    error: function() {
                        showToast('error', 'Error', 'Error al eliminar tipo de asociado');
                    }
                });
            });
        }

        // ===== FUNCIONALIDAD TIPOS DE DOCUMENTOS =====
        function inicializarTipoDocumentos() {
            // Cargar datos iniciales
            cargarTipoDocumentos();
            
            // Configurar eventos
            configurarEventosTipoDocumentos();
        }

        function cargarTipoDocumentos() {
            const filtros = {
                CodTipoDoc: $('#txtFiltroCodigoTipoDoc').val(),
                TipoDocumento: $('#txtFiltroTipoDocumento').val()
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarTipoDocumentos",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: filtros }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const tipoDocumentos = JSON.parse(response.d.Datos);
                        mostrarTipoDocumentos(tipoDocumentos);
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar tipos de documento');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar tipos de documento');
                }
            });
        }

        function mostrarTipoDocumentos(tipoDocumentos) {
            const tbody = $('#tblTipoDocumentos tbody');
            tbody.empty();
            
            if (tipoDocumentos.length === 0) {
                tbody.append('<tr><td colspan="3" class="text-center text-muted">No hay tipos de documento disponibles</td></tr>');
                return;
            }
            
            tipoDocumentos.forEach(function(tipoDocumento) {
                const row = `
                    <tr>
                        <td>${getTipoDocChip(tipoDocumento.CodTipoDoc, tipoDocumento.TipoDocumento)}</td>
                        <td>${tipoDocumento.TipoDocumento}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarTipoDoc(${tipoDocumento.IDTipoDoc})" title="Editar">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarTipoDoc(${tipoDocumento.IDTipoDoc})" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
            });
        }

        function getTipoDocChip(codigo, descripcion) {
            // Mapeo de códigos a iconos y estilos
            const tipoDocConfig = {
                'CED': { icon: 'fa-id-card' },
                'PAS': { icon: 'fa-passport' },
                'RUC': { icon: 'fa-building' }
            };
            
            const config = tipoDocConfig[codigo] || { icon: 'fa-file-alt' };
            
            return `
                <span class="tipo-doc-chip tipo-doc-${codigo}">
                    <i class="fas ${config.icon} icon"></i>${codigo}
                </span>
            `;
        }

        function limpiarFiltrosTipoDoc() {
            $('#txtFiltroCodigoTipoDoc').val('');
            $('#txtFiltroTipoDocumento').val('');
            cargarTipoDocumentos();
        }

        // ===== FUNCIONES AUXILIARES =====
        function crearChipRubroInteligente(codigo, descripcion) {
            if (!codigo || !descripcion) {
                return '<span class="badge bg-secondary"><i class="fas fa-tag me-1"></i>N/A</span>';
            }
            
            // Mapeo de códigos a colores e iconos
            const configuraciones = {
                'AH': { color: 'bg-success', icono: 'fas fa-piggy-bank' },
                'AP': { color: 'bg-info', icono: 'fas fa-coins' },
                'PR': { color: 'bg-warning', icono: 'fas fa-hand-holding-usd' },
                'CR': { color: 'bg-danger', icono: 'fas fa-credit-card' },
                'IN': { color: 'bg-purple', icono: 'fas fa-chart-line' }
            };
            
            const config = configuraciones[codigo] || { color: 'bg-secondary', icono: 'fas fa-tag' };
            const textoCompleto = `${codigo}-${descripcion}`;
            
            return `<span class="badge ${config.color}"><i class="${config.icono} me-1"></i>${textoCompleto}</span>`;
        }

        // ===== FUNCIONALIDAD TIPOS AUXILIARES =====
        function inicializarTiposAuxiliares() {
            console.log('🚀 Inicializando Tipos Auxiliares...');
            
            // Verificar que todos los elementos necesarios existan
            const elementos = [
                '#ddlFiltroRubroAuxiliar',
                '#txtFiltroTipoAuxiliar', 
                '#txtFiltroDescripcionAuxiliar',
                '#tblTiposAuxiliares',
                '#btnNuevoTipoAuxiliar',
                '#btnBuscarTiposAuxiliares',
                '#btnLimpiarFiltrosTiposAuxiliares'
            ];
            
            console.log('🔍 Verificando elementos del DOM...');
            elementos.forEach(selector => {
                const elemento = $(selector);
                console.log(`🔍 ${selector}:`, elemento.length);
            });
            
            // Cargar rubros para filtro y modal
            console.log('📋 Cargando rubros...');
            cargarRubrosAuxiliares();
            
            // Cargar datos iniciales
            console.log('📊 Cargando tipos auxiliares...');
            cargarTiposAuxiliares();
            
            // Configurar eventos
            console.log('⚙️ Configurando eventos...');
            configurarEventosTiposAuxiliares();
            
            console.log('✅ Inicialización de Tipos Auxiliares completada');
        }

        function cargarRubrosAuxiliares() {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerRubros",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const rubros = JSON.parse(response.d.Datos);
                        
                        // Llenar dropdown de filtro
                        $('#ddlFiltroRubroAuxiliar').empty().append('<option value="">Todos los rubros</option>');
                        $.each(rubros, function(index, rubro) {
                            $('#ddlFiltroRubroAuxiliar').append(`<option value="${rubro.CodigoRubro}">${rubro.CodigoRubro} - ${rubro.Descripcion}</option>`);
                        });
                        
                        // Llenar dropdown del modal
                        $('#ddlCodigoRubroAuxiliar').empty().append('<option value="">Seleccionar rubro...</option>');
                        $.each(rubros, function(index, rubro) {
                            $('#ddlCodigoRubroAuxiliar').append(`<option value="${rubro.CodigoRubro}">${rubro.CodigoRubro} - ${rubro.Descripcion}</option>`);
                        });
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar rubros');
                }
            });
        }

        function cargarTiposAuxiliares() {
            console.log('🔄 cargarTiposAuxiliares iniciado');
            
            // Verificar que los elementos del DOM existan
            const ddlRubro = $('#ddlFiltroRubroAuxiliar');
            const txtTipo = $('#txtFiltroTipoAuxiliar');
            const txtDescripcion = $('#txtFiltroDescripcionAuxiliar');
            
            console.log('🔍 Elementos del DOM:');
            console.log('- ddlFiltroRubroAuxiliar:', ddlRubro.length);
            console.log('- txtFiltroTipoAuxiliar:', txtTipo.length);
            console.log('- txtFiltroDescripcionAuxiliar:', txtDescripcion.length);
            
            const filtros = {
                CodigoRubro: ddlRubro.val() || '',
                TipoAuxiliar: txtTipo.val() || '',
                Descripcion: txtDescripcion.val() || ''
            };
            
            console.log('📋 Filtros:', filtros);
            console.log('🌐 Enviando petición AJAX a: Mantenimientos.aspx/ListarTiposAuxiliares');
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarTiposAuxiliares",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: filtros }),
                dataType: "json",
                success: function(response) {
                    console.log('✅ Respuesta AJAX recibida:', response);
                    
                    // Verificar si response.d es un string que necesita ser parseado
                    let responseData = response.d;
                    if (typeof responseData === 'string') {
                        try {
                            responseData = JSON.parse(responseData);
                            console.log('🔍 response.d parseado:', responseData);
                        } catch (parseError) {
                            console.log('❌ Error al parsear response.d:', parseError);
                            mostrarTiposAuxiliares([]);
                            showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
                            return;
                        }
                    }
                    
                    if (responseData && responseData.Resultado === 'SUCCESS') {
                        console.log('📊 Datos recibidos:', responseData.Datos);
                        try {
                            const tiposAuxiliares = JSON.parse(responseData.Datos);
                            console.log('📋 Tipos auxiliares parseados:', tiposAuxiliares);
                            mostrarTiposAuxiliares(tiposAuxiliares);
                        } catch (parseError) {
                            console.log('❌ Error al parsear JSON de datos:', parseError);
                            mostrarTiposAuxiliares([]);
                            showToast('error', 'Error', 'Error al procesar los datos');
                        }
                    } else {
                        console.log('❌ Error en respuesta:', responseData ? responseData.Mensaje : 'Respuesta inválida');
                        mostrarTiposAuxiliares([]);
                        showToast('warning', 'Advertencia', responseData ? responseData.Mensaje : 'No se encontraron datos');
                    }
                },
                error: function(xhr, status, error) {
                    console.log('❌ Error AJAX:', xhr, status, error);
                    mostrarTiposAuxiliares([]);
                    showToast('error', 'Error', 'Error al cargar tipos auxiliares');
                }
            });
        }

        function mostrarTiposAuxiliares(tiposAuxiliares) {
            console.log('📊 mostrarTiposAuxiliares iniciado con:', tiposAuxiliares);
            console.log('🔍 Tipo de datos:', typeof tiposAuxiliares);
            console.log('🔍 Es array:', Array.isArray(tiposAuxiliares));
            console.log('🔍 Longitud:', tiposAuxiliares ? tiposAuxiliares.length : 'undefined');
            
            const tbody = $('#tblTiposAuxiliares tbody');
            console.log('🔍 Buscando tabla tblTiposAuxiliares:', $('#tblTiposAuxiliares').length);
            console.log('🔍 Buscando tbody:', tbody.length);
            
            if (tbody.length === 0) {
                console.log('❌ No se encontró el tbody de la tabla');
                console.log('🔍 Tabla completa:', $('#tblTiposAuxiliares').html());
                return;
            }
            
            tbody.empty();
            
            if (!tiposAuxiliares || !Array.isArray(tiposAuxiliares) || tiposAuxiliares.length === 0) {
                console.log('⚠️ No hay datos para mostrar');
                tbody.append(`
                    <tr>
                        <td colspan="12" class="text-center text-muted">
                            <i class="fas fa-info-circle me-2"></i>No se encontraron tipos auxiliares
                        </td>
                    </tr>
                `);
                return;
            }
            
            console.log('✅ Procesando', tiposAuxiliares.length, 'tipos auxiliares');
            
            try {
                $.each(tiposAuxiliares, function(index, tipo) {
                    console.log(`📋 Procesando tipo ${index}:`, tipo);
                    
                    // Validar que el objeto tipo tenga las propiedades necesarias
                    if (!tipo) {
                        console.log('⚠️ Tipo es null o undefined');
                        return;
                    }
                    
                    const row = `
                        <tr>
                            <td>${tipo.ID || ''}</td>
                            <td>${crearChipRubroInteligente(tipo.CodigoRubro, tipo.RubroDescripcion)}</td>
                            <td><span class="badge bg-primary">${tipo.TipoAuxiliar || ''}</span></td>
                            <td>${tipo.Descripcion || ''}</td>
                            <td>${tipo.Tasa ? parseFloat(tipo.Tasa).toFixed(2) + '%' : ''}</td>
                            <td>${tipo.Plazo || ''}</td>
                            <td>${tipo.MontoMinimo ? '$' + parseFloat(tipo.MontoMinimo).toFixed(2) : ''}</td>
                            <td>${tipo.MontoMaximo ? '$' + parseFloat(tipo.MontoMaximo).toFixed(2) : ''}</td>
                            <td>${tipo.PorManejo ? parseFloat(tipo.PorManejo).toFixed(2) + '%' : ''}</td>
                            <td>${tipo.PorCapitalizacion ? parseFloat(tipo.PorCapitalizacion).toFixed(2) + '%' : ''}</td>
                            <td>${tipo.PorProteccion ? parseFloat(tipo.PorProteccion).toFixed(2) + '%' : ''}</td>
                            <td>
                                <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarTipoAuxiliar(${tipo.ID || 0})" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarTipoAuxiliar(${tipo.ID || 0})" title="Eliminar">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `;
                    tbody.append(row);
                });
                console.log('✅ Tabla actualizada con', tiposAuxiliares.length, 'filas');
            } catch (error) {
                console.log('❌ Error al procesar tipos auxiliares:', error);
                tbody.append(`
                    <tr>
                        <td colspan="12" class="text-center text-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>Error al procesar los datos
                        </td>
                    </tr>
                `);
            }
        }

        function configurarEventosTiposAuxiliares() {
            // Eventos de filtros
            $('#ddlFiltroRubroAuxiliar, #txtFiltroTipoAuxiliar, #txtFiltroDescripcionAuxiliar').on('change keyup', function() {
                clearTimeout(window.busquedaTiposAuxiliaresTimeout);
                window.busquedaTiposAuxiliaresTimeout = setTimeout(function() {
                    cargarTiposAuxiliares();
                }, 500);
            });
            
            // Eventos de botones
            $('#btnNuevoTipoAuxiliar').on('click', function() {
                abrirModalTipoAuxiliar();
            });
            
            $('#btnBuscarTiposAuxiliares').on('click', function() {
                cargarTiposAuxiliares();
            });
            
            $('#btnLimpiarFiltrosAuxiliar').on('click', function() {
                limpiarFiltrosTiposAuxiliares();
            });
            
            $('#btnGuardarTipoAuxiliar').on('click', function() {
                guardarTipoAuxiliar();
            });
        }

        function limpiarFiltrosTiposAuxiliares() {
            $('#ddlFiltroRubroAuxiliar').val('');
            $('#txtFiltroTipoAuxiliar').val('');
            $('#txtFiltroDescripcionAuxiliar').val('');
            cargarTiposAuxiliares();
        }

        function abrirModalTipoAuxiliar() {
            limpiarFormularioTipoAuxiliar();
            
            // Cambiar título del modal
            $('#modalTipoAuxiliarLabel').html('<i class="fas fa-tools me-2"></i>Nuevo Tipo Auxiliar');
            
            // Mostrar modal
            const modal = new bootstrap.Modal(document.getElementById('modalTipoAuxiliar'));
            modal.show();
        }

        function editarTipoAuxiliar(id) {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerTipoAuxiliar",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ id: id }),
                dataType: "json",
                success: function(response) {
                    console.log('✅ Respuesta AJAX editarTipoAuxiliar:', response);
                    
                    // Verificar si response.d es un string que necesita ser parseado
                    let responseData = response.d;
                    if (typeof responseData === 'string') {
                        try {
                            responseData = JSON.parse(responseData);
                            console.log('🔍 response.d parseado:', responseData);
                        } catch (parseError) {
                            console.log('❌ Error al parsear response.d:', parseError);
                            showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
                            return;
                        }
                    }
                    
                    if (responseData && responseData.Resultado === 'SUCCESS') {
                        console.log('📊 Datos recibidos:', responseData.Datos);
                        try {
                            const tipoAuxiliar = JSON.parse(responseData.Datos);
                            console.log('📋 Tipo auxiliar parseado:', tipoAuxiliar);
                            llenarFormularioTipoAuxiliar(tipoAuxiliar);
                            $('#modalTipoAuxiliarLabel').html('<i class="fas fa-tools me-2"></i>Editar Tipo Auxiliar');
                            
                            // Mostrar modal
                            const modal = new bootstrap.Modal(document.getElementById('modalTipoAuxiliar'));
                            modal.show();
                        } catch (parseError) {
                            console.log('❌ Error al parsear JSON de datos:', parseError);
                            showToast('error', 'Error', 'Error al procesar los datos del tipo auxiliar');
                        }
                    } else {
                        console.log('❌ Error en respuesta:', responseData ? responseData.Mensaje : 'Respuesta inválida');
                        showToast('error', 'Error', responseData ? responseData.Mensaje : 'No se pudo obtener el tipo auxiliar');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al obtener tipo auxiliar');
                }
            });
        }

        function llenarFormularioTipoAuxiliar(tipoAuxiliar) {
            console.log('🔧 Llenando formulario con datos:', tipoAuxiliar);
            
            $('#hdnIDTipoAuxiliar').val(tipoAuxiliar.ID);
            console.log('✅ ID asignado:', tipoAuxiliar.ID);
            
            $('#ddlCodigoRubroAuxiliar').val(tipoAuxiliar.CodigoRubro);
            console.log('✅ CodigoRubro asignado:', tipoAuxiliar.CodigoRubro);
            
            $('#txtTipoAuxiliar').val(tipoAuxiliar.TipoAuxiliar);
            console.log('✅ TipoAuxiliar asignado:', tipoAuxiliar.TipoAuxiliar);
            
            $('#txtDescripcionAuxiliar').val(tipoAuxiliar.Descripcion);
            console.log('✅ Descripcion asignada:', tipoAuxiliar.Descripcion);
            
            // Limpiar y asignar valores numéricos
            const tasa = tipoAuxiliar.Tasa ? tipoAuxiliar.Tasa.toString().replace(',', '.') : '';
            $('#txtTasaAuxiliar').val(tasa);
            console.log('✅ Tasa asignada:', tasa, '(original:', tipoAuxiliar.Tasa, ')');
            
            const plazo = tipoAuxiliar.Plazo ? tipoAuxiliar.Plazo.toString() : '';
            $('#txtPlazoAuxiliar').val(plazo);
            console.log('✅ Plazo asignado:', plazo, '(original:', tipoAuxiliar.Plazo, ')');
            
            const montoMinimo = tipoAuxiliar.MontoMinimo ? tipoAuxiliar.MontoMinimo.toString().replace(',', '.') : '';
            $('#txtMontoMinimoAuxiliar').val(montoMinimo);
            console.log('✅ MontoMinimo asignado:', montoMinimo, '(original:', tipoAuxiliar.MontoMinimo, ')');
            
            const montoMaximo = tipoAuxiliar.MontoMaximo ? tipoAuxiliar.MontoMaximo.toString().replace(',', '.') : '';
            $('#txtMontoMaximoAuxiliar').val(montoMaximo);
            console.log('✅ MontoMaximo asignado:', montoMaximo, '(original:', tipoAuxiliar.MontoMaximo, ')');
            
            const porManejo = tipoAuxiliar.PorManejo ? tipoAuxiliar.PorManejo.toString().replace(',', '.') : '';
            $('#txtPorManejoAuxiliar').val(porManejo);
            console.log('✅ PorManejo asignado:', porManejo, '(original:', tipoAuxiliar.PorManejo, ')');
            
            const porCapitalizacion = tipoAuxiliar.PorCapitalizacion ? tipoAuxiliar.PorCapitalizacion.toString().replace(',', '.') : '';
            $('#txtPorCapitalizacionAuxiliar').val(porCapitalizacion);
            console.log('✅ PorCapitalizacion asignado:', porCapitalizacion, '(original:', tipoAuxiliar.PorCapitalizacion, ')');
            
            const porProteccion = tipoAuxiliar.PorProteccion ? tipoAuxiliar.PorProteccion.toString().replace(',', '.') : '';
            $('#txtPorProteccionAuxiliar').val(porProteccion);
            console.log('✅ PorProteccion asignado:', porProteccion, '(original:', tipoAuxiliar.PorProteccion, ')');
            
            console.log('🎯 Formulario llenado completamente');
        }

        function limpiarFormularioTipoAuxiliar() {
            if ($('#formTipoAuxiliar').length > 0) {
                $('#formTipoAuxiliar')[0].reset();
                $('#hdnIDTipoAuxiliar').val('');
            }
        }

        function guardarTipoAuxiliar() {
            if (!validarFormularioTipoAuxiliar()) {
                return;
            }
            
            // Función helper para limpiar valores numéricos
            function limpiarValorNumerico(valor) {
                if (!valor || valor === '' || valor === '0' || valor === '0.00') {
                    return null;
                }
                // Convertir a número y luego a string para asegurar formato correcto
                const numero = parseFloat(valor.toString().replace(',', '.'));
                return isNaN(numero) ? null : numero.toString();
            }
            
            const tipoAuxiliarData = {
                ID: $('#hdnIDTipoAuxiliar').val() || null,
                CodigoRubro: $('#ddlCodigoRubroAuxiliar').val(),
                // TipoAuxiliar se maneja automáticamente en el backend
                Descripcion: $('#txtDescripcionAuxiliar').val(),
                Tasa: limpiarValorNumerico($('#txtTasaAuxiliar').val()),
                Plazo: limpiarValorNumerico($('#txtPlazoAuxiliar').val()),
                MontoMaximo: limpiarValorNumerico($('#txtMontoMaximoAuxiliar').val()),
                MontoMinimo: limpiarValorNumerico($('#txtMontoMinimoAuxiliar').val()),
                PorManejo: limpiarValorNumerico($('#txtPorManejoAuxiliar').val()),
                PorCapitalizacion: limpiarValorNumerico($('#txtPorCapitalizacionAuxiliar').val()),
                PorProteccion: limpiarValorNumerico($('#txtPorProteccionAuxiliar').val())
            };
            
            console.log('Datos a enviar:', tipoAuxiliarData);
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/GuardarTipoAuxiliar",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ tipoAuxiliarData: tipoAuxiliarData }),
                dataType: "json",
                success: function(response) {
                    console.log('✅ Respuesta AJAX guardarTipoAuxiliar:', response);
                    
                    // Verificar si response.d es un string que necesita ser parseado
                    let responseData = response.d;
                    if (typeof responseData === 'string') {
                        try {
                            responseData = JSON.parse(responseData);
                            console.log('🔍 response.d parseado:', responseData);
                        } catch (parseError) {
                            console.log('❌ Error al parsear response.d:', parseError);
                            showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
                            return;
                        }
                    }
                    
                    if (responseData && responseData.Resultado === 'SUCCESS') {
                        console.log('✅ Guardado exitoso:', responseData.Mensaje);
                        showToast('success', 'Éxito', responseData.Mensaje);
                        $('#modalTipoAuxiliar').modal('hide');
                        cargarTiposAuxiliares();
                    } else {
                        console.log('❌ Error en respuesta:', responseData ? responseData.Mensaje : 'Respuesta inválida');
                        showToast('error', 'Error', responseData ? responseData.Mensaje : 'No se pudo guardar el tipo auxiliar');
                    }
                },
                error: function(xhr, status, error) {
                    console.log('Error en AJAX:', xhr, status, error);
                    console.log('Response text:', xhr.responseText);
                    showToast('error', 'Error', 'Error al guardar tipo auxiliar: ' + error);
                }
            });
        }

        function validarFormularioTipoAuxiliar() {
            if (!$('#ddlCodigoRubroAuxiliar').val()) {
                showToast('warning', 'Validación', 'Debe seleccionar un rubro');
                return false;
            }
            
            // Campo Tipo Auxiliar no se valida porque es oculto y se maneja automáticamente
            
            if (!$('#txtDescripcionAuxiliar').val()) {
                showToast('warning', 'Validación', 'La descripción es obligatoria');
                return false;
            }
            
            // Validar montos
            const montoMinimo = parseFloat($('#txtMontoMinimoAuxiliar').val()) || 0;
            const montoMaximo = parseFloat($('#txtMontoMaximoAuxiliar').val()) || 0;
            
            if (montoMinimo > 0 && montoMaximo > 0 && montoMinimo > montoMaximo) {
                showToast('warning', 'Validación', 'El monto mínimo no puede ser mayor al monto máximo');
                return false;
            }
            
            // Validar porcentajes
            const porManejo = parseFloat($('#txtPorManejoAuxiliar').val()) || 0;
            const porCapitalizacion = parseFloat($('#txtPorCapitalizacionAuxiliar').val()) || 0;
            const porProteccion = parseFloat($('#txtPorProteccionAuxiliar').val()) || 0;
            
            if (porManejo < 0 || porManejo > 100) {
                showToast('warning', 'Validación', 'El porcentaje de manejo debe estar entre 0 y 100');
                return false;
            }
            
            if (porCapitalizacion < 0 || porCapitalizacion > 100) {
                showToast('warning', 'Validación', 'El porcentaje de capitalización debe estar entre 0 y 100');
                return false;
            }
            
            if (porProteccion < 0 || porProteccion > 100) {
                showToast('warning', 'Validación', 'El porcentaje de protección debe estar entre 0 y 100');
                return false;
            }
            
            return true;
        }

        function eliminarTipoAuxiliar(id) {
            mostrarConfirmEliminar('tipo auxiliar', function() {
                $.ajax({
                    type: "POST",
                    url: "Mantenimientos.aspx/EliminarTipoAuxiliar",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            showToast('success', 'Éxito', response.d.Mensaje);
                            cargarTiposAuxiliares();
                        } else {
                            showToast('error', 'Error', response.d.Mensaje);
                        }
                    },
                    error: function() {
                        showToast('error', 'Error', 'Error al eliminar tipo auxiliar');
                    }
                });
            });
        }

        function abrirModalTipoDoc() {
            // Limpiar formulario
            limpiarFormularioTipoDoc();
            
            // Cambiar título del modal
            $('#modalTipoDocLabel').html('<i class="fas fa-id-card me-2"></i>Nuevo Tipo de Documento');
            
            // Mostrar modal
            const modal = new bootstrap.Modal(document.getElementById('modalTipoDoc'));
            modal.show();
        }

        function editarTipoDoc(id) {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerTipoDocumento",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ id: id }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const tipoDocumento = JSON.parse(response.d.Datos);
                        llenarFormularioTipoDoc(tipoDocumento);
                        $('#modalTipoDocLabel').html('<i class="fas fa-id-card me-2"></i>Editar Tipo de Documento');
                        
                        // Mostrar modal
                        const modal = new bootstrap.Modal(document.getElementById('modalTipoDoc'));
                        modal.show();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al cargar datos');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar datos del tipo de documento');
                }
            });
        }

        function llenarFormularioTipoDoc(tipoDocumento) {
            console.log('📝 Llenando formulario con tipo de documento:', tipoDocumento);
            
            // Verificar que los elementos existen antes de llenarlos
            if ($('#txtTipoDocID').length > 0) {
                $('#txtTipoDocID').val(tipoDocumento.IDTipoDoc);
                console.log('✅ ID establecido:', tipoDocumento.IDTipoDoc);
            }
            if ($('#txtCodigoTipoDoc').length > 0) {
                $('#txtCodigoTipoDoc').val(tipoDocumento.CodTipoDoc);
                console.log('✅ Código establecido:', tipoDocumento.CodTipoDoc);
            }
            if ($('#txtTipoDocumento').length > 0) {
                $('#txtTipoDocumento').val(tipoDocumento.TipoDocumento);
                console.log('✅ Tipo establecido:', tipoDocumento.TipoDocumento);
            }
        }

        function limpiarFormularioTipoDoc() {
            // Verificar que el formulario existe antes de hacer reset
            if ($('#formTipoDoc').length > 0) {
                $('#formTipoDoc')[0].reset();
            }
            $('#txtTipoDocID').val('0');
        }

        function guardarTipoDoc() {
            if (!validarFormularioTipoDoc()) {
                return;
            }
            
            // Obtener valores del formulario
            const codigoTipoDoc = $('#txtCodigoTipoDoc').val();
            const tipoDocumento = $('#txtTipoDocumento').val();
            
            console.log('🔍 Datos a enviar:', {
                CodTipoDoc: codigoTipoDoc,
                TipoDocumento: tipoDocumento
            });
            
            const tipoDocumentoData = {
                IDTipoDoc: parseInt($('#txtTipoDocID').val()) || 0,
                CodTipoDoc: codigoTipoDoc,
                TipoDocumento: tipoDocumento
            };
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/GuardarTipoDocumento",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ tipoDocumentoData: tipoDocumentoData }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        showToast('success', 'Éxito', response.d.Mensaje);
                        $('#modalTipoDoc').modal('hide');
                        cargarTipoDocumentos();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al guardar tipo de documento');
                }
            });
        }

        function validarFormularioTipoDoc() {
            let esValido = true;
            
            // Limpiar mensajes de error previos
            $('.is-invalid').removeClass('is-invalid');
            $('.invalid-feedback').remove();
            
            // Validar código (requerido)
            if (!$('#txtCodigoTipoDoc').val().trim()) {
                $('#txtCodigoTipoDoc').addClass('is-invalid');
                $('#txtCodigoTipoDoc').after('<div class="invalid-feedback">El código es requerido</div>');
                esValido = false;
            }
            
            // Validar tipo de documento (requerido)
            if (!$('#txtTipoDocumento').val().trim()) {
                $('#txtTipoDocumento').addClass('is-invalid');
                $('#txtTipoDocumento').after('<div class="invalid-feedback">El tipo de documento es requerido</div>');
                esValido = false;
            }
            
            return esValido;
        }

        function eliminarTipoDoc(id) {
            mostrarConfirmEliminar('Tipo de Documento', function() {
                $.ajax({
                    type: "POST",
                    url: "Mantenimientos.aspx/EliminarTipoDocumento",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            showToast('success', 'Éxito', response.d.Mensaje);
                            cargarTipoDocumentos();
                        } else {
                            showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
                        }
                    },
                    error: function() {
                        showToast('error', 'Error', 'Error al eliminar tipo de documento');
                    }
                });
            });
        }

        // ===== USUARIOS =====
        function inicializarUsuarios() {
            console.log('🔍 USUARIOS: inicializarUsuarios iniciado');
            console.log('🔍 USUARIOS: Tab usuarios visible al inicio:', $('#usuarios').is(':visible'));
            console.log('🔍 USUARIOS: Tab usuarios activo al inicio:', $('#usuarios').hasClass('active'));
            
            // Cargar roles para filtro y modal
            console.log('🔍 USUARIOS: Llamando cargarRolesUsuarios...');
            cargarRolesUsuarios();
            
            // Cargar datos iniciales
            console.log('🔍 USUARIOS: Llamando cargarUsuarios...');
            cargarUsuarios();
            
            // Configurar eventos
            console.log('🔍 USUARIOS: Llamando configurarEventosUsuarios...');
            configurarEventosUsuarios();
            
            console.log('🔍 USUARIOS: inicializarUsuarios completado');
        }

        function cargarRolesUsuarios() {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarRoles",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: {} }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const roles = JSON.parse(response.d.Datos);
                        const ddlFiltro = $('#ddlFiltroRolUsuario');
                        const ddlModal = $('#ddlRolUsuario');
                        
                        ddlFiltro.empty().append('<option value="">Todos</option>');
                        ddlModal.empty().append('<option value="">Seleccionar rol...</option>');
                        
                        roles.forEach(function(rol) {
                            ddlFiltro.append(`<option value="${rol.Id}">${rol.Nombre}</option>`);
                            ddlModal.append(`<option value="${rol.Id}">${rol.Nombre}</option>`);
                        });
                    }
                }
            });
        }

        function cargarDepartamentosUsuarios() {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarDepartamentos",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: {} }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const departamentos = JSON.parse(response.d.Datos);
                        const ddlFiltro = $('#ddlFiltroDepartamentoUsuario');
                        const ddlModal = $('#ddlDepartamentoUsuario');
                        
                        ddlFiltro.empty().append('<option value="">Todos</option>');
                        ddlModal.empty().append('<option value="">Seleccionar departamento...</option>');
                        
                        departamentos.forEach(function(departamento) {
                            ddlFiltro.append(`<option value="${departamento.Id}">${departamento.Nombre}</option>`);
                            ddlModal.append(`<option value="${departamento.Id}">${departamento.Nombre}</option>`);
                        });
                    }
                }
            });
        }

        function cargarEstadosUsuarios() {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarStatusAsociados",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: {} }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const estados = JSON.parse(response.d.Datos);
                        const ddlFiltro = $('#ddlFiltroEstadoUsuario');
                        const ddlModal = $('#ddlEstadoUsuario');
                        
                        ddlFiltro.empty().append('<option value="">Todos</option>');
                        ddlModal.empty().append('<option value="">Seleccionar estado...</option>');
                        
                        estados.forEach(function(estado) {
                            ddlFiltro.append(`<option value="${estado.CodStatusAsociado}">${estado.StatusAsociado}</option>`);
                            ddlModal.append(`<option value="${estado.CodStatusAsociado}">${estado.StatusAsociado}</option>`);
                        });
                    }
                }
            });
        }

        function cargarUsuarios() {
            console.log('🔍 USUARIOS: cargarUsuarios iniciado');
            console.log('🔍 USUARIOS: Tab usuarios visible:', $('#usuarios').is(':visible'));
            console.log('🔍 USUARIOS: Tab usuarios activo:', $('#usuarios').hasClass('active'));
            console.log('🔍 USUARIOS: Elementos encontrados:');
            console.log('🔍 USUARIOS: - ddlFiltroRolUsuario:', $('#ddlFiltroRolUsuario').length);
            console.log('🔍 USUARIOS: - ddlFiltroDepartamentoUsuario:', $('#ddlFiltroDepartamentoUsuario').length);
            console.log('🔍 USUARIOS: - ddlFiltroEstadoUsuario:', $('#ddlFiltroEstadoUsuario').length);
            console.log('🔍 USUARIOS: - txtFiltroBuscarUsuario:', $('#txtFiltroBuscarUsuario').length);
            
            const filtros = {
                Rol: $('#ddlFiltroRolUsuario').val(),
                Departamento: $('#ddlFiltroDepartamentoUsuario').val(),
                Estado: $('#ddlFiltroEstadoUsuario').val(),
                Buscar: $('#txtFiltroBuscarUsuario').val()
            };
            
            console.log('🔍 USUARIOS: Filtros:', filtros);
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ListarUsuarios",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ filtros: filtros }),
                dataType: "json",
                success: function(response) {
                    console.log('🔍 USUARIOS: Respuesta AJAX completa:', response);
                    console.log('🔍 USUARIOS: response.d:', response.d);
                    
                    let responseData = response.d;
                    if (typeof responseData === 'string') {
                        try {
                            responseData = JSON.parse(responseData);
                            console.log('🔍 USUARIOS: response.d parseado:', responseData);
                        } catch (parseError) {
                            console.log('🔍 USUARIOS: Error al parsear response.d:', parseError);
                            showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
                            return;
                        }
                    }
                    
                    if (responseData && responseData.Resultado === 'SUCCESS') {
                        console.log('🔍 USUARIOS: Resultado SUCCESS, Datos:', responseData.Datos);
                        const usuarios = JSON.parse(responseData.Datos);
                        console.log('🔍 USUARIOS: Usuarios parseados:', usuarios);
                        console.log('🔍 USUARIOS: Cantidad de usuarios:', usuarios.length);
                        mostrarUsuarios(usuarios);
                    } else {
                        console.log('🔍 USUARIOS: Error en respuesta:', responseData ? responseData.Mensaje : 'No hay responseData');
                        mostrarUsuarios([]);
                        showToast('warning', 'Advertencia', responseData ? responseData.Mensaje : 'No se encontraron datos');
                    }
                },
                error: function(xhr, status, error) {
                    console.log('🔍 USUARIOS: Error AJAX:', xhr, status, error);
                    console.log('🔍 USUARIOS: Response text:', xhr.responseText);
                    mostrarUsuarios([]);
                    showToast('error', 'Error', 'Error al cargar usuarios');
                }
            });
        }

        function mostrarUsuarios(usuarios) {
            console.log('🔍 USUARIOS: mostrarUsuarios iniciado con:', usuarios);
            console.log('🔍 USUARIOS: Tipo de datos:', typeof usuarios);
            console.log('🔍 USUARIOS: Es array:', Array.isArray(usuarios));
            console.log('🔍 USUARIOS: Longitud:', usuarios ? usuarios.length : 'undefined');
            
            // Verificar que el tab esté activo
            const tabPane = $('#usuarios');
            const tabLink = $('#usuarios-tab');
            console.log('🔍 USUARIOS: Tab pane activo:', tabPane.hasClass('active'));
            console.log('🔍 USUARIOS: Tab link activo:', tabLink.hasClass('active'));
            console.log('🔍 USUARIOS: Tab pane visible:', tabPane.is(':visible'));
            
            const tbody = $('#tblUsuarios tbody');
            console.log('🔍 USUARIOS: tbody encontrado:', tbody.length);
            tbody.empty();
            
            if (!usuarios || usuarios.length === 0) {
                console.log('🔍 USUARIOS: No hay usuarios, mostrando mensaje de no datos');
                tbody.append(`
                    <tr>
                        <td colspan="10" class="text-center text-muted">
                            <i class="fas fa-info-circle me-2"></i>No hay datos disponibles
                        </td>
                    </tr>
                `);
                return;
            }
            
            console.log('🔍 USUARIOS: Procesando', usuarios.length, 'usuarios');
            $.each(usuarios, function(index, usuario) {
                console.log('🔍 USUARIOS: Procesando usuario', index + 1, ':', usuario);
                
                const estadoBadge = usuario.Estado === 'A' ? 
                    '<span class="badge bg-success">Activo</span>' : 
                    '<span class="badge bg-secondary">Inactivo</span>';
                
                const ultimoAcceso = usuario.UltimoAcceso ? 
                    new Date(usuario.UltimoAcceso).toLocaleDateString() : 
                    'Nunca';
                
                const row = `
                    <tr>
                        <td>${usuario.Id}</td>
                        <td>${usuario.Nombre} ${usuario.Apellido}</td>
                        <td><strong>${usuario.Usuario}</strong></td>
                        <td>${usuario.Email}</td>
                        <td>${usuario.Telefono || '-'}</td>
                        <td>${usuario.RolNombre || '-'}</td>
                        <td>${usuario.DepartamentoNombre || '-'}</td>
                        <td>${estadoBadge}</td>
                        <td>${ultimoAcceso}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarUsuario(${usuario.Id})" title="Editar">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarUsuario(${usuario.Id})" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tbody.append(row);
                console.log('🔍 USUARIOS: Fila agregada para usuario', usuario.Usuario);
            });
            
            console.log('🔍 USUARIOS: Filas en tbody después de procesar:', tbody.find('tr').length);
            
            // Verificar visibilidad de elementos
            const tabla = $('#tblUsuarios');
            const contenedor = $('.table-responsive');
            
            console.log('🔍 USUARIOS: Tab visible:', tabPane.is(':visible'));
            console.log('🔍 USUARIOS: Tabla encontrada:', tabla.length);
            console.log('🔍 USUARIOS: Tabla visible:', tabla.is(':visible'));
            console.log('🔍 USUARIOS: Tabla height:', tabla.height());
            console.log('🔍 USUARIOS: Tabla display:', tabla.css('display'));
            console.log('🔍 USUARIOS: Tabla visibility:', tabla.css('visibility'));
            console.log('🔍 USUARIOS: Contenedor visible:', contenedor.is(':visible'));
            console.log('🔍 USUARIOS: Contenedor encontrado:', contenedor.length);
            
            // Verificar si la tabla tiene contenido
            console.log('🔍 USUARIOS: Filas en tabla:', tabla.find('tr').length);
            console.log('🔍 USUARIOS: Filas en tbody:', tbody.find('tr').length);
            
            // Forzar visibilidad si es necesario
            setTimeout(function() {
                console.log('🔍 USUARIOS: Verificando visibilidad después del delay...');
                console.log('🔍 USUARIOS: Tab visible después:', tabPane.is(':visible'));
                console.log('🔍 USUARIOS: Tabla visible después:', tabla.is(':visible'));
                console.log('🔍 USUARIOS: Tabla height después:', tabla.height());
                
                if (!tabla.is(':visible') || tabla.height() === 0) {
                    console.log('🔍 USUARIOS: Forzando visibilidad de la tabla...');
                    
                    // Asegurar que el tab esté activo
                    if (!tabPane.hasClass('active')) {
                        console.log('🔍 USUARIOS: Activando tab de usuarios...');
                        tabPane.addClass('active show');
                        tabLink.addClass('active');
                    }
                    
                    tabla.css({
                        'display': 'table !important',
                        'visibility': 'visible !important',
                        'height': 'auto !important',
                        'min-height': '100px !important'
                    });
                    contenedor.css({
                        'display': 'block !important',
                        'visibility': 'visible !important',
                        'height': 'auto !important',
                        'min-height': '100px !important'
                    });
                    tabPane.css({
                        'display': 'block !important',
                        'visibility': 'visible !important'
                    });
                    
                    // Forzar re-render
                    tabla.hide().show();
                    contenedor.hide().show();
                    
                    console.log('🔍 USUARIOS: Visibilidad forzada aplicada');
                }
            }, 100);
        }

        function configurarEventosUsuarios() {
            // Búsqueda en tiempo real
            $('#txtFiltroBuscarUsuario').on('input', function() {
                clearTimeout(window.busquedaUsuariosTimeout);
                window.busquedaUsuariosTimeout = setTimeout(function() {
                    cargarUsuarios();
                }, 500);
            });
        }

        function limpiarFiltrosUsuarios() {
            $('#ddlFiltroRolUsuario').val('');
            $('#ddlFiltroDepartamentoUsuario').val('');
            $('#ddlFiltroEstadoUsuario').val('');
            $('#txtFiltroBuscarUsuario').val('');
            cargarUsuarios();
        }

        function abrirModalUsuario() {
            limpiarFormularioUsuario();
            $('#modalUsuarioLabel').html('<i class="fas fa-user-plus me-2"></i>Nuevo Usuario');
            const modal = new bootstrap.Modal(document.getElementById('modalUsuario'));
            modal.show();
        }

        function editarUsuario(id) {
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/ObtenerUsuario",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ id: id }),
                dataType: "json",
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        const usuario = JSON.parse(response.d.Datos);
                        llenarFormularioUsuario(usuario);
                        $('#modalUsuarioLabel').html('<i class="fas fa-user-edit me-2"></i>Editar Usuario');
                        const modal = new bootstrap.Modal(document.getElementById('modalUsuario'));
                        modal.show();
                    } else {
                        showToast('error', 'Error', response.d.Mensaje);
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al obtener usuario');
                }
            });
        }

        function llenarFormularioUsuario(usuario) {
            $('#hdnIDUsuario').val(usuario.Id);
            $('#txtNombreUsuario').val(usuario.Nombre);
            $('#txtApellidoUsuario').val(usuario.Apellido);
            $('#txtUsuarioUsuario').val(usuario.Usuario);
            $('#txtEmailUsuario').val(usuario.Email);
            $('#txtTelefonoUsuario').val(usuario.Telefono || '');
            $('#ddlRolUsuario').val(usuario.Rol);
            $('#ddlDepartamentoUsuario').val(usuario.Departamento);
            $('#ddlEstadoUsuario').val(usuario.Estado);
        }

        function limpiarFormularioUsuario() {
            if ($('#formUsuario').length > 0) {
                $('#formUsuario')[0].reset();
                $('#hdnIDUsuario').val('');
            }
        }

        function guardarUsuario() {
            if (!validarFormularioUsuario()) {
                return;
            }
            
            const usuarioData = {
                ID: $('#hdnIDUsuario').val() || null,
                Nombre: $('#txtNombreUsuario').val(),
                Apellido: $('#txtApellidoUsuario').val(),
                Usuario: $('#txtUsuarioUsuario').val(),
                Clave: $('#txtClaveUsuario').val(),
                Email: $('#txtEmailUsuario').val(),
                Telefono: $('#txtTelefonoUsuario').val() || null,
                Rol: $('#ddlRolUsuario').val(),
                Departamento: $('#ddlDepartamentoUsuario').val() || null,
                Estado: $('#ddlEstadoUsuario').val()
            };
            
            console.log('Datos a enviar:', usuarioData);
            
            $.ajax({
                type: "POST",
                url: "Mantenimientos.aspx/GuardarUsuario",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ usuarioData: usuarioData }),
                dataType: "json",
                success: function(response) {
                    console.log('✅ Respuesta AJAX guardarUsuario:', response);
                    
                    let responseData = response.d;
                    if (typeof responseData === 'string') {
                        try {
                            responseData = JSON.parse(responseData);
                        } catch (parseError) {
                            console.log('❌ Error al parsear response.d:', parseError);
                            showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
                            return;
                        }
                    }
                    
                    if (responseData && responseData.Resultado === 'SUCCESS') {
                        console.log('✅ Usuario guardado exitosamente:', responseData.Mensaje);
                        showToast('success', 'Éxito', responseData.Mensaje);
                        $('#modalUsuario').modal('hide');
                        cargarUsuarios();
                    } else {
                        console.log('❌ Error en respuesta:', responseData ? responseData.Mensaje : 'Respuesta inválida');
                        showToast('error', 'Error', responseData ? responseData.Mensaje : 'No se pudo guardar el usuario');
                    }
                },
                error: function(xhr, status, error) {
                    console.log('Error en AJAX:', xhr, status, error);
                    console.log('Response text:', xhr.responseText);
                    showToast('error', 'Error', 'Error al guardar usuario: ' + error);
                }
            });
        }

        function validarFormularioUsuario() {
            if (!$('#txtNombreUsuario').val()) {
                showToast('error', 'Error', 'El nombre es obligatorio');
                return false;
            }
            if (!$('#txtApellidoUsuario').val()) {
                showToast('error', 'Error', 'El apellido es obligatorio');
                return false;
            }
            if (!$('#txtUsuarioUsuario').val()) {
                showToast('error', 'Error', 'El usuario es obligatorio');
                return false;
            }
            if (!$('#txtEmailUsuario').val()) {
                showToast('error', 'Error', 'El email es obligatorio');
                return false;
            }
            if (!$('#ddlRolUsuario').val()) {
                showToast('error', 'Error', 'El rol es obligatorio');
                return false;
            }
            if (!$('#ddlEstadoUsuario').val()) {
                showToast('error', 'Error', 'El estado es obligatorio');
                return false;
            }
            return true;
        }

        function eliminarUsuario(id) {
            mostrarConfirmEliminar('usuario', function() {
                $.ajax({
                    type: "POST",
                    url: "Mantenimientos.aspx/EliminarUsuario",
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({ id: id }),
                    dataType: "json",
                    success: function(response) {
                        if (response.d && response.d.Resultado === 'SUCCESS') {
                            showToast('success', 'Éxito', response.d.Mensaje);
                            cargarUsuarios();
                        } else {
                            showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
                        }
                    },
                    error: function() {
                        showToast('error', 'Error', 'Error al eliminar usuario');
                    }
                });
            });
        }

    </script>

</body>
</html>
