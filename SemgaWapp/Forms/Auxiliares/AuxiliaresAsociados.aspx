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
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
        }
        
        body {
            background: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        form {
            display: flex;
            flex-direction: column;
            height: 100%;
            min-height: 0;
            overflow: hidden;
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
        
        .table-container {
            display: flex;
            flex-direction: column;
            flex: 1 1 auto;
            min-height: 0;
            overflow: hidden;
        }
        
        .table-responsive {
            flex: 1 1 auto;
            min-height: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            position: relative;
            height: 100%;
        }
        
        #tblAuxiliares td:nth-child(6),
        #tblAuxiliares td:nth-child(7),
        #tblAuxiliares td:nth-child(8),
        #tblAuxiliares td:nth-child(9),
        #tblAuxiliares td:nth-child(10),
        #tblAuxiliares td:nth-child(11),
        #tblAuxiliares td:nth-child(12),
        #tblAuxiliares td:nth-child(13),
        #tblAuxiliares td:nth-child(14) {
            white-space: nowrap;
        }
        
        /* Barra superior: título | filtros | botones en una fila */
        .top-bar-section {
            display: flex;
            align-items: stretch;
            gap: 6px;
            margin-bottom: 12px;
            flex-shrink: 0;
        }
        .top-bar-titulo {
            background: #2c3e50;
            color: white;
            padding: 10px 16px;
            display: flex;
            align-items: center;
            flex-shrink: 0;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .top-bar-titulo h6 {
            font-size: 15px;
            margin: 0;
            white-space: nowrap;
        }
        .top-bar-filtros {
            flex: 1;
            display: flex;
            align-items: flex-end;
            gap: 12px;
            padding: 8px 12px;
            background: #ffffff;
            min-width: 0;
            border-radius: 6px;
            border: 1px solid #e9ecef;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .top-bar-filtro-item {
            flex: 1;
            min-width: 0;
        }
        .top-bar-filtro-item .form-label {
            font-size: 11px;
            margin-bottom: 2px;
        }
        .top-bar-filtro-buscar {
            flex-shrink: 0;
            align-self: flex-end;
        }
        .top-bar-filtro-buscar .btn {
            min-width: 38px;
        }
        .top-bar-botones {
            background: #2c3e50;
            color: white;
            padding: 8px 12px;
            display: flex;
            align-items: center;
            gap: 8px;
            flex-shrink: 0;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .top-bar-botones .btn-light {
            background: rgba(255,255,255,0.2);
            border-color: rgba(255,255,255,0.3);
            color: white;
        }
        .top-bar-botones .btn-light:hover {
            background: rgba(255,255,255,0.3);
            border-color: rgba(255,255,255,0.5);
            color: white;
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
            font-size: 11px;
            padding: 6px 5px;
            text-align: center !important;
            vertical-align: middle;
        }
        
        .table thead th:last-child {
            border-right: none;
        }
        
        .table tbody td {
            padding: 5px;
            border-bottom: 1px solid #f1f3f4;
            border-right: 1px solid #dee2e6;
            vertical-align: middle;
            font-size: 11px;
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
        
        /* Chip para rubros nuevos no configurados: borde azul, fondo blanco, tag azul */
        .chip-rubro-nuevo {
            border: 1px solid #0d6efd !important;
            background-color: #fff !important;
            color: #0d6efd !important;
            padding: 0.35em 0.65em;
        }
        .chip-rubro-nuevo,
        .chip-rubro-nuevo .text-primary,
        .chip-rubro-nuevo i {
            color: #0d6efd !important;
        }
        
        .dataTables_wrapper {
            position: relative;
            display: flex;
            flex-direction: column;
            width: 100%;
            min-height: 0;
            flex: 1 1 auto;
            height: 100%;
            overflow: visible;
            max-height: 100%;
        }
        
        .dataTables_scroll {
            flex: 1 1 auto;
            min-height: 200px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        
        /* Estilos DataTables alineados con GestionSocios */
        #tblAuxiliares_wrapper .dataTables_scrollBody {
            min-height: 300px !important;
            overflow-y: auto !important;
        }
        .dataTables_scrollBody {
            border: 1px solid #dee2e6;
            border-top: none;
            flex: 1 1 auto;
            min-height: 200px;
            overflow-y: auto !important;
            overflow-x: auto !important;
        }
        .dataTables_scrollHead {
            flex-shrink: 0;
            border: 1px solid #dee2e6;
            border-bottom: none;
        }
        #tblAuxiliares_wrapper .dataTables_scrollBody tbody tr:hover,
        #tblAuxiliares_wrapper .dataTables_scrollBody tbody tr:hover td {
            background-color: #A2F4FD !important;
        }
        #tblAuxiliares thead th {
            text-align: center !important;
        }
        #tblAuxiliares tbody td {
            text-align: center !important;
        }
        
        .dataTables_length {
            padding: 12px 15px;
            margin-top: 15px;
            flex-shrink: 0;
            text-align: center !important;
        }
        
        .dataTables_length label {
            margin-bottom: 0;
            display: inline-block;
        }
        
        .dataTables_length select {
            margin: 0 5px;
        }
        
        #tblAuxiliares_wrapper .dataTables_length select {
            padding-right: 2rem !important;
            min-width: 70px;
            padding-left: 0.5rem;
        }
        
        .dataTables_wrapper > table {
            margin-bottom: 0;
        }
        
        #tblAuxiliares {
            width: 100% !important;
            margin-bottom: 0;
        }
        
        .dataTables_info {
            padding: 12px 15px;
            margin-top: 15px;
            font-size: 13px;
            display: inline-block !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        .dataTables_paginate {
            padding: 12px 15px;
            margin-top: 15px;
            text-align: right;
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
            float: right;
            position: relative !important;
            z-index: 1 !important;
        }
        
        /* Limpiar floats */
        .dataTables_wrapper::after {
            content: "";
            display: table;
            clear: both;
        }
        
        /* Asegurar que la tabla principal no se desborde */
        #tblAuxiliares {
            margin-bottom: 10px;
            width: 100% !important;
        }
        
        /* Asegurar que los controles de paginación sean visibles */
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            display: inline-block !important;
            margin: 0 2px;
            padding: 0.375rem 0.75rem;
            border-radius: 4px;
            border: 1px solid #dee2e6;
            cursor: pointer;
            background-color: #fff;
            color: #2c3e50;
            visibility: visible !important;
            opacity: 1 !important;
            text-decoration: none !important;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover:not(.disabled) {
            background-color: #f8f9fa !important;
            border-color: #2c3e50 !important;
            color: #2c3e50 !important;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: #2c3e50 !important;
            color: white !important;
            border-color: #2c3e50 !important;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .dataTables_wrapper .row.mt-3 {
            display: flex !important;
            visibility: visible !important;
            opacity: 1 !important;
            margin-top: 15px !important;
            padding: 10px 15px !important;
            border-top: 1px solid #dee2e6 !important;
            background-color: #f8f9fa !important;
            border-radius: 4px !important;
            align-items: center !important;
            justify-content: space-between !important;
            clear: both !important;
            min-height: 50px !important;
            height: auto !important;
            overflow: visible !important;
            flex-shrink: 0 !important;
            flex-grow: 0 !important;
            flex-basis: auto !important;
        }
        
        /* Asegurar que la tabla principal no ocupe más espacio del necesario */
        .dataTables_wrapper > table.dataTable {
            flex: 1 1 auto;
            min-height: 0;
            margin-bottom: 0;
        }
        
        /* Forzar visibilidad de todos los elementos de paginación */
        .dataTables_wrapper .dataTables_paginate,
        .dataTables_wrapper .dataTables_info {
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
            height: auto !important;
            min-height: 30px !important;
            overflow: visible !important;
        }
        
        /* Asegurar que los botones de paginación sean visibles */
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            display: inline-block !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        .dataTables_wrapper .dataTables_length select {
            padding: 4px 8px;
            border-radius: 4px;
            border: 1px solid #ced4da;
        }
        
        .dataTables_wrapper .dataTables_filter input {
            padding: 4px 8px;
            border-radius: 4px;
            border: 1px solid #ced4da;
            margin-left: 8px;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 0.375rem 0.75rem;
            margin: 0 2px;
            border-radius: 4px;
            border: 1px solid #dee2e6;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: #2c3e50;
            color: white !important;
            border-color: #2c3e50;
        }
        
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: #34495e;
            color: white !important;
            border-color: #34495e;
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
        
        /* Estilos para selects deshabilitados */
        .form-select:disabled {
            cursor: not-allowed !important;
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
        
        /* Estilos para divs de gastos adicionales con efecto glassmorphism */
        .gasto-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 15px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            min-height: 90px;
        }
        
        .gasto-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        }
        
        .gasto-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
            font-size: 18px;
        }
        
        .gasto-icon.info {
            background: linear-gradient(135deg, #17a2b8, #138496);
            color: white;
        }
        
        .gasto-icon.success {
            background: linear-gradient(135deg, #28a745, #218838);
            color: white;
        }
        
        .gasto-icon.warning {
            background: linear-gradient(135deg, #ffc107, #e0a800);
            color: #212529;
        }
        
        .gasto-title {
            font-size: 12px;
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
        }
        
        .gasto-value-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
        }
        
        .gasto-percentage {
            font-size: 18px;
            font-weight: 700;
        }
        
        .gasto-amount {
            font-size: 35px;
            font-weight: 700;
        }
        
        .gasto-amount-desembolso {
            font-size: 42px;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Barra superior: título + filtros + botones en una sola fila -->
            <div class="top-bar-section">
                <div class="top-bar-titulo">
                    <h6 class="mb-0"><i class="fas fa-users-cog me-2"></i>Gestión de Auxiliares</h6>
                </div>
                <div class="top-bar-filtros">
                    <div class="top-bar-filtro-item">
                        <label class="form-label fw-bold">Buscar</label>
                        <input type="text" id="txtBuscar" class="form-control form-control-sm" placeholder="Asociado, cuenta, identificación, rubro o tipo..."/>
                    </div>
                    <div class="top-bar-filtro-item">
                        <label class="form-label fw-bold">Rubro</label>
                        <select id="ddlRubro" class="form-select form-select-sm">
                            <option value="">Todos los rubros</option>
                        </select>
                    </div>
                    <div class="top-bar-filtro-item">
                        <label class="form-label fw-bold">Tipo Auxiliar</label>
                        <select id="ddlTipoAuxiliar" class="form-select form-select-sm">
                            <option value="">Todos los tipos</option>
                        </select>
                    </div>
                    <div class="top-bar-filtro-buscar d-flex gap-1 align-items-end">
                        <button type="button" id="btnBuscar" class="btn btn-light" title="Buscar">
                            <i class="fas fa-search"></i>
                        </button>
                        <button type="button" id="btnLimpiar" class="btn btn-light" title="Limpiar filtros">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                <div class="top-bar-botones">
                    <button type="button" class="btn btn-light btn-sm me-2" data-bs-toggle="modal" data-bs-target="#modalAuxiliar">
                        <i class="fas fa-plus me-1"></i>Nuevo
                    </button>
                    <button type="button" class="btn btn-light btn-sm" onclick="volverDashboard()">
                        <i class="fas fa-arrow-left me-1"></i>Volver
                    </button>
                </div>
            </div>

            <!-- Tabla de Auxiliares -->
            <div class="table-container">
                <div class="table-responsive">
                    <table id="tblAuxiliares" class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th class="text-center"></th>
                                <th class="text-center">Activo</th>
                                <th class="text-center">Acciones</th>
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

                                <!-- Sección de Manejo, Capitalización y Desembolso -->
                                <div id="divCalculosAdicionales" class="mt-3 pt-3 border-top" style="display: none;">
                                    <h6 class="mb-3 text-muted" style="font-size: 13px; font-weight: 500;">
                                        Gastos Adicionales
                                    </h6>
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <div class="gasto-card">
                                                <div class="gasto-icon info">
                                                    <i class="fas fa-hand-holding-usd"></i>
                                                </div>
                                                <div class="gasto-title">Manejo</div>
                                                <div class="gasto-value-row">
                                                    <span class="gasto-percentage text-info" id="lblPorManejo">0.00%</span>
                                                    <span class="gasto-amount text-info" id="lblMontoManejo">$0.00</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="gasto-card">
                                                <div class="gasto-icon success">
                                                    <i class="fas fa-chart-line"></i>
                                                </div>
                                                <div class="gasto-title">Capitalización</div>
                                                <div class="gasto-value-row">
                                                    <span class="gasto-percentage text-success" id="lblPorCapitalizacion">0.00%</span>
                                                    <span class="gasto-amount text-success" id="lblMontoCapitalizacion">$0.00</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="gasto-card">
                                                <div class="gasto-icon warning">
                                                    <i class="fas fa-money-bill-wave"></i>
                                                </div>
                                                <div class="gasto-title">Monto Desembolso</div>
                                                <div class="gasto-value-row">
                                                    <span class="gasto-amount-desembolso text-warning" id="lblMontoDesembolso" style="width: 100%; text-align: right;">$0.00</span>
                                                </div>
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
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
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

            // Recalcular altura cuando se redimensione la ventana
            $(window).on('resize', function() {
                setTimeout(function() {
                    if (tablaAuxiliaresDataTable) {
                        ajustarAlturaGrid();
                        tablaAuxiliaresDataTable.columns.adjust().draw();
                    }
                }, 100);
            });
            
            // Ajustar altura cuando cambie el número de filas por página
            $(document).on('change', '.dataTables_length select', function() {
                setTimeout(function() {
                    if (tablaAuxiliaresDataTable) {
                        ajustarAlturaGrid();
                    }
                }, 100);
            });

            // Cargar datos iniciales (rubros y tipos). La tabla se llena por paginación server-side al inicializar DataTable.
            cargarRubros();
            cargarTiposAuxiliares();
            inicializarDataTable();
            
            // Inicializar componente global de búsqueda de asociados
            inicializarBusquedaAsociadosGlobal();

            // Eventos
            $('#txtBuscar').on('keypress', function(e) {
                if (e.which === 13) {
                    e.preventDefault();
                    if (tablaAuxiliaresDataTable) tablaAuxiliaresDataTable.ajax.reload();
                }
            });

            $('#ddlTipoAuxiliar, #ddlRubro').on('change', function() {
                if (tablaAuxiliaresDataTable) tablaAuxiliaresDataTable.ajax.reload();
            });

            $('#btnBuscar').on('click', function() {
                if (tablaAuxiliaresDataTable) tablaAuxiliaresDataTable.ajax.reload();
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
                    // Asegurar que rubro y tipo de auxiliar estén habilitados en modo creación
                    $('#ddlRubroModal').prop('disabled', false).removeClass('bg-light');
                    $('#ddlTipoAuxiliarModal').prop('disabled', false).removeClass('bg-light');
                }
            });
            
            // Limpiar modal al cerrar
            $('#modalAuxiliar').on('hidden.bs.modal', function() {
                limpiarModal();
            });

            // Cambiar tipo de auxiliar según rubro
            $('#ddlRubroModal').on('change', function() {
                cargarTiposAuxiliaresModal();
                // Ocultar campos adicionales al cambiar rubro (se resetea el tipo)
                $('#divCalculosAdicionales').hide();
            });

            // Manejar cambio de tipo de auxiliar para cargar tasa automática (solo en creación; en edición usamos la tasa del auxiliar)
            $('#ddlTipoAuxiliarModal').on('change', function() {
                if ($('#hdnModoEdicion').val() !== 'true') {
                    cargarTasaAutomatica();
                }
                setTimeout(function() {
                    calcularCamposAdicionales();
                }, 100);
            });
            
            // Manejar cambio de monto original para recalcular campos adicionales
            $('#txtMontoOriginal').on('input change', function() {
                calcularCamposAdicionales();
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
                
                // Aplicar tasa automática solo en creación; en edición la tasa ya viene del auxiliar
                if ($('#hdnModoEdicion').val() !== 'true') {
                    setTimeout(function() {
                        cargarTasaAutomatica();
                    }, 200);
                }
            });
        });

        // Variable global para almacenar todos los tipos de auxiliares
        var todosLosTiposAuxiliares = [];
        var globalSearchConfig = null;
        
        // Variable global para almacenar todos los auxiliares
        var todosLosAuxiliares = [];
        
        // Variable global para la instancia de DataTable
        var tablaAuxiliaresDataTable = null;
        
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
                    html += '<option value="' + item.IdTipoAuxiliar + '" data-tasa="' + (item.Tasa || 0) + '" data-pormanejo="' + (item.PorManejo || 0) + '" data-porcapitalizacion="' + (item.PorCapitalizacion || 0) + '">' + item.Descripcion + '</option>';
                });
                
                // Si solo hay un tipo, seleccionarlo automáticamente
                if (tiposFiltrados.length === 1) {
                    html = '<option value="' + tiposFiltrados[0].IdTipoAuxiliar + '" data-tasa="' + (tiposFiltrados[0].Tasa || 0) + '" data-pormanejo="' + (tiposFiltrados[0].PorManejo || 0) + '" data-porcapitalizacion="' + (tiposFiltrados[0].PorCapitalizacion || 0) + '">' + tiposFiltrados[0].Descripcion + '</option>';
                    $('#ddlTipoAuxiliarModal').html(html);
                    $('#ddlTipoAuxiliarModal').val(tiposFiltrados[0].IdTipoAuxiliar);
                    // Disparar evento change para que se ejecuten todos los handlers
                    $('#ddlTipoAuxiliarModal').trigger('change');
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
            
            // Calcular campos adicionales después de cargar la tasa
            calcularCamposAdicionales();
        }

        // Variable global para almacenar valores guardados del auxiliar en modo edición
        var auxiliarEditando = null;
        
        function calcularCamposAdicionales() {
            var tipoSeleccionado = $('#ddlTipoAuxiliarModal option:selected');
            var montoOriginal = normalizarValorNumerico($('#txtMontoOriginal').val());
            var modoEdicion = $('#hdnModoEdicion').val() === 'true';
            
            var porManejo = 0;
            var porCapitalizacion = 0;
            
            // En modo edición, usar los valores guardados del auxiliar
            // En modo creación, usar los valores del tipo de auxiliar
            if (modoEdicion && auxiliarEditando) {
                porManejo = parseFloat(auxiliarEditando.PorcManejo) || 0;
                porCapitalizacion = parseFloat(auxiliarEditando.PorcCapitalizacion) || 0;
            } else {
                // Obtener PorManejo y PorCapitalizacion del tipo seleccionado
                porManejo = parseFloat(tipoSeleccionado.data('pormanejo')) || 0;
                porCapitalizacion = parseFloat(tipoSeleccionado.data('porcapitalizacion')) || 0;
            }
            
            // Verificar si alguno de los campos es distinto de cero (solo verificar el tipo, no el monto)
            var mostrarCalculos = (porManejo > 0 || porCapitalizacion > 0);
            
            if (mostrarCalculos) {
                var montoManejo = 0;
                var montoCapitalizacion = 0;
                
                // En modo edición, usar los montos guardados si existen, sino calcular
                if (modoEdicion && auxiliarEditando) {
                    montoManejo = parseFloat(auxiliarEditando.MontoManejo) || 0;
                    montoCapitalizacion = parseFloat(auxiliarEditando.MontoCapitalizacion) || 0;
                    
                    // Si los montos guardados son 0 pero hay porcentajes, recalcular
                    if (montoManejo === 0 && montoOriginal > 0 && porManejo > 0) {
                        montoManejo = (montoOriginal * porManejo) / 100;
                    }
                    if (montoCapitalizacion === 0 && montoOriginal > 0 && porCapitalizacion > 0) {
                        montoCapitalizacion = (montoOriginal * porCapitalizacion) / 100;
                    }
                } else {
                    // Calcular montos (si no hay monto original, mostrar 0)
                    montoManejo = montoOriginal > 0 ? (montoOriginal * porManejo) / 100 : 0;
                    montoCapitalizacion = montoOriginal > 0 ? (montoOriginal * porCapitalizacion) / 100 : 0;
                }
                
                var montoDesembolso = montoOriginal > 0 ? (montoOriginal - montoManejo - montoCapitalizacion) : 0;
                
                // Mostrar valores
                $('#lblPorManejo').text(porManejo.toFixed(2) + '%');
                $('#lblMontoManejo').text(formatearMonto(montoManejo));
                
                $('#lblPorCapitalizacion').text(porCapitalizacion.toFixed(2) + '%');
                $('#lblMontoCapitalizacion').text(formatearMonto(montoCapitalizacion));
                
                $('#lblMontoDesembolso').text(formatearMonto(montoDesembolso));
                
                // Mostrar el div inmediatamente
                $('#divCalculosAdicionales').show();
            } else {
                // Ocultar el div
                $('#divCalculosAdicionales').hide();
                
                // Limpiar valores
                $('#lblPorManejo').text('0.00%');
                $('#lblMontoManejo').text('$0.00');
                $('#lblPorCapitalizacion').text('0.00%');
                $('#lblMontoCapitalizacion').text('$0.00');
                $('#lblMontoDesembolso').text('$0.00');
            }
        }

        // Función de compatibilidad - ahora usa la función global
        function crearChipIdentificacion(codTipoDoc, numeroIdentificacion) {
            return crearChipTipoDocumento(codTipoDoc, numeroIdentificacion);
        }
        
        // Función para calcular la altura del grid dinámicamente
        function calcularAlturaGrid() {
            var viewportHeight = $(window).height();
            var mainContainerMargin = parseFloat($('.main-container').css('margin-top')) + parseFloat($('.main-container').css('margin-bottom'));
            var mainContainerPadding = parseFloat($('.main-container').css('padding-top')) + parseFloat($('.main-container').css('padding-bottom'));
            var topBarSectionHeight = $('.top-bar-section').outerHeight(true);
            var dataTablesLengthHeight = $('.dataTables_length').outerHeight(true) || 0;
            var dataTablesFooterHeight = 0;
            if ($('.dataTables_info').length) {
                var infoHeight = $('.dataTables_info').outerHeight(true) || 0;
                var paginateHeight = $('.dataTables_paginate').outerHeight(true) || 0;
                var rowHeight = $('.dataTables_wrapper .row.mt-3').outerHeight(true) || 0;
                dataTablesFooterHeight = Math.max(rowHeight, infoHeight + paginateHeight);
            }
            var espacioAdicional = 20;
            var totalARestar = mainContainerMargin + mainContainerPadding + topBarSectionHeight + dataTablesLengthHeight + dataTablesFooterHeight + espacioAdicional;
            var alturaGrid = viewportHeight - totalARestar;
            
            return {
                viewportHeight: viewportHeight,
                totalARestar: totalARestar,
                alturaGrid: alturaGrid,
                desglose: {
                    margin: mainContainerMargin,
                    padding: mainContainerPadding,
                    topBar: topBarSectionHeight,
                    length: dataTablesLengthHeight,
                    footer: dataTablesFooterHeight,
                    adicional: espacioAdicional
                }
            };
        }
        
        // Función para aplicar la altura calculada al grid usando !important
        function aplicarEstiloConImportant(elemento, propiedad, valor) {
            if (elemento && elemento.length) {
                elemento.each(function() {
                    this.style.setProperty(propiedad, valor, 'important');
                });
            }
        }
        
        // Función para aplicar la altura calculada al grid - asegurar que ocupe todo el espacio
        function aplicarAlturaGrid(alturaCalculada) {
            var tableContainer = $('.table-container');
            if (tableContainer.length) {
                aplicarEstiloConImportant(tableContainer, 'flex', '1 1 auto');
                aplicarEstiloConImportant(tableContainer, 'overflow', 'visible');
                aplicarEstiloConImportant(tableContainer, 'height', 'auto');
                aplicarEstiloConImportant(tableContainer, 'max-height', 'none');
            }
            
            var tableResponsive = $('.table-responsive');
            if (tableResponsive.length) {
                aplicarEstiloConImportant(tableResponsive, 'flex', '1 1 auto');
                aplicarEstiloConImportant(tableResponsive, 'overflow', 'visible');
                aplicarEstiloConImportant(tableResponsive, 'height', 'auto');
                aplicarEstiloConImportant(tableResponsive, 'max-height', 'none');
            }
            
            var dataTablesWrapper = $('#tblAuxiliares_wrapper');
            if (dataTablesWrapper.length) {
                aplicarEstiloConImportant(dataTablesWrapper, 'flex', '1 1 auto');
                aplicarEstiloConImportant(dataTablesWrapper, 'overflow', 'visible');
                aplicarEstiloConImportant(dataTablesWrapper, 'display', 'flex');
                aplicarEstiloConImportant(dataTablesWrapper, 'flex-direction', 'column');
                aplicarEstiloConImportant(dataTablesWrapper, 'height', '100%');
            }
        }
        
        // Función para diagnosticar visibilidad de controles de navegación (sin logs)
        function diagnosticarControlesNavegacion() {
            if (!tablaAuxiliaresDataTable) return;
        }
        
        // Función auxiliar para verificar si un elemento está en el viewport
        function esElementoEnViewport(elemento) {
            var rect = elemento.getBoundingClientRect();
            return (
                rect.top >= 0 &&
                rect.left >= 0 &&
                rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
                rect.right <= (window.innerWidth || document.documentElement.clientWidth)
            );
        }
        
        // Función para ajustar la altura del grid basándose en 10 filas fijas
        function ajustarAlturaGrid() {
            if (!tablaAuxiliaresDataTable) return;
            
            // Calcular altura máxima disponible restando todos los elementos fijos
            var viewportHeight = $(window).height();
            var mainContainer = $('.main-container');
            var mainContainerOffset = mainContainer.offset();
            var mainContainerTop = mainContainerOffset ? mainContainerOffset.top : 0;
            var mainContainerPadding = parseFloat(mainContainer.css('padding-top')) + parseFloat(mainContainer.css('padding-bottom')) || 0;
            var topBarHeight = $('.top-bar-section').outerHeight(true) || 0;
            
            // Obtener altura del footer ANTES de calcular, para asegurar que esté visible
            var footerRow = $('.dataTables_wrapper .row.mt-3');
            var footerHeight = footerRow.outerHeight(true) || 60;
            
            // Calcular altura disponible para el wrapper de DataTables
            // Restar espacio adicional para márgenes y padding
            var espacioAdicional = 30;
            var alturaDisponible = viewportHeight - mainContainerTop - mainContainerPadding - topBarHeight - espacioAdicional;
            
            // Asegurar altura mínima
            if (alturaDisponible < 300) {
                alturaDisponible = 300;
            }
            
            var dataTablesWrapper = $('#tblAuxiliares_wrapper');
            if (dataTablesWrapper.length) {
                var alturaScroll = alturaDisponible - footerHeight;
                if (alturaScroll < 200) alturaScroll = 200;
                dataTablesWrapper.css({
                    'height': alturaDisponible + 'px',
                    'max-height': alturaDisponible + 'px',
                    'min-height': alturaDisponible + 'px'
                });
                var scrollDiv = dataTablesWrapper.find('.dataTables_scroll');
                var scrollBody = dataTablesWrapper.find('.dataTables_scrollBody');
                if (scrollDiv.length) {
                    scrollDiv.css({ 'min-height': alturaScroll + 'px', 'flex': '1 1 auto' });
                }
                if (scrollBody.length) {
                    scrollBody.css({
                        'min-height': alturaScroll + 'px',
                        'max-height': alturaScroll + 'px',
                        'height': alturaScroll + 'px',
                        'overflow-y': 'auto !important',
                        'overflow-x': 'auto !important'
                    });
                }
                if (tablaAuxiliaresDataTable && tablaAuxiliaresDataTable.settings()[0].oScroll) {
                    var settings = tablaAuxiliaresDataTable.settings()[0];
                    if (settings.oScroll && settings.oScroll.sY) {
                        settings.oScroll.sY = alturaScroll + 'px';
                        tablaAuxiliaresDataTable.columns.adjust();
                    }
                }
                footerRow.css({
                    'display': 'flex !important',
                    'visibility': 'visible !important',
                    'opacity': '1 !important',
                    'flex-shrink': '0 !important',
                    'flex-grow': '0 !important'
                });
            }
            var tableResponsive = $('.table-responsive');
            if (tableResponsive.length) {
                tableResponsive.css({
                    'flex': '1 1 auto',
                    'min-height': '0',
                    'overflow': 'hidden',
                    'height': '100%'
                });
            }
        }
        
        function inicializarDataTable() {
            if (tablaAuxiliaresDataTable) {
                tablaAuxiliaresDataTable.destroy();
                tablaAuxiliaresDataTable = null;
            }
            
            tablaAuxiliaresDataTable = $('#tblAuxiliares').DataTable({
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json',
                    emptyTable: "No hay auxiliares registrados",
                    zeroRecords: "No se encontraron auxiliares que coincidan con la búsqueda"
                },
                responsive: false,
                pageLength: 25,
                lengthMenu: [[10, 15, 25, 50, 100], [10, 15, 25, 50, 100]],
                order: [[3, 'asc']],
                paging: true,
                autoWidth: false,
                deferRender: false,
                scrollY: '400px',
                scrollCollapse: false,
                scroller: false,
                columnDefs: [
                    { targets: 0, width: '50px', orderable: false, className: 'text-center' },
                    { targets: 1, width: '70px', orderable: false, className: 'text-center' },
                    { targets: 2, width: '100px', orderable: false, className: 'text-center' },
                    { targets: 3, width: '100px' },
                    { targets: 4, width: '90px' },
                    { targets: 5, width: '180px' },
                    { targets: [6, 7], width: '100px' },
                    { targets: [8, 9, 10], width: '95px' },
                    { targets: [11, 14, 15, 17, 18], visible: false },
                    { targets: [12, 13, 16], width: '95px' },
                    { targets: '_all', className: 'text-center' },
                    { targets: [4, 5], className: 'text-start' }
                ],
                dom: 'rt<"row mt-3"<"col-sm-12 col-md-4"i><"col-sm-12 col-md-4 text-center"l><"col-sm-12 col-md-4"p>>',
                searching: false,
                serverSide: true,
                processing: true,
                ajax: function(data, callback, settings) {
                    var order = data.order && data.order[0];
                    var sortColumn = (order && order.column >= 3 && order.column <= 13) ? (order.column - 2) : 1;
                    var sortDirection = order ? order.dir : 'desc';
                    var filtros = {
                        FiltroBusqueda: ($('#txtBuscar').val() || '').trim(),
                        CodigoRubro: ($('#ddlRubro').val() || '').trim(),
                        IdTipoAuxiliar: ($('#ddlTipoAuxiliar').val() || '').trim(),
                        PageSize: data.length,
                        PageIndex: Math.floor(data.start / data.length),
                        SortColumn: sortColumn,
                        SortDirection: sortDirection
                    };
                    $.ajax({
                        type: 'POST',
                        url: 'AuxiliaresAsociados.aspx/ObtenerAuxiliares',
                        contentType: 'application/json; charset=utf-8',
                        data: JSON.stringify({ filtrosJson: JSON.stringify(filtros) }),
                        dataType: 'json',
                        success: function(response) {
                            var payload = response.d;
                            if (typeof payload === 'string') {
                                try { payload = JSON.parse(payload); } catch (e) { payload = { Success: false }; }
                            }
                            if (!payload.Success) {
                                if (payload.Message) showToast('error', 'Error', payload.Message);
                                callback({ draw: data.draw, recordsTotal: 0, recordsFiltered: 0, data: [] });
                                return;
                            }
                            var auxiliares = payload.Data || [];
                            var totalRegistros = payload.TotalRegistros || 0;
                            var rows = auxiliares.map(function(item) { return buildRowArrayForDataTable(item); });
                            callback({ draw: data.draw, recordsTotal: totalRegistros, recordsFiltered: totalRegistros, data: rows });
                        },
                        error: function() {
                            showToast('error', 'Error', 'Error al cargar auxiliares');
                            callback({ draw: data.draw, recordsTotal: 0, recordsFiltered: 0, data: [] });
                        }
                    });
                },
                drawCallback: function(settings) {
                    var api = this.api();
                    api.rows().every(function() {
                        var $first = $(this.node()).find('td:first');
                        var da = $first.find('span[data-auxiliar]').attr('data-auxiliar');
                        if (da) $(this.node()).attr('data-auxiliar', da);
                    });
                    aplicarEventosFilas();
                    setTimeout(function() { ajustarAlturaGrid(); }, 50);
                },
                initComplete: function(settings, json) {
                    setTimeout(function() {
                        // Ajustar altura del grid
                        ajustarAlturaGrid();
                        
                        // Forzar visibilidad de controles de paginación
                        var paginate = $('.dataTables_paginate');
                        var info = $('.dataTables_info');
                        var row = $('.dataTables_wrapper .row.mt-3');
                        
                        if (paginate.length) {
                            paginate.each(function() {
                                this.style.setProperty('display', 'block', 'important');
                                this.style.setProperty('visibility', 'visible', 'important');
                                this.style.setProperty('opacity', '1', 'important');
                            });
                        }
                        
                        if (info.length) {
                            info.each(function() {
                                this.style.setProperty('display', 'inline-block', 'important');
                                this.style.setProperty('visibility', 'visible', 'important');
                                this.style.setProperty('opacity', '1', 'important');
                            });
                        }
                        
                        if (row.length) {
                            row.each(function() {
                                this.style.setProperty('display', 'flex', 'important');
                                this.style.setProperty('visibility', 'visible', 'important');
                                this.style.setProperty('opacity', '1', 'important');
                            });
                        }
                    }, 200);
                }
            });
            
            aplicarEventosFilas();
        }
        
        // Función para aplicar eventos a las filas (clic derecho, etc.)
        function aplicarEventosFilas() {
            // Evento de clic derecho a las filas para menú contextual
            $('#tbodyAuxiliares tr').off('contextmenu').on('contextmenu', function(e) {
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

        function buildRowArrayForDataTable(item) {
            var nivelAccesoActual = typeof nivelAcceso === 'number' && !isNaN(nivelAcceso) ? nivelAcceso : 999;
            var puedeEliminar = (nivelAccesoActual === 0 || nivelAccesoActual === 1);
            var jsonAux = JSON.stringify(item).replace(/'/g, '&#39;');
            var snComprobante = item.snComprobante === true || item.snComprobante === 1 || item.snComprobante === '1' || item.snComprobante === 'true';
            var btnDisabled = snComprobante ? '' : 'disabled';
            var btnClass = snComprobante ? 'btn-outline-primary' : 'btn-outline-secondary';
            var cell0 = '<span class="d-none" data-auxiliar=\'' + jsonAux + '\'></span><button type="button" class="btn btn-sm ' + btnClass + '" ' + btnDisabled + ' onclick="imprimirComprobanteAuxiliar(' + item.ID + ', ' + item.NumeroAsociado + ')" title="Imprimir Comprobante"><i class="fas fa-print"></i></button>';
            var snActivo = item.snActivo === true || item.snActivo === 1 || item.snActivo === '1' || item.snActivo === 'true';
            var cell1 = puedeEliminar
                ? '<div class="form-check form-switch d-inline-block"><input class="form-check-input" type="checkbox" role="switch" id="switchActivo_' + item.ID + '_' + item.NumeroAsociado + '" ' + (snActivo ? 'checked' : '') + ' onchange="cambiarEstadoActivo(' + item.ID + ', ' + item.NumeroAsociado + ', this.checked)"><label class="form-check-label ms-1" for="switchActivo_' + item.ID + '_' + item.NumeroAsociado + '">' + (snActivo ? 'Sí' : 'No') + '</label></div>'
                : (snActivo ? 'Sí' : 'No');
            var cell2 = '<button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarAuxiliar(' + item.ID + ', ' + item.NumeroAsociado + ')"><i class="fas fa-edit"></i></button>' +
                (puedeEliminar ? '<button type="button" class="btn btn-sm btn-outline-danger me-1" onclick="eliminarAuxiliar(' + item.ID + ', ' + item.NumeroAsociado + ')"><i class="fas fa-trash"></i></button>' : '');
            return [
                cell0, cell1, cell2,
                (item.Cuenta || '-'),
                crearChipIdentificacion(item.CodTipoDoc, item.NumeroIdentificacion),
                (item.NombreAsociado || ''),
                (item.DescripcionRubro || item.CodigoRubro || '-'),
                (item.DescripcionTipoAuxiliar || ''),
                formatearMonto(item.Cuota || 0),
                formatearMonto(item.Saldo || 0),
                formatearMonto(item.MontoOriginal || 0),
                formatearMonto(item.MontoPignorado || 0),
                parseFloat(item.TasaInteres || 0).toFixed(2) + '%',
                formatearMonto(item.PagoMes || 0),
                (item.FechaOtorgado || '-'),
                (item.FechaUltimoPago || '-'),
                (item.FechaCreacion || '-'),
                (item.UsuarioCrea || '-'),
                (item.UsuarioModifica || '-')
            ];
        }

        function mostrarAuxiliares(auxiliares) {
            if (auxiliares.length === 0) {
                if (tablaAuxiliaresDataTable) {
                    tablaAuxiliaresDataTable.clear().draw();
                } else {
                    $('#tbodyAuxiliares').html('<tr><td colspan="19" class="text-center text-muted py-4">No hay auxiliares registrados</td></tr>');
                }
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
                // Columna de impresión
                var snComprobante = item.snComprobante === true || item.snComprobante === 1 || item.snComprobante === '1' || item.snComprobante === 'true';
                var btnDisabled = snComprobante ? '' : 'disabled';
                var btnClass = snComprobante ? 'btn-outline-primary' : 'btn-outline-secondary';
                html += '<td class="text-center">';
                html += '<button type="button" class="btn btn-sm ' + btnClass + '" ' + btnDisabled + ' onclick="imprimirComprobanteAuxiliar(' + item.ID + ', ' + item.NumeroAsociado + ')" title="Imprimir Comprobante">';
                html += '<i class="fas fa-print"></i>';
                html += '</button>';
                html += '</td>';
                // Activo (segunda columna)
                html += '<td class="text-center">';
                var snActivo = item.snActivo === true || item.snActivo === 1 || item.snActivo === '1' || item.snActivo === 'true';
                if (puedeEliminar) {
                    var checkedAttr = snActivo ? 'checked' : '';
                    html += '<div class="form-check form-switch d-inline-block">';
                    html += '<input class="form-check-input" type="checkbox" role="switch" id="switchActivo_' + item.ID + '_' + item.NumeroAsociado + '" ' + checkedAttr + ' onchange="cambiarEstadoActivo(' + item.ID + ', ' + item.NumeroAsociado + ', this.checked)">';
                    html += '<label class="form-check-label ms-1" for="switchActivo_' + item.ID + '_' + item.NumeroAsociado + '">' + (snActivo ? 'Sí' : 'No') + '</label>';
                    html += '</div>';
                } else {
                    html += (snActivo ? 'Sí' : 'No');
                }
                html += '</td>';
                // Acciones (tercera columna)
                html += '<td class="text-center">';
                html += '<button type="button" class="btn btn-sm btn-outline-primary me-1" onclick="editarAuxiliar(' + item.ID + ', ' + item.NumeroAsociado + ')">';
                html += '<i class="fas fa-edit"></i>';
                html += '</button>';
                if (puedeEliminar) {
                    html += '<button type="button" class="btn btn-sm btn-outline-danger me-1" onclick="eliminarAuxiliar(' + item.ID + ', ' + item.NumeroAsociado + ')">';
                    html += '<i class="fas fa-trash"></i>';
                    html += '</button>';
                }
                html += '</td>';
                html += '<td class="text-center">' + (item.Cuenta || '-') + '</td>';
                html += '<td class="text-start">' + crearChipIdentificacion(item.CodTipoDoc, item.NumeroIdentificacion) + '</td>';
                html += '<td class="text-center">' + item.NombreAsociado + '</td>';
                html += '<td class="text-center">' + (item.DescripcionRubro || item.CodigoRubro || '-') + '</td>';
                html += '<td class="text-center">' + item.DescripcionTipoAuxiliar + '</td>';
                html += '<td class="text-center">' + formatearMonto(item.Cuota || 0) + '</td>';
                html += '<td class="text-center">' + formatearMonto(item.Saldo || 0) + '</td>';
                html += '<td class="text-center">' + formatearMonto(item.MontoOriginal || 0) + '</td>';
                html += '<td class="text-center">' + formatearMonto(item.MontoPignorado || 0) + '</td>';
                html += '<td class="text-center">' + parseFloat(item.TasaInteres || 0).toFixed(2) + '%</td>';
                html += '<td class="text-center">' + formatearMonto(item.PagoMes || 0) + '</td>';
                html += '<td class="text-center">' + (item.FechaOtorgado || '-') + '</td>';
                html += '<td class="text-center">' + (item.FechaUltimoPago || '-') + '</td>';
                html += '<td class="text-center">' + (item.FechaCreacion || '-') + '</td>';
                html += '<td class="text-center">' + (item.UsuarioCrea || '-') + '</td>';
                html += '<td class="text-center">' + (item.UsuarioModifica || '-') + '</td>';
                html += '</tr>';
            });
            
            // Si DataTable ya está inicializado, actualizar los datos
            if (tablaAuxiliaresDataTable) {
                // Destruir la instancia actual para recrearla con los nuevos datos
                tablaAuxiliaresDataTable.destroy();
                tablaAuxiliaresDataTable = null;
            }
            
            // Establecer el HTML del tbody
            $('#tbodyAuxiliares').html(html);
            
            // Inicializar o reinicializar DataTable
            inicializarDataTable();
            
            // Diagnosticar después de inicializar
            setTimeout(function() {
                diagnosticarControlesNavegacion();
            }, 500);
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

        // Función para formatear montos con comas de miles
        function formatearMonto(monto) {
            if (monto === null || monto === undefined || isNaN(monto)) {
                return '$0.00';
            }
            
            // Formatear con 2 decimales y agregar comas de miles
            return '$' + parseFloat(monto).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
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
            
            // Obtener PorManejo y PorCapitalizacion del tipo seleccionado
            var porManejo = parseFloat(tipoAuxiliarSeleccionado.data('pormanejo')) || 0;
            var porCapitalizacion = parseFloat(tipoAuxiliarSeleccionado.data('porcapitalizacion')) || 0;
            
            // Calcular montos de manejo y capitalización
            var montoOriginal = normalizarValorNumerico($('#txtMontoOriginal').val());
            var montoManejo = montoOriginal > 0 ? (montoOriginal * porManejo) / 100 : 0;
            var montoCap = montoOriginal > 0 ? (montoOriginal * porCapitalizacion) / 100 : 0;

            var auxiliar = {
                ID: $('#hdnAuxiliarID').val() || 0,
                NumeroAsociado: $('#hdnNumeroAsociado').val(),
                CodigoRubro: $('#ddlRubroModal').val(),
                TipoAuxiliar: idTipoAuxiliar, // Enviar el ID en lugar de la descripción
                DescripcionTipoAuxiliar: descripcionTipoAuxiliar, // Para referencia
                Cuota: normalizarValorNumerico($('#txtCuota').val()),
                Saldo: normalizarValorNumerico($('#txtSaldo').val()),
                MontoOriginal: montoOriginal,
                MontoPignorado: montoPignoradoVal,
                FechaOtorgado: convertirFechaParaBD($('#txtFechaOtorgado').val()),
                // Campos opcionales - normalizar valores numéricos
                TasaInteres: normalizarValorNumerico($('#txtTasaInteres').val()),
                PagoMes: normalizarValorNumerico($('#txtPagoMes').val()),
                // Nuevos campos para manejo y capitalización
                PorcManejo: porManejo,
                PorcCap: porCapitalizacion,
                MontoManejo: montoManejo,
                MontoCap: montoCap
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
                        if (tablaAuxiliaresDataTable) tablaAuxiliaresDataTable.ajax.reload();
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
            $.ajax({
                type: 'POST',
                url: 'AuxiliaresAsociados.aspx/ObtenerAuxiliar',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ idAuxiliar: id }),
                dataType: 'json',
                success: function(response) {
                    var payload = response.d;
                    if (typeof payload === 'string') {
                        try { payload = JSON.parse(payload); } catch (e) { payload = { Success: false }; }
                    }
                    if (!payload.Success || !payload.Data) {
                        showToast('error', 'Error', payload.Message || 'No se encontró el auxiliar');
                        return;
                    }
                    var auxiliar = payload.Data;
                    llenarModalEdicionAuxiliar(auxiliar);
                    $('#modalAuxiliar').modal('show');
                },
                error: function() {
                    showToast('error', 'Error', 'Error al cargar los datos del auxiliar');
                }
            });
        }

        function llenarModalEdicionAuxiliar(auxiliar) {
            auxiliarEditando = auxiliar;
            $('#hdnAuxiliarID').val(auxiliar.ID);
            $('#hdnModoEdicion').val('true');
            $('#hdnNumeroAsociado').val(auxiliar.NumeroAsociado);

            $('#lblAsociadoInfo').html(auxiliar.NombreAsociado || '');
            var identificacionHtml = crearChipIdentificacion(auxiliar.CodTipoDoc, auxiliar.NumeroIdentificacion);
            $('#lblAsociadoDetalle').html(identificacionHtml + ' | N° Asociado: ' + auxiliar.NumeroAsociado);
            $('#divAsociadoSeleccionado').removeClass('d-none');
            $('#divSinAsociado').addClass('d-none');
            $('#divDatosAuxiliar').show();
            $('#btnEliminarAsociado').prop('disabled', false);

            $('#ddlRubroModal').val(auxiliar.CodigoRubro);
            $('#ddlRubroModal').prop('disabled', true).addClass('bg-light');
            cargarTiposAuxiliaresModal();

            setTimeout(function() {
                $('#ddlTipoAuxiliarModal').val(auxiliar.IdTipoAuxiliar ? String(auxiliar.IdTipoAuxiliar) : '');
                $('#ddlTipoAuxiliarModal').prop('disabled', true).addClass('bg-light');
                calcularCamposAdicionales();
            }, 500);

            $('#txtMontoOriginal').val(auxiliar.MontoOriginal);
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

            // En edición no llamar cargarTasaAutomatica: ya usamos la tasa guardada del auxiliar (evita mostrar 10000 cuando la tasa es 0)
            setTimeout(function() { calcularCamposAdicionales(); }, 200);

            $('#modalAuxiliarLabel').html('<i class="fas fa-edit me-2"></i>Editar Auxiliar - Cuenta: ' + (auxiliar.Cuenta || 'Sin cuenta'));
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
                                if (tablaAuxiliaresDataTable) tablaAuxiliaresDataTable.ajax.reload();
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
                                if (tablaAuxiliaresDataTable) tablaAuxiliaresDataTable.ajax.reload();
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

        function limpiarFiltros() {
            $('#txtBuscar').val('');
            $('#ddlTipoAuxiliar').val('');
            $('#ddlRubro').val('');
            if (tablaAuxiliaresDataTable) tablaAuxiliaresDataTable.ajax.reload();
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
            
            // Limpiar variable global de auxiliar en edición
            auxiliarEditando = null;
            
            // Limpiar todos los campos del modal
            $('#ddlRubroModal').val('').trigger('change');
            // Desbloquear rubro al limpiar (modo creación)
            $('#ddlRubroModal').prop('disabled', false).removeClass('bg-light');
            $('#ddlTipoAuxiliarModal').val('').trigger('change');
            // Desbloquear tipo de auxiliar al limpiar (modo creación)
            $('#ddlTipoAuxiliarModal').prop('disabled', false).removeClass('bg-light');
            $('#txtMontoOriginal').val('');
            $('#txtMontoPignorado').val('0').prop('readonly', true).addClass('bg-light');
            $('#txtCuota').val('');
            $('#txtTasaInteres').val('').prop('readonly', true).addClass('bg-light');
            $('#txtPagoMes').val('').prop('readonly', true).addClass('bg-light');
            // Fecha otorgada: hoy por defecto al crear nuevo auxiliar
            var hoy = new Date();
            var fechaHoy = hoy.getDate().toString().padStart(2, '0') + '/' +
                (hoy.getMonth() + 1).toString().padStart(2, '0') + '/' +
                hoy.getFullYear();
            $('#txtFechaOtorgado').val(fechaHoy);
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
            
            // Ocultar div de cálculos adicionales
            $('#divCalculosAdicionales').hide();
            
        }

        // FUNCIÓN NO UTILIZADA - Comentada porque no se llama en ningún lugar del código
        /*
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
        */

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

        function imprimirComprobanteAuxiliar(auxiliarID, numeroAsociado) {
            if (!auxiliarID || !numeroAsociado) {
                showToast('error', 'Error', 'No se pudo determinar el auxiliar a imprimir');
                return;
            }

            $.ajax({
                type: 'POST',
                url: 'AuxiliaresAsociados.aspx/GenerarComprobanteAuxiliar',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ 
                    auxiliarID: auxiliarID, 
                    numeroAsociado: numeroAsociado 
                }),
                dataType: 'json',
                success: function(response) {
                    if (response.d && response.d.Resultado === 'SUCCESS') {
                        imprimirComprobante(response.d.Html, auxiliarID, numeroAsociado);
                    } else {
                        const mensaje = response.d && response.d.Mensaje ? response.d.Mensaje : 'No fue posible generar el comprobante.';
                        showToast('error', 'Error', mensaje);
                    }
                },
                error: function(xhr, status, error) {
                    showToast('error', 'Error', 'Error al generar el comprobante: ' + error);
                }
            });
        }

        function imprimirComprobante(htmlContent, auxiliarID, numeroAsociado) {
            const ventanaImpresion = window.open('', '_blank', 'width=800,height=600');
            ventanaImpresion.document.write(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Comprobante de Auxiliar</title>
                    <style>
                        body { margin: 0; padding: 20px; font-family: Arial, sans-serif; }
                        .comprobante { height: auto !important; }
                        .separator { display: block !important; }
                        .no-print { display: none !important; }
                    </style>
                </head>
                <body>
                    ${htmlContent}
                </body>
                </html>
            `);

            ventanaImpresion.document.close();
            ventanaImpresion.onload = function () {
                setTimeout(() => {
                    ventanaImpresion.print();
                    ventanaImpresion.close();
                }, 200);
            };
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
                <strong>Monto Original:</strong> ${formatearMonto(auxiliarSeleccionado.MontoOriginal || 0)}<br>
                <strong>Monto Pignorado Actual:</strong> ${formatearMonto(auxiliarSeleccionado.MontoPignorado || 0)}
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
                        if (tablaAuxiliaresDataTable) tablaAuxiliaresDataTable.ajax.reload(); // Recargar la tabla
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



