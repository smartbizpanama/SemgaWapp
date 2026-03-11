<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Movimientos.aspx.vb" Inherits="SemgaWapp.Movimientos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reporte de Movimientos</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"/>
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    
    <style>
        body {
            background: #f8f9fa;
            height: 100vh;
            overflow: hidden;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        * {
            box-sizing: border-box;
        }

        html, body {
            overflow-x: hidden;
        }
        
        .main-container {
            background: #ffffff;
            border-radius: 6px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin: 15px;
            padding: 15px;
            border: 1px solid #e9ecef;
            overflow: hidden;
            height: calc(100vh - 30px);
            width: calc(100vw - 30px);
            display: flex;
            flex-direction: column;
            box-sizing: border-box;
            min-height: 0;
        }
        
        .header-section {
            background: #2c3e50;
            color: white;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-shrink: 0;
        }
        
        .header-section .logo {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .header-section .logo-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #87CEEB, #B0E0E6);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }
        
        .header-section .logo-text {
            font-size: 24px;
            font-weight: 700;
        }
        
        .header-section .breadcrumb {
            color: #bdc3c7;
            font-size: 14px;
        }
        
        .back-btn {
            background: linear-gradient(135deg, #87CEEB, #5F9EA0);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(135, 206, 235, 0.4);
            color: white;
            text-decoration: none;
        }
        
        .filters-section {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 15px;
            margin-bottom: 15px;
            flex-shrink: 0;
            min-height: fit-content;
        }
        
        .filters-title {
            font-size: 16px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .filter-group {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .filter-label {
            font-weight: 500;
            color: #495057;
            font-size: 13px;
            white-space: nowrap;
            margin: 0;
            display: block;
        }
        
        .filter-select {
            padding: 6px 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            background: white;
            color: #495057;
            font-size: 13px;
            transition: all 0.3s ease;
            width: 100%;
            min-width: 130px;
        }

        .filter-input {
            padding: 6px 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            background: white;
            color: #495057;
            font-size: 13px;
            transition: all 0.3s ease;
            width: 100%;
            min-width: 130px;
        }
        
        .filter-select:focus,
        .filter-input:focus {
            outline: none;
            border-color: #87CEEB;
            box-shadow: 0 0 0 2px rgba(135, 206, 235, 0.25);
        }

        .filters-table {
            width: 100%;
            border-collapse: collapse;
        }

        .filters-table tr {
            vertical-align: middle;
        }

        .filters-table td {
            padding: 8px;
            vertical-align: middle;
        }

        /* Asegurar que las celdas con controles tengan el mismo ancho */
        .filters-table td:nth-child(2),
        .filters-table td:nth-child(4) {
            width: auto;
            min-width: 150px;
        }

        /* Celda de botones */
        .filters-table .filter-row-dates td:last-child {
            text-align: right;
            white-space: nowrap;
        }

        .filters-table .filter-row-dates td:last-child .btn-buscar,
        .filters-table .filter-row-dates td:last-child .btn-limpiar,
        .filters-table .filter-row-dates td:last-child .btn-exportar-excel {
            margin-left: 8px;
        }

        .filters-table .filter-row-dates td:last-child .btn-buscar:first-child {
            margin-left: 0;
        }

        .filters-table .filter-select,
        .filters-table .filter-input {
            width: 100%;
            min-width: 150px;
            box-sizing: border-box;
        }

        .filter-label {
            margin: 0;
            white-space: nowrap;
        }

        .filter-row:last-child {
            margin-bottom: 0;
        }

        .btn-buscar {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-buscar:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .btn-limpiar {
            background: #6c757d;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-limpiar:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .btn-exportar-excel {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-exportar-excel:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .btn-exportar-excel:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        /* Estilos de tabla */
        .table-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            min-height: 0;
        }

        .table-responsive {
            flex: 1;
            min-height: 0;
            overflow-x: auto;
            overflow-y: auto;
        }

        /* Scroll horizontal en pantallas pequeñas */
        @media (max-width: 992px) {
            .table-responsive {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }

            #tablaMovimientos {
                min-width: 800px;
            }
        }

        /* Footer de DataTables siempre visible */
        .table-container .dataTables_info,
        .table-container .dataTables_paginate {
            padding: 10px 0;
        }

        /* Alinear leyenda centrada y controles a la derecha en la misma fila */
        .table-container .dataTables_wrapper .row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 0;
            position: relative;
        }

        .table-container .dataTables_info {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            white-space: nowrap;
        }

        .table-container .dataTables_paginate {
            margin-left: auto;
        }

        .table th {
            background-color: #2c3e50;
            color: white;
            border: none;
            font-weight: 500;
            font-size: 13px;
            padding: 8px 6px;
            text-align: center !important;
            vertical-align: middle;
        }

        .table td {
            padding: 6px 6px;
            vertical-align: middle;
            border-top: 1px solid #dee2e6;
            font-size: 13px;
            word-wrap: break-word;
            text-align: center !important;
        }

        /* Forzar centrado en todas las celdas de DataTables */
        #tablaMovimientos th,
        #tablaMovimientos td {
            text-align: center !important;
        }

        /* Asegurar centrado en el wrapper de DataTables */
        .table-container .dataTables_wrapper .dataTables_scrollHead th,
        .table-container .dataTables_wrapper .dataTables_scrollBody td {
            text-align: center !important;
        }

        /* Centrar contenido de todas las columnas */
        .table-container table th,
        .table-container table td {
            text-align: center !important;
        }

        /* Modal de resultados de tamaño completo */
        .modal-resultados-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0, 0, 0, 0.8);
            z-index: 9999;
            display: none;
            overflow: hidden;
        }

        .modal-resultados-content {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: white;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .modal-resultados-header {
            background: linear-gradient(135deg, #a8e6cf, #88d8a3);
            color: #2d5a3d;
            padding: 8px 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            min-height: 50px;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .modal-resultados-header h3 {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            color: #2d5a3d;
            text-shadow: none;
        }

        .export-buttons-compact {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .export-buttons-compact .btn {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 11px;
            padding: 4px 8px;
            border-radius: 4px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .export-buttons-compact .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }

        .btn-cerrar-modal {
            background: rgba(45, 90, 61, 0.2);
            color: #2d5a3d;
            border: none;
            padding: 6px 10px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .btn-cerrar-modal:hover {
            background: rgba(45, 90, 61, 0.3);
            transform: scale(1.05);
        }

        .modal-resultados-body {
            flex: 1;
            padding: 8px;
            overflow: hidden;
            background: #f8f9fa;
            display: flex;
            flex-direction: column;
        }

        .modal-resultados-body .table-responsive {
            overflow-x: auto !important;
            overflow-y: auto;
            max-height: calc(100vh - 120px);
            border: 1px solid #dee2e6;
            border-radius: 8px;
            flex: 1;
            width: 95%;
            margin: 0 auto;
        }

        /* Scrollbar más sutil */
        .modal-resultados-body .table-responsive::-webkit-scrollbar {
            height: 8px;
            width: 8px;
        }

        .modal-resultados-body .table-responsive::-webkit-scrollbar-track {
            background: #f8f9fa;
            border-radius: 4px;
        }

        .modal-resultados-body .table-responsive::-webkit-scrollbar-thumb {
            background: #6c757d;
            border-radius: 4px;
        }

        .modal-resultados-body .table-responsive::-webkit-scrollbar-thumb:hover {
            background: #495057;
        }

        .modal-resultados-body .table {
            background: white;
            border-radius: 8px;
            overflow: visible;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            min-width: 100%;
            table-layout: auto;
        }

        .modal-resultados-body .table th {
            background: #2c3e50;
            color: white;
            padding: 8px 6px;
            font-weight: 600;
            text-align: center;
            border: none;
            font-size: 11px;
            white-space: nowrap;
            min-width: 70px;
            max-width: 120px;
            position: sticky;
            top: 0;
            z-index: 10;
            cursor: pointer;
            user-select: none;
            transition: background-color 0.2s ease;
        }

        .modal-resultados-body .table th:hover {
            background: #34495e;
        }

        .modal-resultados-body .table th.sortable::after {
            content: " ↕";
            opacity: 0.5;
            font-size: 10px;
        }

        .modal-resultados-body .table th.sort-asc::after {
            content: " ↑";
            opacity: 1;
            color: #ffc107;
        }

        .modal-resultados-body .table th.sort-desc::after {
            content: " ↓";
            opacity: 1;
            color: #ffc107;
        }

        .modal-resultados-body .table td {
            padding: 6px 4px;
            text-align: center;
            border-bottom: 1px solid #dee2e6;
            vertical-align: middle;
            font-size: 11px;
            white-space: nowrap;
            min-width: 70px;
            max-width: 120px;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .modal-resultados-body .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .modal-resultados-body .table tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
        }

        .table tbody tr {
            line-height: 1.2;
        }

        .table tbody tr td {
            padding-top: 4px;
            padding-bottom: 4px;
        }

        #tablaMovimientos {
            width: 100% !important;
            border-collapse: collapse;
            border: 1px solid rgba(0, 0, 0, 0.1);
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .filter-row {
                gap: 8px;
            }

            .filter-label {
                font-size: 12px;
            }

            .filter-select,
            .filter-input {
                min-width: 120px;
                font-size: 12px;
            }

            .btn-buscar,
            .btn-limpiar,
            .btn-exportar-excel,
            .back-btn {
                padding: 6px 15px;
                font-size: 13px;
            }
        }

        @media (max-width: 992px) {
            .main-container {
                margin: 10px;
                padding: 10px;
                height: calc(100vh - 20px);
                width: calc(100vw - 20px);
            }

            .filters-section {
                padding: 12px;
            }

            .filter-row {
                gap: 8px;
                flex-wrap: wrap;
            }

            .filter-label {
                min-width: 80px;
                font-size: 12px;
            }

            .filter-select,
            .filter-input {
                min-width: 110px;
                font-size: 12px;
                padding: 5px 8px;
            }

            .btn-buscar,
            .btn-limpiar,
            .btn-exportar-excel,
            .back-btn {
                padding: 6px 12px;
                font-size: 12px;
            }

            .table th,
            .table td {
                font-size: 12px;
                padding: 4px 4px;
            }
        }

        @media (max-width: 768px) {
            .main-container {
                margin: 5px;
                padding: 8px;
                height: calc(100vh - 10px);
                width: calc(100vw - 10px);
            }

            .header-section {
                padding: 8px 12px;
                margin-bottom: 10px;
            }

            .header-section .logo-text {
                font-size: 18px;
            }

            .header-section .breadcrumb {
                font-size: 12px;
            }

            .header-section .logo-icon {
                width: 35px;
                height: 35px;
                font-size: 18px;
            }

            .back-btn {
                padding: 6px 12px;
                font-size: 12px;
            }

            .filters-section {
                padding: 10px;
            }

            .filters-table {
                display: block;
            }

            .filters-table tr {
                display: block;
                margin-bottom: 10px;
            }

            .filters-table td {
                display: block;
                padding: 4px 0;
                width: 100% !important;
            }

            .filter-label {
                margin-bottom: 4px;
            }

            .filter-select,
            .filter-input {
                min-width: auto;
                width: 100%;
                font-size: 14px;
                padding: 8px 10px;
            }

            .filter-row-buttons {
                flex-direction: row;
                gap: 8px;
            }

            .btn-buscar,
            .btn-limpiar,
            .btn-exportar-excel {
                flex: 1;
                min-width: 0;
                justify-content: center;
            }

            .table th,
            .table td {
                font-size: 11px;
                padding: 3px 2px;
            }

            /* Paginación responsive */
            .table-container .dataTables_wrapper .row {
                flex-direction: column;
                gap: 10px;
                align-items: center;
            }

            .table-container .dataTables_info {
                position: static;
                transform: none;
                text-align: center;
            }

            .table-container .dataTables_paginate {
                margin-left: 0;
                justify-content: center;
            }
        }

        @media (max-width: 576px) {
            .main-container {
                margin: 0;
                padding: 5px;
                height: 100vh;
                width: 100vw;
                border-radius: 0;
            }

            .filters-section {
                padding: 8px;
                border-radius: 4px;
            }

            .filters-title {
                font-size: 14px;
                margin-bottom: 8px;
            }

            .filter-row {
                gap: 8px;
            }

            .table th,
            .table td {
                font-size: 10px;
                padding: 2px 1px;
            }

            .table-container .dataTables_info {
                font-size: 11px;
            }

            .table-container .dataTables_paginate .paginate_button {
                padding: 4px 6px;
                font-size: 11px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Header -->
            <div class="header-section">
                <div class="logo">
                    <div class="logo-icon">
                        <i class="fas fa-exchange-alt"></i>
                    </div>
        <div>
                        <div class="logo-text">Reporte de Movimientos</div>
                        <div class="breadcrumb">Consulta de movimientos y transacciones</div>
        </div>
                </div>
                <a href="dashboardReportes.aspx" class="back-btn">
                    <i class="fas fa-arrow-left"></i>
                    Volver
                </a>
            </div>

            <!-- Filtros -->
            <div class="filters-section">
                <table class="filters-table">
                    <!-- Primera fila: Dropdowns -->
                    <tr class="filter-row-dropdowns">
                        <td>
                            <label class="filter-label">Usuario:</label>
                        </td>
                        <td>
                            <select id="ddlUsuario" class="filter-select">
                                <option value="">Todos los usuarios</option>
                            </select>
                        </td>
                        <td>
                            <label class="filter-label">Asociado:</label>
                        </td>
                        <td>
                            <div style="display: flex; gap: 5px; align-items: center;">
                                <div id="txtAsociadoSeleccionado" class="filter-input" 
                                     style="flex: 1; background-color: #f8f9fa; cursor: pointer; min-height: 38px; padding: 6px 10px; display: flex; align-items: center; color: #6c757d;">
                                    <span id="txtAsociadoSeleccionadoTexto">Ningún asociado seleccionado</span>
                                </div>
                                <button type="button" id="btnBuscarAsociado" class="btn btn-outline-primary btn-sm" 
                                        style="white-space: nowrap; padding: 6px 12px;">
                                    <i class="fas fa-search"></i>
                                </button>
                                <button type="button" id="btnLimpiarAsociado" class="btn btn-outline-secondary btn-sm" 
                                        style="white-space: nowrap; padding: 6px 12px; display: none;">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </td>
                        <td>
                            <label class="filter-label">Rubro:</label>
                        </td>
                        <td>
                            <select id="ddlRubro" class="filter-select">
                                <option value="">Todos los rubros</option>
                            </select>
                        </td>
                        <td>
                            <label class="filter-label">Tipo Transacción:</label>
                        </td>
                        <td>
                            <select id="ddlTransaccion" class="filter-select">
                                <option value="">Todas las transacciones</option>
                            </select>
                        </td>
                    </tr>

                    <!-- Segunda fila: Datepickers y Botones -->
                    <tr class="filter-row-dates">
                        <td>
                            <label class="filter-label">Fecha Desde:</label>
                        </td>
                        <td>
                            <input type="text" id="txtFechaDesde" class="filter-input" placeholder="dd/MM/yyyy" />
                        </td>
                        <td>
                            <label class="filter-label">Fecha Hasta:</label>
                        </td>
                        <td>
                            <input type="text" id="txtFechaHasta" class="filter-input" placeholder="dd/MM/yyyy" />
                        </td>
                        <td colspan="2" style="text-align: right;">
                            <button type="button" id="btnBuscarMovimientos" class="btn-buscar" onclick="buscarMovimientos()">
                                <i class="fas fa-search"></i>
                                Buscar
                            </button>

                            <button type="button" class="btn-limpiar" onclick="limpiarFiltros()">
                                <i class="fas fa-eraser"></i>
                                Limpiar
                            </button>
                        </td>
                    </tr>
                </table>
            </div>

            <!-- Contenedor de resultados (se mostrará en modal) -->
            <div class="table-container" style="display: flex; align-items: center; justify-content: center; color: #6c757d;">
                <div style="text-align: center;">
                    <i class="fas fa-search" style="font-size: 48px; margin-bottom: 15px; opacity: 0.3;"></i>
                    <p style="font-size: 16px;">Utiliza los filtros y haz clic en "Buscar" para ver los resultados</p>
                </div>
            </div>
        </div>
        
        <!-- Global Modals Container -->
        <div id="globalModalsContainer"></div>
    </form>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>
    <!-- Script de monitoreo de inactividad -->
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    <!-- Script de notificaciones globales -->
    <script src="../../Scripts/notifications.js"></script>
    <!-- Script de chips para identificación -->
    <script src="../../Scripts/smart-chips.js"></script>
    <!-- Script global de búsqueda de asociados -->
    <script src="../../Scripts/global-associate-search.js?v=1.4"></script>

    <script type="text/javascript">
        // Inicializar cuando el DOM esté listo
        $(document).ready(function() {
            // Inicializar monitoreo de inactividad
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }

            // Inicializar Flatpickr para fechas con fecha actual por defecto
            const fechaHoy = new Date();
            const fechaHoyStr = fechaHoy.toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit', year: 'numeric' });
            
            flatpickr("#txtFechaDesde", {
                locale: "es",
                dateFormat: "d/m/Y",
                altInput: true,
                altFormat: "d/m/Y",
                allowInput: true,
                defaultDate: fechaHoy,
                required: true
            });

            flatpickr("#txtFechaHasta", {
                locale: "es",
                dateFormat: "d/m/Y",
                altInput: true,
                altFormat: "d/m/Y",
                allowInput: true,
                defaultDate: fechaHoy,
                required: true
            });
            
            // Establecer valores por defecto
            $('#txtFechaDesde').val(fechaHoyStr);
            $('#txtFechaHasta').val(fechaHoyStr);

            // Cargar dropdowns
            cargarUsuarios();
            cargarRubros();
            cargarCodigosTransaccion();
            
            // Test de conexión al WebMethod
            $.ajax({
                type: "POST",
                url: "Movimientos.aspx/BuscarAsociados",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ busqueda: "test" }),
                success: function(response) {
                    // WebMethod accesible
                },
                error: function(xhr, status, error) {
                    // WebMethod no accesible
                }
            });
            
            // Inicializar componente global de búsqueda de asociados
            inicializarBusquedaAsociadosGlobal();
            
            // Eventos para búsqueda de asociado
            $('#btnBuscarAsociado').on('click', function() {
                abrirBusquedaAsociados(globalSearchConfig);
            });
            
            $('#txtAsociadoSeleccionado').on('click', function() {
                abrirBusquedaAsociados(globalSearchConfig);
            });
            
            $('#btnLimpiarAsociado').on('click', function() {
                limpiarAsociadoSeleccionado();
            });
        });

        // Cargar usuarios
        function cargarUsuarios() {
            $.ajax({
                type: "POST",
                url: "Movimientos.aspx/ObtenerUsuarios",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({}),
                success: function(response) {
                    try {
                        let responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (responseData && responseData.Success && responseData.Data) {
                            let usuarios = typeof responseData.Data === 'string' ? JSON.parse(responseData.Data) : responseData.Data;
                            const ddl = $('#ddlUsuario');
                            usuarios.forEach(function(usuario) {
                                ddl.append($('<option>', {
                                    value: usuario.Id,
                                    text: usuario.Usuario
                                }));
                            });
                        }
                    } catch (error) {
                        // Error al cargar usuarios
                    }
                },
                error: function(xhr, status, error) {
                    // Error en AJAX al cargar usuarios
                }
            });
        }

        // Variable global para almacenar el asociado seleccionado
        var asociadoSeleccionado = null;
        var globalSearchConfig = null;
        
        // Función para inicializar el componente global de búsqueda
        function inicializarBusquedaAsociadosGlobal() {
            globalSearchConfig = crearBusquedaAsociados('globalModalsContainer', {
                modalId: 'modalBuscarAsociadoMovimientos',
                searchInputId: 'txtBuscarAsociadoMovimientos',
                resultsTableId: 'tbodyAsociadosMovimientos',
                searchButtonId: 'btnBuscarAsociadoMovimientos',
                clearButtonId: 'btnLimpiarBusquedaMovimientos',
                modalTitle: 'Buscar Asociado',
                searchPlaceholder: 'Ingrese nombre, cédula o número de asociado...',
                validarAuxiliares: false, // No validar auxiliares para reportes
                onSelect: function(asociado) {
                    // Callback cuando se selecciona un asociado
                    seleccionarAsociadoParaFiltro(asociado.numeroAsociado, asociado.nombre, asociado.numeroIdentificacion, asociado.codTipoDoc);
                },
                onCancel: function() {
                    // Callback cuando se cancela la búsqueda
                }
            });
        }
        
        // Función para seleccionar un asociado para el filtro
        function seleccionarAsociadoParaFiltro(numeroAsociado, nombre, cedula, tipoDocumento) {
            asociadoSeleccionado = {
                numeroAsociado: numeroAsociado,
                nombre: nombre,
                cedula: cedula,
                tipoDocumento: tipoDocumento
            };
            
            // Mostrar información del asociado en el div
            const identificacionHtml = crearChipTipoDocumento ? crearChipTipoDocumento(tipoDocumento, cedula) : `${tipoDocumento}: ${cedula}`;
            const contenidoHtml = `${nombre} (${identificacionHtml}) - N° ${numeroAsociado}`;
            $('#txtAsociadoSeleccionadoTexto').html(contenidoHtml);
            $('#txtAsociadoSeleccionado').css('color', '#495057');
            
            // Mostrar botón de limpiar
            $('#btnLimpiarAsociado').show();
        }
        
        // Función para limpiar el asociado seleccionado
        function limpiarAsociadoSeleccionado() {
            asociadoSeleccionado = null;
            $('#txtAsociadoSeleccionadoTexto').text('Ningún asociado seleccionado');
            $('#txtAsociadoSeleccionado').css('color', '#6c757d');
            $('#btnLimpiarAsociado').hide();
        }

        // Cargar rubros
        function cargarRubros() {
            $.ajax({
                type: "POST",
                url: "Movimientos.aspx/ObtenerRubros",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({}),
                success: function(response) {
                    try {
                        let responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (responseData && responseData.Success && responseData.Data) {
                            let rubros = typeof responseData.Data === 'string' ? JSON.parse(responseData.Data) : responseData.Data;
                            const ddl = $('#ddlRubro');
                            rubros.forEach(function(rubro) {
                                ddl.append($('<option>', {
                                    value: rubro.CodigoRubro,
                                    text: rubro.Descripcion
                                }));
                            });
                        }
                    } catch (error) {
                        // Error al cargar rubros
                    }
                },
                error: function(xhr, status, error) {
                    // Error en AJAX al cargar rubros
                }
            });
        }

        // Cargar códigos de transacción
        function cargarCodigosTransaccion() {
            $.ajax({
                type: "POST",
                url: "Movimientos.aspx/ObtenerCodigosTransaccion",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({}),
                success: function(response) {
                    try {
                        let responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (responseData && responseData.Success && responseData.Data) {
                            let transacciones = typeof responseData.Data === 'string' ? JSON.parse(responseData.Data) : responseData.Data;
                            const ddl = $('#ddlTransaccion');
                            transacciones.forEach(function(transaccion) {
                                ddl.append($('<option>', {
                                    value: transaccion.CodigoTransaccion,
                                    text: transaccion.Descripcion
                                }));
                            });
                        }
                    } catch (error) {
                        // Error al cargar códigos de transacción
                    }
                },
                error: function(xhr, status, error) {
                    // Error en AJAX al cargar códigos de transacción
                }
            });
        }

        // Buscar movimientos
        function buscarMovimientos() {
            // Obtener valores de filtros
            const idUsuario = $('#ddlUsuario').val() || null;
            const numeroAsociado = asociadoSeleccionado ? asociadoSeleccionado.numeroAsociado : null;
            const codigoRubro = $('#ddlRubro').val() || null;
            const codigoTransaccion = $('#ddlTransaccion').val() || null;
            
            // Obtener fechas y convertir formato
            let fechaDesde = $('#txtFechaDesde').val();
            let fechaHasta = $('#txtFechaHasta').val();
            
            // Validar que las fechas estén presentes ANTES de convertir
            if (!fechaDesde || fechaDesde.trim() === '') {
                showToast('warning', 'Fecha requerida', 'La fecha desde es obligatoria');
                return;
            }
            
            if (!fechaHasta || fechaHasta.trim() === '') {
                showToast('warning', 'Fecha requerida', 'La fecha hasta es obligatoria');
                return;
            }
            
            // Convertir fecha de dd/MM/yyyy a yyyyMMdd para el servidor
            let fechaDesdeConvertida = null;
            let fechaHastaConvertida = null;
            
            const partesDesde = fechaDesde.split('/');
            if (partesDesde.length === 3) {
                fechaDesdeConvertida = partesDesde[2] + partesDesde[1] + partesDesde[0];
            } else {
                showToast('warning', 'Formato inválido', 'La fecha desde tiene un formato inválido. Use dd/MM/yyyy');
                return;
            }

            const partesHasta = fechaHasta.split('/');
            if (partesHasta.length === 3) {
                fechaHastaConvertida = partesHasta[2] + partesHasta[1] + partesHasta[0];
            } else {
                showToast('warning', 'Formato inválido', 'La fecha hasta tiene un formato inválido. Use dd/MM/yyyy');
                return;
            }
            
            // Usar las fechas convertidas
            fechaDesde = fechaDesdeConvertida;
            fechaHasta = fechaHastaConvertida;

            // Mostrar loading en el botón Buscar
            const btnBuscar = $('#btnBuscarMovimientos');
            const htmlOriginal = btnBuscar.html();
            btnBuscar.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Buscando...');

            $.ajax({
                type: "POST",
                url: "Movimientos.aspx/BuscarMovimientos",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({
                    idUsuario: idUsuario,
                    numeroAsociado: numeroAsociado,
                    fechaDesde: fechaDesde,
                    fechaHasta: fechaHasta,
                    codigoRubro: codigoRubro,
                    codigoTransaccion: codigoTransaccion
                }),
                success: function(response) {
                    try {
                        let responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        
                        if (responseData && responseData.Success && responseData.Html) {
                            mostrarReporteMovimientos(responseData.Html);
                        } else {
                            showToast('error', 'Error', responseData?.Message || 'Error al generar el reporte');
                        }
                    } catch (error) {
                        showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
                    }
                },
                error: function(xhr, status, error) {
                    mostrarMovimientos([]);
                },
                complete: function() {
                    btnBuscar.prop('disabled', false).html(htmlOriginal);
                }
            });
        }

        // Variable global para HTML del reporte
        let htmlReporteMovimientos = '';

        // Mostrar reporte de movimientos en modal
        function mostrarReporteMovimientos(htmlContent) {
            htmlReporteMovimientos = htmlContent;
            
            // Crear modal para mostrar el reporte
            const modalHTML = `
                <div id="modalReporteMovimientos" class="estado-cuenta-modal-overlay" style="display: flex;">
                    <div class="estado-cuenta-modal" style="max-width: 95%; max-height: 95%; overflow: auto;">
                        <div class="estado-cuenta-modal-header">
                            <h5><i class="fas fa-file-invoice text-primary"></i> Reporte de Movimientos</h5>
                            <button type="button" class="btn-close-custom" onclick="cerrarModalReporteMovimientos()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="estado-cuenta-modal-body">
                            <div class="estado-cuenta-container">
                                ${htmlContent}
                            </div>
                        </div>
                        <div class="estado-cuenta-modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="cerrarModalReporteMovimientos()">
                                <i class="fas fa-times"></i> Cerrar
                            </button>
                            <button type="button" class="btn btn-primary" onclick="imprimirReporteMovimientos()">
                                <i class="fas fa-print"></i> Imprimir
                            </button>
                        </div>
                    </div>
                </div>
            `;
            
            // Agregar estilos si no existen
            if ($('#estilosModalReporteMovimientos').length === 0) {
                $('head').append(`
                    <style id="estilosModalReporteMovimientos">
                        .estado-cuenta-modal-overlay {
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
                        
                        .estado-cuenta-modal {
                            background: white;
                            border-radius: 12px;
                            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
                            width: 95%;
                            max-width: 1000px;
                            max-height: 95vh;
                            overflow: hidden;
                            animation: modalSlideIn 0.3s ease-out;
                            display: flex;
                            flex-direction: column;
                        }
                        
                        @keyframes modalSlideIn {
                            from {
                                opacity: 0;
                                transform: scale(0.9) translateY(-20px);
                            }
                            to {
                                opacity: 1;
                                transform: scale(1) translateY(0);
                            }
                        }
                        
                        .estado-cuenta-modal-header {
                            background: linear-gradient(135deg, #2c3e50, #34495e);
                            color: white;
                            padding: 15px 20px;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            flex-shrink: 0;
                        }
                        
                        .estado-cuenta-modal-header h5 {
                            margin: 0;
                            font-size: 18px;
                            font-weight: 600;
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
                            transition: all 0.2s;
                        }
                        
                        .btn-close-custom:hover {
                            background: rgba(255, 255, 255, 0.3);
                            transform: rotate(90deg);
                        }
                        
                        .estado-cuenta-modal-body {
                            flex: 1;
                            overflow: auto;
                            padding: 20px;
                            background: #f8f9fa;
                        }
                        
                        .estado-cuenta-container {
                            background: white;
                            border-radius: 8px;
                            padding: 20px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }
                        
                        .estado-cuenta-modal-footer {
                            padding: 15px 20px;
                            background: #f8f9fa;
                            border-top: 1px solid #dee2e6;
                            display: flex;
                            justify-content: flex-end;
                            gap: 10px;
                            flex-shrink: 0;
                        }
                        
                        .estado-cuenta-modal-footer .btn {
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
                        
                        .estado-cuenta-modal-footer .btn-secondary {
                            background: #6c757d;
                            color: white;
                        }
                        
                        .estado-cuenta-modal-footer .btn-secondary:hover {
                            background: #5a6268;
                        }
                        
                        .estado-cuenta-modal-footer .btn-primary {
                            background: #007bff;
                            color: white;
                        }
                        
                        .estado-cuenta-modal-footer .btn-primary:hover {
                            background: #0056b3;
                        }
                    </style>
                `);
            }
            
            $('body').append(modalHTML);
            $('#modalReporteMovimientos').fadeIn(300);
        }
        
        function cerrarModalReporteMovimientos() {
            $('#modalReporteMovimientos').fadeOut(300, function() {
                $(this).remove();
            });
        }
        
        function imprimirReporteMovimientos() {
            const ventanaImpresion = window.open('', '_blank', 'width=800,height=600');
            
            const contenidoReporte = htmlReporteMovimientos;
            
            const estilosCompletos = `
                @page {
                    size: 8.5in 11in;
                    margin: 0.5in;
                }
                
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    margin: 0;
                    padding: 20px;
                    font-size: 12px;
                    line-height: 1.4;
                    background-color: white;
                    color: #333;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                    color-adjust: exact;
                }
                
                .reporte-movimientos {
                    width: 100%;
                    max-width: 8.5in;
                    margin: 0 auto;
                    background-color: white;
                }
                
                .header {
                    text-align: center;
                    margin-bottom: 30px;
                    padding-bottom: 20px;
                    border-bottom: 2px solid #2c3e50;
                }
                
                .logo img {
                    max-width: 200px;
                    height: auto;
                }
                
                .cooperativa-nombre {
                    font-size: 18px;
                    font-weight: 700;
                    color: #2c3e50;
                    margin-bottom: 10px;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                }
                
                .titulo-reporte {
                    font-size: 24px;
                    font-weight: 700;
                    color: #2c3e50;
                    margin-top: 15px;
                    text-transform: uppercase;
                    letter-spacing: 2px;
                }
                
                .datos-filtro {
                    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                    border: 1px solid #dee2e6;
                    border-radius: 6px;
                    padding: 15px;
                    margin-bottom: 25px;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                
                .datos-filtro h3 {
                    font-size: 14px;
                    font-weight: 600;
                    color: #2c3e50;
                    margin-bottom: 10px;
                    text-transform: uppercase;
                    border-bottom: 1px solid #ced4da;
                    padding-bottom: 8px;
                }
                
                .datos-filtro .campo {
                    display: flex;
                    margin-bottom: 8px;
                }
                
                .datos-filtro .campo-label {
                    font-weight: 600;
                    color: #495057;
                    min-width: 150px;
                }
                
                .datos-filtro .campo-label::after {
                    content: ":";
                    margin-right: 10px;
                }
                
                .tabla-datos {
                    width: 100%;
                    border-collapse: collapse;
                    margin-bottom: 30px;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                }
                
                .tabla-datos thead {
                    background: #2c3e50;
                    color: white;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                
                .tabla-datos thead th {
                    padding: 12px 8px;
                    text-align: center;
                    font-weight: 600;
                    font-size: 11px;
                    text-transform: uppercase;
                    border: 1px solid #1a252f;
                }
                
                .tabla-datos tbody td {
                    padding: 10px 8px;
                    text-align: center;
                    border: 1px solid #dee2e6;
                    font-size: 11px;
                }
                
                .tabla-datos tbody tr:nth-child(even) {
                    background-color: #f8f9fa;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                
                .grupo-rubro {
                    margin-bottom: 20px;
                }
                
                .grupo-rubro-header {
                    background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
                    color: white;
                    padding: 10px 15px;
                    font-weight: 600;
                    font-size: 13px;
                    text-transform: uppercase;
                    border-radius: 4px 4px 0 0;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                
                .grupo-rubro-total {
                    background: #e9ecef;
                    padding: 10px 15px;
                    font-weight: 600;
                    font-size: 11px;
                    text-align: right;
                    border: 1px solid #dee2e6;
                    border-top: none;
                    border-radius: 0 0 4px 4px;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                
                .total-general {
                    background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                    color: white;
                    padding: 15px;
                    font-weight: 700;
                    font-size: 13px;
                    text-align: right;
                    border-radius: 4px;
                    margin-top: 20px;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                
                .monto {
                    font-family: 'monospace';
                    text-align: right;
                }
                
                .monto-cr {
                    color: #e74c3c;
                    font-weight: 600;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                
                .footer {
                    margin-top: 40px;
                    padding-top: 20px;
                    border-top: 2px solid #2c3e50;
                    text-align: center;
                    font-size: 10px;
                    color: #6c757d;
                }
            `;
            
            ventanaImpresion.document.write(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Reporte de Movimientos</title>
                    <style>${estilosCompletos}</style>
                </head>
                <body>
                    ${contenidoReporte}
                </body>
                </html>
            `);
            
            ventanaImpresion.document.close();
            ventanaImpresion.focus();
            
            setTimeout(function() {
                ventanaImpresion.print();
            }, 250);
        }

        // Mostrar resultados en ventana modal de tamaño completo
        function mostrarResultadosModal(nombreReporte, datos) {
            // Crear ventana modal de tamaño completo
            const modalHTML = `
                <div id="modalResultados" class="modal-resultados-overlay">
                    <div class="modal-resultados-content">
                        <div class="modal-resultados-header">
                            <div class="header-left">
                                <h3><i class="fas fa-exchange-alt"></i> ${nombreReporte}</h3>
                                <div class="export-buttons-compact">
                                    <button type="button" class="btn btn-success btn-sm" onclick="exportarAExcelModal()">
                                        <i class="fas fa-file-excel"></i> Excel
                                    </button>
                                </div>
                            </div>
                            <button type="button" class="btn-cerrar-modal" onclick="cerrarModalResultados()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="modal-resultados-body">
                            <div class="table-responsive">
                                <table id="tablaResultados" class="table table-hover">
                                    <thead id="theadResultados">
                                        <!-- Se llenará dinámicamente -->
                                    </thead>
                                    <tbody id="tbodyResultados">
                                        <!-- Se llenará dinámicamente -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            
            // Agregar modal al body
            $('body').append(modalHTML);
            
            // Llenar tabla con datos
            llenarTablaResultados(datos);
            
            // Mostrar modal
            $('#modalResultados').fadeIn(300);
        }

        // Llenar tabla con los resultados
        function llenarTablaResultados(datos) {
            if (!datos || datos.length === 0) {
                $('#tbodyResultados').html('<tr><td colspan="100%" class="text-center">No hay datos para mostrar</td></tr>');
                return;
            }
            
            // Obtener columnas del primer objeto
            const columnas = Object.keys(datos[0]);
            
            // Crear encabezados con funcionalidad de ordenamiento
            let theadHTML = '<tr>';
            columnas.forEach((columna, index) => {
                theadHTML += `<th class="sortable" data-column="${index}">${columna}</th>`;
            });
            theadHTML += '</tr>';
            $('#theadResultados').html(theadHTML);
            
            // Agregar event listeners para ordenamiento
            agregarFuncionalidadOrdenamiento();
            
            // Crear filas de datos
            let tbodyHTML = '';
            datos.forEach((fila) => {
                tbodyHTML += '<tr>';
                columnas.forEach(columna => {
                    const valor = fila[columna] || '';
                    tbodyHTML += `<td>${valor}</td>`;
                });
                tbodyHTML += '</tr>';
            });
            
            $('#tbodyResultados').html(tbodyHTML);
        }

        // Agregar funcionalidad de ordenamiento
        function agregarFuncionalidadOrdenamiento() {
            $('.modal-resultados-body .table th.sortable').on('click', function() {
                const columnIndex = parseInt($(this).data('column'));
                const columnName = $(this).text().trim();
                
                // Determinar dirección de ordenamiento
                let sortDirection = 'asc';
                if ($(this).hasClass('sort-asc')) {
                    sortDirection = 'desc';
                } else if ($(this).hasClass('sort-desc')) {
                    sortDirection = 'asc';
                }
                
                // Remover clases de ordenamiento de todas las columnas
                $('.modal-resultados-body .table th').removeClass('sort-asc sort-desc');
                
                // Agregar clase de ordenamiento a la columna actual
                $(this).addClass(sortDirection === 'asc' ? 'sort-asc' : 'sort-desc');
                
                // Ordenar datos
                ordenarDatosModal(columnIndex, sortDirection);
            });
        }

        // Ordenar datos de la tabla
        function ordenarDatosModal(columnIndex, direction) {
            const tbody = $('#tbodyResultados');
            const rows = tbody.find('tr').toArray();
            
            // Ordenar filas
            rows.sort((a, b) => {
                const aValue = $(a).find('td').eq(columnIndex).text().trim();
                const bValue = $(b).find('td').eq(columnIndex).text().trim();
                
                // Intentar convertir a números
                const aNum = parseFloat(aValue.replace(',', '.').replace(/[^0-9.-]/g, ''));
                const bNum = parseFloat(bValue.replace(',', '.').replace(/[^0-9.-]/g, ''));
                
                let comparison = 0;
                if (!isNaN(aNum) && !isNaN(bNum)) {
                    comparison = aNum - bNum;
                } else {
                    comparison = aValue.localeCompare(bValue, 'es', { numeric: true });
                }
                
                return direction === 'asc' ? comparison : -comparison;
            });
            
            // Reordenar filas en la tabla
            tbody.empty();
            rows.forEach((row) => {
                tbody.append(row);
            });
        }

        // Cerrar modal de resultados
        function cerrarModalResultados() {
            $('#modalResultados').fadeOut(300, function() {
                $(this).remove();
            });
        }

        // Exportar a Excel desde el modal
        function exportarAExcelModal() {
            if (!datosMovimientosModal || datosMovimientosModal.length === 0) {
                showToast('warning', 'Advertencia', 'No hay datos para exportar');
                return;
            }

            // Mostrar indicador de carga
            const botonExcel = $('.export-buttons-compact .btn-success');
            const textoOriginal = botonExcel.html();
            botonExcel.html('<i class="fas fa-spinner fa-spin"></i> Exportando...');
            botonExcel.prop('disabled', true);

            $.ajax({
                type: "POST",
                url: "Movimientos.aspx/ExportarAExcel",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({
                    nombreReporte: nombreReporteModal,
                    datos: datosMovimientosModal
                }),
                success: function(response) {
                    try {
                        let responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;

                        if (responseData && responseData.Resultado === 'SUCCESS') {
                            // Crear enlace de descarga
                            const url = `Movimientos.aspx?action=download&file=${responseData.NombreArchivo}`;
                            const link = document.createElement('a');
                            link.href = url;
                            link.download = responseData.NombreArchivo;
                            document.body.appendChild(link);
                            link.click();
                            document.body.removeChild(link);

                            showToast('success', 'Éxito', 'Archivo Excel generado exitosamente');
                        } else {
                            showToast('error', 'Error', 'Error al generar archivo Excel: ' + (responseData.Mensaje || 'Error desconocido'));
                        }
                    } catch (error) {
                        showToast('error', 'Error', 'Error al procesar la exportación');
                    }
                },
                error: function(xhr, status, error) {
                    showToast('error', 'Error', 'Error al exportar a Excel');
                },
                complete: function() {
                    // Restaurar botón
                    botonExcel.html(textoOriginal);
                    botonExcel.prop('disabled', false);
                }
            });
        }

        // Limpiar filtros
        function limpiarFiltros() {
            $('#ddlUsuario').val('');
            limpiarAsociadoSeleccionado();
            $('#ddlRubro').val('');
            $('#ddlTransaccion').val('');
            
            // Restablecer fechas al día de hoy
            const fechaHoy = new Date();
            const fechaHoyStr = fechaHoy.toLocaleDateString('es-ES', { day: '2-digit', month: '2-digit', year: 'numeric' });
            
            // Actualizar los campos de fecha
            $('#txtFechaDesde').val(fechaHoyStr);
            $('#txtFechaHasta').val(fechaHoyStr);
            
            // Actualizar los datepickers de Flatpickr
            const fpDesde = $('#txtFechaDesde')[0]._flatpickr;
            const fpHasta = $('#txtFechaHasta')[0]._flatpickr;
            if (fpDesde) {
                fpDesde.setDate(fechaHoy, false);
            }
            if (fpHasta) {
                fpHasta.setDate(fechaHoy, false);
            }
        }

    </script>
</body>
</html>
