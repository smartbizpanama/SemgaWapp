<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Reportes.aspx.vb" Inherits="SemgaWapp.Reportes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reportes y Estadísticas - Cooperativa Coopsemga</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"/>
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    
    <!-- Script de monitoreo de inactividad -->
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    
    <style>
        body {
            background: #f8f9fa;
            height: 100vh;
            overflow: hidden;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
        }
        
        .filter-select {
            padding: 6px 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            background: white;
            color: #495057;
            font-size: 13px;
            transition: all 0.3s ease;
            min-width: 150px;
        }
        
        .filter-select:focus {
            outline: none;
            border-color: #87CEEB;
            box-shadow: 0 0 0 2px rgba(135, 206, 235, 0.25);
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
            word-wrap: break-word;
            max-width: 200px;
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
        
        /* Tabla responsive con scroll interno */
        .table-responsive {
            overflow-x: hidden !important;
            overflow-y: auto !important;
            flex: 1;
            max-height: none;
        }

        .modal-resultados-body .table-responsive {
            overflow-x: auto !important;
            overflow-y: auto !important;
        }
        
        .table-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        #tablaReportes {
            width: 100% !important;
            table-layout: fixed;
            border-collapse: collapse;
            border: 1px solid rgba(0, 0, 0, 0.1);
        }

        #tablaReportes th {
            text-align: center !important;
            font-weight: 600;
            background-color: #2c3e50;
            color: white;
            padding: 12px 8px;
            border: none;
            border-right: 1px solid rgba(255, 255, 255, 0.2);
            vertical-align: middle;
        }
        
        #tablaReportes th:last-child {
            border-right: none;
        }
        
        /* Controlar ancho de columnas específicas */
        #tablaReportes th:nth-child(1),
        #tablaReportes td:nth-child(1) {
            width: 0%;
            display: none; /* ID - OCULTA solo en la tabla principal */
        }
        #tablaReportes th:nth-child(2), #tablaReportes td:nth-child(2) { width: 25%; text-align: center; } /* Nombre */
        #tablaReportes th:nth-child(3), #tablaReportes td:nth-child(3) { width: 6%; text-align: center; } /* Tipo */
        #tablaReportes th:nth-child(4), #tablaReportes td:nth-child(4) { width: 59%; text-align: center; } /* Descripción */
        #tablaReportes th:nth-child(5), #tablaReportes td:nth-child(5) { width: 10%; text-align: center; } /* Acción */
        
        /* Asegurar que el texto se ajuste */
        #tablaReportes td {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            text-align: center;
            border-right: 1px solid rgba(0, 0, 0, 0.1);
            border-bottom: 1px solid #dee2e6;
        }
        
        #tablaReportes td:last-child {
            border-right: none;
        }
        
        /* Permitir que la descripción se expanda */
        #tablaReportes td:nth-child(4) {
            white-space: normal;
            word-wrap: break-word;
            max-width: none;
        }
        
        /* Centrar contenido de todas las celdas */
        #tablaReportes td {
            text-align: center;
        }
        
        /* Centrar botones en la columna de acción */
        #tablaReportes td:nth-child(5) {
            text-align: center;
        }
        
        /* Forzar centrado de todos los headers */
        #tablaReportes thead th {
            text-align: center !important;
        }
        
        /* Centrado específico para cada header */
        #tablaReportes thead th:nth-child(1) {
            text-align: center !important;
            display: none; /* ID - OCULTA solo en la tabla principal */
        }
        #tablaReportes thead th:nth-child(2) { text-align: center !important; } /* Nombre */
        #tablaReportes thead th:nth-child(3) { text-align: center !important; } /* Tipo */
        #tablaReportes thead th:nth-child(4) { text-align: center !important; } /* Descripción */
        #tablaReportes thead th:nth-child(5) { text-align: center !important; } /* Acción */

        #tablaResultados {
            width: 100% !important;
            table-layout: auto;
            min-width: max-content;
        }

        #tablaResultados th,
        #tablaResultados td {
            white-space: nowrap;
            padding: 8px 12px;
            text-align: center;
        }

        /* Chips para tipos de reporte */
        .type-chip {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

        .type-chip:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }

        .type-chip.finanzas {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .type-chip.operativo {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
        }

        .type-chip.asociados {
            background: linear-gradient(135deg, #ff7f50, #ff6347);
            color: white;
        }

        .type-chip.administrativo {
            background: linear-gradient(135deg, #ffc107, #e0a800);
            color: #333;
        }

        .type-chip.estadístico,
        .type-chip.estadistico {
            background: linear-gradient(135deg, #6f42c1, #5a32a3);
            color: white;
        }

        .type-chip.contable {
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
        }

        .type-chip.auxiliares {
            background: linear-gradient(135deg, #17a2b8, #138496);
            color: white;
        }

        .type-chip.otro {
            background: linear-gradient(135deg, #6c757d, #5a6268);
            color: white;
        }

        /* Botón de abrir reporte */
        .btn-open-report {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-width: 100px;
            justify-content: center;
        }

        .btn-open-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .btn-open-report:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        /* Mensaje cuando no hay reportes */
        .no-reports {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
        }

        .no-reports i {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        .no-reports h4 {
            margin-bottom: 10px;
            color: #495057;
        }

        .no-reports p {
            margin: 0;
            font-size: 14px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 10px;
                text-align: center;
                padding: 10px 15px;
            }

            .main-content {
                padding: 10px;
            }

            .filter-group {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-select {
                min-width: auto;
            }

            .table-container {
                font-size: 12px;
            }

            .table th,
            .table td {
                padding: 8px;
            }
        }

        /* Toast Styles */
        .toast {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            z-index: 9999;
            min-width: 300px;
            max-width: 400px;
            transform: translateX(100%);
            transition: transform 0.3s ease;
        }

        .toast.show {
            transform: translateX(0);
        }

        .toast-icon {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
        }

        .toast-content {
            flex: 1;
        }

        .toast-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
        }

        .toast-message {
            color: #666;
            font-size: 14px;
            line-height: 1.4;
        }

        .toast-close {
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
            font-size: 18px;
            padding: 0;
            margin-left: 8px;
        }

        .toast-close:hover {
            color: #666;
        }

        .toast.info .toast-icon {
            background: #17a2b8;
        }

        .toast.success .toast-icon {
            background: #28a745;
        }

        .toast.warning .toast-icon {
            background: #ffc107;
        }

        .toast.error .toast-icon {
            background: #dc3545;
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

        /* Modal de opciones CSV */
        .modal-csv-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0, 0, 0, 0.5);
            z-index: 10000;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .modal-csv-content {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            max-width: 400px;
            width: 90%;
            max-height: 90vh;
            overflow: hidden;
        }

        .modal-csv-header {
            background: #17a2b8;
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-csv-header h4 {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
        }

        .btn-cerrar-csv {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-cerrar-csv:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .modal-csv-body {
            padding: 20px;
        }

        .modal-csv-footer {
            padding: 15px 20px;
            background: #f8f9fa;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #495057;
        }

        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-control:focus {
            outline: none;
            border-color: #17a2b8;
            box-shadow: 0 0 0 2px rgba(23, 162, 184, 0.25);
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

        /* Eliminar doble scrollbar */
        .modal-resultados-overlay {
            overflow: hidden !important;
        }

        .modal-resultados-content {
            overflow: hidden !important;
        }

        .modal-resultados-body {
            overflow: hidden !important;
        }

        /* Solo permitir scroll en la tabla */
        .modal-resultados-body .table-responsive {
            overflow-x: auto !important;
            overflow-y: auto !important;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container">
            <!-- Filtros -->
            <div class="filters-section d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div class="filter-group mb-0">
                    <label class="filter-label">Tipo de Reporte:</label>
                    <select id="filtroTipo" class="filter-select">
                        <option value="">Cargando tipos...</option>
                    </select>
                </div>
                <div class="alert alert-info py-2 px-3 mb-0 d-flex align-items-center gap-2" role="alert" style="flex: 1; max-width: none; margin: 0;">
                    <i class="fas fa-info-circle me-1"></i>
                    <span>Selecciona un reporte y haz clic en</span>
                    <button type="button" class="btn-open-report btn btn-sm" style="pointer-events: none; opacity: 1; font-size: 0.85rem; padding: 4px 10px;">
                        <i class="fas fa-external-link-alt"></i> Abrir
                    </button>
                    <span>para visualizar los resultados.</span>
                </div>
                <a href="dashboardReportes.aspx" class="back-btn ms-auto">
                    <i class="fas fa-arrow-left"></i>
                    Volver
                </a>
            </div>

            <!-- Lista de Reportes -->
            <div class="table-container">
                <div class="table-responsive">
                    <table id="tablaReportes" class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre del Reporte</th>
                                <th>Tipo</th>
                                <th>Descripción</th>
                                <th>Acción</th>
                                <th style="display: none;">Comando</th>
                            </tr>
                        </thead>
                        <tbody id="tbodyReportes">
                            <!-- Los datos se cargarán dinámicamente -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>

    <!-- Modal de opciones CSV -->
    <div id="modalOpcionesCSV" class="modal-csv-overlay" style="display: none;">
        <div class="modal-csv-content">
            <div class="modal-csv-header">
                <h4><i class="fas fa-file-csv"></i> Opciones de Exportación CSV</h4>
                <button type="button" class="btn-cerrar-csv" onclick="cerrarModalCSV()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-csv-body">
                <div class="form-group">
                    <label for="separadorCSV">Separador de campos:</label>
                    <select id="separadorCSV" class="form-control">
                        <option value=",">Coma (,)</option>
                        <option value=";">Punto y coma (;)</option>
                        <option value="|">Pipe (|)</option>
                        <option value="otro">Otro</option>
                    </select>
                </div>
                <div class="form-group" id="grupoOtroSeparador" style="display: none;">
                    <label for="otroSeparador">Caracter personalizado:</label>
                    <input type="text" id="otroSeparador" class="form-control" maxlength="1" placeholder="Ingrese un solo caracter">
                </div>
                <div class="modal-csv-footer">
                    <button type="button" class="btn btn-secondary" onclick="cerrarModalCSV()">Cancelar</button>
                    <button type="button" class="btn btn-info" onclick="exportarACSVConOpciones()">
                        <i class="fas fa-download"></i> Exportar CSV
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        let tablaReportes;
        let reportesData = [];

        // Inicializar monitoreo de inactividad cuando el DOM esté listo
        document.addEventListener('DOMContentLoaded', function() {
            // Manejar cambio en el dropdown de separador CSV
            $(document).on('change', '#separadorCSV', function() {
                const valor = $(this).val();
                if (valor === 'otro') {
                    $('#grupoOtroSeparador').show();
                    $('#otroSeparador').focus();
                } else {
                    $('#grupoOtroSeparador').hide();
                    $('#otroSeparador').val('');
                }
            });
            if (typeof initializeInactivityMonitoring === 'function') {
                initializeInactivityMonitoring();
            }
            inicializarTabla();
            cargarReportes();
        });

        // Inicializar DataTable
        function inicializarTabla() {
            
            tablaReportes = $('#tablaReportes').DataTable({
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
                },
                responsive: false, // Desactivar responsive para evitar scrollbar
                scrollX: false, // Desactivar scroll horizontal
                pageLength: 25,
                lengthMenu: [[10, 25, 50, 100], [10, 25, 50, 100]],
                order: [[2, 'asc'], [1, 'asc']],
                columnDefs: [
                    { targets: [0], width: '8%' },
                    { targets: [1], width: '25%' },
                    { targets: [2], width: '15%' },
                    { targets: [3], width: '42%' },
                    { targets: [4], width: '10%', orderable: false },
                    { targets: [5], visible: false } // Columna oculta para el comando
                ],
                dom: 'rtip',
                processing: true,
                data: [], // Inicializar con array vacío
                columns: [
                    { title: 'ID' },
                    { title: 'Nombre del Reporte' },
                    { title: 'Tipo' },
                    { title: 'Descripción' },
                    { title: 'Acción' },
                    { title: 'Comando', visible: false }
                ]
            });
        }

        // Cargar reportes al inicializar
        function cargarReportes() {
            $.ajax({
                type: "POST",
                url: "Reportes.aspx/ObtenerReportes",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({}),
                success: function(response) {
                    try {
                        let reportes = [];
                        
                        // Parsear response.d si es string
                        let responseData;
                        if (typeof response.d === 'string') {
                            responseData = JSON.parse(response.d);
                        } else {
                            responseData = response.d;
                        }
                        
                        // Ahora acceder a Data del objeto parseado
                        if (responseData && responseData.Data) {
                            if (typeof responseData.Data === 'string') {
                                reportes = JSON.parse(responseData.Data);
                            } else {
                                reportes = responseData.Data;
                            }
                        }
                        
                        reportesData = reportes;
                        llenarDropdownTipos(reportes);
                        mostrarReportes(reportes);
                        
                    } catch (error) {
                        mostrarReportes([]);
                    }
                },
                error: function(xhr, status, error) {
                    showToast('Error al cargar reportes', 'error');
                    mostrarReportes([]);
                }
            });
        }

        // Mostrar reportes en la tabla
        function mostrarReportes(reportes) {
            tablaReportes.clear();
            
            if (!reportes || reportes.length === 0) {
                // Mostrar mensaje cuando no hay datos
                tablaReportes.row.add([
                    '', // Columna ID oculta
                    '<div class="text-center text-muted"><i class="fas fa-chart-line me-2"></i>No hay reportes disponibles</div>',
                    '',
                    '',
                    '',
                    '' // Columna comando oculta
                ]);
                tablaReportes.draw();
                return;
            }
            
            reportes.forEach(function(reporte, index) {
                const tipoClass = obtenerClaseTipo(normalizarTipo(reporte.Tipo));
                
                const rowData = [
                    reporte.ID, // Columna oculta (ID)
                    `<strong>${reporte.Nombre}</strong>`,
                    `<span class="type-chip ${tipoClass}">${reporte.Tipo}</span>`,
                    reporte.Descripcion || 'Sin descripción',
                    `<button type="button" class="btn-open-report" onclick="abrirReporte(${reporte.ID}, '${reporte.Nombre}', '${reporte.Comando}'); return false;">
                        <i class="fas fa-external-link-alt"></i> Abrir
                    </button>`,
                    reporte.Comando || '' // Columna oculta con el comando
                ];
                
                tablaReportes.row.add(rowData);
            });
            
            tablaReportes.draw();
        }

        // Llenar dropdown con tipos únicos de los reportes
        function llenarDropdownTipos(reportes) {
            // Obtener tipos únicos
            const tiposUnicos = [...new Set(reportes.map(reporte => normalizarTipo(reporte.Tipo)))];
            
            // Limpiar dropdown actual
            const dropdown = $('#filtroTipo');
            dropdown.empty();
            
            // Agregar opción "Todos"
            dropdown.append('<option value="">Todos</option>');
            
            // Agregar cada tipo único
            tiposUnicos.forEach(tipo => {
                const option = `<option value="${tipo}">${tipo}</option>`;
                dropdown.append(option);
            });
        }

        function normalizarTipo(tipo) {
            if (!tipo) return 'Otros';
            return tipo.trim();
        }

        function obtenerClaseTipo(tipoNormalizado) {
            const map = {
                'Finanzas': 'finanzas',
                'Auxiliares': 'auxiliares',
                'Asociados': 'asociados',
                'Operativos': 'operativo',
                'Operativo': 'operativo',
                'Administrativo': 'administrativo',
                'Administrativos': 'administrativo',
                'Estadístico': 'estadístico',
                'Estadisticos': 'estadístico',
                'Contable': 'contable',
                'Contables': 'contable'
            };
            return map[tipoNormalizado] || 'otro';
        }

        // Filtro automático por tipo
        $('#filtroTipo').on('change', function() {
            const tipoSeleccionado = $(this).val();
            
            if (tipoSeleccionado === '') {
                // Mostrar todos los reportes
                mostrarReportes(reportesData);
            } else {
                // Filtrar por tipo
                const reportesFiltrados = reportesData.filter(function(reporte) {
                    return normalizarTipo(reporte.Tipo) === tipoSeleccionado;
                });
                mostrarReportes(reportesFiltrados);
            }
        });

        // Abrir reporte y ejecutar comando
        function abrirReporte(id, nombre, comando) {
            showToast(`Ejecutando reporte: ${nombre}`, 'info');
            
            // Ejecutar comando SQL
            ejecutarComandoReporte(id, nombre, comando);
        }

        // Ejecutar comando SQL del reporte
        function ejecutarComandoReporte(id, nombre, comando) {
            $.ajax({
                type: "POST",
                url: "Reportes.aspx/EjecutarComandoReporte",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({ 
                    idReporte: id, 
                    nombreReporte: nombre, 
                    comandoSQL: comando 
                }),
                success: function(response) {
                    try {
                        let datos = [];
                        
                        // Parsear response.d si es string
                        let responseData;
                        if (typeof response.d === 'string') {
                            responseData = JSON.parse(response.d);
                        } else {
                            responseData = response.d;
                        }
                        
                        // Acceder a Data del objeto parseado
                        if (responseData && responseData.Data) {
                            if (typeof responseData.Data === 'string') {
                                datos = JSON.parse(responseData.Data);
                            } else {
                                datos = responseData.Data;
                            }
                        }
                        
                        if (datos && datos.length > 0) {
                            mostrarResultadosReporte(nombre, datos);
                        } else {
                            showToast('No se encontraron datos para el reporte', 'warning');
                        }
                        
                    } catch (error) {
                        showToast('Error al procesar los resultados del reporte', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    showToast('Error al ejecutar el comando del reporte', 'error');
                }
            });
        }

        // Mostrar resultados en ventana de tamaño completo
        function mostrarResultadosReporte(nombreReporte, datos) {
            // Guardar datos globalmente para exportación
            datosReporteActual = datos;
            nombreReporteActual = nombreReporte;
            
            // Crear ventana modal de tamaño completo
            const modalHTML = `
                <div id="modalResultados" class="modal-resultados-overlay">
                    <div class="modal-resultados-content">
                        <div class="modal-resultados-header">
                            <div class="header-left">
                                <h3><i class="fas fa-chart-bar"></i> ${nombreReporte}</h3>
                                <div class="export-buttons-compact">
                                    <button type="button" class="btn btn-success btn-sm" onclick="exportarAExcel()">
                                        <i class="fas fa-file-excel"></i> Excel
                                    </button>
                                    <button type="button" class="btn btn-info btn-sm" onclick="mostrarOpcionesCSV()">
                                        <i class="fas fa-file-csv"></i> CSV
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
            datos.forEach((fila, index) => {
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
                
                // Determinar dirección de ordenamiento basada en la clase actual
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
                ordenarDatos(columnIndex, sortDirection);
            });
        }

        // Ordenar datos de la tabla
        function ordenarDatos(columnIndex, direction) {
            // Obtener datos actuales
            const tbody = $('#tbodyResultados');
            const rows = tbody.find('tr').toArray();
            
            // Ordenar filas
            rows.sort((a, b) => {
                const aValue = $(a).find('td').eq(columnIndex).text().trim();
                const bValue = $(b).find('td').eq(columnIndex).text().trim();
                
                // Intentar convertir a números si es posible para ordenamiento
                // Solo para comparación, no para modificar los valores mostrados
                const aNum = parseFloat(aValue.replace(',', '.'));
                const bNum = parseFloat(bValue.replace(',', '.'));
                
                let comparison = 0;
                if (!isNaN(aNum) && !isNaN(bNum)) {
                    // Comparación numérica
                    comparison = aNum - bNum;
                } else {
                    // Comparación de texto
                    comparison = aValue.localeCompare(bValue, 'es', { numeric: true });
                }
                
                const result = direction === 'asc' ? comparison : -comparison;
                return result;
            });
            
            // Reordenar filas en la tabla
            tbody.empty();
            rows.forEach((row, index) => {
                tbody.append(row);
            });
        }

        // Variables globales para los datos del reporte
        let datosReporteActual = [];
        let nombreReporteActual = '';

        // Exportar a Excel
        function exportarAExcel() {
            if (!datosReporteActual || datosReporteActual.length === 0) {
                showToast('No hay datos para exportar', 'warning');
                return;
            }

            // Obtener datos de la tabla actual (con el orden actual)
            const datosTablaActual = obtenerDatosTablaActual();

            // Mostrar indicador de carga
            const botonExcel = $('.export-buttons-compact .btn-success');
            const textoOriginal = botonExcel.html();
            botonExcel.html('<i class="fas fa-spinner fa-spin"></i> ...');
            botonExcel.prop('disabled', true);

            $.ajax({
                type: "POST",
                url: "Reportes.aspx/ExportarAExcel",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({
                    nombreReporte: nombreReporteActual,
                    datos: datosTablaActual
                }),
                success: function(response) {
                    try {
                        let responseData;
                        
                        // Parsear response.d si es string
                        if (typeof response.d === 'string') {
                            responseData = JSON.parse(response.d);
                        } else {
                            responseData = response.d;
                        }
                        
                        if (responseData && responseData.Resultado === 'SUCCESS') {
                            // Crear enlace de descarga
                            const url = `Reportes.aspx?action=download&file=${responseData.NombreArchivo}`;
                            const link = document.createElement('a');
                            link.href = url;
                            link.download = responseData.NombreArchivo;
                            document.body.appendChild(link);
                            link.click();
                            document.body.removeChild(link);
                            
                            showToast('Archivo Excel generado exitosamente', 'success');
                        } else {
                            showToast('Error al generar archivo Excel: ' + (responseData.Mensaje || 'Error desconocido'), 'error');
                        }
                    } catch (error) {
                        showToast('Error al procesar la exportación', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    showToast('Error al exportar a Excel', 'error');
                },
                complete: function() {
                    // Restaurar botón
                    botonExcel.html(textoOriginal);
                    botonExcel.prop('disabled', false);
                }
            });
        }

        // Mostrar opciones de CSV
        function mostrarOpcionesCSV() {
            $('#modalOpcionesCSV').fadeIn(300);
        }

        // Cerrar modal de opciones CSV
        function cerrarModalCSV() {
            $('#modalOpcionesCSV').fadeOut(300);
        }

        // Exportar CSV con opciones
        function exportarACSVConOpciones() {
            if (!datosReporteActual || datosReporteActual.length === 0) {
                showToast('No hay datos para exportar', 'warning');
                return;
            }

            // Obtener separador seleccionado
            const separadorSeleccionado = $('#separadorCSV').val();
            let separador = separadorSeleccionado;
            
            if (separadorSeleccionado === 'otro') {
                separador = $('#otroSeparador').val();
                if (!separador || separador.length !== 1) {
                    showToast('Por favor ingrese un caracter válido para el separador', 'warning');
                    return;
                }
            }

            // Obtener datos de la tabla actual (con el orden actual)
            const datosTablaActual = obtenerDatosTablaActual();

            // Mostrar indicador de carga
            const botonCSV = $('.modal-csv-footer .btn-info');
            const textoOriginal = botonCSV.html();
            botonCSV.html('<i class="fas fa-spinner fa-spin"></i> Exportando...');
            botonCSV.prop('disabled', true);

            $.ajax({
                type: "POST",
                url: "Reportes.aspx/ExportarACSV",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({
                    nombreReporte: nombreReporteActual,
                    datos: datosTablaActual,
                    separador: separador
                }),
                success: function(response) {
                    try {
                        let responseData;
                        
                        // Parsear response.d si es string
                        if (typeof response.d === 'string') {
                            responseData = JSON.parse(response.d);
                        } else {
                            responseData = response.d;
                        }
                        
                        if (responseData && responseData.Resultado === 'SUCCESS') {
                            // Crear enlace de descarga
                            const url = `Reportes.aspx?action=download&file=${responseData.NombreArchivo}`;
                            const link = document.createElement('a');
                            link.href = url;
                            link.download = responseData.NombreArchivo;
                            document.body.appendChild(link);
                            link.click();
                            document.body.removeChild(link);
                            
                            showToast('Archivo CSV generado exitosamente', 'success');
                            cerrarModalCSV();
                        } else {
                            showToast('Error al generar archivo CSV: ' + (responseData.Mensaje || 'Error desconocido'), 'error');
                        }
                    } catch (error) {
                        showToast('Error al procesar la exportación CSV', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    showToast('Error al exportar a CSV', 'error');
                },
                complete: function() {
                    // Restaurar botón
                    botonCSV.html(textoOriginal);
                    botonCSV.prop('disabled', false);
                }
            });
        }

        // Obtener datos de la tabla actual (con el orden actual)
        function obtenerDatosTablaActual() {
            const datosTabla = [];
            const columnas = [];
            
            // Obtener columnas del header (saltando la primera columna ID que está oculta)
            $('#theadResultados th').each(function(index) {
                if (!$(this).hasClass('sortable')) return; // Saltar columnas no ordenables
                if (index === 0) return; // Saltar columna ID (primera columna)
                columnas.push($(this).text().trim());
            });
            
            // Obtener datos de cada fila (saltando la primera celda ID)
            $('#tbodyResultados tr').each(function(rowIndex) {
                const fila = {};
                let columnaIndex = 0;
                $(this).find('td').each(function(cellIndex) {
                    if (cellIndex === 0) return; // Saltar primera celda (ID)
                    if (columnaIndex < columnas.length) {
                        const valor = $(this).text().trim();
                        fila[columnas[columnaIndex]] = valor;
                        columnaIndex++;
                    }
                });
                
                if (Object.keys(fila).length > 0) {
                    datosTabla.push(fila);
                }
            });
            
            return datosTabla;
        }

        // Cerrar modal de resultados
        function cerrarModalResultados() {
            $('#modalResultados').fadeOut(300, function() {
                $(this).remove();
            });
        }

        // Función para mostrar toast
        function showToast(message, type = 'info', title = 'Información') {
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            
            const icons = {
                'info': 'fas fa-info-circle',
                'success': 'fas fa-check-circle',
                'warning': 'fas fa-exclamation-triangle',
                'error': 'fas fa-times-circle'
            };
            
            toast.innerHTML = `
                <div class="toast-icon">
                    <i class="${icons[type] || icons.info}"></i>
                </div>
                <div class="toast-content">
                    <div class="toast-title">${title}</div>
                    <div class="toast-message">${message}</div>
                </div>
                <button class="toast-close" onclick="closeToast(this)">
                    <i class="fas fa-times"></i>
                </button>
            `;
            
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.classList.add('show');
            }, 100);
            
            setTimeout(() => {
                closeToast(toast.querySelector('.toast-close'));
            }, 4000);
        }
        
        function closeToast(button) {
            const toast = button.closest('.toast');
            if (toast) {
                toast.classList.remove('show');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 300);
            }
        }
    </script>
</body>
</html>
