<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Mantenimientos.aspx.vb" Inherits="SemgaWapp.Mantenimientos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Mantenimientos</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet"/>
    <!-- Script de monitoreo de inactividad -->
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    <script src="../../Scripts/notifications.js?v=1.0"></script>
    
    <style>
        html, body {
            height: 100vh;
            overflow: hidden;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: #f8f9fa;
            display: flex;
            flex-direction: column;
        }
        
        .main-container {
            background: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin: 15px;
            padding: 15px;
            border: 1px solid #e9ecef;
            display: flex;
            flex-direction: column;
            height: calc(100vh - 30px);
            max-height: calc(100vh - 30px);
            overflow: hidden;
        }
        
        /* Contenedor interno después del header */
        .main-container > *:not(.main-header) {
            flex: 1;
            min-height: 0;
            overflow: hidden;
        }
        
        .header-section {
            background: #2c3e50;
            color: white;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
        }
        
        /* Header más pequeño y elegante */
        .main-header {
            background: linear-gradient(135deg, #1e3a8a, #3b82f6);
            color: white;
            padding: 6px 12px;
            margin: -15px -15px 15px -15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-radius: 6px 6px 0 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            flex-shrink: 0;
        }
        
        .main-header-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
            margin: 0;
        }
        
        .main-header-title i {
            font-size: 16px;
        }
        
        .main-header-title .maintenance-name {
            margin-left: 8px;
            color: #ffd700;
            font-weight: 500;
        }
        
        .main-header-actions {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .main-header-btn {
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.2);
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            transition: all 0.2s;
        }
        
        .main-header-btn:hover {
            background: rgba(255,255,255,0.25);
            transform: translateY(-1px);
        }
        
        /* ========== MENÚ LATERAL ========== */
        .sidebar-layout {
            display: flex;
            gap: 20px;
            position: relative;
            flex: 1;
            min-height: 0;
            overflow: hidden;
        }
        
        .sidebar-search-container {
            display: flex;
            gap: 8px;
            margin-bottom: 15px;
        }
        
        .sidebar-toggle {
            background: #2c3e50;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
            min-width: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            z-index: 10;
            position: relative;
        }
        
        .sidebar-toggle:hover {
            background: #34495e;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .sidebar-menu {
            width: 250px;
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            height: 100%;
            max-height: 100%;
            transition: all 0.3s ease;
            overflow-y: auto;
            overflow-x: hidden;
            flex-shrink: 0;
            align-self: flex-start;
        }
        
        /* Scrollbar elegante para el sidebar */
        .sidebar-menu::-webkit-scrollbar {
            width: 8px;
        }
        
        .sidebar-menu::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        
        .sidebar-menu::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 10px;
            transition: background 0.3s;
        }
        
        .sidebar-menu::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }
        
        /* Para Firefox */
        .sidebar-menu {
            scrollbar-width: thin;
            scrollbar-color: #c1c1c1 #f1f1f1;
        }
        
        .sidebar-menu.collapsed {
            width: 60px;
            padding: 15px 8px;
            overflow-x: visible;
        }
        
        .sidebar-menu.collapsed .sidebar-item span {
            display: none;
        }
        
        .sidebar-menu.collapsed .sidebar-item {
            justify-content: center;
            padding: 10px;
        }
        
        .sidebar-menu.collapsed h4 {
            display: none;
        }
        
        .sidebar-menu.collapsed .sidebar-search {
            display: none;
        }
        
        .sidebar-menu.collapsed .sidebar-toggle {
            display: flex;
            width: 100%;
            margin-bottom: 15px;
        }
        
        .sidebar-search {
            flex: 1;
            position: relative;
        }
        
        .sidebar-search input {
            width: 100%;
            padding: 8px 12px;
            padding-left: 35px;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 13px;
            transition: all 0.3s;
        }
        
        .sidebar-search input:focus {
            outline: none;
            border-color: #2c3e50;
            box-shadow: 0 0 0 2px rgba(44, 62, 80, 0.1);
        }
        
        .sidebar-search i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            font-size: 13px;
        }
        
        .sidebar-menu h4 {
            font-size: 14px;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 15px 0 10px 0;
            font-weight: 600;
        }
        
        .sidebar-menu h4:first-child {
            margin-top: 0;
        }
        
        .sidebar-menu h4.hidden {
            display: none;
        }
        
        .sidebar-item.hidden {
            display: none;
        }
        
        .sidebar-item {
            padding: 10px 12px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
            color: #495057;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .sidebar-item:hover {
            background: #e9ecef;
            color: #2c3e50;
        }
        
        .sidebar-item.active {
            background: #2c3e50;
            color: white;
        }
        
        .sidebar-item i {
            width: 20px;
            text-align: center;
        }
        
        .sidebar-content {
            flex: 1;
            background: white;
            border-radius: 8px;
            padding: 20px;
            transition: margin-left 0.3s ease;
            min-height: 0;
            overflow-y: auto;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
        }
        
        .sidebar-menu.collapsed ~ .sidebar-content {
            margin-left: 0;
        }
        
        .sidebar-menu.collapsed .sidebar-item {
            border-radius: 8px;
            margin-bottom: 8px;
        }
        
        .sidebar-menu.collapsed .sidebar-item:hover {
            background: #2c3e50;
            color: white;
        }
        
        /* Tooltips para menú colapsado */
        .sidebar-tooltip {
            display: none;
        }
        
        .sidebar-menu.collapsed {
            overflow-x: visible;
            overflow-y: auto;
        }
        
        .sidebar-menu.collapsed .sidebar-item {
            position: relative;
        }
        
        .sidebar-menu.collapsed .sidebar-tooltip {
            display: block;
            position: fixed;
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 8px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            white-space: nowrap;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55), transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            z-index: 10000;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            letter-spacing: 0.3px;
            transform: scale(0.9);
        }
        
        .sidebar-menu.collapsed .sidebar-tooltip::before {
            content: '';
            position: absolute;
            right: 100%;
            top: 50%;
            transform: translateY(-50%);
            border: 6px solid transparent;
            border-right-color: #2c3e50;
        }
        
        .sidebar-menu.collapsed .sidebar-tooltip.show {
            opacity: 1;
            transform: scale(1);
        }
        
        /* Banner de Selección */
        .selection-banner {
            display: flex;
            align-items: center;
            justify-content: center;
            flex: 1;
            min-height: 200px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 8px;
            border: 2px dashed #dee2e6;
            margin: 0;
        }
        
        .selection-banner.hidden {
            display: none;
        }
        
        .selection-banner-content {
            text-align: center;
            padding: 40px;
        }
        
        .selection-banner-content i {
            font-size: 64px;
            color: #6c757d;
            margin-bottom: 20px;
            opacity: 0.6;
        }
        
        .selection-banner-content h3 {
            font-size: 24px;
            color: #495057;
            margin-bottom: 10px;
            font-weight: 600;
        }
        
        .selection-banner-content p {
            font-size: 16px;
            color: #6c757d;
            margin: 0;
        }
        
        .tab-content {
            background: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 6px;
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
        
        .tab-icon {
            margin-right: 8px;
        }
        
        #mantenimientosTabContent {
            flex: 1;
            min-height: 0;
            overflow-y: auto;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
        }
        .tab-pane {
            flex: 1;
            min-height: 0;
            overflow-y: auto;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
        }
        
        .tab-content .card {
            border: none;
            box-shadow: none;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        
        .tab-content .card-body {
            flex: 1;
            overflow-y: auto;
            overflow-x: hidden;
        }
        
        .tab-content .card-header {
            background: #f8fafa;
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
        
        /* Switch imputable cuentas más grande */
        .form-switch-lg .form-check-input {
            width: 2.5em;
            height: 1.25em;
            min-height: 1.25em;
        }
        .form-switch-lg .form-check-input:checked {
            background-position: right center;
        }
        
        /* Tabla cuentas: tamaño de letra más grande */
        #tblCuentas,
        #tblCuentas th,
        #tblCuentas td {
            font-size: 1.05rem;
        }
        
        /* Badge código de cuenta más grande */
        #tblCuentas .badge-codigo-cuenta {
            font-size: 0.95rem;
            padding: 0.4em 0.65em;
        }

        /* Encabezados ordenables */
        #tblCuentas th.sortable-cuenta {
            cursor: pointer;
            user-select: none;
            white-space: nowrap;
        }

        #tblCuentas th.sortable-cuenta:hover {
            background-color: #3b5266;
            color: #fff;
        }

        #tblCuentas th .sort-icon {
            font-size: 12px;
            margin-left: 4px;
        }
        
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Header Section -->
            <div class="main-header">
                <div class="main-header-title">
                    <i class="fas fa-cogs"></i>
                    <span>Mantenimientos del Sistema</span>
                    <span class="maintenance-name" id="currentMaintenanceName" style="display: none;"></span>
                </div>
                <div class="main-header-actions">
                    <button type="button" class="main-header-btn" onclick="volverDashboard()">
                        <i class="fas fa-arrow-left"></i>
                        Volver
                    </button>
                </div>
            </div>

            <!-- Sidebar Layout -->
            <div class="sidebar-layout">
                <!-- Sidebar Menu -->
                <div class="sidebar-menu" id="sidebarMenu">
                    <div class="sidebar-search-container">
                        <div class="sidebar-search">
                            <i class="fas fa-search"></i>
                            <input type="text" id="sidebarSearch" placeholder="Buscar..." onkeyup="filterSidebar()">
                        </div>
                        <button type="button" class="sidebar-toggle" onclick="toggleSidebar(event); return false;" id="sidebarToggle" title="Colapsar/Expandir menú">
                            <i class="fas fa-chevron-left" id="toggleIcon"></i>
                        </button>
                    </div>
                    
                    <!-- Finanzas -->
                    <h4 class="category-finanzas">Finanzas</h4>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#cuentas" data-search="cuentas cuenta" data-tooltip="Cuentas" onclick="showTab('cuentas')" id="sidebar-cuentas">
                        <i class="fas fa-wallet"></i>
                        <span>Cuentas</span>
                        <span class="sidebar-tooltip">Cuentas</span>
                    </div>
                    
                    <!-- Usuarios -->
                    <h4 class="category-usuarios">Usuarios</h4>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#roles" data-search="roles rol usuario" data-tooltip="Roles de Usuario" onclick="showTab('roles', event)" id="sidebar-roles">
                        <i class="fas fa-user-tag"></i>
                        <span>Roles de Usuario</span>
                        <span class="sidebar-tooltip">Roles de Usuario</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#departamentos" data-search="departamentos departamento" data-tooltip="Departamentos" onclick="showTab('departamentos')" id="sidebar-departamentos">
                        <i class="fas fa-building"></i>
                        <span>Departamentos</span>
                        <span class="sidebar-tooltip">Departamentos</span>
                    </div>
                    
                    <!-- Asociados -->
                    <h4 class="category-asociados">Asociados</h4>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#tipo-identificacion" data-search="tipo identificación identificacion tipo identificacion documento" data-tooltip="Tipo Identificación" onclick="showTab('tipo-identificacion')" id="sidebar-tipo-identificacion">
                        <i class="fas fa-id-card"></i>
                        <span>Tipo Identificación</span>
                        <span class="sidebar-tooltip">Tipo Identificación</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#tipo-asociados" data-search="tipo asociados tipo asociado tipos" data-tooltip="Tipo Asociados" onclick="showTab('tipo-asociados')" id="sidebar-tipo-asociados">
                        <i class="fas fa-user-friends"></i>
                        <span>Tipo Asociados</span>
                        <span class="sidebar-tooltip">Tipo Asociados</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#parentezcos" data-search="parentezcos parentezco parentesco" data-tooltip="Parentezcos" onclick="showTab('parentezcos')" id="sidebar-parentezcos">
                        <i class="fas fa-users"></i>
                        <span>Parentezcos</span>
                        <span class="sidebar-tooltip">Parentezcos</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#estatus-asociados" data-search="estatus asociados status" data-tooltip="Estatus Asociados" onclick="showTab('estatus-asociados')" id="sidebar-estatus-asociados">
                        <i class="fas fa-user-check"></i>
                        <span>Estatus Asociados</span>
                        <span class="sidebar-tooltip">Estatus Asociados</span>
                    </div>
                    
                    <!-- Auxiliares -->
                    <h4 class="category-auxiliares">Auxiliares</h4>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#codigos-transacciones" data-search="códigos transacciones codigos codigo transaccion" data-tooltip="Códigos Transacción" onclick="showTab('codigos-transacciones')" id="sidebar-codigos-transacciones">
                        <i class="fas fa-exchange-alt"></i>
                        <span>Códigos Transacción</span>
                        <span class="sidebar-tooltip">Códigos Transacción</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#rubros" data-search="rubros rubro" data-tooltip="Rubros" onclick="showTab('rubros')" id="sidebar-rubros">
                        <i class="fas fa-list-alt"></i>
                        <span>Rubros</span>
                        <span class="sidebar-tooltip">Rubros</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#tipos-auxiliares" data-search="tipos auxiliares tipo auxiliar auxiliares" data-tooltip="Tipos Auxiliares" onclick="showTab('tipos-auxiliares')" id="sidebar-tipos-auxiliares">
                        <i class="fas fa-tools"></i>
                        <span>Tipos Auxiliares</span>
                        <span class="sidebar-tooltip">Tipos Auxiliares</span>
                    </div>
                    
                    <!-- Educación / Profesión -->
                    <h4 class="category-educacion">Educación / Profesión</h4>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#niveles-estudio" data-search="niveles estudio nivel nivel estudio educacion" data-tooltip="Niveles de Estudio" onclick="showTab('niveles-estudio')" id="sidebar-niveles-estudio">
                        <i class="fas fa-graduation-cap"></i>
                        <span>Niveles de Estudio</span>
                        <span class="sidebar-tooltip">Niveles de Estudio</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#profesiones" data-search="profesiones profesion" data-tooltip="Profesiones" onclick="showTab('profesiones')" id="sidebar-profesiones">
                        <i class="fas fa-briefcase"></i>
                        <span>Profesiones</span>
                        <span class="sidebar-tooltip">Profesiones</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#ocupaciones" data-search="ocupaciones ocupacion" data-tooltip="Ocupaciones" onclick="showTab('ocupaciones')" id="sidebar-ocupaciones">
                        <i class="fas fa-user-tie"></i>
                        <span>Ocupaciones</span>
                        <span class="sidebar-tooltip">Ocupaciones</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#empresas" data-search="empresas empresa" data-tooltip="Empresas" onclick="showTab('empresas')" id="sidebar-empresas">
                        <i class="fas fa-building"></i>
                        <span>Empresas</span>
                        <span class="sidebar-tooltip">Empresas</span>
                    </div>
                    
                    <!-- Regiones -->
                    <h4 class="category-regiones">Regiones</h4>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#paises" data-search="países pais paises" data-tooltip="Países" onclick="showTab('paises')" id="sidebar-paises">
                        <i class="fas fa-globe"></i>
                        <span>Países</span>
                        <span class="sidebar-tooltip">Países</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#provincias" data-search="provincias provincia" data-tooltip="Provincias" onclick="showTab('provincias')" id="sidebar-provincias">
                        <i class="fas fa-map"></i>
                        <span>Provincias</span>
                        <span class="sidebar-tooltip">Provincias</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#distritos" data-search="distritos distrito" data-tooltip="Distritos" onclick="showTab('distritos')" id="sidebar-distritos">
                        <i class="fas fa-map-marked-alt"></i>
                        <span>Distritos</span>
                        <span class="sidebar-tooltip">Distritos</span>
                    </div>
                    <div class="sidebar-item" data-url="forms/mantenimientos/mantenimientos.aspx#corregimientos" data-search="corregimientos corregimiento" data-tooltip="Corregimientos" onclick="showTab('corregimientos')" id="sidebar-corregimientos">
                        <i class="fas fa-map-pin"></i>
                        <span>Corregimientos</span>
                        <span class="sidebar-tooltip">Corregimientos</span>
                    </div>
                </div>
                
                <!-- Content Area -->
                <div class="sidebar-content">
                    <!-- Banner de Selección -->
                    <div id="bannerSeleccion" class="selection-banner">
                        <div class="selection-banner-content">
                            <i class="fas fa-hand-pointer"></i>
                            <h3>Elija el mantenimiento deseado a la izquierda</h3>
                            <p>Seleccione una opción del menú lateral para comenzar</p>
                        </div>
                    </div>
                    
                    <!-- Tab Content -->
                    <div class="tab-content" id="mantenimientosTabContent" style="display: none;">
                <!-- Códigos Transacciones Tab -->
                <div class="tab-pane fade" id="codigos-transacciones" role="tabpanel">
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
                                            <th>Tipo Auxiliar</th>
                                            <th>Código</th>
                                            <th>Descripción</th>
                                            <th>Cuenta Contable</th>
                                            <th>Contra Cuenta</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="9" class="text-center text-muted">
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
                                        <tr><th>ID</th><th>Nombre</th><th>Descripción</th><th>Responsable</th><th>Teléfono</th><th>Email</th><th>Estado</th><th>Acciones</th></tr>
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
                                        <tr><th>ID</th><th>Nombre</th><th>Descripción</th><th>Nivel de Acceso</th><th>Estado</th><th>Última modificación</th><th>Acciones</th></tr>
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

                <!-- Niveles de Estudio Tab -->
                <div class="tab-pane fade" id="niveles-estudio" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="number" id="txtFiltroCodigoNivel" class="form-control" placeholder="Buscar código..."/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Descripción:</label>
                                        <input type="text" id="txtFiltroDescripcionNivel" class="form-control" placeholder="Buscar descripción..."/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoNivel" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo Nivel
                                        </button>
                                        <button type="button" id="btnBuscarNiveles" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosNivel" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblNivelesEstudio" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
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

                <!-- Profesiones Tab -->
                <div class="tab-pane fade" id="profesiones" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="number" id="txtFiltroCodigoProfesion" class="form-control" placeholder="Buscar código..."/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Descripción:</label>
                                        <input type="text" id="txtFiltroDescripcionProfesion" class="form-control" placeholder="Buscar descripción..."/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoProfesion" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nueva Profesión
                                        </button>
                                        <button type="button" id="btnBuscarProfesiones" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosProfesion" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblProfesiones" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
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

                <!-- Empresas Tab -->
                <div class="tab-pane fade" id="empresas" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="number" id="txtFiltroCodigoEmpresa" class="form-control" placeholder="Buscar código..."/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Descripción:</label>
                                        <input type="text" id="txtFiltroDescripcionEmpresa" class="form-control" placeholder="Buscar descripción..."/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoEmpresa" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nueva Empresa
                                        </button>
                                        <button type="button" id="btnBuscarEmpresas" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosEmpresa" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblEmpresas" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
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
                <!-- Ocupaciones Tab -->
                <div class="tab-pane fade" id="ocupaciones" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="number" id="txtFiltroCodigoOcupacion" class="form-control" placeholder="Buscar código..."/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Descripción:</label>
                                        <input type="text" id="txtFiltroDescripcionOcupacion" class="form-control" placeholder="Buscar descripción..."/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoOcupacion" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nueva Ocupación
                                        </button>
                                        <button type="button" id="btnBuscarOcupaciones" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosOcupacion" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblOcupaciones" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
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

                <!-- Países Tab -->
                <div class="tab-pane fade" id="paises" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código ISO:</label>
                                        <input type="text" id="txtFiltroCodigoPais" class="form-control" placeholder="Buscar código..." maxlength="3" style="text-transform: uppercase;"/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">País:</label>
                                        <input type="text" id="txtFiltroDescripcionPais" class="form-control" placeholder="Buscar país..."/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoPais" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo País
                                        </button>
                                        <button type="button" id="btnBuscarPaises" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosPais" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblPaises" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Código ISO</th>
                                            <th>País</th>
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

                <!-- Provincias Tab -->
                <div class="tab-pane fade" id="provincias" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="number" id="txtFiltroCodigoProvincia" class="form-control" placeholder="Código..."/>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">País:</label>
                                        <select id="ddlFiltroPaisProvincia" class="form-select">
                                            <option value="">Todos</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Provincia:</label>
                                        <input type="text" id="txtFiltroDescripcionProvincia" class="form-control" placeholder="Buscar provincia..."/>
                                    </div>
                                </div>
                                <div class="col-md-5">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoProvincia" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nueva Provincia
                                        </button>
                                        <button type="button" id="btnBuscarProvincias" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosProvincia" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblProvincias" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Código</th>
                                            <th>País</th>
                                            <th>Provincia</th>
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

                <!-- Distritos Tab -->
                <div class="tab-pane fade" id="distritos" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="number" id="txtFiltroCodigoDistrito" class="form-control" placeholder="Código..."/>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">País:</label>
                                        <select id="ddlFiltroPaisDistrito" class="form-select">
                                            <option value="">Todos</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Provincia:</label>
                                        <select id="ddlFiltroProvinciaDistrito" class="form-select">
                                            <option value="">Todas</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Distrito:</label>
                                        <input type="text" id="txtFiltroDescripcionDistrito" class="form-control" placeholder="Buscar distrito..."/>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoDistrito" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo Distrito
                                        </button>
                                        <button type="button" id="btnBuscarDistritos" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosDistrito" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblDistritos" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Código</th>
                                            <th>País</th>
                                            <th>Provincia</th>
                                            <th>Distrito</th>
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

                <!-- Corregimientos Tab -->
                <div class="tab-pane fade" id="corregimientos" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <input type="number" id="txtFiltroCodigoCorregimiento" class="form-control" placeholder="Código..."/>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">País:</label>
                                        <select id="ddlFiltroPaisCorregimiento" class="form-select">
                                            <option value="">Todos</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Provincia:</label>
                                        <select id="ddlFiltroProvinciaCorregimiento" class="form-select">
                                            <option value="">Todas</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Distrito:</label>
                                        <select id="ddlFiltroDistritoCorregimiento" class="form-select">
                                            <option value="">Todos</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Corregimiento:</label>
                                        <input type="text" id="txtFiltroDescripcionCorregimiento" class="form-control" placeholder="Buscar corregimiento..."/>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoCorregimiento" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo
                                        </button>
                                        <button type="button" id="btnBuscarCorregimientos" class="btn btn-outline-primary">
                                            <i class="fas fa-search me-1"></i>Buscar
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosCorregimiento" class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-1"></i>Limpiar
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblCorregimientos" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Código</th>
                                            <th>País</th>
                                            <th>Provincia</th>
                                            <th>Distrito</th>
                                            <th>Corregimiento</th>
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
                
                <!-- Cuentas Tab -->
                <div class="tab-pane fade" id="cuentas" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <!-- Filtros y Botones -->
                            <div class="row mb-2">
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Grupo:</label>
                                        <select id="ddlFiltroGrupoCuenta" class="form-select">
                                            <option value="">Todos</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Código:</label>
                                        <div class="input-group">
                                            <input type="text" id="txtFiltroCodigoCuenta" class="form-control" placeholder="Buscar código..."/>
                                            <button type="button" class="btn btn-outline-secondary btn-limpiar-campo-cuenta" data-target="txtFiltroCodigoCuenta" title="Limpiar">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-center">
                                        <label class="form-label me-2 mb-0">Nombre:</label>
                                        <div class="input-group">
                                            <input type="text" id="txtFiltroNombreCuenta" class="form-control" placeholder="Buscar nombre..."/>
                                            <button type="button" class="btn btn-outline-secondary btn-limpiar-campo-cuenta" data-target="txtFiltroNombreCuenta" title="Limpiar">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="d-flex align-items-end gap-2">
                                        <button type="button" id="btnNuevoCuenta" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Nuevo
                                        </button>
                                        <button type="button" id="btnLimpiarFiltrosCuenta" class="btn btn-outline-secondary">
                                            <i class="fas fa-eraser me-1"></i>Limpiar todo
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tabla -->
                            <div class="table-responsive">
                                <table id="tblCuentas" class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th class="sortable-cuenta" data-col="ID">ID <i class="fas fa-sort sort-icon text-muted"></i></th>
                                            <th class="sortable-cuenta" data-col="Cuenta">Cuenta <i class="fas fa-sort sort-icon text-muted"></i></th>
                                            <th class="sortable-cuenta" data-col="Nombre">Nombre <i class="fas fa-sort sort-icon text-muted"></i></th>
                                            <th class="sortable-cuenta" data-col="Grupo">Grupo <i class="fas fa-sort sort-icon text-muted"></i></th>
                                            <th class="sortable-cuenta" data-col="Imputable">Imputable <i class="fas fa-sort sort-icon text-muted"></i></th>
                                            <th class="sortable-cuenta text-end" data-col="Saldo">Saldo <i class="fas fa-sort sort-icon text-muted"></i></th>
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
            </div>
        </div>

        <!-- Toast Container -->
        <div id="toastContainer" class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 1060;"></div>
        
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
                            
                            <!-- Fila 1: Rubro - Tipo Auxiliar -->
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
                                        <label for="ddlTipoAuxiliar" class="form-label">Tipo Auxiliar <span class="text-danger">*</span></label>
                                        <select id="ddlTipoAuxiliar" class="form-select">
                                            <option value="">Seleccionar tipo auxiliar...</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Fila 2: Código de Transacción - Descripción -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoTransaccion" class="form-label">Código de Transacción <span class="text-danger">*</span></label>
                                        <input type="text" id="txtCodigoTransaccion" class="form-control" maxlength="10">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtDescripcion" class="form-label">Descripción <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcion" class="form-control" maxlength="150">
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Fila 3: Tipo - Activo -->
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
                                        <div class="form-check mt-4">
                                            <input class="form-check-input" type="checkbox" id="chkSnActivo" checked>
                                            <label class="form-check-label" for="chkSnActivo">
                                                Activo
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Groupbox Contabilidad -->
                            <div class="card border-primary mb-3">
                                <div class="card-header bg-primary text-white">
                                    <h6 class="mb-0"><i class="fas fa-calculator me-2"></i>Contabilidad</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="ddlCuentaContable" class="form-label">Cuenta Contable</label>
                                                <select id="ddlCuentaContable" class="form-select">
                                                    <option value="">Seleccionar cuenta...</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="ddlContraCuenta" class="form-label">Contra Cuenta</label>
                                                <select id="ddlContraCuenta" class="form-select">
                                                    <option value="">Seleccionar cuenta...</option>
                                                </select>
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

        <!-- Modal Nivel de Estudio -->
        <div class="modal fade" id="modalNivelEstudio" tabindex="-1" aria-labelledby="modalNivelEstudioLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalNivelEstudioLabel">
                            <i class="fas fa-graduation-cap me-2"></i>Nuevo Nivel de Estudio
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formNivelEstudio">
                            <input type="hidden" id="hdnIDNivelEstudio" />
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoNivel" class="form-label">Código <span class="text-danger">*</span></label>
                                        <input type="number" id="txtCodigoNivel" class="form-control" placeholder="Código del nivel" min="1" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtDescripcionNivel" class="form-label">Descripción <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcionNivel" class="form-control" placeholder="Descripción del nivel" maxlength="50" required>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarNivel" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modal Profesión -->
        <div class="modal fade" id="modalProfesion" tabindex="-1" aria-labelledby="modalProfesionLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalProfesionLabel">
                            <i class="fas fa-briefcase me-2"></i>Nueva Profesión
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formProfesion">
                            <input type="hidden" id="hdnIDProfesion" />
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoProfesion" class="form-label">Código <span class="text-danger">*</span></label>
                                        <input type="number" id="txtCodigoProfesion" class="form-control" placeholder="Código de la profesión" min="1" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtDescripcionProfesion" class="form-label">Descripción <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcionProfesion" class="form-control" placeholder="Descripción de la profesión" maxlength="100" required>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarProfesion" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Empresa -->
        <div class="modal fade" id="modalEmpresa" tabindex="-1" aria-labelledby="modalEmpresaLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalEmpresaLabel">
                            <i class="fas fa-building me-2"></i>Nueva Empresa
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formEmpresa">
                            <input type="hidden" id="hdnIDEmpresa" />
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoEmpresa" class="form-label">Código <span class="text-danger">*</span></label>
                                        <input type="number" id="txtCodigoEmpresa" class="form-control" placeholder="Código de la empresa" min="1" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtDescripcionEmpresa" class="form-label">Descripción <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcionEmpresa" class="form-control" placeholder="Descripción de la empresa" maxlength="100" required>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarEmpresa" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Ocupación -->
        <div class="modal fade" id="modalOcupacion" tabindex="-1" aria-labelledby="modalOcupacionLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalOcupacionLabel">
                            <i class="fas fa-user-tie me-2"></i>Nueva Ocupación
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formOcupacion">
                            <input type="hidden" id="hdnIDOcupacion" />
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoOcupacion" class="form-label">Código <span class="text-danger">*</span></label>
                                        <input type="number" id="txtCodigoOcupacion" class="form-control" placeholder="Código de la ocupación" min="1" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtDescripcionOcupacion" class="form-label">Descripción <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcionOcupacion" class="form-control" placeholder="Descripción de la ocupación" maxlength="100" required>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarOcupacion" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal País -->
        <div class="modal fade" id="modalPais" tabindex="-1" aria-labelledby="modalPaisLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalPaisLabel">
                            <i class="fas fa-globe me-2"></i>Nuevo País
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formPais">
                            <input type="hidden" id="hdnIDPais" />
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoISOPais" class="form-label">Código ISO <span class="text-danger">*</span></label>
                                        <input type="text" id="txtCodigoISOPais" class="form-control" placeholder="Ej: PA" maxlength="3" style="text-transform: uppercase;" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtDescripcionPais" class="form-label">País <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcionPais" class="form-control" placeholder="Nombre del país" maxlength="100" required>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarPais" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Provincia -->
        <div class="modal fade" id="modalProvincia" tabindex="-1" aria-labelledby="modalProvinciaLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalProvinciaLabel">
                            <i class="fas fa-map me-2"></i>Nueva Provincia
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formProvincia">
                            <input type="hidden" id="hdnIDProvincia" />
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoProvincia" class="form-label">Código <span class="text-danger">*</span></label>
                                        <input type="number" id="txtCodigoProvincia" class="form-control" placeholder="Código de la provincia" min="1" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="ddlPaisProvincia" class="form-label">País <span class="text-danger">*</span></label>
                                        <select id="ddlPaisProvincia" class="form-select" required>
                                            <option value="">Seleccionar país...</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label for="txtDescripcionProvincia" class="form-label">Provincia <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcionProvincia" class="form-control" placeholder="Nombre de la provincia" maxlength="100" required>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarProvincia" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Distrito -->
        <div class="modal fade" id="modalDistrito" tabindex="-1" aria-labelledby="modalDistritoLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalDistritoLabel">
                            <i class="fas fa-map-marked-alt me-2"></i>Nuevo Distrito
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formDistrito">
                            <input type="hidden" id="hdnIDDistrito" />
                            <input type="hidden" id="txtCodigoDistrito" />
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="ddlPaisDistrito" class="form-label">País <span class="text-danger">*</span></label>
                                        <select id="ddlPaisDistrito" class="form-select" required>
                                            <option value="">Seleccionar país...</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="ddlProvinciaDistrito" class="form-label">Provincia <span class="text-danger">*</span></label>
                                        <select id="ddlProvinciaDistrito" class="form-select" required>
                                            <option value="">Seleccionar provincia...</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label for="txtDescripcionDistrito" class="form-label">Distrito <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcionDistrito" class="form-control" placeholder="Nombre del distrito" maxlength="100" required>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarDistrito" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Corregimiento -->
        <div class="modal fade" id="modalCorregimiento" tabindex="-1" aria-labelledby="modalCorregimientoLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalCorregimientoLabel">
                            <i class="fas fa-map-pin me-2"></i>Nuevo Corregimiento
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formCorregimiento">
                            <input type="hidden" id="hdnIDCorregimiento" />
                            <input type="hidden" id="txtCodigoCorregimiento" />
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="ddlPaisCorregimiento" class="form-label">País <span class="text-danger">*</span></label>
                                        <select id="ddlPaisCorregimiento" class="form-select" required>
                                            <option value="">Seleccionar país...</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="ddlProvinciaCorregimiento" class="form-label">Provincia <span class="text-danger">*</span></label>
                                        <select id="ddlProvinciaCorregimiento" class="form-select" required>
                                            <option value="">Seleccionar provincia...</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="ddlDistritoCorregimiento" class="form-label">Distrito <span class="text-danger">*</span></label>
                                        <select id="ddlDistritoCorregimiento" class="form-select" required>
                                            <option value="">Seleccionar distrito...</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label for="txtDescripcionCorregimiento" class="form-label">Corregimiento <span class="text-danger">*</span></label>
                                        <input type="text" id="txtDescripcionCorregimiento" class="form-control" placeholder="Nombre del corregimiento" maxlength="100" required>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancelar
                        </button>
                        <button type="button" id="btnGuardarCorregimiento" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal Cuenta -->
        <div class="modal fade" id="modalCuenta" tabindex="-1" aria-labelledby="modalCuentaLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalCuentaLabel">
                            <i class="fas fa-wallet me-2"></i>Nueva Cuenta
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formCuenta">
                            <input type="hidden" id="hdnIDCuenta" />
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="ddlGrupoCuenta" class="form-label">Grupo <span class="text-danger">*</span></label>
                                        <select id="ddlGrupoCuenta" class="form-select" required>
                                            <option value="">Seleccionar grupo...</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="txtCodigoCuenta" class="form-label">Cuenta <span class="text-danger">*</span></label>
                                        <input type="text" id="txtCodigoCuenta" class="form-control" placeholder="Número de cuenta" maxlength="50" required>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label for="txtNombreCuenta" class="form-label">Nombre <span class="text-danger">*</span></label>
                                        <input type="text" id="txtNombreCuenta" class="form-control" placeholder="Nombre de la cuenta" maxlength="255" required>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" id="chkSnImputableCuenta" checked>
                                            <label class="form-check-label" for="chkSnImputableCuenta">Imputable</label>
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
                        <button type="button" id="btnGuardarCuenta" class="btn btn-primary">
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
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script src="../../Scripts/smart-chips.js"></script>
    <script>
		// Permisos de menú: mostrar solo opciones del sidebar (y sus tab-pane) permitidas; ocultar títulos de categoría sin ítems visibles
		(function() {
			var permisosMenuAdmin = <%= If(PermisosMenuAdminValue, "true", "false") %>;
			var permisosMenuUrls = <%= PermisosMenuUrlsJsonValue %>;
			$(document).ready(function() {
				document.querySelectorAll('.sidebar-item[data-url]').forEach(function(el) {
					var url = el.getAttribute('data-url');
					if (!url) return;
					var permitido = permisosMenuAdmin || (permisosMenuUrls === true) || (Array.isArray(permisosMenuUrls) && permisosMenuUrls.indexOf(url) !== -1);
					if (!permitido) {
						el.style.display = 'none';
						var idx = url.indexOf('#');
						var tabId = idx >= 0 ? url.substring(idx + 1) : '';
						if (tabId) {
							var tabPane = document.getElementById(tabId);
							if (tabPane) tabPane.style.display = 'none';
						}
					}
				});
				// Ocultar títulos (h4) de categoría que no tienen ningún ítem visible debajo
				var menu = document.getElementById('sidebarMenu');
				if (menu) {
					var h4s = menu.querySelectorAll('h4');
					h4s.forEach(function(h4) {
						var next = h4.nextElementSibling;
						var hasVisible = false;
						while (next && !next.matches('h4')) {
							if (next.classList.contains('sidebar-item') && next.style.display !== 'none') hasVisible = true;
							next = next.nextElementSibling;
						}
						if (!hasVisible) h4.style.display = 'none';
					});
				}
			});
		})();

		$(document).ready(function () {
			// Configurar tooltips del sidebar
			configurarTooltipsSidebar();
			
			// Inicializar monitoreo de inactividad
			if (typeof initializeInactivityMonitoring === 'function') {
				initializeInactivityMonitoring();
			}
		});

		// Mapeo de IDs de tabs a nombres descriptivos
		const maintenanceNames = {
			'codigos-transacciones': 'Códigos Transacción',
			'rubros': 'Rubros',
			'tipos-auxiliares': 'Tipos Auxiliares',
			'roles': 'Roles de Usuario',
			'departamentos': 'Departamentos',
			'tipo-identificacion': 'Tipo Identificación',
			'tipo-asociados': 'Tipo Asociados',
			'parentezcos': 'Parentezcos',
			'estatus-asociados': 'Estatus Asociados',
			'niveles-estudio': 'Niveles de Estudio',
			'profesiones': 'Profesiones',
			'ocupaciones': 'Ocupaciones',
			'empresas': 'Empresas',
			'paises': 'Países',
			'provincias': 'Provincias',
			'distritos': 'Distritos',
			'corregimientos': 'Corregimientos',
			'cuentas': 'Cuentas'
		};

		// Función para actualizar el nombre del mantenimiento en el header
		function actualizarNombreMantenimiento(tabId) {
			const maintenanceName = maintenanceNames[tabId];
			const $maintenanceNameSpan = $('#currentMaintenanceName');

			if (maintenanceName) {
				$maintenanceNameSpan.text('> ' + maintenanceName).show();
			} else {
				$maintenanceNameSpan.hide();
			}
		}

		// Función para mostrar un tab desde el sidebar
		function showTab(tabId, event) {
			// Prevenir propagación si hay evento
			if (event) {
				event.stopPropagation();
			}

			// Expandir el sidebar si está colapsado (solo cuando se hace clic en un item del menú)
			expandSidebarIfCollapsed();

			// Verificar si el tab-pane existe
			const tabPane = $('#' + tabId);
			if (tabPane.length === 0) {
				return;
			}

			// Actualizar el nombre del mantenimiento en el header
			actualizarNombreMantenimiento(tabId);

			// Ocultar el banner de selección
			$('#bannerSeleccion').addClass('hidden');

			// Mostrar el tab-content con flexbox
			$('#mantenimientosTabContent').css('display', 'flex');

			// Ocultar todos los tab-panes
			$('.tab-pane').removeClass('show active');

			// Activar el tab-pane correspondiente
			tabPane.addClass('show active');

			// Actualizar items del sidebar
			$('.sidebar-item').removeClass('active');
			const sidebarItem = $('#sidebar-' + tabId);
			if (sidebarItem.length) {
				sidebarItem.addClass('active');
			}

			// Activar el tab de Bootstrap si existe
			const tabButton = $('button[data-bs-target="#' + tabId + '"]');
			if (tabButton.length) {
				const tab = new bootstrap.Tab(tabButton[0]);
				tab.show();
			}

			// Cargar datos del tab según el ID (lazy loading)
			inicializarTabSeleccionado(tabId);
		}

		// Función para inicializar el tab seleccionado
		function inicializarTabSeleccionado(tabId) {
			switch (tabId) {
				case 'codigos-transacciones':
					if (!window.codigosTransaccionInicializado) {
						mostrarLoading('tblCodigosTransaccion');
						inicializarCodigosTransaccion();
						window.codigosTransaccionInicializado = true;
					}
					break;
				case 'departamentos':
					if (!window.departamentosInicializado) {
						mostrarLoading('tblDepartamentos');
						inicializarDepartamentos();
						window.departamentosInicializado = true;
					}
					break;
				case 'parentezcos':
					if (!window.parentezcosInicializado) {
						mostrarLoading('tblParentezcos');
						inicializarParentezcos();
						window.parentezcosInicializado = true;
					}
					break;
				case 'roles':
					if (!window.rolesInicializado) {
						mostrarLoading('tblRoles');
						inicializarRoles();
						window.rolesInicializado = true;
					}
					break;
				case 'rubros':
					if (!window.rubrosInicializado) {
						mostrarLoading('tblRubros');
						inicializarRubros();
						window.rubrosInicializado = true;
					}
					break;
				case 'estatus-asociados':
					if (!window.statusAsociadosInicializado) {
						mostrarLoading('tblStatus');
						inicializarStatusAsociados();
						window.statusAsociadosInicializado = true;
					}
					break;
				case 'tipo-asociados':
					if (!window.tipoAsociadosInicializado) {
						mostrarLoading('tblTipoAsociado');
						inicializarTipoAsociados();
						window.tipoAsociadosInicializado = true;
					}
					break;
				case 'tipo-identificacion':
					if (!window.tipoDocumentosInicializado) {
						mostrarLoading('tblTipoDocumentos');
						inicializarTipoDocumentos();
						window.tipoDocumentosInicializado = true;
					}
					break;
				case 'tipos-auxiliares':
					if (!window.tiposAuxiliaresInicializado) {
						mostrarLoading('tblTiposAuxiliares');
						inicializarTiposAuxiliares();
						window.tiposAuxiliaresInicializado = true;
					}
					break;
				case 'niveles-estudio':
					if (!window.nivelesEstudioInicializado) {
						mostrarLoading('tblNivelesEstudio');
						inicializarNivelesEstudio();
						window.nivelesEstudioInicializado = true;
					}
					break;
				case 'profesiones':
					if (!window.profesionesInicializado) {
						mostrarLoading('tblProfesiones');
						inicializarProfesiones();
						window.profesionesInicializado = true;
					}
					break;
				case 'empresas':
					if (!window.empresasInicializado) {
						mostrarLoading('tblEmpresas');
						inicializarEmpresas();
						window.empresasInicializado = true;
					}
					break;
				case 'ocupaciones':
					if (!window.ocupacionesInicializado) {
						mostrarLoading('tblOcupaciones');
						inicializarOcupaciones();
						window.ocupacionesInicializado = true;
					}
					break;
				case 'paises':
					if (!window.paisesInicializado) {
						inicializarPaises();
						window.paisesInicializado = true;
					}
					break;
				case 'provincias':
					if (!window.provinciasInicializado) {
						inicializarProvincias();
						window.provinciasInicializado = true;
					}
					break;
				case 'distritos':
					if (!window.distritosInicializado) {
						inicializarDistritos();
						window.distritosInicializado = true;
					}
					break;
				case 'corregimientos':
					if (!window.corregimientosInicializado) {
						inicializarCorregimientos();
						window.corregimientosInicializado = true;
					}
					break;
				case 'cuentas':
					if (!window.cuentasInicializado) {
						inicializarCuentas();
						window.cuentasInicializado = true;
					}
					break;
			}
		}

		// Variable para prevenir toggle múltiple
		let sidebarToggling = false;

		// Toggle sidebar
		function toggleSidebar(event) {
			// Prevenir toggle múltiple simultáneo
			if (sidebarToggling) {
				return false;
			}

			sidebarToggling = true;

			// Prevenir propagación del evento y cualquier comportamiento por defecto
			if (event) {
				event.preventDefault();
				event.stopPropagation();
				event.stopImmediatePropagation();
			}

			const sidebar = $('#sidebarMenu');
			const toggleIcon = $('#toggleIcon');

			// Verificar el estado actual
			const isCollapsed = sidebar.hasClass('collapsed');

			// Toggle del estado inmediatamente
			if (isCollapsed) {
				sidebar.removeClass('collapsed');
				toggleIcon.removeClass('fa-chevron-right').addClass('fa-chevron-left');
			} else {
				sidebar.addClass('collapsed');
				toggleIcon.removeClass('fa-chevron-left').addClass('fa-chevron-right');
			}

			// Guardar el estado en localStorage para persistencia
			localStorage.setItem('sidebarCollapsed', !isCollapsed);

			// Permitir toggle nuevamente después de un breve delay
			setTimeout(function () {
				sidebarToggling = false;
			}, 300);

			// Retornar false para evitar cualquier comportamiento por defecto
			return false;
		}

		// Configurar tooltips para menú colapsado
		function configurarTooltipsSidebar() {
			$(document).off('mouseenter', '.sidebar-menu.collapsed .sidebar-item');
			$(document).off('mouseleave', '.sidebar-menu.collapsed .sidebar-item');
			
			$(document).on('mouseenter', '.sidebar-menu.collapsed .sidebar-item', function(e) {
				const $item = $(this);
				const $tooltip = $item.find('.sidebar-tooltip');
				if ($tooltip.length) {
					const itemOffset = $item.offset();
					const itemHeight = $item.outerHeight();
					const tooltipHeight = $tooltip.outerHeight();
					
					$tooltip.css({
						left: (itemOffset.left + $item.outerWidth() + 12) + 'px',
						top: (itemOffset.top + (itemHeight / 2) - (tooltipHeight / 2)) + 'px'
					}).addClass('show');
				}
			});
			
			$(document).on('mouseleave', '.sidebar-menu.collapsed .sidebar-item', function(e) {
				$(this).find('.sidebar-tooltip').removeClass('show');
			});
		}

		// Función para expandir el sidebar si está colapsado cuando se hace clic en un item
		function expandSidebarIfCollapsed() {
			const sidebar = $('#sidebarMenu');
			if (sidebar.hasClass('collapsed')) {
				sidebar.removeClass('collapsed');
				$('#toggleIcon').removeClass('fa-chevron-right').addClass('fa-chevron-left');
				localStorage.setItem('sidebarCollapsed', false);
			}
		}

		// Filtrar sidebar por búsqueda
		function filterSidebar() {
			const searchTerm = document.getElementById('sidebarSearch').value.toLowerCase().trim();
			const items = document.querySelectorAll('#sidebarMenu .sidebar-item');
			const categories = document.querySelectorAll('#sidebarMenu h4');

			if (searchTerm === '') {
				// Mostrar todos los elementos
				items.forEach(item => {
					item.classList.remove('hidden');
				});
				categories.forEach(category => {
					category.classList.remove('hidden');
				});
				return;
			}

			// Filtrar elementos
			items.forEach(item => {
				const searchText = item.getAttribute('data-search') || '';
				const itemText = item.querySelector('span')?.textContent.toLowerCase() || '';

				if (searchText.includes(searchTerm) || itemText.includes(searchTerm)) {
					item.classList.remove('hidden');
				} else {
					item.classList.add('hidden');
				}
			});

			// Mostrar/ocultar categorías según si tienen items visibles
			categories.forEach(category => {
				let hasVisible = false;
				let nextElement = category.nextElementSibling;

				// Buscar items visibles hasta el siguiente h4
				while (nextElement && nextElement.tagName !== 'H4') {
					if (nextElement.classList.contains('sidebar-item') && !nextElement.classList.contains('hidden')) {
						hasVisible = true;
						break;
					}
					nextElement = nextElement.nextElementSibling;
				}

				if (hasVisible) {
					category.classList.remove('hidden');
				} else {
					category.classList.add('hidden');
				}
			});
		}

		// Inicializar tabs (mantener compatibilidad con código existente)
		var triggerTabList = [].slice.call(document.querySelectorAll('button[data-bs-toggle="tab"]'));
		triggerTabList.forEach(function (triggerEl) {
			var tabTrigger = new bootstrap.Tab(triggerEl);

			triggerEl.addEventListener('click', function (event) {
				event.preventDefault();
				tabTrigger.show();

				// Actualizar el sidebar cuando se hace clic en un tab
				const targetId = triggerEl.getAttribute('data-bs-target').replace('#', '');
				$('.sidebar-item').removeClass('active');
				$('#sidebar-' + targetId).addClass('active');
			});
		});

		// Inicializar eventos de tabs para carga bajo demanda
		inicializarTabsLazyLoading();

		function volverDashboard() {
			window.location.href = 'dashboardSistemas.aspx';
		}

		// ===== CARGA BAJO DEMANDA DE TABS =====
		function inicializarTabsLazyLoading() {
			// Eventos para tabs
			$('#codigos-transaccion-tab').on('click', function () {
				if (!window.codigosTransaccionInicializado) {
					mostrarLoading('tblCodigosTransaccion');
					inicializarCodigosTransaccion();
					window.codigosTransaccionInicializado = true;
				}
			});

			$('#departamentos-tab').on('click', function () {
				if (!window.departamentosInicializado) {
					mostrarLoading('tblDepartamentos');
					inicializarDepartamentos();
					window.departamentosInicializado = true;
				}
			});

			$('#parentezcos-tab').on('click', function () {
				if (!window.parentezcosInicializado) {
					mostrarLoading('tblParentezcos');
					inicializarParentezcos();
					window.parentezcosInicializado = true;
				}
			});

			$('#roles-tab').on('click', function () {
				if (!window.rolesInicializado) {
					mostrarLoading('tblRoles');
					inicializarRoles();
					window.rolesInicializado = true;
				}
			});

			$('#rubros-tab').on('click', function () {
				if (!window.rubrosInicializado) {
					mostrarLoading('tblRubros');
					inicializarRubros();
					window.rubrosInicializado = true;
				}
			});

			$('#estatus-asociados-tab').on('click', function () {
				if (!window.statusAsociadosInicializado) {
					mostrarLoading('tblStatus');
					inicializarStatusAsociados();
					window.statusAsociadosInicializado = true;
				}
			});

			$('#tipo-asociados-tab').on('click', function () {
				if (!window.tipoAsociadosInicializado) {
					mostrarLoading('tblTipoAsociado');
					inicializarTipoAsociados();
					window.tipoAsociadosInicializado = true;
				}
			});

			$('#tipo-identificacion-tab').on('click', function () {
				if (!window.tipoDocumentosInicializado) {
					mostrarLoading('tblTipoDocumentos');
					inicializarTipoDocumentos();
					window.tipoDocumentosInicializado = true;
				}
			});

			$('#tipos-auxiliares-tab').on('click', function () {
				if (!window.tiposAuxiliaresInicializado) {
					mostrarLoading('tblTiposAuxiliares');
					inicializarTiposAuxiliares();
					window.tiposAuxiliaresInicializado = true;
				}
			});

			$('#niveles-estudio-tab').on('click', function () {
				if (!window.nivelesEstudioInicializado) {
					mostrarLoading('tblNivelesEstudio');
					inicializarNivelesEstudio();
					window.nivelesEstudioInicializado = true;
				}
			});

			$('#profesiones-tab').on('click', function () {
				if (!window.profesionesInicializado) {
					mostrarLoading('tblProfesiones');
					inicializarProfesiones();
					window.profesionesInicializado = true;
				}
			});

			$('#empresas-tab').on('click', function () {
				if (!window.empresasInicializado) {
					mostrarLoading('tblEmpresas');
					inicializarEmpresas();
					window.empresasInicializado = true;
				}
			});

			$('#ocupaciones-tab').on('click', function () {
				if (!window.ocupacionesInicializado) {
					mostrarLoading('tblOcupaciones');
					inicializarOcupaciones();
					window.ocupacionesInicializado = true;
				}
			});

			$('#usuarios-tab').on('click', function () {
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
			$('#btnNuevoCodigo').on('click', function () {
				abrirModalCodigoTransaccion();
			});

			$('#btnBuscarCodigos').on('click', function () {
				cargarCodigosTransaccion();
			});

			$('#btnLimpiarFiltros').on('click', function () {
				limpiarFiltros();
			});

			$('#btnGuardarCodigoTransaccion').on('click', function () {
				guardarCodigoTransaccion();
			});

			// Evento cuando cambia el rubro en el modal
			$('#ddlCodigoRubro').on('change', function () {
				const codigoRubro = $(this).val();
				cargarTiposAuxiliaresPorRubro(codigoRubro);
				// Limpiar selección de tipo auxiliar cuando cambia el rubro
				$('#ddlTipoAuxiliar').val('').removeClass('is-invalid');
			});

			// Búsqueda en tiempo real
			$('#txtFiltroCodigo, #txtFiltroDescripcion').on('keyup', function () {
				clearTimeout(window.busquedaTimeout);
				window.busquedaTimeout = setTimeout(function () {
					cargarCodigosTransaccion();
				}, 500);
			});
		}

		function configurarEventosDepartamentos() {
			$('#btnNuevoDepartamento').on('click', function () {
				abrirModalDepartamento();
			});

			$('#btnBuscarDepartamentos').on('click', function () {
				cargarDepartamentos();
			});

			$('#btnLimpiarFiltrosDepartamento').on('click', function () {
				limpiarFiltrosDepartamento();
			});

			$('#btnGuardarDepartamento').on('click', function () {
				guardarDepartamento();
			});

			// Búsqueda en tiempo real
			$('#txtFiltroNombreDepartamento, #txtFiltroResponsableDepartamento').on('keyup', function () {
				clearTimeout(window.busquedaDepartamentoTimeout);
				window.busquedaDepartamentoTimeout = setTimeout(function () {
					cargarDepartamentos();
				}, 500);
			});
		}

		function configurarEventosParentezcos() {
			$('#btnNuevoParentezco').on('click', function () {
				abrirModalParentezco();
			});

			$('#btnBuscarParentezcos').on('click', function () {
				cargarParentezcos();
			});

			$('#btnLimpiarFiltrosParentezco').on('click', function () {
				limpiarFiltrosParentezco();
			});

			$('#btnGuardarParentezco').on('click', function () {
				guardarParentezco();
			});

			// Búsqueda en tiempo real
			$('#txtFiltroParentezco').on('keyup', function () {
				clearTimeout(window.busquedaParentezcoTimeout);
				window.busquedaParentezcoTimeout = setTimeout(function () {
					cargarParentezcos();
				}, 500);
			});
		}

		function configurarEventosRoles() {
			$('#btnNuevoRol').on('click', function () {
				abrirModalRol();
			});

			$('#btnBuscarRoles').on('click', function () {
				cargarRoles();
			});

			$('#btnLimpiarFiltrosRol').on('click', function () {
				limpiarFiltrosRol();
			});

			$('#btnGuardarRol').on('click', function () {
				guardarRol();
			});

			// Búsqueda en tiempo real
			$('#txtFiltroNombreRol, #ddlFiltroNivelAcceso, #ddlFiltroEstadoRol').on('keyup change', function () {
				clearTimeout(window.busquedaRolTimeout);
				window.busquedaRolTimeout = setTimeout(function () {
					cargarRoles();
				}, 500);
			});
		}

		function configurarEventosRubros() {
			$('#btnNuevoRubro').on('click', function () {
				abrirModalRubro();
			});

			$('#btnBuscarRubros').on('click', function () {
				cargarRubrosTab();
			});

			$('#btnLimpiarFiltrosRubro').on('click', function () {
				limpiarFiltrosRubro();
			});

			$('#btnGuardarRubro').on('click', function () {
				guardarRubro();
			});

			// Búsqueda en tiempo real
			$('#txtFiltroCodigoRubro, #txtFiltroDescripcionRubro').on('keyup', function () {
				clearTimeout(window.busquedaRubroTimeout);
				window.busquedaRubroTimeout = setTimeout(function () {
					cargarRubrosTab();
				}, 500);
			});
		}

		function configurarEventosStatusAsociados() {
			$('#btnNuevoStatus').on('click', function () {
				abrirModalStatus();
			});

			$('#btnBuscarStatus').on('click', function () {
				cargarStatusAsociados();
			});

			$('#btnLimpiarFiltrosStatus').on('click', function () {
				limpiarFiltrosStatus();
			});

			$('#btnGuardarStatus').on('click', function () {
				guardarStatus();
			});

			// Búsqueda en tiempo real
			$('#txtFiltroCodigoStatus, #txtFiltroDescripcionStatus').on('keyup', function () {
				clearTimeout(window.busquedaStatusTimeout);
				window.busquedaStatusTimeout = setTimeout(function () {
					cargarStatusAsociados();
				}, 500);
			});
		}

		function configurarEventosTipoAsociados() {
			$('#btnNuevoTipoAsociado').on('click', function () {
				abrirModalTipoAsociado();
			});

			$('#btnBuscarTipoAsociado').on('click', function () {
				cargarTipoAsociados();
			});

			$('#btnLimpiarFiltrosTipoAsociado').on('click', function () {
				limpiarFiltrosTipoAsociado();
			});

			$('#btnGuardarTipoAsociado').on('click', function () {
				guardarTipoAsociado();
			});

			// Búsqueda en tiempo real
			$('#txtFiltroCodigoTipoAsociado, #txtFiltroTipoAsociado').on('keyup', function () {
				clearTimeout(window.busquedaTipoAsociadoTimeout);
				window.busquedaTipoAsociadoTimeout = setTimeout(function () {
					cargarTipoAsociados();
				}, 500);
			});
		}

		function configurarEventosTipoDocumentos() {
			$('#btnNuevoTipoDoc').on('click', function () {
				abrirModalTipoDoc();
			});

			$('#btnBuscarTipoDoc').on('click', function () {
				cargarTipoDocumentos();
			});

			$('#btnLimpiarFiltrosTipoDoc').on('click', function () {
				limpiarFiltrosTipoDoc();
			});

			$('#btnGuardarTipoDoc').on('click', function () {
				guardarTipoDoc();
			});

			// Búsqueda en tiempo real
			$('#txtFiltroCodigoTipoDoc, #txtFiltroTipoDocumento').on('keyup', function () {
				clearTimeout(window.busquedaTipoDocTimeout);
				window.busquedaTipoDocTimeout = setTimeout(function () {
					cargarTipoDocumentos();
				}, 500);
			});
		}

		// ===== FUNCIONALIDAD CÓDIGOS DE TRANSACCIÓN =====
		function inicializarCodigosTransaccion() {
			// Cargar rubros para filtro y modal
			cargarRubros();

			// Cargar cuentas para dropdowns
			cargarCuentasParaDropdown().always(function () {
				// Cargar datos iniciales
				cargarCodigosTransaccion();
			});

			// Configurar eventos
			configurarEventosCodigosTransaccion();

			$('#ddlFiltroRubro, #ddlFiltroEstado').on('change', function () {
				cargarCodigosTransaccion();
			});
		}

		function cargarCuentasParaDropdown() {
			return $.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerCuentasParaDropdown",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const cuentas = JSON.parse(responseData.Datos);
						llenarDropdownCuentas(cuentas);
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al cargar cuentas');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al cargar cuentas');
				}
			});
		}
		let catalogoCuentas = {};

		function llenarDropdownCuentas(cuentas) {
			const $ddlCuentaContable = $('#ddlCuentaContable');
			const $ddlContraCuenta = $('#ddlContraCuenta');

			catalogoCuentas = {};

			// Destruir Select2 si ya está inicializado
			if ($.fn.select2) {
				if ($ddlCuentaContable.hasClass('select2-hidden-accessible')) {
					$ddlCuentaContable.select2('destroy');
				}
				if ($ddlContraCuenta.hasClass('select2-hidden-accessible')) {
					$ddlContraCuenta.select2('destroy');
				}
			}

			$ddlCuentaContable.empty().append('<option value="">Seleccionar cuenta...</option>');
			$ddlContraCuenta.empty().append('<option value="">Seleccionar cuenta...</option>');

			cuentas.forEach(function (cuenta) {
				catalogoCuentas[cuenta.Cuenta] = cuenta.NombreCuenta;
				const option = `<option value="${cuenta.Cuenta}">${cuenta.NombreCuenta}</option>`;
				$ddlCuentaContable.append(option);
				$ddlContraCuenta.append(option);
			});
		}

		function obtenerDescripcionCuenta(cuentaCodigo) {
			if (!cuentaCodigo) {
				return '-';
			}

			if (catalogoCuentas && catalogoCuentas[cuentaCodigo]) {
				return catalogoCuentas[cuentaCodigo];
			}

			return cuentaCodigo;
		}
		// Variable global para almacenar rubros con sus tipos de auxiliares
		let catalogoRubros = {};

		function cargarRubros() {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerRubros",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const rubros = JSON.parse(response.d.Datos);

						// Almacenar rubros con sus tipos de auxiliares
						catalogoRubros = {};
						$.each(rubros, function (index, rubro) {
							catalogoRubros[rubro.CodigoRubro] = {
								CodigoRubro: rubro.CodigoRubro,
								Descripcion: rubro.Descripcion,
								JsonTiposAuxiliares: rubro.JsonTiposAuxiliares || "[]"
							};
						});

						// Llenar dropdown de filtro
						$('#ddlFiltroRubro').empty().append('<option value="">Todos los rubros</option>');
						$.each(rubros, function (index, rubro) {
							$('#ddlFiltroRubro').append(`<option value="${rubro.CodigoRubro}">${rubro.CodigoRubro} - ${rubro.Descripcion}</option>`);
						});

						// Llenar dropdown del modal
						$('#ddlCodigoRubro').empty().append('<option value="">Seleccionar rubro...</option>');
						$.each(rubros, function (index, rubro) {
							$('#ddlCodigoRubro').append(`<option value="${rubro.CodigoRubro}">${rubro.CodigoRubro} - ${rubro.Descripcion}</option>`);
						});
					}
				},
				error: function (xhr, status, error) {
					showToast('error', 'Error', 'Error al cargar rubros: ' + error);
				}
			});
		}

		function cargarTiposAuxiliaresPorRubro(codigoRubro) {
			const $ddlTipoAuxiliar = $('#ddlTipoAuxiliar');
			$ddlTipoAuxiliar.empty().append('<option value="">Seleccionar tipo auxiliar...</option>');

			if (!codigoRubro || !catalogoRubros[codigoRubro]) {
				return;
			}

			try {
				const jsonTiposAuxiliares = catalogoRubros[codigoRubro].JsonTiposAuxiliares;
				const tiposAuxiliares = JSON.parse(jsonTiposAuxiliares);

				if (Array.isArray(tiposAuxiliares) && tiposAuxiliares.length > 0) {
					$.each(tiposAuxiliares, function (index, tipo) {
						$ddlTipoAuxiliar.append(`<option value="${tipo.IDAuxiliar}">${tipo.DescripcionAuxiliar}</option>`);
					});
				} else {
					$ddlTipoAuxiliar.append('<option value="">No hay tipos de auxiliares disponibles</option>');
				}
			} catch (e) {
				console.error('Error al parsear JsonTiposAuxiliares:', e);
				showToast('warning', 'Advertencia', 'Error al cargar tipos de auxiliares para este rubro');
			}
		}

		function cargarCodigosTransaccion() {

			const filtros = {
				CodigoRubro: $('#ddlFiltroRubro').val(),
				CodigoTransaccion: $('#txtFiltroCodigo').val(),
				Descripcion: $('#txtFiltroDescripcion').val(),
				SnActivo: $('#ddlFiltroEstado').val() === '' ? null : $('#ddlFiltroEstado').val() === '1'
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarCodigosTransaccion",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const codigos = JSON.parse(response.d.Datos);
						mostrarCodigosTransaccion(codigos);
					} else {
						mostrarCodigosTransaccion([]);
						showToast('warning', 'Advertencia', response.d.Mensaje || 'No se encontraron datos');
					}
				},
				error: function (xhr, status, error) {
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
                        <td colspan="9" class="text-center text-muted">
                            <i class="fas fa-info-circle me-2"></i>No hay datos disponibles
                        </td>
                    </tr>
                `);
				return;
			}

			$.each(codigos, function (index, codigo) {
				const estadoBadge = codigo.SnActivo ?
					'<span class="badge bg-success">Activo</span>' :
					'<span class="badge bg-secondary">Inactivo</span>';

				const cuentaContableTexto = obtenerDescripcionCuenta(codigo.CuentaContable);
				const contraCuentaTexto = obtenerDescripcionCuenta(codigo.ContraCuenta);
				const descripcionAuxiliar = codigo.DescripcionAuxiliar || '-';

				const row = `
                    <tr>
                        <td>${codigo.ID}</td>
                        <td>${crearChipRubroInteligente(codigo.CodigoRubro, codigo.DescripcionRubro)}</td>
                        <td>${descripcionAuxiliar}</td>
                        <td><strong>${codigo.CodigoTransaccion}</strong></td>
                        <td>${codigo.Descripcion}</td>
                        <td>${cuentaContableTexto}</td>
                        <td>${contraCuentaTexto}</td>
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

			// Asegurar que las cuentas estén cargadas antes de mostrar el modal
			if ($('#ddlCuentaContable option').length <= 1) {
				cargarCuentasParaDropdown().then(function () {
					// Mostrar modal después de cargar cuentas
					const modal = new bootstrap.Modal(document.getElementById('modalCodigoTransaccion'));
					modal.show();

					$('#modalCodigoTransaccion').one('shown.bs.modal', function () {
						reinicializarSelect2Cuentas();
						$('#txtCodigoTransaccion').focus();
					});
				});
			} else {
				// Mostrar modal
				const modal = new bootstrap.Modal(document.getElementById('modalCodigoTransaccion'));
				modal.show();

				// Enfocar el campo Código después de que el modal se muestre
				$('#modalCodigoTransaccion').one('shown.bs.modal', function () {
					reinicializarSelect2Cuentas();
					$('#txtCodigoTransaccion').focus();
				});
			}
		}

		function editarCodigoTransaccion(id) {
			// Asegurar que las cuentas estén cargadas antes de abrir el modal
			if ($('#ddlCuentaContable option').length <= 1) {
				cargarCuentasParaDropdown().then(function () {
					cargarDatosCodigoTransaccion(id);
				});
			} else {
				cargarDatosCodigoTransaccion(id);
			}
		}
		function cargarDatosCodigoTransaccion(id) {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerCodigoTransaccion",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ id: id }),
				dataType: "json",
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const codigo = JSON.parse(response.d.Datos);
						llenarFormularioCodigoTransaccion(codigo);
						$('#modalCodigoTransaccionLabel').html('<i class="fas fa-exchange-alt me-2"></i>Editar Código de Transacción');

						// Mostrar modal
						const modal = new bootstrap.Modal(document.getElementById('modalCodigoTransaccion'));
						modal.show();

						// Reinicializar Select2 cuando se abre el modal
						$('#modalCodigoTransaccion').one('shown.bs.modal', function () {
							reinicializarSelect2Cuentas();
						});
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al cargar datos');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al cargar datos del código de transacción');
				}
			});
		}

		function reinicializarSelect2Cuentas() {
			if ($.fn.select2) {
				const $ddlCuentaContable = $('#ddlCuentaContable');
				const $ddlContraCuenta = $('#ddlContraCuenta');

				// Destruir Select2 existente si está inicializado
				if ($ddlCuentaContable.hasClass('select2-hidden-accessible')) {
					$ddlCuentaContable.select2('destroy');
				}
				if ($ddlContraCuenta.hasClass('select2-hidden-accessible')) {
					$ddlContraCuenta.select2('destroy');
				}

				// Reinicializar Select2
				$ddlCuentaContable.select2({
					theme: 'bootstrap-5',
					placeholder: 'Seleccionar cuenta...',
					allowClear: true,
					width: '100%',
					dropdownParent: $('#modalCodigoTransaccion')
				});

				$ddlContraCuenta.select2({
					theme: 'bootstrap-5',
					placeholder: 'Seleccionar cuenta...',
					allowClear: true,
					width: '100%',
					dropdownParent: $('#modalCodigoTransaccion')
				});
			}
		}

		function llenarFormularioCodigoTransaccion(codigo) {
			// Verificar que los elementos existen antes de llenarlos
			if ($('#txtCodigoTransaccionID').length > 0) {
				$('#txtCodigoTransaccionID').val(codigo.ID);
			}
			if ($('#ddlCodigoRubro').length > 0) {
				$('#ddlCodigoRubro').val(codigo.CodigoRubro);
				// Cargar tipos de auxiliares cuando se selecciona el rubro
				cargarTiposAuxiliaresPorRubro(codigo.CodigoRubro);
				// Esperar a que se carguen los tipos de auxiliares antes de seleccionar
				if (codigo.IdTipoAuxiliar && codigo.IdTipoAuxiliar !== "0") {
					// Intentar varias veces hasta que el dropdown esté listo
					let intentos = 0;
					const maxIntentos = 10;
					const intervalo = setInterval(function () {
						intentos++;
						const $ddlTipoAuxiliar = $('#ddlTipoAuxiliar');
						if ($ddlTipoAuxiliar.find('option[value="' + codigo.IdTipoAuxiliar + '"]').length > 0) {
							$ddlTipoAuxiliar.val(codigo.IdTipoAuxiliar);
							clearInterval(intervalo);
						} else if (intentos >= maxIntentos) {
							clearInterval(intervalo);
						}
					}, 50);
				}
			}
			if ($('#txtCodigoTransaccion').length > 0) {
				$('#txtCodigoTransaccion').val(codigo.CodigoTransaccion);
			}
			if ($('#txtDescripcion').length > 0) {
				$('#txtDescripcion').val(codigo.Descripcion);
			}
			if ($('#ddlDebCred').length > 0) {
				$('#ddlDebCred').val(codigo.DebCred);
			}
			if ($('#ddlCuentaContable').length > 0) {
				$('#ddlCuentaContable').val(codigo.CuentaContable || '').trigger('change');
			}
			if ($('#ddlContraCuenta').length > 0) {
				$('#ddlContraCuenta').val(codigo.ContraCuenta || '').trigger('change');
			}
			if ($('#chkSnActivo').length > 0) {
				$('#chkSnActivo').prop('checked', codigo.SnActivo);
			}
		}

		function limpiarFormularioCodigoTransaccion() {
			// Verificar que el formulario existe antes de hacer reset
			if ($('#formCodigoTransaccion').length > 0) {
				$('#formCodigoTransaccion')[0].reset();
			}
			
			// Limpiar campos específicos
			$('#txtCodigoTransaccionID').val('0');
			$('#ddlCodigoRubro').val('');
			$('#ddlTipoAuxiliar').empty().append('<option value="">Seleccionar tipo auxiliar...</option>');
			$('#txtCodigoTransaccion').val('');
			$('#txtDescripcion').val('');
			$('#ddlDebCred').val('');
			$('#ddlCuentaContable').val('').trigger('change');
			$('#ddlContraCuenta').val('').trigger('change');
			$('#chkSnActivo').prop('checked', true);
			
			// Remover clases de validación
			$('.form-control, .form-select').removeClass('is-invalid');
		}

		function guardarCodigoTransaccion() {
			if (!validarFormularioCodigoTransaccion()) {
				return;
			}

			// Obtener valores del formulario
			const codigoRubro = $('#ddlCodigoRubro').val();
			const idTipoAuxiliar = $('#ddlTipoAuxiliar').val();
			const codigoTransaccion = $('#txtCodigoTransaccion').val();
			const descripcion = $('#txtDescripcion').val();
			const debCred = $('#ddlDebCred').val();
			const cuentaContable = $('#ddlCuentaContable').val() || '';
			const contraCuenta = $('#ddlContraCuenta').val() || '';
			const snActivo = $('#chkSnActivo').is(':checked');

			const codigoData = {
				ID: parseInt($('#txtCodigoTransaccionID').val()) || 0,
				CodigoRubro: codigoRubro,
				IdTipoAuxiliar: parseInt(idTipoAuxiliar) || 0,
				CodigoTransaccion: codigoTransaccion,
				Descripcion: descripcion,
				DebCred: debCred,
				CuentaContable: cuentaContable,
				ContraCuenta: contraCuenta,
				SnActivo: snActivo
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarCodigoTransaccion",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ codigoData: codigoData }),
				dataType: "json",
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', response.d.Mensaje);
						$('#modalCodigoTransaccion').modal('hide');
						cargarCodigosTransaccion();
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
					}
				},
				error: function () {
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

			if (!$('#ddlTipoAuxiliar').val()) {
				$('#ddlTipoAuxiliar').addClass('is-invalid');
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
			mostrarConfirmEliminar('Código de Transacción', function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarCodigoTransaccion",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						if (response.d && response.d.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', response.d.Mensaje);
							cargarCodigosTransaccion();
						} else {
							showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
						}
					},
					error: function () {
						showToast('error', 'Error', 'Error al eliminar código de transacción');
					}
				});
			});
		}

		// ===== FUNCIONES DE CONFIRMACIÓN =====
		
		// Función local para mostrar toast de confirmación
		function showConfirmToastLocal(type, title, message, onConfirm, onCancel) {
			// Obtener el contenedor de toasts (debe existir en el HTML)
			const toastContainer = $('#toastContainer');
			if (toastContainer.length === 0) {
				return;
			}
			
			const toastId = 'confirm-toast-' + Date.now();
			
			const iconClass = getToastIcon ? getToastIcon(type) : 'fas fa-exclamation-triangle text-warning';
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
							<button type="button" class="btn btn-sm btn-outline-secondary" onclick="cancelConfirmToastLocal('${toastId}')">
								<i class="fas fa-times me-1"></i>Cancelar
							</button>
							<button type="button" class="btn btn-sm btn-danger" onclick="confirmToastLocal('${toastId}')">
								<i class="fas fa-check me-1"></i>Eliminar
							</button>
						</div>
					</div>
				</div>
			`;
			
			toastContainer.append(toastHtml);
			
			const toastElement = document.getElementById(toastId);
			if (!toastElement) {
				return;
			}
			
			// Almacenar callbacks
			toastElement.onConfirm = onConfirm;
			toastElement.onCancel = onCancel || function() {};
			
			// Crear y mostrar el toast
			const toastInstance = new bootstrap.Toast(toastElement, {
				autohide: false,
				delay: 0
			});
			
			toastInstance.show();
			
			// Remover del DOM cuando se oculte
			toastElement.addEventListener('hidden.bs.toast', function() {
				this.remove();
			});
		}
		
		// Funciones auxiliares para los botones del toast
		function confirmToastLocal(toastId) {
			const toastElement = document.getElementById(toastId);
			if (!toastElement) {
				return;
			}
			
			if (toastElement.onConfirm && typeof toastElement.onConfirm === 'function') {
				toastElement.onConfirm();
			}
			
			const toastInstance = bootstrap.Toast.getInstance(toastElement);
			if (toastInstance) {
				toastInstance.hide();
			}
		}
		
		function cancelConfirmToastLocal(toastId) {
			const toastElement = document.getElementById(toastId);
			if (!toastElement) {
				return;
			}
			
			if (toastElement.onCancel && typeof toastElement.onCancel === 'function') {
				toastElement.onCancel();
			}
			
			const toastInstance = bootstrap.Toast.getInstance(toastElement);
			if (toastInstance) {
				toastInstance.hide();
			}
		}
		
		function mostrarConfirmEliminar(entidad, callback) {
			try {
				showConfirmToastLocal(
					'warning',
					'Confirmar eliminación',
					`¿Está seguro de eliminar el ${entidad}? Esta acción no se puede deshacer.`,
					function () {
						if (typeof callback === 'function') {
							callback();
						}
					},
					function () {
						// Usuario canceló
					}
				);
			} catch (error) {
				// Fallback a confirm nativo
				if (confirm(`¿Está seguro de eliminar el ${entidad}? Esta acción no se puede deshacer.`)) {
					if (typeof callback === 'function') {
						callback();
					}
				}
			}
		}

		// ===== FUNCIONALIDAD DEPARTAMENTOS =====
		function inicializarDepartamentos() {
			// Cargar datos iniciales
			cargarDepartamentos();

			// Configurar eventos
			configurarEventosDepartamentos();

			$('#ddlFiltroEstadoDepartamento').on('change', function () {
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const departamentos = JSON.parse(response.d.Datos);
						mostrarDepartamentos(departamentos);
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al cargar departamentos');
					}
				},
				error: function () {
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

			departamentos.forEach(function (departamento) {
				const row = `
                    <tr>
                        <td>${departamento.Id}</td>
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

			// Enfocar el campo Nombre después de que el modal se muestre
			$('#modalDepartamento').on('shown.bs.modal', function () {
				$('#txtNombreDepartamento').focus();
			});
		}

		function editarDepartamento(id) {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerDepartamento",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ id: id }),
				dataType: "json",
				success: function (response) {
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
				error: function () {
					showToast('error', 'Error', 'Error al cargar datos del departamento');
				}
			});
		}

		function llenarFormularioDepartamento(departamento) {
			// Verificar que los elementos existen antes de llenarlos
			if ($('#txtDepartamentoID').length > 0) {
				$('#txtDepartamentoID').val(departamento.Id);
			}
			if ($('#txtNombreDepartamento').length > 0) {
				$('#txtNombreDepartamento').val(departamento.Nombre);
			}
			if ($('#txtDescripcionDepartamento').length > 0) {
				$('#txtDescripcionDepartamento').val(departamento.Descripcion);
			}
			if ($('#txtResponsableDepartamento').length > 0) {
				$('#txtResponsableDepartamento').val(departamento.Responsable);
			}
			if ($('#txtTelefonoDepartamento').length > 0) {
				$('#txtTelefonoDepartamento').val(departamento.Telefono);
			}
			if ($('#txtEmailDepartamento').length > 0) {
				$('#txtEmailDepartamento').val(departamento.Email);
			}
			if ($('#chkActivoDepartamento').length > 0) {
				$('#chkActivoDepartamento').prop('checked', departamento.Activo);
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', response.d.Mensaje);
						$('#modalDepartamento').modal('hide');
						cargarDepartamentos();
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
					}
				},
				error: function () {
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
			mostrarConfirmEliminar('Departamento', function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarDepartamento",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						if (response.d && response.d.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', response.d.Mensaje);
							cargarDepartamentos();
						} else {
							showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
						}
					},
					error: function () {
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const parentezcos = JSON.parse(response.d.Datos);
						mostrarParentezcos(parentezcos);
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al cargar parentezcos');
					}
				},
				error: function () {
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

			parentezcos.forEach(function (parentezco) {
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

			// Enfocar el campo Parentezco después de que el modal se muestre
			$('#modalParentezco').on('shown.bs.modal', function () {
				$('#txtParentezco').focus();
			});
		}

		function editarParentezco(id) {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerParentezco",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ id: id }),
				dataType: "json",
				success: function (response) {
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
				error: function () {
					showToast('error', 'Error', 'Error al cargar datos del parentezco');
				}
			});
		}
		function llenarFormularioParentezco(parentezco) {
			// Verificar que los elementos existen antes de llenarlos
			if ($('#txtParentezcoID').length > 0) {
				$('#txtParentezcoID').val(parentezco.IDParentezco);
			}
			if ($('#txtParentezco').length > 0) {
				$('#txtParentezco').val(parentezco.Parentezco);
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', response.d.Mensaje);
						$('#modalParentezco').modal('hide');
						cargarParentezcos();
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
					}
				},
				error: function () {
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
			mostrarConfirmEliminar('Parentezco', function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarParentezco",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						if (response.d && response.d.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', response.d.Mensaje);
							cargarParentezcos();
						} else {
							showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
						}
					},
					error: function () {
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

			$('#ddlFiltroNivelAcceso, #ddlFiltroEstadoRol').on('change', function () {
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const roles = JSON.parse(response.d.Datos);
						mostrarRoles(roles);
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al cargar roles');
					}
				},
				error: function () {
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

			roles.forEach(function (rol) {
				const nivelBadge = getNivelAccesoBadge(rol.NivelAcceso);
				const estadoBadge = rol.Activo ? 'bg-success' : 'bg-danger';

				const row = `
                    <tr>
                        <td>${rol.Id}</td>
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
			switch (nivelAcceso) {
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

			// Enfocar el campo Nombre después de que el modal se muestre
			$('#modalRol').on('shown.bs.modal', function () {
				$('#txtNombreRol').focus();
			});
		}

		function editarRol(id) {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerRol",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ id: id }),
				dataType: "json",
				success: function (response) {
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
				error: function () {
					showToast('error', 'Error', 'Error al cargar datos del rol');
				}
			});
		}

		function llenarFormularioRol(rol) {
			// Verificar que los elementos existen antes de llenarlos
			if ($('#txtRolID').length > 0) {
				$('#txtRolID').val(rol.Id);
			}
			if ($('#txtNombreRol').length > 0) {
				$('#txtNombreRol').val(rol.Nombre);
			}
			if ($('#txtDescripcionRol').length > 0) {
				$('#txtDescripcionRol').val(rol.Descripcion);
			}
			if ($('#ddlNivelAcceso').length > 0) {
				$('#ddlNivelAcceso').val(rol.NivelAcceso);
			}
			if ($('#chkActivoRol').length > 0) {
				$('#chkActivoRol').prop('checked', rol.Activo);
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', response.d.Mensaje);
						$('#modalRol').modal('hide');
						cargarRoles();
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
					}
				},
				error: function () {
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
			mostrarConfirmEliminar('Rol', function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarRol",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						if (response.d && response.d.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', response.d.Mensaje);
							cargarRoles();
						} else {
							showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
						}
					},
					error: function () {
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const rubros = JSON.parse(response.d.Datos);
						mostrarRubros(rubros);
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al cargar rubros');
					}
				},
				error: function () {
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

			rubros.forEach(function (rubro) {
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

			// Enfocar el campo Código después de que el modal se muestre
			$('#modalRubro').on('shown.bs.modal', function () {
				$('#txtCodigoRubro').focus();
			});
		}

		function editarRubro(id) {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerRubro",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ id: id }),
				dataType: "json",
				success: function (response) {
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
				error: function () {
					showToast('error', 'Error', 'Error al cargar datos del rubro');
				}
			});
		}

		function llenarFormularioRubro(rubro) {
			// Verificar que los elementos existen antes de llenarlos
			if ($('#txtRubroID').length > 0) {
				$('#txtRubroID').val(rubro.IDRubro);
			}
			if ($('#txtCodigoRubro').length > 0) {
				$('#txtCodigoRubro').val(rubro.CodigoRubro);
			}
			if ($('#txtDescripcionRubro').length > 0) {
				$('#txtDescripcionRubro').val(rubro.Descripcion);
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', response.d.Mensaje);
						$('#modalRubro').modal('hide');
						cargarRubrosTab();
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
					}
				},
				error: function () {
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
			mostrarConfirmEliminar('Rubro', function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarRubro",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						if (response.d && response.d.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', response.d.Mensaje);
							cargarRubrosTab();
						} else {
							showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
						}
					},
					error: function () {
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const statusList = JSON.parse(response.d.Datos);
						mostrarStatusAsociados(statusList);
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al cargar estatus');
					}
				},
				error: function () {
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

			statusList.forEach(function (status) {
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

			// Enfocar el campo Código después de que el modal se muestre
			$('#modalStatus').on('shown.bs.modal', function () {
				$('#txtCodigoStatus').focus();
			});
		}

		function editarStatus(id) {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerStatusAsociado",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ id: id }),
				dataType: "json",
				success: function (response) {
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
				error: function () {
					showToast('error', 'Error', 'Error al cargar datos del estatus');
				}
			});
		}

		function llenarFormularioStatus(status) {
			// Verificar que los elementos existen antes de llenarlos
			if ($('#txtStatusID').length > 0) {
				$('#txtStatusID').val(status.IDStatus);
			}
			if ($('#txtCodigoStatus').length > 0) {
				$('#txtCodigoStatus').val(status.CodStatusAsociado);
			}
			if ($('#txtDescripcionStatus').length > 0) {
				$('#txtDescripcionStatus').val(status.StatusAsociado);
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', response.d.Mensaje);
						$('#modalStatus').modal('hide');
						cargarStatusAsociados();
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
					}
				},
				error: function () {
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
			mostrarConfirmEliminar('Estatus', function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarStatusAsociado",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						if (response.d && response.d.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', response.d.Mensaje);
							cargarStatusAsociados();
						} else {
							showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
						}
					},
					error: function () {
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const tipoAsociados = JSON.parse(response.d.Datos);
						mostrarTipoAsociados(tipoAsociados);
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al cargar tipos de asociado');
					}
				},
				error: function () {
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

			tipoAsociados.forEach(function (tipoAsociado) {
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

			// Enfocar el campo Código después de que el modal se muestre
			$('#modalTipoAsociado').on('shown.bs.modal', function () {
				$('#txtCodigoTipoAsociado').focus();
			});
		}

		function editarTipoAsociado(id) {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerTipoAsociado",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ id: id }),
				dataType: "json",
				success: function (response) {
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
				error: function () {
					showToast('error', 'Error', 'Error al cargar datos del tipo de asociado');
				}
			});
		}

		function llenarFormularioTipoAsociado(tipoAsociado) {
			// Verificar que los elementos existen antes de llenarlos
			if ($('#txtTipoAsociadoID').length > 0) {
				$('#txtTipoAsociadoID').val(tipoAsociado.IdTipoAsociado);
			}
			if ($('#txtCodigoTipoAsociado').length > 0) {
				$('#txtCodigoTipoAsociado').val(tipoAsociado.CodTipoAsociado);
			}
			if ($('#txtTipoAsociado').length > 0) {
				$('#txtTipoAsociado').val(tipoAsociado.TipoAsociado);
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', response.d.Mensaje);
						$('#modalTipoAsociado').modal('hide');
						cargarTipoAsociados();
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
					}
				},
				error: function () {
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
			mostrarConfirmEliminar('Tipo de Asociado', function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarTipoAsociado",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						if (response.d && response.d.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', response.d.Mensaje);
							cargarTipoAsociados();
						} else {
							showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
						}
					},
					error: function () {
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const tipoDocumentos = JSON.parse(response.d.Datos);
						mostrarTipoDocumentos(tipoDocumentos);
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al cargar tipos de documento');
					}
				},
				error: function () {
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

			tipoDocumentos.forEach(function (tipoDocumento) {
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

		function crearChipGrupoCuentaInteligente(grupoDescripcion) {
			if (!grupoDescripcion) {
				return '<span class="badge bg-secondary"><i class="fas fa-tag me-1"></i>Sin grupo</span>';
			}

			const grupoLower = grupoDescripcion.toLowerCase().trim();

			// Mapeo de grupos a colores e iconos
			let config = { color: 'bg-secondary', icono: 'fas fa-tag' };

			if (grupoLower.includes('activo')) {
				config = { color: 'bg-success', icono: 'fas fa-arrow-up' };
			} else if (grupoLower.includes('pasivo')) {
				config = { color: 'bg-danger', icono: 'fas fa-arrow-down' };
			} else if (grupoLower.includes('capital')) {
				config = { color: 'bg-primary', icono: 'fas fa-coins' };
			} else if (grupoLower.includes('ingreso')) {
				config = { color: 'bg-info', icono: 'fas fa-arrow-circle-up' };
			} else if (grupoLower.includes('costo')) {
				config = { color: 'bg-warning', icono: 'fas fa-dollar-sign' };
			} else if (grupoLower.includes('gasto')) {
				config = { color: 'bg-secondary', icono: 'fas fa-arrow-circle-down' };
			}

			return `<span class="badge ${config.color}"><i class="${config.icono} me-1"></i>${grupoDescripcion}</span>`;
		}

		// ===== FUNCIONALIDAD TIPOS AUXILIARES =====
		function inicializarTiposAuxiliares() {
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

			elementos.forEach(selector => {
				const elemento = $(selector);
			});

			// Cargar rubros para filtro y modal
			cargarRubrosAuxiliares();

			// Cargar datos iniciales
			cargarTiposAuxiliares();

			// Configurar eventos
			configurarEventosTiposAuxiliares();
		}

		function cargarRubrosAuxiliares() {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerRubros",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const rubros = JSON.parse(response.d.Datos);

						// Llenar dropdown de filtro
						$('#ddlFiltroRubroAuxiliar').empty().append('<option value="">Todos los rubros</option>');
						$.each(rubros, function (index, rubro) {
							$('#ddlFiltroRubroAuxiliar').append(`<option value="${rubro.CodigoRubro}">${rubro.CodigoRubro} - ${rubro.Descripcion}</option>`);
						});

						// Llenar dropdown del modal
						$('#ddlCodigoRubroAuxiliar').empty().append('<option value="">Seleccionar rubro...</option>');
						$.each(rubros, function (index, rubro) {
							$('#ddlCodigoRubroAuxiliar').append(`<option value="${rubro.CodigoRubro}">${rubro.CodigoRubro} - ${rubro.Descripcion}</option>`);
						});
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al cargar rubros');
				}
			});
		}

		function cargarTiposAuxiliares() {
			// Verificar que los elementos del DOM existan
			const ddlRubro = $('#ddlFiltroRubroAuxiliar');
			const txtTipo = $('#txtFiltroTipoAuxiliar');
			const txtDescripcion = $('#txtFiltroDescripcionAuxiliar');

			const filtros = {
				CodigoRubro: ddlRubro.val() || '',
				TipoAuxiliar: txtTipo.val() || '',
				Descripcion: txtDescripcion.val() || ''
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarTiposAuxiliares",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					// Verificar si response.d es un string que necesita ser parseado
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							mostrarTiposAuxiliares([]);
							showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						try {
							const tiposAuxiliares = JSON.parse(responseData.Datos);
							mostrarTiposAuxiliares(tiposAuxiliares);
						} catch (parseError) {
							mostrarTiposAuxiliares([]);
							showToast('error', 'Error', 'Error al procesar los datos');
						}
					} else {
						mostrarTiposAuxiliares([]);
						showToast('warning', 'Advertencia', responseData ? responseData.Mensaje : 'No se encontraron datos');
					}
				},
				error: function (xhr, status, error) {
					mostrarTiposAuxiliares([]);
					showToast('error', 'Error', 'Error al cargar tipos auxiliares');
				}
			});
		}
		function mostrarTiposAuxiliares(tiposAuxiliares) {
			const tbody = $('#tblTiposAuxiliares tbody');

			if (tbody.length === 0) {
				return;
			}

			tbody.empty();

			if (!tiposAuxiliares || !Array.isArray(tiposAuxiliares) || tiposAuxiliares.length === 0) {
				tbody.append(`
                    <tr>
                        <td colspan="12" class="text-center text-muted">
                            <i class="fas fa-info-circle me-2"></i>No se encontraron tipos auxiliares
                        </td>
                    </tr>
                `);
				return;
			}

			try {
				$.each(tiposAuxiliares, function (index, tipo) {
					// Validar que el objeto tipo tenga las propiedades necesarias
					if (!tipo) {
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
			} catch (error) {
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
			$('#ddlFiltroRubroAuxiliar, #txtFiltroTipoAuxiliar, #txtFiltroDescripcionAuxiliar').on('change keyup', function () {
				clearTimeout(window.busquedaTiposAuxiliaresTimeout);
				window.busquedaTiposAuxiliaresTimeout = setTimeout(function () {
					cargarTiposAuxiliares();
				}, 500);
			});

			// Eventos de botones
			$('#btnNuevoTipoAuxiliar').on('click', function () {
				abrirModalTipoAuxiliar();
			});

			$('#btnBuscarTiposAuxiliares').on('click', function () {
				cargarTiposAuxiliares();
			});

			$('#btnLimpiarFiltrosAuxiliar').on('click', function () {
				limpiarFiltrosTiposAuxiliares();
			});

			$('#btnGuardarTipoAuxiliar').on('click', function () {
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

			// Enfocar el campo Código después de que el modal se muestre
			$('#modalTipoAuxiliar').on('shown.bs.modal', function () {
				$('#txtCodigoTipoAuxiliar').focus();
			});
		}

		function editarTipoAuxiliar(id) {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerTipoAuxiliar",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ id: id }),
				dataType: "json",
				success: function (response) {
					// Verificar si response.d es un string que necesita ser parseado
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						try {
							const tipoAuxiliar = JSON.parse(responseData.Datos);
							llenarFormularioTipoAuxiliar(tipoAuxiliar);
							$('#modalTipoAuxiliarLabel').html('<i class="fas fa-tools me-2"></i>Editar Tipo Auxiliar');

							// Mostrar modal
							const modal = new bootstrap.Modal(document.getElementById('modalTipoAuxiliar'));
							modal.show();
						} catch (parseError) {
							showToast('error', 'Error', 'Error al procesar los datos del tipo auxiliar');
						}
					} else {
						showToast('error', 'Error', responseData ? responseData.Mensaje : 'No se pudo obtener el tipo auxiliar');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al obtener tipo auxiliar');
				}
			});
		}

		function llenarFormularioTipoAuxiliar(tipoAuxiliar) {
			$('#hdnIDTipoAuxiliar').val(tipoAuxiliar.ID);

			$('#ddlCodigoRubroAuxiliar').val(tipoAuxiliar.CodigoRubro);

			$('#txtTipoAuxiliar').val(tipoAuxiliar.TipoAuxiliar);

			$('#txtDescripcionAuxiliar').val(tipoAuxiliar.Descripcion);

			// Limpiar y asignar valores numéricos
			const tasa = tipoAuxiliar.Tasa ? tipoAuxiliar.Tasa.toString().replace(',', '.') : '';
			$('#txtTasaAuxiliar').val(tasa);

			const plazo = tipoAuxiliar.Plazo ? tipoAuxiliar.Plazo.toString() : '';
			$('#txtPlazoAuxiliar').val(plazo);

			const montoMinimo = tipoAuxiliar.MontoMinimo ? tipoAuxiliar.MontoMinimo.toString().replace(',', '.') : '';
			$('#txtMontoMinimoAuxiliar').val(montoMinimo);

			const montoMaximo = tipoAuxiliar.MontoMaximo ? tipoAuxiliar.MontoMaximo.toString().replace(',', '.') : '';
			$('#txtMontoMaximoAuxiliar').val(montoMaximo);

			const porManejo = tipoAuxiliar.PorManejo ? tipoAuxiliar.PorManejo.toString().replace(',', '.') : '';
			$('#txtPorManejoAuxiliar').val(porManejo);

			const porCapitalizacion = tipoAuxiliar.PorCapitalizacion ? tipoAuxiliar.PorCapitalizacion.toString().replace(',', '.') : '';
			$('#txtPorCapitalizacionAuxiliar').val(porCapitalizacion);

			const porProteccion = tipoAuxiliar.PorProteccion ? tipoAuxiliar.PorProteccion.toString().replace(',', '.') : '';
			$('#txtPorProteccionAuxiliar').val(porProteccion);
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

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarTipoAuxiliar",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ tipoAuxiliarData: tipoAuxiliarData }),
				dataType: "json",
				success: function (response) {
					// Verificar si response.d es un string que necesita ser parseado
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', responseData.Mensaje);
						$('#modalTipoAuxiliar').modal('hide');
						cargarTiposAuxiliares();
					} else {
						showToast('error', 'Error', responseData ? responseData.Mensaje : 'No se pudo guardar el tipo auxiliar');
					}
				},
				error: function (xhr, status, error) {
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
			mostrarConfirmEliminar('tipo auxiliar', function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarTipoAuxiliar",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						var data = response.d;
						if (typeof data === 'string') {
							data = JSON.parse(data);
						}

						if (data.Resultado === "SUCCESS") {
							showToast('success', 'Éxito', data.Mensaje || 'Tipo de auxiliar eliminado correctamente');
							cargarTiposAuxiliares();
						} else {
							showToast('error', 'Error', data.Mensaje || 'No se pudo eliminar el tipo de auxiliar');
						}
					},
					error: function () {
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

			// Enfocar el campo Código después de que el modal se muestre
			$('#modalTipoDoc').on('shown.bs.modal', function () {
				$('#txtCodigoTipoDoc').focus();
			});
		}

		function editarTipoDoc(id) {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerTipoDocumento",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ id: id }),
				dataType: "json",
				success: function (response) {
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
				error: function () {
					showToast('error', 'Error', 'Error al cargar datos del tipo de documento');
				}
			});
		}

		function llenarFormularioTipoDoc(tipoDocumento) {
			// Verificar que los elementos existen antes de llenarlos
			if ($('#txtTipoDocID').length > 0) {
				$('#txtTipoDocID').val(tipoDocumento.IDTipoDoc);
			}
			if ($('#txtCodigoTipoDoc').length > 0) {
				$('#txtCodigoTipoDoc').val(tipoDocumento.CodTipoDoc);
			}
			if ($('#txtTipoDocumento').length > 0) {
				$('#txtTipoDocumento').val(tipoDocumento.TipoDocumento);
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', response.d.Mensaje);
						$('#modalTipoDoc').modal('hide');
						cargarTipoDocumentos();
					} else {
						showToast('error', 'Error', response.d.Mensaje || 'Error al guardar');
					}
				},
				error: function () {
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
			mostrarConfirmEliminar('Tipo de Documento', function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarTipoDocumento",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						if (response.d && response.d.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', response.d.Mensaje);
							cargarTipoDocumentos();
						} else {
							showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
						}
					},
					error: function () {
						showToast('error', 'Error', 'Error al eliminar tipo de documento');
					}
				});
			});
		}

		// ===== USUARIOS =====
		function inicializarUsuarios() {
			// Cargar roles para filtro y modal
			cargarRolesUsuarios();

			// Cargar datos iniciales
			cargarUsuarios();

			// Configurar eventos
			configurarEventosUsuarios();
		}

		function cargarRolesUsuarios() {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarRoles",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: {} }),
				dataType: "json",
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const roles = JSON.parse(response.d.Datos);
						const ddlFiltro = $('#ddlFiltroRolUsuario');
						const ddlModal = $('#ddlRolUsuario');

						ddlFiltro.empty().append('<option value="">Todos</option>');
						ddlModal.empty().append('<option value="">Seleccionar rol...</option>');

						roles.forEach(function (rol) {
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const departamentos = JSON.parse(response.d.Datos);
						const ddlFiltro = $('#ddlFiltroDepartamentoUsuario');
						const ddlModal = $('#ddlDepartamentoUsuario');

						ddlFiltro.empty().append('<option value="">Todos</option>');
						ddlModal.empty().append('<option value="">Seleccionar departamento...</option>');

						departamentos.forEach(function (departamento) {
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
				success: function (response) {
					if (response.d && response.d.Resultado === 'SUCCESS') {
						const estados = JSON.parse(response.d.Datos);
						const ddlFiltro = $('#ddlFiltroEstadoUsuario');
						const ddlModal = $('#ddlEstadoUsuario');

						ddlFiltro.empty().append('<option value="">Todos</option>');
						ddlModal.empty().append('<option value="">Seleccionar estado...</option>');

						estados.forEach(function (estado) {
							ddlFiltro.append(`<option value="${estado.CodStatusAsociado}">${estado.StatusAsociado}</option>`);
							ddlModal.append(`<option value="${estado.CodStatusAsociado}">${estado.StatusAsociado}</option>`);
						});
					}
				}
			});
		}

		function cargarUsuarios() {
			const filtros = {
				Rol: $('#ddlFiltroRolUsuario').val(),
				Departamento: $('#ddlFiltroDepartamentoUsuario').val(),
				Estado: $('#ddlFiltroEstadoUsuario').val(),
				Buscar: $('#txtFiltroBuscarUsuario').val()
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarUsuarios",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const usuarios = JSON.parse(responseData.Datos);
						mostrarUsuarios(usuarios);
					} else {
						mostrarUsuarios([]);
						showToast('warning', 'Advertencia', responseData ? responseData.Mensaje : 'No se encontraron datos');
					}
				},
				error: function (xhr, status, error) {
					mostrarUsuarios([]);
					showToast('error', 'Error', 'Error al cargar usuarios');
				}
			});
		}
		function mostrarUsuarios(usuarios) {
			// Verificar que el tab esté activo
			const tabPane = $('#usuarios');
			const tabLink = $('#usuarios-tab');

			const tbody = $('#tblUsuarios tbody');
			tbody.empty();

			if (!usuarios || usuarios.length === 0) {
				tbody.append(`
                    <tr>
                        <td colspan="10" class="text-center text-muted">
                            <i class="fas fa-info-circle me-2"></i>No hay datos disponibles
                        </td>
                    </tr>
                `);
				return;
			}

			$.each(usuarios, function (index, usuario) {

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
			});

			// Verificar visibilidad de elementos
			const tabla = $('#tblUsuarios');
			const contenedor = $('.table-responsive');

			// Forzar visibilidad si es necesario
			setTimeout(function () {
				if (!tabla.is(':visible') || tabla.height() === 0) {
					// Asegurar que el tab esté activo
					if (!tabPane.hasClass('active')) {
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
				}
			}, 100);
		}

		function configurarEventosUsuarios() {
			// Búsqueda en tiempo real
			$('#txtFiltroBuscarUsuario').on('input', function () {
				clearTimeout(window.busquedaUsuariosTimeout);
				window.busquedaUsuariosTimeout = setTimeout(function () {
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

			// Enfocar el campo Usuario después de que el modal se muestre
			$('#modalUsuario').on('shown.bs.modal', function () {
				$('#txtUsuario').focus();
			});
		}

		function editarUsuario(id) {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerUsuario",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ id: id }),
				dataType: "json",
				success: function (response) {
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
				error: function () {
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

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarUsuario",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ usuarioData: usuarioData }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', responseData.Mensaje);
						$('#modalUsuario').modal('hide');
						cargarUsuarios();
					} else {
						showToast('error', 'Error', responseData ? responseData.Mensaje : 'No se pudo guardar el usuario');
					}
				},
				error: function (xhr, status, error) {
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
			mostrarConfirmEliminar('usuario', function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarUsuario",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						if (response.d && response.d.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', response.d.Mensaje);
							cargarUsuarios();
						} else {
							showToast('error', 'Error', response.d.Mensaje || 'Error al eliminar');
						}
					},
					error: function () {
						showToast('error', 'Error', 'Error al eliminar usuario');
					}
				});
			});
		}

		// ===== FUNCIONES PARA NIVELES DE ESTUDIO =====
		function inicializarNivelesEstudio() {
			// Verificar que todos los elementos necesarios existan
			const elementos = [
				'#txtFiltroCodigoNivel',
				'#txtFiltroDescripcionNivel',
				'#tblNivelesEstudio',
				'#btnNuevoNivel',
				'#btnBuscarNiveles',
				'#btnLimpiarFiltrosNivel'
			];

			elementos.forEach(selector => {
				const elemento = $(selector);
			});

			// Cargar datos iniciales
			cargarNivelesEstudio();

			// Configurar eventos
			configurarEventosNivelesEstudio();
		}
		function cargarNivelesEstudio() {
			const filtros = {
				Codigo: $('#txtFiltroCodigoNivel').val() || '',
				Descripcion: $('#txtFiltroDescripcionNivel').val() || ''
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarNivelesEstudio",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							mostrarNivelesEstudio([]);
							showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						try {
							const niveles = JSON.parse(responseData.Datos);
							mostrarNivelesEstudio(niveles);
						} catch (parseError) {
							mostrarNivelesEstudio([]);
							showToast('error', 'Error', 'Error al procesar los datos');
						}
					} else {
						mostrarNivelesEstudio([]);
						showToast('warning', 'Advertencia', responseData ? responseData.Mensaje : 'No se encontraron datos');
					}
				},
				error: function (xhr, status, error) {
					mostrarNivelesEstudio([]);
					showToast('error', 'Error', 'Error al cargar niveles de estudio');
				}
			});
		}

		function mostrarNivelesEstudio(niveles) {
			const tbody = $('#tblNivelesEstudio tbody');

			if (tbody.length === 0) {
				return;
			}

			tbody.empty();

			if (!niveles || !Array.isArray(niveles) || niveles.length === 0) {
				tbody.append(`
                    <tr>
                        <td colspan="4" class="text-center text-muted">
                            <i class="fas fa-info-circle me-2"></i>No se encontraron niveles de estudio
                        </td>
                    </tr>
                `);
				return;
			}

			try {
				$.each(niveles, function (index, nivel) {
					if (!nivel) {
						return;
					}

					const row = `
                        <tr>
                            <td>${nivel.ID || ''}</td>
                            <td><span class="badge bg-primary">${nivel.Code || ''}</span></td>
                            <td>${nivel.Descripcion || ''}</td>
                            <td>
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="editarNivel(${nivel.ID})" title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarNivel(${nivel.ID})" title="Eliminar">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    `;

					tbody.append(row);
				});
			} catch (error) {
				tbody.append(`
                    <tr>
                        <td colspan="4" class="text-center text-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>Error al mostrar los datos
                        </td>
                    </tr>
                `);
			}
		}
		function configurarEventosNivelesEstudio() {
			// Botón Nuevo
			$('#btnNuevoNivel').off('click').on('click', function () {
				limpiarFormularioNivel();
				$('#modalNivelEstudioLabel').html('<i class="fas fa-graduation-cap me-2"></i>Nuevo Nivel de Estudio');
				$('#modalNivelEstudio').modal('show');

				// Enfocar el campo Código después de que el modal se muestre
				$('#modalNivelEstudio').on('shown.bs.modal', function () {
					$('#txtCodigoNivel').focus();
				});
			});

			// Botón Buscar
			$('#btnBuscarNiveles').off('click').on('click', function () {
				cargarNivelesEstudio();
			});

			// Botón Limpiar
			$('#btnLimpiarFiltrosNivel').off('click').on('click', function () {
				$('#txtFiltroCodigoNivel').val('');
				$('#txtFiltroDescripcionNivel').val('');
				cargarNivelesEstudio();
			});

			// Botón Guardar
			$('#btnGuardarNivel').off('click').on('click', function () {
				guardarNivel();
			});

			// Enter en filtros
			$('#txtFiltroCodigoNivel, #txtFiltroDescripcionNivel').off('keypress').on('keypress', function (e) {
				if (e.which === 13) {
					cargarNivelesEstudio();
				}
			});

			// Enter en campos del modal para guardar
			$('#txtCodigoNivel, #txtDescripcionNivel').off('keypress').on('keypress', function (e) {
				if (e.which === 13) {
					e.preventDefault();
					guardarNivel();
				}
			});
		}

		function limpiarFormularioNivel() {
			$('#hdnIDNivelEstudio').val('');
			$('#txtCodigoNivel').val('');
			$('#txtDescripcionNivel').val('');
		}

		function editarNivel(id) {
			// Buscar el nivel en la tabla actual
			const tbody = $('#tblNivelesEstudio tbody');
			const row = tbody.find(`button[onclick="editarNivel(${id})"]`).closest('tr');

			if (row.length === 0) {
				showToast('error', 'Error', 'No se encontró el nivel a editar');
				return;
			}

			// Extraer datos de la fila
			const cells = row.find('td');
			const codigo = cells.eq(1).find('.badge').text();
			const descripcion = cells.eq(2).text();

			// Llenar el formulario del modal
			$('#hdnIDNivelEstudio').val(id);
			$('#txtCodigoNivel').val(codigo);
			$('#txtDescripcionNivel').val(descripcion);

			// Cambiar título del modal
			$('#modalNivelEstudioLabel').html('<i class="fas fa-graduation-cap me-2"></i>Editar Nivel de Estudio');

			// Mostrar el modal
			$('#modalNivelEstudio').modal('show');
		}

		function eliminarNivel(id) {
			// Obtener descripción del nivel para mostrar en la confirmación
			const tbody = $('#tblNivelesEstudio tbody');
			const row = tbody.find(`button[onclick="eliminarNivel(${id})"]`).closest('tr');
			const descripcion = row.find('td').eq(2).text();

			// Mostrar confirmación personalizada
			mostrarConfirmEliminar(`Nivel "${descripcion}"`, function () {
				// Mostrar loading
				const btnEliminar = row.find('button[onclick="eliminarNivel(' + id + ')"]');
				btnEliminar.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i>');

				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarNivelEstudio",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						let responseData = response.d;
						if (typeof responseData === 'string') {
							try {
								responseData = JSON.parse(responseData);
							} catch (parseError) {
								showToast('error', 'Error', 'Error al procesar la respuesta');
								return;
							}
						}

						if (responseData && responseData.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', responseData.Mensaje || 'Nivel eliminado exitosamente');
							cargarNivelesEstudio(); // Recargar la tabla
						} else {
							showToast('error', 'Error', responseData.Mensaje || 'Error al eliminar el nivel');
						}
					},
					error: function (xhr, status, error) {
						showToast('error', 'Error', 'Error al eliminar el nivel');
					},
					complete: function () {
						// Restaurar botón
						btnEliminar.prop('disabled', false).html('<i class="fas fa-trash"></i>');
					}
				});
			});
		}

		function guardarNivel() {

			// Validar campos requeridos
			const codigo = $('#txtCodigoNivel').val().trim();
			const descripcion = $('#txtDescripcionNivel').val().trim();
			const id = $('#hdnIDNivelEstudio').val();

			if (!codigo || !descripcion) {
				showToast('warning', 'Validación', 'Código y descripción son requeridos');
				return;
			}

			// Validar que el código sea numérico
			if (isNaN(codigo) || parseInt(codigo) <= 0) {
				showToast('warning', 'Validación', 'El código debe ser un número entero positivo');
				return;
			}

			// Verificar si el código ya existe en la tabla actual
			const tbody = $('#tblNivelesEstudio tbody');
			const codigoExistente = tbody.find(`span.badge:contains("${codigo}")`);

			if (codigoExistente.length > 0) {
				// Si estamos editando, verificar que no sea el mismo registro
				if (id) {
					const filaActual = tbody.find(`button[onclick="editarNivel(${id})"]`).closest('tr');
					const codigoActual = filaActual.find('span.badge').text();

					// Si el código no cambió, permitir la actualización
					if (codigoActual !== codigo) {
						showToast('warning', 'Validación', 'El código ingresado ya existe. Por favor, ingrese un código diferente.');
						return;
					}
				} else {
					// Para nuevos registros, cualquier código duplicado es inválido
					showToast('warning', 'Validación', 'El código ingresado ya existe. Por favor, ingrese un código diferente.');
					return;
				}
			}

			// Preparar datos para enviar
			const nivelData = {
				ID: id || null,
				Code: codigo,
				Descripcion: descripcion
			};

			// Mostrar loading
			$('#btnGuardarNivel').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarNivelEstudio",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ nivelData: nivelData }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							showToast('error', 'Error', 'Error al procesar la respuesta');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', responseData.Mensaje || 'Nivel guardado exitosamente');
						$('#modalNivelEstudio').modal('hide');
						cargarNivelesEstudio(); // Recargar la tabla
					} else {
						// Mostrar mensaje de error más descriptivo
						const mensajeError = responseData.Mensaje || 'Error al guardar el nivel';
						showToast('error', 'Error', mensajeError);

						// Si es error de código duplicado, enfocar el campo código
						if (mensajeError.includes('código ingresado ya existe') || mensajeError.includes('duplicate key')) {
							$('#txtCodigoNivel').focus().select();
						}
					}
				},
				error: function (xhr, status, error) {
					showToast('error', 'Error', 'Error al guardar el nivel');
				},
				complete: function () {
					// Restaurar botón
					$('#btnGuardarNivel').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
				}
			});
		}

		// ===== FUNCIONES PARA PROFESIONES =====
		function inicializarProfesiones() {
			// Verificar que todos los elementos necesarios existan
			const elementos = [
				'#txtFiltroCodigoProfesion',
				'#txtFiltroDescripcionProfesion',
				'#tblProfesiones',
				'#btnNuevoProfesion',
				'#btnBuscarProfesiones',
				'#btnLimpiarFiltrosProfesion'
			];

			elementos.forEach(selector => {
				const elemento = $(selector);
			});

			// Cargar datos iniciales
			cargarProfesiones();

			// Configurar eventos
			configurarEventosProfesiones();
		}

		function cargarProfesiones() {
			const filtros = {
				Codigo: $('#txtFiltroCodigoProfesion').val() || '',
				Descripcion: $('#txtFiltroDescripcionProfesion').val() || ''
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarProfesiones",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							mostrarProfesiones([]);
							showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						try {
							const profesiones = JSON.parse(responseData.Datos);
							mostrarProfesiones(profesiones);
						} catch (parseError) {
							mostrarProfesiones([]);
							showToast('error', 'Error', 'Error al procesar los datos');
						}
					} else {
						mostrarProfesiones([]);
						showToast('warning', 'Advertencia', responseData ? responseData.Mensaje : 'No se encontraron datos');
					}
				},
				error: function (xhr, status, error) {
					mostrarProfesiones([]);
					showToast('error', 'Error', 'Error al cargar profesiones');
				}
			});
		}
		function mostrarProfesiones(profesiones) {
			const tbody = $('#tblProfesiones tbody');

			if (tbody.length === 0) {
				return;
			}

			tbody.empty();

			if (!profesiones || !Array.isArray(profesiones) || profesiones.length === 0) {
				tbody.append(`
                    <tr>
                        <td colspan="4" class="text-center text-muted">
                            <i class="fas fa-info-circle me-2"></i>No se encontraron profesiones
                        </td>
                    </tr>
                `);
				return;
			}

			try {
				$.each(profesiones, function (index, profesion) {
					if (!profesion) {
						return;
					}

					const row = `
                        <tr>
                            <td>${profesion.ID || ''}</td>
                            <td><span class="badge bg-primary">${profesion.Code || ''}</span></td>
                            <td>${profesion.Descripcion || ''}</td>
                            <td>
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="editarProfesion(${profesion.ID})" title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarProfesion(${profesion.ID})" title="Eliminar">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    `;

					tbody.append(row);
				});
			} catch (error) {
				tbody.append(`
                    <tr>
                        <td colspan="4" class="text-center text-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>Error al mostrar los datos
                        </td>
                    </tr>
                `);
			}
		}

		function configurarEventosProfesiones() {
			// Botón Nuevo
			$('#btnNuevoProfesion').off('click').on('click', function () {
				limpiarFormularioProfesion();
				$('#modalProfesionLabel').html('<i class="fas fa-briefcase me-2"></i>Nueva Profesión');
				$('#modalProfesion').modal('show');

				// Enfocar el campo Código después de que el modal se muestre
				$('#modalProfesion').on('shown.bs.modal', function () {
					$('#txtCodigoProfesion').focus();
				});
			});

			// Botón Buscar
			$('#btnBuscarProfesiones').off('click').on('click', function () {
				cargarProfesiones();
			});

			// Botón Limpiar
			$('#btnLimpiarFiltrosProfesion').off('click').on('click', function () {
				$('#txtFiltroCodigoProfesion').val('');
				$('#txtFiltroDescripcionProfesion').val('');
				cargarProfesiones();
			});

			// Botón Guardar
			$('#btnGuardarProfesion').off('click').on('click', function () {
				guardarProfesion();
			});

			// Enter en filtros
			$('#txtFiltroCodigoProfesion, #txtFiltroDescripcionProfesion').off('keypress').on('keypress', function (e) {
				if (e.which === 13) {
					cargarProfesiones();
				}
			});

			// Enter en campos del modal para guardar
			$('#txtCodigoProfesion, #txtDescripcionProfesion').off('keypress').on('keypress', function (e) {
				if (e.which === 13) {
					e.preventDefault();
					guardarProfesion();
				}
			});
		}

		function limpiarFormularioProfesion() {
			$('#hdnIDProfesion').val('');
			$('#txtCodigoProfesion').val('');
			$('#txtDescripcionProfesion').val('');
		}

		function editarProfesion(id) {
			// Buscar la profesión en la tabla actual
			const tbody = $('#tblProfesiones tbody');
			const row = tbody.find(`button[onclick="editarProfesion(${id})"]`).closest('tr');

			if (row.length === 0) {
				showToast('error', 'Error', 'No se encontró la profesión a editar');
				return;
			}

			// Extraer datos de la fila
			const cells = row.find('td');
			const codigo = cells.eq(1).find('.badge').text();
			const descripcion = cells.eq(2).text();

			// Llenar el formulario del modal
			$('#hdnIDProfesion').val(id);
			$('#txtCodigoProfesion').val(codigo);
			$('#txtDescripcionProfesion').val(descripcion);

			// Cambiar título del modal
			$('#modalProfesionLabel').html('<i class="fas fa-briefcase me-2"></i>Editar Profesión');

			// Mostrar el modal
			$('#modalProfesion').modal('show');
		}
		function eliminarProfesion(id) {
			// Obtener descripción de la profesión para mostrar en la confirmación
			const tbody = $('#tblProfesiones tbody');
			const row = tbody.find(`button[onclick="eliminarProfesion(${id})"]`).closest('tr');
			const descripcion = row.find('td').eq(2).text();

			// Mostrar confirmación personalizada
			mostrarConfirmEliminar(`Profesión "${descripcion}"`, function () {
				// Mostrar loading
				const btnEliminar = row.find('button[onclick="eliminarProfesion(' + id + ')"]');
				btnEliminar.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i>');

				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarProfesion",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						let responseData = response.d;
						if (typeof responseData === 'string') {
							try {
								responseData = JSON.parse(responseData);
							} catch (parseError) {
								showToast('error', 'Error', 'Error al procesar la respuesta');
								return;
							}
						}

						if (responseData && responseData.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', responseData.Mensaje || 'Profesión eliminada exitosamente');
							cargarProfesiones(); // Recargar la tabla
						} else {
							showToast('error', 'Error', responseData.Mensaje || 'Error al eliminar la profesión');
						}
					},
					error: function (xhr, status, error) {
						showToast('error', 'Error', 'Error al eliminar la profesión');
					},
					complete: function () {
						// Restaurar botón
						btnEliminar.prop('disabled', false).html('<i class="fas fa-trash"></i>');
					}
				});
			});
		}

		function guardarProfesion() {

			// Validar campos requeridos
			const codigo = $('#txtCodigoProfesion').val().trim();
			const descripcion = $('#txtDescripcionProfesion').val().trim();
			const id = $('#hdnIDProfesion').val();

			if (!codigo || !descripcion) {
				showToast('warning', 'Validación', 'Código y descripción son requeridos');
				return;
			}

			// Validar que el código sea numérico
			if (isNaN(codigo) || parseInt(codigo) <= 0) {
				showToast('warning', 'Validación', 'El código debe ser un número entero positivo');
				return;
			}

			// Verificar si el código ya existe en la tabla actual
			const tbody = $('#tblProfesiones tbody');
			const codigoExistente = tbody.find(`span.badge:contains("${codigo}")`);

			if (codigoExistente.length > 0) {
				// Si estamos editando, verificar que no sea el mismo registro
				if (id) {
					const filaActual = tbody.find(`button[onclick="editarProfesion(${id})"]`).closest('tr');
					const codigoActual = filaActual.find('span.badge').text();

					// Si el código no cambió, permitir la actualización
					if (codigoActual !== codigo) {
						showToast('warning', 'Validación', 'El código ingresado ya existe. Por favor, ingrese un código diferente.');
						return;
					}
				} else {
					// Para nuevos registros, cualquier código duplicado es inválido
					showToast('warning', 'Validación', 'El código ingresado ya existe. Por favor, ingrese un código diferente.');
					return;
				}
			}

			// Preparar datos para enviar
			const profesionData = {
				ID: id || null,
				Code: codigo,
				Descripcion: descripcion
			};


			// Mostrar loading
			$('#btnGuardarProfesion').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarProfesion",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ profesionData: profesionData }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							showToast('error', 'Error', 'Error al procesar la respuesta');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', responseData.Mensaje || 'Profesión guardada exitosamente');
						$('#modalProfesion').modal('hide');
						cargarProfesiones(); // Recargar la tabla
					} else {
						// Mostrar mensaje de error más descriptivo
						const mensajeError = responseData.Mensaje || 'Error al guardar la profesión';
						showToast('error', 'Error', mensajeError);

						// Si es error de código duplicado, enfocar el campo código
						if (mensajeError.includes('código ingresado ya existe') || mensajeError.includes('duplicate key')) {
							$('#txtCodigoProfesion').focus().select();
						}
					}
				},
				error: function (xhr, status, error) {
					showToast('error', 'Error', 'Error al guardar la profesión');
				},
				complete: function () {
					// Restaurar botón
					$('#btnGuardarProfesion').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
				}
			});
		}

		// ===== FUNCIONES PARA EMPRESAS =====
		function inicializarEmpresas() {
			// Cargar datos iniciales
			cargarEmpresas();

			// Configurar eventos
			configurarEventosEmpresas();
		}
		function cargarEmpresas() {
			const filtros = {
				Codigo: $('#txtFiltroCodigoEmpresa').val() || '',
				Descripcion: $('#txtFiltroDescripcionEmpresa').val() || ''
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarEmpresas",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							mostrarEmpresas([]);
							showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						try {
							const empresas = JSON.parse(responseData.Datos);
							mostrarEmpresas(empresas);
						} catch (parseError) {
							mostrarEmpresas([]);
							showToast('error', 'Error', 'Error al procesar los datos');
						}
					} else {
						mostrarEmpresas([]);
						showToast('warning', 'Advertencia', responseData ? responseData.Mensaje : 'No se encontraron datos');
					}
				},
				error: function (xhr, status, error) {
					mostrarEmpresas([]);
					showToast('error', 'Error', 'Error al cargar empresas');
				}
			});
		}

		function mostrarEmpresas(empresas) {
			const tbody = $('#tblEmpresas tbody');

			if (tbody.length === 0) {
				return;
			}

			tbody.empty();

			if (!empresas || !Array.isArray(empresas) || empresas.length === 0) {
				tbody.append(`
                    <tr>
                        <td colspan="4" class="text-center text-muted">
                            <i class="fas fa-info-circle me-2"></i>No se encontraron empresas
                        </td>
                    </tr>
                `);
				return;
			}

			try {
				$.each(empresas, function (index, empresa) {
					if (!empresa) {
						return;
					}

					const row = `
                        <tr>
                            <td>${empresa.ID || ''}</td>
                            <td><span class="badge bg-primary">${empresa.Code || ''}</span></td>
                            <td>${empresa.Descripcion || ''}</td>
                            <td>
                                <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarEmpresa(${empresa.ID})" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger btn-eliminar-empresa" data-empresa-id="${empresa.ID}" title="Eliminar">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `;
					tbody.append(row);
					
					// Agregar event listener después de agregar la fila
					const btnEliminar = tbody.find('tr:last-child .btn-eliminar-empresa[data-empresa-id="' + empresa.ID + '"]');
					btnEliminar.off('click').on('click', function(e) {
						e.preventDefault();
						e.stopPropagation();
						eliminarEmpresa(empresa.ID);
					});
				});
			} catch (error) {
				tbody.append(`
                    <tr>
                        <td colspan="4" class="text-center text-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>Error al mostrar los datos
                        </td>
                    </tr>
                `);
			}
		}

		function configurarEventosEmpresas() {
			// Botón Nuevo
			$('#btnNuevoEmpresa').off('click').on('click', function () {
				limpiarFormularioEmpresa();
				$('#modalEmpresaLabel').html('<i class="fas fa-building me-2"></i>Nueva Empresa');
				$('#modalEmpresa').modal('show');

				// Enfocar el campo Código después de que el modal se muestre
				$('#modalEmpresa').on('shown.bs.modal', function () {
					$('#txtCodigoEmpresa').focus();
				});
			});

			// Botón Buscar
			$('#btnBuscarEmpresas').off('click').on('click', function () {
				cargarEmpresas();
			});

			// Botón Limpiar
			$('#btnLimpiarFiltrosEmpresa').off('click').on('click', function () {
				$('#txtFiltroCodigoEmpresa').val('');
				$('#txtFiltroDescripcionEmpresa').val('');
				cargarEmpresas();
			});

			// Botón Guardar
			$('#btnGuardarEmpresa').off('click').on('click', function () {
				guardarEmpresa();
			});

			// Enter en filtros
			$('#txtFiltroCodigoEmpresa, #txtFiltroDescripcionEmpresa').off('keypress').on('keypress', function (e) {
				if (e.which === 13) {
					cargarEmpresas();
				}
			});

			// Enter en campos del modal para guardar
			$('#txtCodigoEmpresa, #txtDescripcionEmpresa').off('keypress').on('keypress', function (e) {
				if (e.which === 13) {
					e.preventDefault();
					guardarEmpresa();
				}
			});
		}

		function limpiarFormularioEmpresa() {
			$('#hdnIDEmpresa').val('');
			$('#txtCodigoEmpresa').val('');
			$('#txtDescripcionEmpresa').val('');
		}

		function editarEmpresa(id) {

			// Buscar la empresa en la tabla actual
			const tbody = $('#tblEmpresas tbody');
			const row = tbody.find(`button[onclick="editarEmpresa(${id})"]`).closest('tr');

			if (row.length === 0) {
				showToast('error', 'Error', 'No se encontró la empresa a editar');
				return;
			}

			// Extraer datos de la fila
			const cells = row.find('td');
			const codigo = cells.eq(1).find('.badge').text();
			const descripcion = cells.eq(2).text();

			// Llenar el formulario del modal
			$('#hdnIDEmpresa').val(id);
			$('#txtCodigoEmpresa').val(codigo);
			$('#txtDescripcionEmpresa').val(descripcion);

			// Cambiar título del modal
			$('#modalEmpresaLabel').html('<i class="fas fa-building me-2"></i>Editar Empresa');

			// Mostrar el modal
			$('#modalEmpresa').modal('show');
		}

		function eliminarEmpresa(id) {
			if (!id) {
				showToast('error', 'Error', 'ID de empresa no válido');
				return;
			}

			// Obtener descripción de la empresa para mostrar en la confirmación
			const tbody = $('#tblEmpresas tbody');
			
			// Buscar la fila usando el atributo data-empresa-id o onclick
			let row = tbody.find(`button.btn-eliminar-empresa[data-empresa-id="${id}"]`).closest('tr');
			if (row.length === 0) {
				// Fallback: buscar por onclick
				row = tbody.find(`button[onclick="eliminarEmpresa(${id})"]`).closest('tr');
			}
			
			if (row.length === 0) {
				showToast('error', 'Error', 'No se encontró la empresa a eliminar');
				return;
			}
			
			const descripcion = row.find('td').eq(2).text();

			// Mostrar confirmación personalizada
			mostrarConfirmEliminar(`Empresa "${descripcion}"`, function () {

				// Mostrar loading en el botón
				let btnEliminar = row.find(`button.btn-eliminar-empresa[data-empresa-id="${id}"]`);
				if (btnEliminar.length === 0) {
					btnEliminar = row.find(`button[onclick="eliminarEmpresa(${id})"]`);
				}
				btnEliminar.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i>');

				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarEmpresa",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						let responseData = response.d;
						if (typeof responseData === 'string') {
							try {
								responseData = JSON.parse(responseData);
							} catch (parseError) {
								showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
								return;
							}
						}

						if (responseData && responseData.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', responseData.Mensaje || 'Empresa eliminada exitosamente');
							cargarEmpresas(); // Recargar la tabla
						} else {
							const mensajeError = responseData.Mensaje || 'Error al eliminar la empresa';
							showToast('error', 'Error', mensajeError);
						}
					},
					error: function (xhr, status, error) {
						showToast('error', 'Error', 'Error al eliminar la empresa: ' + error);
					},
					complete: function () {
						if (btnEliminar && btnEliminar.length > 0) {
							btnEliminar.prop('disabled', false).html('<i class="fas fa-trash"></i>');
						}
					}
				});
			});
		}

		function guardarEmpresa() {

			// Validar campos requeridos
			const codigo = $('#txtCodigoEmpresa').val().trim();
			const descripcion = $('#txtDescripcionEmpresa').val().trim();
			const id = $('#hdnIDEmpresa').val();

			if (!codigo || !descripcion) {
				showToast('warning', 'Advertencia', 'Por favor complete todos los campos requeridos');
				return;
			}

			// Deshabilitar botón y mostrar loading
			$('#btnGuardarEmpresa').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');

			const empresaData = {
				ID: id || null,
				Code: parseInt(codigo),
				Descripcion: descripcion
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarEmpresa",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ empresaData: empresaData }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', responseData.Mensaje || 'Empresa guardada exitosamente');
						$('#modalEmpresa').modal('hide');
						cargarEmpresas(); // Recargar la tabla
					} else {
						// Mostrar mensaje de error más descriptivo
						const mensajeError = responseData.Mensaje || 'Error al guardar la empresa';
						showToast('error', 'Error', mensajeError);

						// Si es error de código duplicado, enfocar el campo código
						if (mensajeError.includes('código ingresado ya existe') || mensajeError.includes('duplicate key')) {
							$('#txtCodigoEmpresa').focus().select();
						}
					}
				},
				error: function (xhr, status, error) {
					showToast('error', 'Error', 'Error al guardar la empresa');
				},
				complete: function () {
					// Restaurar botón
					$('#btnGuardarEmpresa').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
				}
			});
		}
		// ===== FUNCIONES PARA OCUPACIONES =====
		function inicializarOcupaciones() {
			cargarOcupaciones();
			configurarEventosOcupaciones();
		}

		function cargarOcupaciones() {
			const filtros = {
				Codigo: $('#txtFiltroCodigoOcupacion').val(),
				Descripcion: $('#txtFiltroDescripcionOcupacion').val()
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarOcupaciones",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							showToast('error', 'Error', 'Error al procesar la respuesta');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const ocupaciones = JSON.parse(responseData.Datos);
						mostrarOcupaciones(ocupaciones);
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al cargar ocupaciones');
					}
				},
				error: function (xhr, status, error) {
					showToast('error', 'Error', 'Error al cargar ocupaciones');
				}
			});
		}

		function mostrarOcupaciones(ocupaciones) {
			const tbody = $('#tblOcupaciones tbody');
			tbody.empty();

			ocupaciones.forEach(function (ocupacion) {
				const row = `
                    <tr>
                        <td>${ocupacion.ID}</td>
                        <td><span class="badge bg-primary">${ocupacion.Code}</span></td>
                        <td>${ocupacion.Descripcion}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarOcupacion(${ocupacion.ID})" title="Editar">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarOcupacion(${ocupacion.ID})" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
				tbody.append(row);
			});
		}

		function configurarEventosOcupaciones() {
			// Botón Nuevo
			$('#btnNuevoOcupacion').off('click').on('click', function () {
				limpiarFormularioOcupacion();
				$('#modalOcupacionLabel').html('<i class="fas fa-user-tie me-2"></i>Nueva Ocupación');
				$('#modalOcupacion').modal('show');

				// Enfocar el campo Código después de que el modal se muestre
				$('#modalOcupacion').on('shown.bs.modal', function () {
					$('#txtCodigoOcupacion').focus();
				});
			});

			// Botón Buscar
			$('#btnBuscarOcupaciones').off('click').on('click', function () {
				cargarOcupaciones();
			});

			// Botón Limpiar
			$('#btnLimpiarFiltrosOcupacion').off('click').on('click', function () {
				limpiarFiltrosOcupacion();
			});

			// Botón Guardar
			$('#btnGuardarOcupacion').off('click').on('click', function () {
				guardarOcupacion();
			});
		}

		function limpiarFiltrosOcupacion() {
			$('#txtFiltroCodigoOcupacion').val('');
			$('#txtFiltroDescripcionOcupacion').val('');
			cargarOcupaciones();
		}

		function limpiarFormularioOcupacion() {
			$('#hdnIDOcupacion').val('');
			$('#txtCodigoOcupacion').val('');
			$('#txtDescripcionOcupacion').val('');
		}
		function editarOcupacion(id) {

			// Buscar la ocupación en la tabla
			const tbody = $('#tblOcupaciones tbody');
			const row = tbody.find(`button[onclick="editarOcupacion(${id})"]`).closest('tr');

			if (row.length === 0) {
				showToast('error', 'Error', 'No se encontró la ocupación');
				return;
			}

			// Obtener datos de la fila
			const codigo = row.find('span.badge').text();
			const descripcion = row.find('td').eq(2).text();

			// Llenar formulario
			$('#hdnIDOcupacion').val(id);
			$('#txtCodigoOcupacion').val(codigo);
			$('#txtDescripcionOcupacion').val(descripcion);

			// Cambiar título del modal
			$('#modalOcupacionLabel').html('<i class="fas fa-user-tie me-2"></i>Editar Ocupación');

			// Mostrar el modal
			$('#modalOcupacion').modal('show');
		}

		function eliminarOcupacion(id) {

			// Obtener descripción de la ocupación para mostrar en la confirmación
			const tbody = $('#tblOcupaciones tbody');
			const row = tbody.find(`button[onclick="eliminarOcupacion(${id})"]`).closest('tr');
			const descripcion = row.find('td').eq(2).text();

			// Mostrar confirmación personalizada
			mostrarConfirmEliminar(`Ocupación "${descripcion}"`, function () {

				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarOcupacion",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {

						let responseData = response.d;
						if (typeof responseData === 'string') {
							try {
								responseData = JSON.parse(responseData);
							} catch (parseError) {
								showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
								return;
							}
						}

						if (responseData && responseData.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', responseData.Mensaje || 'Ocupación eliminada exitosamente');
							cargarOcupaciones(); // Recargar la tabla
						} else {
							const mensajeError = responseData.Mensaje || 'Error al eliminar la ocupación';
							showToast('error', 'Error', mensajeError);
						}
					},
					error: function (xhr, status, error) {
						showToast('error', 'Error', 'Error al eliminar la ocupación');
					}
				});
			});
		}

		function guardarOcupacion() {

			// Validar campos requeridos
			const codigo = $('#txtCodigoOcupacion').val().trim();
			const descripcion = $('#txtDescripcionOcupacion').val().trim();
			const id = $('#hdnIDOcupacion').val();

			if (!codigo || !descripcion) {
				showToast('warning', 'Validación', 'Código y descripción son requeridos');
				return;
			}

			// Validar que el código sea numérico
			if (isNaN(codigo) || parseInt(codigo) <= 0) {
				showToast('warning', 'Validación', 'El código debe ser un número entero positivo');
				return;
			}

			// Preparar datos para enviar
			const ocupacionData = {
				ID: id || null,
				Code: parseInt(codigo),
				Descripcion: descripcion
			};

			// Mostrar loading
			$('#btnGuardarOcupacion').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarOcupacion",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ ocupacionData: ocupacionData }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							showToast('error', 'Error', 'Error al procesar la respuesta');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', responseData.Mensaje || 'Ocupación guardada exitosamente');
						$('#modalOcupacion').modal('hide');
						cargarOcupaciones(); // Recargar la tabla
					} else {
						// Mostrar mensaje de error más descriptivo
						const mensajeError = responseData.Mensaje || 'Error al guardar la ocupación';
						showToast('error', 'Error', mensajeError);

						// Si es error de código duplicado, enfocar el campo
						if (mensajeError.includes('código ingresado ya existe') || mensajeError.includes('duplicate key')) {
							$('#txtCodigoOcupacion').focus().select();
						}
					}
				},
				error: function (xhr, status, error) {
					showToast('error', 'Error', 'Error al guardar la ocupación');
				},
				complete: function () {
					// Restaurar botón
					$('#btnGuardarOcupacion').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
				}
			});
		}

		// ===== FUNCIONES PARA REGIONES =====

		// ===== PAÍSES =====
		function inicializarPaises() {
			cargarPaises();
			configurarEventosPaises();
		}

		function cargarPaises() {
			const filtros = {
				CodigoISO: $('#txtFiltroCodigoPais').val() || '',
				Descripcion: $('#txtFiltroDescripcionPais').val() || ''
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarPaises",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						try {
							responseData = JSON.parse(responseData);
						} catch (parseError) {
							showToast('error', 'Error', 'Error al procesar la respuesta');
							return;
						}
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const paises = JSON.parse(responseData.Datos);
						mostrarPaises(paises);
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al cargar países');
					}
				},
				error: function (xhr, status, error) {
					showToast('error', 'Error', 'Error al cargar países');
				}
			});
		}

		function mostrarPaises(paises) {
			const tbody = $('#tblPaises tbody');
			tbody.empty();

			if (paises && paises.length > 0) {
				paises.forEach(function (pais) {
					const row = `
                        <tr>
                            <td>${pais.ID}</td>
                            <td><span class="badge bg-primary">${pais.Code}</span></td>
                            <td>${pais.Descripcion}</td>
                            <td>
                                <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarPais(${pais.ID})" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarPais(${pais.ID})" title="Eliminar">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `;
					tbody.append(row);
				});
			} else {
				tbody.append('<tr><td colspan="4" class="text-center text-muted">No hay datos disponibles</td></tr>');
			}
		}

		function configurarEventosPaises() {
			$('#btnNuevoPais').on('click', function () {
				limpiarFormularioPais();
				$('#modalPaisLabel').html('<i class="fas fa-globe me-2"></i>Nuevo País');
				$('#modalPais').modal('show');
			});

			$('#btnBuscarPaises').on('click', function () {
				cargarPaises();
			});

			$('#btnLimpiarFiltrosPais').on('click', function () {
				limpiarFiltrosPais();
			});

			$('#btnGuardarPais').on('click', function () {
				guardarPais();
			});

			$('#txtFiltroCodigoPais, #txtFiltroDescripcionPais').on('keypress', function (e) {
				if (e.which === 13) {
					cargarPaises();
				}
			});
		}

		function limpiarFiltrosPais() {
			$('#txtFiltroCodigoPais').val('');
			$('#txtFiltroDescripcionPais').val('');
			cargarPaises();
		}

		function limpiarFormularioPais() {
			$('#hdnIDPais').val('');
			$('#txtCodigoISOPais').val('');
			$('#txtDescripcionPais').val('');
		}

		function editarPais(id) {
			const tbody = $('#tblPaises tbody');
			const row = tbody.find(`button[onclick="editarPais(${id})"]`).closest('tr');

			if (row.length === 0) {
				showToast('error', 'Error', 'No se encontró el país');
				return;
			}

			const codigo = row.find('span.badge').text();
			const descripcion = row.find('td').eq(2).text();

			$('#hdnIDPais').val(id);
			$('#txtCodigoISOPais').val(codigo);
			$('#txtDescripcionPais').val(descripcion);

			$('#modalPaisLabel').html('<i class="fas fa-globe me-2"></i>Editar País');
			$('#modalPais').modal('show');
		}

		function eliminarPais(id) {
			const tbody = $('#tblPaises tbody');
			const row = tbody.find(`button[onclick="eliminarPais(${id})"]`).closest('tr');
			const descripcion = row.find('td').eq(2).text();

			mostrarConfirmEliminar(`País "${descripcion}"`, function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarPais",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						let responseData = response.d;
						if (typeof responseData === 'string') {
							responseData = JSON.parse(responseData);
						}

						if (responseData && responseData.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', responseData.Mensaje || 'País eliminado exitosamente');
							cargarPaises();
						} else {
							showToast('error', 'Error', responseData.Mensaje || 'Error al eliminar país');
						}
					},
					error: function () {
						showToast('error', 'Error', 'Error al eliminar país');
					}
				});
			});
		}
		function guardarPais() {
			const codigoISO = $('#txtCodigoISOPais').val().trim().toUpperCase();
			const descripcion = $('#txtDescripcionPais').val().trim();
			const id = $('#hdnIDPais').val();

			if (!codigoISO || !descripcion) {
				showToast('warning', 'Validación', 'Código ISO y descripción son requeridos');
				return;
			}

			$('#btnGuardarPais').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');

			const paisData = {
				ID: id || null,
				Code: codigoISO,
				Descripcion: descripcion
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarPais",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ paisData: paisData }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', responseData.Mensaje || 'País guardado exitosamente');
						$('#modalPais').modal('hide');
						cargarPaises();
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al guardar país');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al guardar país');
				},
				complete: function () {
					$('#btnGuardarPais').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
				}
			});
		}

		// ===== PROVINCIAS =====
		function inicializarProvincias() {
			cargarPaisesParaProvincias();
			cargarPaisesParaFiltroProvincias();
			cargarProvincias();
			configurarEventosProvincias();
		}
		function cargarPaisesParaFiltroProvincias() {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarPaises",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: {} }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const paises = JSON.parse(responseData.Datos);
						const select = $('#ddlFiltroPaisProvincia');
						select.empty().append('<option value="">Todos</option>');
						paises.forEach(function (pais) {
							select.append(`<option value="${pais.Code}">${pais.Descripcion}</option>`);
						});
					}
				}
			});
		}

		function cargarPaisesParaProvincias() {
			return $.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarPaises",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: {} }),
				dataType: "json"
			}).then(function (response) {
				let responseData = response.d;
				if (typeof responseData === 'string') {
					responseData = JSON.parse(responseData);
				}

				if (responseData && responseData.Resultado === 'SUCCESS') {
					const paises = JSON.parse(responseData.Datos);
					const select = $('#ddlPaisProvincia');
					select.empty().append('<option value="">Seleccionar país...</option>');
					paises.forEach(function (pais) {
						select.append(`<option value="${pais.Code}">${pais.Descripcion}</option>`);
					});

					// Si Select2 ya está inicializado, destruirlo y reinicializarlo
					if ($.fn.select2 && select.hasClass('select2-hidden-accessible')) {
						select.select2('destroy');
					}
					
					// Inicializar Select2
					if ($.fn.select2) {
						select.select2({
							theme: 'bootstrap-5',
							placeholder: 'Seleccionar país...',
							allowClear: true,
							width: '100%',
							minimumResultsForSearch: 0,
							dropdownParent: $('#modalProvincia')
						});
					}
				}
			}).fail(function (xhr, status, error) {
			});
		}

		function cargarProvincias() {

			const filtros = {
				Code: $('#txtFiltroCodigoProvincia').val() || '',
				CodePais: $('#ddlFiltroPaisProvincia').val() || '',
				Descripcion: $('#txtFiltroDescripcionProvincia').val() || ''
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarProvincias",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const provincias = JSON.parse(responseData.Datos);
						mostrarProvincias(provincias);
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al cargar provincias');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al cargar provincias');
				}
			});
		}

		function mostrarProvincias(provincias) {
			const tbody = $('#tblProvincias tbody');
			tbody.empty();

			if (provincias && provincias.length > 0) {
				provincias.forEach(function (provincia) {
					const row = `
                        <tr>
                            <td>${provincia.ID}</td>
                            <td><span class="badge bg-primary">${provincia.Code}</span></td>
                            <td>${provincia.PaisDescripcion || '-'}</td>
                            <td>${provincia.Descripcion}</td>
                            <td>
                                <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarProvincia(${provincia.ID})" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarProvincia(${provincia.ID})" title="Eliminar">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `;
					tbody.append(row);
				});
			} else {
				tbody.append('<tr><td colspan="5" class="text-center text-muted">No hay datos disponibles</td></tr>');
			}
		}

		function configurarEventosProvincias() {
			$('#btnNuevoProvincia').on('click', function () {
				limpiarFormularioProvincia();
				$('#modalProvinciaLabel').html('<i class="fas fa-map me-2"></i>Nueva Provincia');
				$('#modalProvincia').modal('show');

				// Cargar provincias de Panamá si está seleccionado
				setTimeout(function () {
					if ($('#ddlPaisProvincia').val() === 'PA') {
						cargarProvinciasPorPaisParaProvincia('PA');
					}
				}, 300);
			});

			$('#btnBuscarProvincias').on('click', function () {
				cargarProvincias();
			});

			$('#btnLimpiarFiltrosProvincia').on('click', function () {
				limpiarFiltrosProvincia();
			});

			$('#btnGuardarProvincia').on('click', function () {
				guardarProvincia();
			});

			// Event listener para cambio de país en el modal
			$('#ddlPaisProvincia').on('change', function () {
				const codigoPais = $(this).val();
				if (codigoPais) {
					cargarProvinciasPorPaisParaProvincia(codigoPais);
				}
			});

			// Reinicializar Select2 cuando se abre el modal y cargar países si están vacíos
			$('#modalProvincia').on('shown.bs.modal', function () {
				const select = $('#ddlPaisProvincia');
				const numOpciones = select.find('option').length;
				
				// Si el dropdown está vacío o solo tiene la opción por defecto, cargar países
				if (numOpciones <= 1) {
					cargarPaisesParaProvincias();
				} else {
					// Si ya tiene opciones, solo inicializar Select2 si no está inicializado
					if ($.fn.select2 && !select.hasClass('select2-hidden-accessible')) {
						select.select2({
							theme: 'bootstrap-5',
							placeholder: 'Seleccionar país...',
							allowClear: true,
							width: '100%',
							minimumResultsForSearch: 0,
							dropdownParent: $('#modalProvincia')
						});
					}
				}
			});
		}

		function cargarProvinciasPorPaisParaProvincia(codigoPais) {
			if (!codigoPais) {
				return;
			}

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarProvincias",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: { CodePais: codigoPais } }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const provincias = JSON.parse(responseData.Datos);
						// Esta función es para mostrar provincias en el modal, pero no hay un select de provincias en el modal de provincias
						// Solo se usa para actualizar cuando cambia el país
					}
				}
			});
		}

		function limpiarFiltrosProvincia() {
			$('#txtFiltroCodigoProvincia').val('');
			$('#ddlFiltroPaisProvincia').val('');
			$('#txtFiltroDescripcionProvincia').val('');
			cargarProvincias();
		}

		function limpiarFormularioProvincia() {
			$('#hdnIDProvincia').val('');
			$('#txtCodigoProvincia').val('');
			$('#ddlPaisProvincia').val('PA').trigger('change');
			$('#txtDescripcionProvincia').val('');
		}

		function editarProvincia(id) {
			const tbody = $('#tblProvincias tbody');
			const row = tbody.find(`button[onclick="editarProvincia(${id})"]`).closest('tr');

			if (row.length === 0) {
				return;
			}

			const codigo = row.find('span.badge').text();
			const descripcion = row.find('td').eq(3).text();

			// Necesitamos obtener el CodePais del registro
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarProvincias",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: { Code: codigo } }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const provincias = JSON.parse(responseData.Datos);
						if (provincias && provincias.length > 0) {
							const provincia = provincias[0];
							$('#hdnIDProvincia').val(id);
							$('#txtCodigoProvincia').val(provincia.Code);
							$('#txtDescripcionProvincia').val(provincia.Descripcion);

							// Primero cargar los países si no están cargados
							const selectPais = $('#ddlPaisProvincia');
							const numOpciones = selectPais.find('option').length;
							
							const promiseCargarPaises = (numOpciones <= 1) 
								? cargarPaisesParaProvincias() 
								: $.Deferred().resolve().promise();
							
							promiseCargarPaises.then(function() {
								// Luego establecer el valor del país
								$('#ddlPaisProvincia').val(provincia.CodePais);
								
								// Si Select2 está inicializado, actualizar el valor
								if ($.fn.select2 && $('#ddlPaisProvincia').hasClass('select2-hidden-accessible')) {
									$('#ddlPaisProvincia').trigger('change.select2');
								} else {
									$('#ddlPaisProvincia').trigger('change');
								}
								
								$('#modalProvinciaLabel').html('<i class="fas fa-map me-2"></i>Editar Provincia');
								$('#modalProvincia').modal('show');
							}).fail(function(error) {
								// Abrir el modal de todas formas
								$('#modalProvinciaLabel').html('<i class="fas fa-map me-2"></i>Editar Provincia');
								$('#modalProvincia').modal('show');
							});
						}
					}
				},
				error: function(xhr, status, error) {
				}
			});
		}

		function eliminarProvincia(id) {
			const tbody = $('#tblProvincias tbody');
			const row = tbody.find(`button[onclick="eliminarProvincia(${id})"]`).closest('tr');
			const descripcion = row.find('td').eq(3).text();

			mostrarConfirmEliminar(`Provincia "${descripcion}"`, function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarProvincia",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						let responseData = response.d;
						if (typeof responseData === 'string') {
							responseData = JSON.parse(responseData);
						}

						if (responseData && responseData.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', responseData.Mensaje || 'Provincia eliminada exitosamente');
							cargarProvincias();
						} else {
							showToast('error', 'Error', responseData.Mensaje || 'Error al eliminar provincia');
						}
					},
					error: function () {
						showToast('error', 'Error', 'Error al eliminar provincia');
					}
				});
			});
		}

		function guardarProvincia() {
			const codigo = $('#txtCodigoProvincia').val();
			const codigoPais = $('#ddlPaisProvincia').val();
			const descripcion = $('#txtDescripcionProvincia').val().trim();
			const id = $('#hdnIDProvincia').val();

			if (!codigo || !codigoPais || !descripcion) {
				showToast('warning', 'Validación', 'Todos los campos son requeridos');
				return;
			}

			$('#btnGuardarProvincia').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');

			const provinciaData = {
				ID: id || null,
				Code: parseInt(codigo),
				CodePais: codigoPais,
				Descripcion: descripcion
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarProvincia",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ provinciaData: provinciaData }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', responseData.Mensaje || 'Provincia guardada exitosamente');
						$('#modalProvincia').modal('hide');
						cargarProvincias();
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al guardar provincia');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al guardar provincia');
				},
				complete: function () {
					$('#btnGuardarProvincia').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
				}
			});
		}

		// ===== DISTRITOS =====
		function inicializarDistritos() {
			cargarPaisesParaDistritos();
			cargarPaisesParaFiltroDistritos();
			cargarProvinciasParaFiltroDistritos();
			cargarDistritos();
			configurarEventosDistritos();
		}

		function cargarPaisesParaFiltroDistritos() {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarPaises",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: {} }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const paises = JSON.parse(responseData.Datos);
						const select = $('#ddlFiltroPaisDistrito');
						select.empty().append('<option value="">Todos</option>');
						paises.forEach(function (pais) {
							select.append(`<option value="${pais.Code}">${pais.Descripcion}</option>`);
						});
					}
				}
			});
		}

		function cargarProvinciasParaFiltroDistritos() {
			$('#ddlFiltroPaisDistrito').on('change', function () {
				const codigoPais = $(this).val();
				const select = $('#ddlFiltroProvinciaDistrito');
				select.empty().append('<option value="">Todas</option>');

				if (codigoPais) {
					$.ajax({
						type: "POST",
						url: "Mantenimientos.aspx/ListarProvincias",
						contentType: "application/json; charset=utf-8",
						data: JSON.stringify({ filtros: { CodePais: codigoPais } }),
						dataType: "json",
						success: function (response) {
							let responseData = response.d;
							if (typeof responseData === 'string') {
								responseData = JSON.parse(responseData);
							}

							if (responseData && responseData.Resultado === 'SUCCESS') {
								const provincias = JSON.parse(responseData.Datos);
								provincias.forEach(function (provincia) {
									select.append(`<option value="${provincia.Code}">${provincia.Descripcion}</option>`);
								});
							}
						}
					});
				}
			});
		}
		function cargarPaisesParaDistritos() {
			return $.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarPaises",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: {} }),
				dataType: "json"
			}).then(function (response) {
				let responseData = response.d;
				if (typeof responseData === 'string') {
					responseData = JSON.parse(responseData);
				}

				if (responseData && responseData.Resultado === 'SUCCESS') {
					const paises = JSON.parse(responseData.Datos);
					const selects = ['#ddlPaisDistrito', '#ddlFiltroPaisDistrito'];
					selects.forEach(function (selector) {
						const select = $(selector);
						// Si Select2 ya está inicializado, destruirlo
						if ($.fn.select2 && select.hasClass('select2-hidden-accessible')) {
							select.select2('destroy');
						}
						select.empty().append('<option value="">Seleccionar país...</option>');
						paises.forEach(function (pais) {
							select.append(`<option value="${pais.Code}">${pais.Descripcion}</option>`);
						});
						
						// Inicializar Select2 solo para el dropdown del modal (no para el filtro)
						if (selector === '#ddlPaisDistrito' && $.fn.select2) {
							select.select2({
								theme: 'bootstrap-5',
								placeholder: 'Seleccionar país...',
								allowClear: true,
								width: '100%',
								minimumResultsForSearch: 0,
								dropdownParent: $('#modalDistrito')
							});
						}
					});
				}
			}).fail(function (xhr, status, error) {
			});
		}

		function cargarProvinciasPorPaisParaDistrito(codigoPais) {
			if (!codigoPais) {
				$('#ddlProvinciaDistrito').empty().append('<option value="">Seleccionar provincia...</option>');
				return $.Deferred().resolve().promise();
			}

			return $.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarProvincias",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: { CodePais: codigoPais } }),
				dataType: "json"
			}).then(function (response) {
				let responseData = response.d;
				if (typeof responseData === 'string') {
					responseData = JSON.parse(responseData);
				}

				if (responseData && responseData.Resultado === 'SUCCESS') {
					const provincias = JSON.parse(responseData.Datos);
					const select = $('#ddlProvinciaDistrito');
					select.empty().append('<option value="">Seleccionar provincia...</option>');
					provincias.forEach(function (provincia) {
						select.append(`<option value="${provincia.Code}">${provincia.Descripcion}</option>`);
					});
				}
			});
		}

		function cargarDistritos() {

			const filtros = {
				Code: $('#txtFiltroCodigoDistrito').val() || '',
				CodePais: $('#ddlFiltroPaisDistrito').val() || '',
				CodeProvincia: $('#ddlFiltroProvinciaDistrito').val() || '',
				Descripcion: $('#txtFiltroDescripcionDistrito').val() || ''
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarDistritos",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const distritos = JSON.parse(responseData.Datos);
						mostrarDistritos(distritos);
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al cargar distritos');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al cargar distritos');
				}
			});
		}
		function mostrarDistritos(distritos) {
			const tbody = $('#tblDistritos tbody');
			tbody.empty();

			if (distritos && distritos.length > 0) {
				distritos.forEach(function (distrito) {
					const row = `
                        <tr>
                            <td>${distrito.ID}</td>
                            <td><span class="badge bg-primary">${distrito.Code}</span></td>
                            <td>${distrito.PaisDescripcion || '-'}</td>
                            <td>${distrito.ProvinciaDescripcion || '-'}</td>
                            <td>${distrito.Descripcion}</td>
                            <td>
                                <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarDistrito(${distrito.ID})" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarDistrito(${distrito.ID})" title="Eliminar">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `;
					tbody.append(row);
				});
			} else {
				tbody.append('<tr><td colspan="6" class="text-center text-muted">No hay datos disponibles</td></tr>');
			}
		}

		function configurarEventosDistritos() {
			$('#btnNuevoDistrito').on('click', function () {
				limpiarFormularioDistrito();
				$('#modalDistritoLabel').html('<i class="fas fa-map-marked-alt me-2"></i>Nuevo Distrito');
				$('#modalDistrito').modal('show');

				// Cargar provincias de Panamá si está seleccionado
				setTimeout(function () {
					if ($('#ddlPaisDistrito').val() === 'PA') {
						cargarProvinciasPorPaisParaDistrito('PA');
					}
					$('#txtDescripcionDistrito').focus();
				}, 300);
			});

			$('#btnBuscarDistritos').on('click', function () {
				cargarDistritos();
			});

			$('#btnLimpiarFiltrosDistrito').on('click', function () {
				limpiarFiltrosDistrito();
			});

			$('#btnGuardarDistrito').on('click', function () {
				guardarDistrito();
			});

			$('#ddlPaisDistrito').on('change', function () {
				const codigoPais = $(this).val();
				$('#ddlProvinciaDistrito').empty().append('<option value="">Seleccionar provincia...</option>');
				if (codigoPais) {
					cargarProvinciasPorPaisParaDistrito(codigoPais);
				}
			});

			// Reinicializar Select2 cuando se abre el modal y cargar países si están vacíos
			$('#modalDistrito').on('shown.bs.modal', function () {
				const selectPais = $('#ddlPaisDistrito');
				// Si el dropdown de países está vacío o solo tiene la opción por defecto, cargar países
				if (selectPais.find('option').length <= 1) {
					cargarPaisesParaDistritos().then(function() {
						// Después de cargar, inicializar Select2 si es necesario
						if ($.fn.select2) {
							const selects = ['#ddlPaisDistrito', '#ddlProvinciaDistrito'];
							selects.forEach(function (selector) {
								const select = $(selector);
								if (!select.hasClass('select2-hidden-accessible')) {
									select.select2({
										theme: 'bootstrap-5',
										placeholder: 'Seleccionar...',
										allowClear: true,
										width: '100%',
										minimumResultsForSearch: 0,
										dropdownParent: $('#modalDistrito')
									});
								}
							});
						}
					});
				} else {
					// Si ya tiene opciones, solo inicializar Select2
					if ($.fn.select2) {
						const selects = ['#ddlPaisDistrito', '#ddlProvinciaDistrito'];
						selects.forEach(function (selector) {
							const select = $(selector);
							if (!select.hasClass('select2-hidden-accessible')) {
								select.select2({
									theme: 'bootstrap-5',
									placeholder: 'Seleccionar...',
									allowClear: true,
									width: '100%',
									minimumResultsForSearch: 0,
									dropdownParent: $('#modalDistrito')
								});
							}
						});
					}
				}
			});
		}

		function limpiarFiltrosDistrito() {
			$('#txtFiltroCodigoDistrito').val('');
			$('#ddlFiltroPaisDistrito').val('');
			$('#ddlFiltroProvinciaDistrito').val('');
			$('#txtFiltroDescripcionDistrito').val('');
			cargarDistritos();
		}

		function limpiarFormularioDistrito() {
			$('#hdnIDDistrito').val('');
			$('#txtCodigoDistrito').val('');
			$('#ddlPaisDistrito').val('PA').trigger('change');
			$('#ddlProvinciaDistrito').empty().append('<option value="">Seleccionar provincia...</option>');
			$('#txtDescripcionDistrito').val('');
		}

		function editarDistrito(id) {
			const tbody = $('#tblDistritos tbody');
			const row = tbody.find(`button[onclick="editarDistrito(${id})"]`).closest('tr');

			if (row.length === 0) {
				return;
			}

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarDistritos",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: {} }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const distritos = JSON.parse(responseData.Datos);
						const distrito = distritos.find(d => d.ID === id);
						if (distrito) {
							$('#hdnIDDistrito').val(id);
							$('#txtCodigoDistrito').val(distrito.Code);
							$('#txtDescripcionDistrito').val(distrito.Descripcion);

							// Primero cargar los países si no están cargados
							const selectPais = $('#ddlPaisDistrito');
							const promiseCargarPaises = (selectPais.find('option').length <= 1) 
								? cargarPaisesParaDistritos() 
								: $.Deferred().resolve().promise();
							
							promiseCargarPaises.then(function() {
								// Luego establecer el país y cargar provincias
								$('#ddlPaisDistrito').val(distrito.CodePais).trigger('change');
								return cargarProvinciasPorPaisParaDistrito(distrito.CodePais);
							}).then(function() {
								// Finalmente establecer la provincia
								$('#ddlProvinciaDistrito').val(distrito.CodeProvincia).trigger('change');
								
								$('#modalDistritoLabel').html('<i class="fas fa-map-marked-alt me-2"></i>Editar Distrito');
								$('#modalDistrito').modal('show');
							});
						}
					}
				},
				error: function(xhr, status, error) {
				}
			});
		}

		function eliminarDistrito(id) {
			const tbody = $('#tblDistritos tbody');
			const row = tbody.find(`button[onclick="eliminarDistrito(${id})"]`).closest('tr');
			const descripcion = row.find('td').eq(4).text();

			mostrarConfirmEliminar(`Distrito "${descripcion}"`, function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarDistrito",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						let responseData = response.d;
						if (typeof responseData === 'string') {
							responseData = JSON.parse(responseData);
						}

						if (responseData && responseData.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', responseData.Mensaje || 'Distrito eliminado exitosamente');
							cargarDistritos();
						} else {
							showToast('error', 'Error', responseData.Mensaje || 'Error al eliminar distrito');
						}
					},
					error: function () {
						showToast('error', 'Error', 'Error al eliminar distrito');
					}
				});
			});
		}

		function guardarDistrito() {
			const codigoPais = $('#ddlPaisDistrito').val();
			const codigoProvincia = $('#ddlProvinciaDistrito').val();
			const descripcion = $('#txtDescripcionDistrito').val().trim();
			const id = $('#hdnIDDistrito').val();
			const codigo = $('#txtCodigoDistrito').val();


			if (!codigoPais || !codigoProvincia || !descripcion) {
				showToast('warning', 'Validación', 'Todos los campos son requeridos');
				return;
			}

			$('#btnGuardarDistrito').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');

			const distritoData = {
				ID: (id && id.trim() !== '') ? id : null,
				Code: codigo ? parseInt(codigo) : null,
				CodePais: codigoPais,
				CodeProvincia: parseInt(codigoProvincia),
				Descripcion: descripcion
			};


			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarDistrito",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ distritoData: distritoData }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', responseData.Mensaje || 'Distrito guardado exitosamente');
						$('#modalDistrito').modal('hide');
						cargarDistritos();
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al guardar distrito');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al guardar distrito');
				},
				complete: function () {
					$('#btnGuardarDistrito').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
				}
			});
		}

		// ===== CORREGIMIENTOS =====
		function inicializarCorregimientos() {
			cargarPaisesParaCorregimientos();
			cargarPaisesParaFiltroCorregimientos();
			cargarProvinciasParaFiltroCorregimientos();
			cargarDistritosParaFiltroCorregimientos();
			cargarCorregimientos();
			configurarEventosCorregimientos();
		}
		function cargarPaisesParaFiltroCorregimientos() {
			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarPaises",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: {} }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const paises = JSON.parse(responseData.Datos);
						const select = $('#ddlFiltroPaisCorregimiento');
						select.empty().append('<option value="">Todos</option>');
						paises.forEach(function (pais) {
							select.append(`<option value="${pais.Code}">${pais.Descripcion}</option>`);
						});
					}
				}
			});
		}

		function cargarProvinciasParaFiltroCorregimientos() {
			$('#ddlFiltroPaisCorregimiento').on('change', function () {
				const codigoPais = $(this).val();
				const selectProvincia = $('#ddlFiltroProvinciaCorregimiento');
				const selectDistrito = $('#ddlFiltroDistritoCorregimiento');
				selectProvincia.empty().append('<option value="">Todas</option>');
				selectDistrito.empty().append('<option value="">Todos</option>');

				if (codigoPais) {
					$.ajax({
						type: "POST",
						url: "Mantenimientos.aspx/ListarProvincias",
						contentType: "application/json; charset=utf-8",
						data: JSON.stringify({ filtros: { CodePais: codigoPais } }),
						dataType: "json",
						success: function (response) {
							let responseData = response.d;
							if (typeof responseData === 'string') {
								responseData = JSON.parse(responseData);
							}

							if (responseData && responseData.Resultado === 'SUCCESS') {
								const provincias = JSON.parse(responseData.Datos);
								provincias.forEach(function (provincia) {
									selectProvincia.append(`<option value="${provincia.Code}">${provincia.Descripcion}</option>`);
								});
							}
						}
					});
				}
			});
		}

		function cargarDistritosParaFiltroCorregimientos() {
			$('#ddlFiltroProvinciaCorregimiento').on('change', function () {
				const codigoProvincia = $(this).val();
				const select = $('#ddlFiltroDistritoCorregimiento');
				select.empty().append('<option value="">Todos</option>');

				if (codigoProvincia) {
					$.ajax({
						type: "POST",
						url: "Mantenimientos.aspx/ListarDistritos",
						contentType: "application/json; charset=utf-8",
						data: JSON.stringify({ filtros: { CodeProvincia: codigoProvincia } }),
						dataType: "json",
						success: function (response) {
							let responseData = response.d;
							if (typeof responseData === 'string') {
								responseData = JSON.parse(responseData);
							}

							if (responseData && responseData.Resultado === 'SUCCESS') {
								const distritos = JSON.parse(responseData.Datos);
								distritos.forEach(function (distrito) {
									select.append(`<option value="${distrito.Code}">${distrito.Descripcion}</option>`);
								});
							}
						}
					});
				}
			});
		}

		function cargarPaisesParaCorregimientos() {
			return $.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarPaises",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: {} }),
				dataType: "json"
			}).then(function (response) {
				let responseData = response.d;
				if (typeof responseData === 'string') {
					responseData = JSON.parse(responseData);
				}

				if (responseData && responseData.Resultado === 'SUCCESS') {
					const paises = JSON.parse(responseData.Datos);
					const selects = ['#ddlPaisCorregimiento', '#ddlFiltroPaisCorregimiento'];
					selects.forEach(function (selector) {
						const select = $(selector);
						// Si Select2 ya está inicializado, destruirlo
						if ($.fn.select2 && select.hasClass('select2-hidden-accessible')) {
							select.select2('destroy');
						}
						select.empty().append('<option value="">Seleccionar país...</option>');
						paises.forEach(function (pais) {
							select.append(`<option value="${pais.Code}">${pais.Descripcion}</option>`);
						});
						
						// Inicializar Select2 solo para el dropdown del modal (no para el filtro)
						if (selector === '#ddlPaisCorregimiento' && $.fn.select2) {
							select.select2({
								theme: 'bootstrap-5',
								placeholder: 'Seleccionar país...',
								allowClear: true,
								width: '100%',
								minimumResultsForSearch: 0,
								dropdownParent: $('#modalCorregimiento')
							});
						}
					});
				}
			}).fail(function (xhr, status, error) {
			});
		}

		function cargarProvinciasPorPaisParaCorregimiento(codigoPais) {
			if (!codigoPais) {
				$('#ddlProvinciaCorregimiento').empty().append('<option value="">Seleccionar provincia...</option>');
				$('#ddlDistritoCorregimiento').empty().append('<option value="">Seleccionar distrito...</option>');
				return $.Deferred().resolve().promise();
			}

			return $.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarProvincias",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: { CodePais: codigoPais } }),
				dataType: "json"
			}).then(function (response) {
				let responseData = response.d;
				if (typeof responseData === 'string') {
					responseData = JSON.parse(responseData);
				}

				if (responseData && responseData.Resultado === 'SUCCESS') {
					const provincias = JSON.parse(responseData.Datos);
					const select = $('#ddlProvinciaCorregimiento');
					select.empty().append('<option value="">Seleccionar provincia...</option>');
					provincias.forEach(function (provincia) {
						select.append(`<option value="${provincia.Code}">${provincia.Descripcion}</option>`);
					});
					$('#ddlDistritoCorregimiento').empty().append('<option value="">Seleccionar distrito...</option>');
				}
			});
		}

		function cargarDistritosPorProvinciaParaCorregimiento(codigoProvincia) {
			
			if (!codigoProvincia) {
				const select = $('#ddlDistritoCorregimiento');
				// Destruir Select2 si está inicializado
				if (select.data('select2')) {
					select.select2('destroy');
				}
				select.empty().append('<option value="">Seleccionar distrito...</option>');
				// Reinicializar Select2
				if ($.fn.select2) {
					select.select2({
						theme: 'bootstrap-5',
						placeholder: 'Seleccionar distrito...',
						allowClear: true,
						width: '100%',
						minimumResultsForSearch: 0,
						dropdownParent: $('#modalCorregimiento')
					});
				}
				return $.Deferred().resolve().promise();
			}

			return $.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarDistritos",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: { CodeProvincia: codigoProvincia } }),
				dataType: "json"
			}).then(function (response) {
				let responseData = response.d;
				if (typeof responseData === 'string') {
					try {
						responseData = JSON.parse(responseData);
					} catch (parseError) {
						showToast('error', 'Error', 'Error al procesar la respuesta de distritos');
						return $.Deferred().reject().promise();
					}
				}

				if (responseData && responseData.Resultado === 'SUCCESS') {
					const distritos = JSON.parse(responseData.Datos);
					const select = $('#ddlDistritoCorregimiento');
					
					// Destruir Select2 si ya está inicializado
					if (select.data('select2')) {
						select.select2('destroy');
					}
					
					select.empty().append('<option value="">Seleccionar distrito...</option>');
					distritos.forEach(function (distrito) {
						select.append(`<option value="${distrito.Code}">${distrito.Descripcion}</option>`);
					});
					
					// Inicializar Select2 después de cargar las opciones
					if ($.fn.select2) {
						select.select2({
							theme: 'bootstrap-5',
							placeholder: 'Seleccionar distrito...',
							allowClear: true,
							width: '100%',
							minimumResultsForSearch: 0,
							dropdownParent: $('#modalCorregimiento')
						});
					}
				} else {
					showToast('error', 'Error', responseData.Mensaje || 'Error al cargar distritos');
					return $.Deferred().reject().promise();
				}
			}).fail(function (xhr, status, error) {
				showToast('error', 'Error', 'Error al cargar distritos');
				return $.Deferred().reject().promise();
			});
		}

		function cargarCorregimientos() {

			const filtros = {
				Code: $('#txtFiltroCodigoCorregimiento').val() || '',
				CodePais: $('#ddlFiltroPaisCorregimiento').val() || '',
				CodeProvincia: $('#ddlFiltroProvinciaCorregimiento').val() || '',
				CodeDistrito: $('#ddlFiltroDistritoCorregimiento').val() || '',
				Descripcion: $('#txtFiltroDescripcionCorregimiento').val() || ''
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarCorregimientos",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const corregimientos = JSON.parse(responseData.Datos);
						mostrarCorregimientos(corregimientos);
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al cargar corregimientos');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al cargar corregimientos');
				}
			});
		}

		function mostrarCorregimientos(corregimientos) {
			const tbody = $('#tblCorregimientos tbody');
			tbody.empty();

			if (corregimientos && corregimientos.length > 0) {
				corregimientos.forEach(function (corregimiento) {
					const row = `
                        <tr>
                            <td>${corregimiento.ID}</td>
                            <td><span class="badge bg-primary">${corregimiento.Code}</span></td>
                            <td>${corregimiento.PaisDescripcion || '-'}</td>
                            <td>${corregimiento.ProvinciaDescripcion || '-'}</td>
                            <td>${corregimiento.DistritoDescripcion || '-'}</td>
                            <td>${corregimiento.Descripcion}</td>
                            <td>
                                <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarCorregimiento(${corregimiento.ID})" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarCorregimiento(${corregimiento.ID})" title="Eliminar">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    `;
					tbody.append(row);
				});
			} else {
				tbody.append('<tr><td colspan="7" class="text-center text-muted">No hay datos disponibles</td></tr>');
			}
		}
		function configurarEventosCorregimientos() {
			$('#btnNuevoCorregimiento').on('click', function () {
				limpiarFormularioCorregimiento();
				$('#modalCorregimientoLabel').html('<i class="fas fa-map-pin me-2"></i>Nuevo Corregimiento');
				$('#modalCorregimiento').modal('show');

				// Cargar provincias de Panamá si está seleccionado
				setTimeout(function () {
					if ($('#ddlPaisCorregimiento').val() === 'PA') {
						cargarProvinciasPorPaisParaCorregimiento('PA');
					}
					$('#txtDescripcionCorregimiento').focus();
				}, 300);
			});

			$('#btnBuscarCorregimientos').on('click', function () {
				cargarCorregimientos();
			});

			$('#btnLimpiarFiltrosCorregimiento').on('click', function () {
				limpiarFiltrosCorregimiento();
			});

			$('#btnGuardarCorregimiento').on('click', function () {
				guardarCorregimiento();
			});

			$('#ddlPaisCorregimiento').on('change', function () {
				const codigoPais = $(this).val();
				$('#ddlProvinciaCorregimiento').empty().append('<option value="">Seleccionar provincia...</option>');
				$('#ddlDistritoCorregimiento').empty().append('<option value="">Seleccionar distrito...</option>');
				if (codigoPais) {
					cargarProvinciasPorPaisParaCorregimiento(codigoPais);
				}
			});

			$('#ddlProvinciaCorregimiento').on('change', function () {
				const codigoProvincia = $(this).val();
				$('#ddlDistritoCorregimiento').empty().append('<option value="">Seleccionar distrito...</option>');
				if (codigoProvincia) {
					cargarDistritosPorProvinciaParaCorregimiento(codigoProvincia);
				}
			});

			// Reinicializar Select2 cuando se abre el modal y cargar países si están vacíos
			$('#modalCorregimiento').on('shown.bs.modal', function () {
				const selectPais = $('#ddlPaisCorregimiento');
				// Si el dropdown de países está vacío o solo tiene la opción por defecto, cargar países
				if (selectPais.find('option').length <= 1) {
					cargarPaisesParaCorregimientos().then(function() {
						// Después de cargar, inicializar Select2 si es necesario
						if ($.fn.select2) {
							const selects = ['#ddlPaisCorregimiento', '#ddlProvinciaCorregimiento', '#ddlDistritoCorregimiento'];
							selects.forEach(function (selector) {
								const select = $(selector);
								if (!select.hasClass('select2-hidden-accessible')) {
									select.select2({
										theme: 'bootstrap-5',
										placeholder: 'Seleccionar...',
										allowClear: true,
										width: '100%',
										minimumResultsForSearch: 0,
										dropdownParent: $('#modalCorregimiento')
									});
								}
							});
						}
					});
				} else {
					// Si ya tiene opciones, solo inicializar Select2
					if ($.fn.select2) {
						const selects = ['#ddlPaisCorregimiento', '#ddlProvinciaCorregimiento', '#ddlDistritoCorregimiento'];
						selects.forEach(function (selector) {
							const select = $(selector);
							if (!select.hasClass('select2-hidden-accessible')) {
								select.select2({
									theme: 'bootstrap-5',
									placeholder: 'Seleccionar...',
									allowClear: true,
									width: '100%',
									minimumResultsForSearch: 0,
									dropdownParent: $('#modalCorregimiento')
								});
							}
						});
					}
				}
			});
		}

		function limpiarFiltrosCorregimiento() {
			$('#txtFiltroCodigoCorregimiento').val('');
			$('#ddlFiltroPaisCorregimiento').val('');
			$('#ddlFiltroProvinciaCorregimiento').val('');
			$('#ddlFiltroDistritoCorregimiento').val('');
			$('#txtFiltroDescripcionCorregimiento').val('');
			cargarCorregimientos();
		}

		function limpiarFormularioCorregimiento() {
			$('#hdnIDCorregimiento').val('');
			$('#txtCodigoCorregimiento').val('');
			$('#ddlPaisCorregimiento').val('PA').trigger('change');
			$('#ddlProvinciaCorregimiento').empty().append('<option value="">Seleccionar provincia...</option>');
			$('#ddlDistritoCorregimiento').empty().append('<option value="">Seleccionar distrito...</option>');
			$('#txtDescripcionCorregimiento').val('');
		}

		function editarCorregimiento(id) {
			const tbody = $('#tblCorregimientos tbody');
			const row = tbody.find(`button[onclick="editarCorregimiento(${id})"]`).closest('tr');

			if (row.length === 0) {
				return;
			}

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarCorregimientos",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: {} }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const corregimientos = JSON.parse(responseData.Datos);
						const corregimiento = corregimientos.find(c => c.ID === id);
						if (corregimiento) {
							$('#hdnIDCorregimiento').val(id);
							$('#txtCodigoCorregimiento').val(corregimiento.Code);
							$('#txtDescripcionCorregimiento').val(corregimiento.Descripcion);

							// Primero cargar los países si no están cargados
							const selectPais = $('#ddlPaisCorregimiento');
							const promiseCargarPaises = (selectPais.find('option').length <= 1) 
								? cargarPaisesParaCorregimientos() 
								: $.Deferred().resolve().promise();
							
							promiseCargarPaises.then(function() {
								// Luego establecer el país y cargar provincias
								$('#ddlPaisCorregimiento').val(corregimiento.CodePais).trigger('change');
								return cargarProvinciasPorPaisParaCorregimiento(corregimiento.CodePais);
							}).then(function() {
								// Luego establecer la provincia y cargar distritos
								$('#ddlProvinciaCorregimiento').val(corregimiento.CodeProvincia).trigger('change');
								return cargarDistritosPorProvinciaParaCorregimiento(corregimiento.CodeProvincia);
							}).then(function() {
								// Finalmente establecer el distrito
								$('#ddlDistritoCorregimiento').val(corregimiento.CodeDistrito).trigger('change');
								
								$('#modalCorregimientoLabel').html('<i class="fas fa-map-pin me-2"></i>Editar Corregimiento');
								$('#modalCorregimiento').modal('show');
							});
						}
					}
				},
				error: function(xhr, status, error) {
				}
			});
		}

		function eliminarCorregimiento(id) {
			const tbody = $('#tblCorregimientos tbody');
			const row = tbody.find(`button[onclick="eliminarCorregimiento(${id})"]`).closest('tr');
			const descripcion = row.find('td').eq(5).text();

			mostrarConfirmEliminar(`Corregimiento "${descripcion}"`, function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarCorregimiento",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						let responseData = response.d;
						if (typeof responseData === 'string') {
							responseData = JSON.parse(responseData);
						}

						if (responseData && responseData.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', responseData.Mensaje || 'Corregimiento eliminado exitosamente');
							cargarCorregimientos();
						} else {
							showToast('error', 'Error', responseData.Mensaje || 'Error al eliminar corregimiento');
						}
					},
					error: function () {
						showToast('error', 'Error', 'Error al eliminar corregimiento');
					}
				});
			});
		}

		function guardarCorregimiento() {
			const codigoPais = $('#ddlPaisCorregimiento').val();
			const codigoProvincia = $('#ddlProvinciaCorregimiento').val();
			const codigoDistrito = $('#ddlDistritoCorregimiento').val();
			const descripcion = $('#txtDescripcionCorregimiento').val().trim();
			const id = $('#hdnIDCorregimiento').val();
			const codigo = $('#txtCodigoCorregimiento').val();


			if (!codigoPais || !codigoProvincia || !codigoDistrito || !descripcion) {
				showToast('warning', 'Validación', 'Todos los campos son requeridos');
				return;
			}

			$('#btnGuardarCorregimiento').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');

			const corregimientoData = {
				ID: (id && id.trim() !== '') ? id : null,
				Code: codigo ? parseInt(codigo) : null,
				CodePais: codigoPais,
				CodeProvincia: parseInt(codigoProvincia),
				CodeDistrito: parseInt(codigoDistrito),
				Descripcion: descripcion
			};


			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarCorregimiento",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ corregimientoData: corregimientoData }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', responseData.Mensaje || 'Corregimiento guardado exitosamente');
						$('#modalCorregimiento').modal('hide');
						cargarCorregimientos();
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al guardar corregimiento');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al guardar corregimiento');
				},
				complete: function () {
					$('#btnGuardarCorregimiento').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
				}
			});
		}

		// ========== FUNCIONES PARA CUENTAS ==========
		function inicializarCuentas() {
			configurarEventosCuentas();
			cargarGruposCuenta();
		}
		function cargarGruposCuenta() {
			return $.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerGruposCuenta",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const grupos = JSON.parse(responseData.Datos);
						llenarDropdownGrupos(grupos);
						// Cargar cuentas después de cargar grupos solo si no estamos en el modal
						if (!$('#modalCuenta').is(':visible')) {
							cargarCuentas();
						}
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al cargar grupos de cuenta');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al cargar grupos de cuenta');
				}
			});
		}

		function llenarDropdownGrupos(grupos) {
			const $ddlFiltro = $('#ddlFiltroGrupoCuenta');
			const $ddlModal = $('#ddlGrupoCuenta');

			$ddlFiltro.empty().append('<option value="">Todos</option>');
			$ddlModal.empty().append('<option value="">Seleccionar grupo...</option>');

			grupos.forEach(function (grupo) {
				$ddlFiltro.append(`<option value="${grupo.IDGrupo}">${grupo.Descripcion}</option>`);
				$ddlModal.append(`<option value="${grupo.IDGrupo}">${grupo.Descripcion}</option>`);
			});
		}

		let ordenActualCuenta = { col: null, dir: 'ASC' };
		let debounceFiltroCuenta = null;

		function cargarCuentasDebounced() {
			clearTimeout(debounceFiltroCuenta);
			debounceFiltroCuenta = setTimeout(cargarCuentas, 350);
		}

		function actualizarIconosOrdenCuenta() {
			$('#tblCuentas thead th.sortable-cuenta').each(function () {
				const $icon = $(this).find('.sort-icon');
				if ($(this).data('col') === ordenActualCuenta.col) {
					$icon.removeClass('fa-sort text-muted')
						.addClass(ordenActualCuenta.dir === 'ASC' ? 'fa-sort-up' : 'fa-sort-down');
				} else {
					$icon.removeClass('fa-sort-up fa-sort-down').addClass('fa-sort text-muted');
				}
			});
		}

		function cargarCuentas() {
			const filtros = {
				IDGrupo: $('#ddlFiltroGrupoCuenta').val() || null,
				Codigo: $('#txtFiltroCodigoCuenta').val() || null,
				Nombre: $('#txtFiltroNombreCuenta').val() || null,
				OrderBy: ordenActualCuenta.col,
				OrderDir: ordenActualCuenta.dir
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ListarCuentas",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ filtros: filtros }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const cuentas = JSON.parse(responseData.Datos);
						mostrarCuentas(cuentas);
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al cargar cuentas');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al cargar cuentas');
				}
			});
		}

		function mostrarCuentas(cuentas) {
			const tbody = $('#tblCuentas tbody');
			tbody.empty();

			if (cuentas.length === 0) {
				tbody.append('<tr><td colspan="7" class="text-center">No se encontraron cuentas</td></tr>');
				return;
			}

			cuentas.forEach(function (cuenta) {
				const saldoNum = parseFloat(cuenta.Saldo || 0);
				const saldo = '$' + saldoNum.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
				const grupoChip = crearChipGrupoCuentaInteligente(cuenta.GrupoDescripcion);
				const imputable = cuenta.snImputable === true || cuenta.snImputable === 1 || cuenta.snImputable === '1';
				const checkedAttr = imputable ? ' checked' : '';
				const row = `
                    <tr>
                        <td>${cuenta.ID}</td>
                        <td><span class="badge bg-primary badge-codigo-cuenta">${cuenta.Codigo}</span></td>
                        <td>${cuenta.Nombre || ''}</td>
                        <td>${grupoChip}</td>
                        <td>
                            <div class="form-check form-switch form-switch-lg mb-0">
                                <input class="form-check-input switch-imputable-cuenta" type="checkbox" data-id="${cuenta.ID}"${checkedAttr} title="Imputable">
                            </div>
                        </td>
                        <td class="text-end">${saldo}</td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarCuenta(${cuenta.ID}); return false;">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarCuenta(${cuenta.ID}); return false;">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
				tbody.append(row);
			});
		}

		function configurarEventosCuentas() {
			$('#btnNuevoCuenta').on('click', function () {
				limpiarFormularioCuenta();
				// Asegurar que los grupos estén cargados antes de mostrar el modal
				if ($('#ddlGrupoCuenta option').length <= 1) {
					cargarGruposCuenta().then(function () {
						$('#modalCuentaLabel').html('<i class="fas fa-wallet me-2"></i>Nueva Cuenta');
						$('#modalCuenta').modal('show');
					});
				} else {
					$('#modalCuentaLabel').html('<i class="fas fa-wallet me-2"></i>Nueva Cuenta');
					$('#modalCuenta').modal('show');
				}
			});

			$('#ddlFiltroGrupoCuenta').on('change', function () {
				cargarCuentas();
			});

			$('#txtFiltroCodigoCuenta, #txtFiltroNombreCuenta').on('input', cargarCuentasDebounced);
			$('#txtFiltroCodigoCuenta, #txtFiltroNombreCuenta').on('keypress', function (e) {
				if (e.which === 13) { e.preventDefault(); clearTimeout(debounceFiltroCuenta); cargarCuentas(); }
			});

			$('.btn-limpiar-campo-cuenta').on('click', function () {
				const target = $(this).data('target');
				$('#' + target).val('');
				clearTimeout(debounceFiltroCuenta);
				cargarCuentas();
			});

			$('#tblCuentas thead').on('click', 'th.sortable-cuenta', function () {
				const col = $(this).data('col');
				if (ordenActualCuenta.col === col) {
					ordenActualCuenta.dir = (ordenActualCuenta.dir === 'ASC') ? 'DESC' : 'ASC';
				} else {
					ordenActualCuenta.col = col;
					ordenActualCuenta.dir = 'ASC';
				}
				actualizarIconosOrdenCuenta();
				cargarCuentas();
			});

			$('#btnLimpiarFiltrosCuenta').on('click', function () {
				limpiarFiltrosCuenta();
			});

			$('#btnGuardarCuenta').on('click', function () {
				guardarCuenta();
			});

			$(document).on('change', '.switch-imputable-cuenta', function () {
				const id = parseInt($(this).data('id'), 10);
				const snImputable = $(this).is(':checked');
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/GuardarCuentaImputable",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id, snImputable: snImputable }),
					dataType: "json",
					success: function (response) {
						let responseData = response.d;
						if (typeof responseData === 'string') responseData = JSON.parse(responseData);
						if (responseData && responseData.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', responseData.Mensaje || 'Imputable actualizado');
						} else {
							showToast('error', 'Error', responseData.Mensaje || 'Error al actualizar imputable');
							$(document).find('.switch-imputable-cuenta[data-id="' + id + '"]').prop('checked', !snImputable);
						}
					},
					error: function () {
						showToast('error', 'Error', 'Error al actualizar imputable');
						$(document).find('.switch-imputable-cuenta[data-id="' + id + '"]').prop('checked', !snImputable);
					}
				});
			});
		}

		function limpiarFiltrosCuenta() {
			$('#ddlFiltroGrupoCuenta').val('');
			$('#txtFiltroCodigoCuenta').val('');
			$('#txtFiltroNombreCuenta').val('');
			ordenActualCuenta = { col: null, dir: 'ASC' };
			actualizarIconosOrdenCuenta();
			cargarCuentas();
		}

		function limpiarFormularioCuenta() {
			$('#hdnIDCuenta').val('');
			$('#ddlGrupoCuenta').val('');
			$('#txtCodigoCuenta').val('');
			$('#txtNombreCuenta').val('');
			$('#chkSnImputableCuenta').prop('checked', true);
		}

		function editarCuenta(id) {
			if (!id) return false;

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/ObtenerCuenta",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ id: id }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						const cuenta = typeof responseData.Datos === 'string' ? JSON.parse(responseData.Datos) : responseData.Datos;
						llenarFormularioCuenta(cuenta);
						$('#modalCuentaLabel').html('<i class="fas fa-wallet me-2"></i>Editar Cuenta');
						$('#modalCuenta').modal('show');
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al obtener cuenta');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al obtener cuenta');
				}
			});
		}

		function llenarFormularioCuenta(cuenta) {
			$('#hdnIDCuenta').val(cuenta.ID);
			$('#ddlGrupoCuenta').val(cuenta.IDGrupo);
			$('#txtCodigoCuenta').val(cuenta.Codigo);
			$('#txtNombreCuenta').val(cuenta.Nombre || '');
			const raw = cuenta.snImputable !== undefined ? cuenta.snImputable : cuenta.SnImputable;
			const imputable = raw === true || raw === 1 || raw === '1' || String(raw).toLowerCase() === 'true';
			$('#chkSnImputableCuenta').prop('checked', !!imputable);
		}

		function eliminarCuenta(id) {
			if (!id) return false;

			const tbody = $('#tblCuentas tbody');
			const row = tbody.find(`button[onclick*="eliminarCuenta(${id})"]`).closest('tr');
			const codigo = row.find('span.badge').first().text();

			mostrarConfirmEliminar(`Cuenta "${codigo}"`, function () {
				$.ajax({
					type: "POST",
					url: "Mantenimientos.aspx/EliminarCuenta",
					contentType: "application/json; charset=utf-8",
					data: JSON.stringify({ id: id }),
					dataType: "json",
					success: function (response) {
						let responseData = response.d;
						if (typeof responseData === 'string') {
							responseData = JSON.parse(responseData);
						}

						if (responseData && responseData.Resultado === 'SUCCESS') {
							showToast('success', 'Éxito', responseData.Mensaje || 'Cuenta eliminada exitosamente');
							cargarCuentas();
						} else {
							showToast('error', 'Error', responseData.Mensaje || 'Error al eliminar cuenta');
						}
					},
					error: function () {
						showToast('error', 'Error', 'Error al eliminar cuenta');
					}
				});
			});
		}

		function guardarCuenta() {
			const idGrupo = $('#ddlGrupoCuenta').val();
			const codigo = $('#txtCodigoCuenta').val().trim();
			const nombre = $('#txtNombreCuenta').val().trim();
			const id = $('#hdnIDCuenta').val();

			if (!idGrupo || !codigo || !nombre) {
				showToast('warning', 'Validación', 'Todos los campos son requeridos');
				return;
			}

			$('#btnGuardarCuenta').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-1"></i>Guardando...');

			const snImputable = $('#chkSnImputableCuenta').is(':checked');
			const cuentaData = {
				ID: id || null,
				Codigo: codigo,
				Nombre: nombre,
				IDGrupo: parseInt(idGrupo),
				snImputable: snImputable
			};

			$.ajax({
				type: "POST",
				url: "Mantenimientos.aspx/GuardarCuenta",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ cuentaData: cuentaData }),
				dataType: "json",
				success: function (response) {
					let responseData = response.d;
					if (typeof responseData === 'string') {
						responseData = JSON.parse(responseData);
					}

					if (responseData && responseData.Resultado === 'SUCCESS') {
						showToast('success', 'Éxito', responseData.Mensaje || 'Cuenta guardada exitosamente');
						$('#modalCuenta').modal('hide');
						cargarCuentas();
					} else {
						showToast('error', 'Error', responseData.Mensaje || 'Error al guardar cuenta');
					}
				},
				error: function () {
					showToast('error', 'Error', 'Error al guardar cuenta');
				},
				complete: function () {
					$('#btnGuardarCuenta').prop('disabled', false).html('<i class="fas fa-save me-1"></i>Guardar');
				}
			});
		}

	</script>

</body>
</html>