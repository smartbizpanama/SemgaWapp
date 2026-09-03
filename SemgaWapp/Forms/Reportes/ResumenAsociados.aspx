<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ResumenAsociados.aspx.vb" Inherits="SemgaWapp.ResumenAsociados" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Resumen Asociados</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"/>
    <link href="../../Scripts/toast-global.css" rel="stylesheet"/>
    
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
        
        /* Barra: título | filtros | volver (mismo patrón que Asientos.aspx) */
        .barra-reporte-movimientos {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            flex-shrink: 0;
        }

        .barra-reporte-movimientos .titulo-reporte {
            font-size: 18px;
            font-weight: 700;
            color: #2c3e50;
            line-height: 1.15;
            text-align: center;
        }

        .barra-reporte-movimientos .filters-section {
            flex: 1;
            margin-bottom: 0;
            padding: 8px 12px;
        }

        .barra-reporte-movimientos .back-btn {
            flex-shrink: 0;
            padding: 6px 14px;
            font-size: 13px;
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

        /* Una sola fila: etiqueta arriba, control abajo */
        .filters-toolbar {
            display: flex;
            flex-wrap: nowrap;
            align-items: flex-end;
            gap: 10px;
            width: 100%;
        }

        .filters-toolbar .filter-field {
            display: flex;
            flex-direction: column;
            gap: 4px;
            flex: 1 1 0;
            min-width: 0;
        }

        .filters-toolbar .filter-field--asociado {
            flex: 1.4 1 126px;
        }

        .filters-toolbar .filter-field--fecha {
            flex: 0 1 118px;
        }

        .filters-toolbar .filter-field--actions {
            flex: 0 0 auto;
        }

        .filter-asociado-row {
            display: flex;
            gap: 6px;
            align-items: stretch;
            min-width: 0;
        }

        .filter-asociado-row .filter-input {
            flex: 1;
            min-width: 0;
        }

        .filters-toolbar .filter-select,
        .filters-toolbar .filter-input {
            width: 100%;
            min-width: 0;
            box-sizing: border-box;
        }

        .filter-actions-inner {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
            justify-content: flex-end;
            min-height: 38px;
        }

        .filters-toolbar .filter-actions-inner .btn-buscar,
        .filters-toolbar .filter-actions-inner .btn-limpiar,
        .filters-toolbar .filter-actions-inner .btn-imprimir,
        .filters-toolbar .filter-actions-inner .btn-exportar-excel {
            min-width: 38px;
            padding: 8px 10px;
            justify-content: center;
            display: inline-flex;
            align-items: center;
            gap: 0;
        }

        .filters-toolbar .filter-actions-inner .btn-imprimir {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: #fff;
        }

        .filters-toolbar .filter-actions-inner .btn-imprimir:hover:not(:disabled) {
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.35);
        }

        .filters-toolbar .filter-actions-inner .btn-exportar-excel {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: #fff;
        }

        .filters-toolbar .filter-actions-inner .btn-exportar-excel:hover:not(:disabled) {
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
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

        .btn-imprimir {
            background: linear-gradient(135deg, #007bff, #0056b3);
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

        .btn-imprimir:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.35);
        }

        .btn-imprimir:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
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
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        /* Grid de tabla igual al patrón de Asientos */
        .movimientos-grid-wrapper {
            flex: 1;
            min-height: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .movimientos-grid-wrapper .dataTables_wrapper {
            flex: 1;
            display: grid;
            grid-template-rows: 1fr auto;
            grid-template-columns: 1fr auto 1fr;
            min-height: 0;
            overflow: hidden;
        }

        .movimientos-grid-wrapper .dataTables_scroll {
            grid-row: 1;
            grid-column: 1 / -1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            border-bottom: 1px solid #dee2e6;
        }

        .movimientos-grid-wrapper .dataTables_scrollBody {
            flex: 1;
            min-height: 0;
            overflow-y: auto !important;
            overflow-x: auto !important;
            height: 100% !important;
        }

        .movimientos-grid-wrapper .dataTables_length {
            grid-row: 2;
            grid-column: 2;
            align-self: center;
            justify-self: center;
            padding: 10px 0;
        }

        .movimientos-grid-wrapper .dataTables_info {
            grid-row: 2;
            grid-column: 1;
            align-self: center;
            justify-self: start;
            padding: 10px 0;
            position: static !important;
            left: auto !important;
            transform: none !important;
            white-space: nowrap;
        }

        .movimientos-grid-wrapper .dataTables_paginate {
            grid-row: 2;
            grid-column: 3;
            align-self: center;
            justify-self: end;
            padding: 10px 0;
            margin-left: 0 !important;
        }

        .movimientos-grid-wrapper .dataTables_length {
            position: static !important;
            left: auto !important;
            transform: none !important;
        }

        .movimientos-grid-wrapper .dataTables_wrapper > .row,
        .movimientos-grid-wrapper .dataTables_wrapper .row [class*="col-"] {
            display: contents;
        }

        /* Panel de resultados: flex para que el área central tenga altura acotada y haga scroll */
        .panel-reporte-resumen {
            flex: 1 1 0;
            min-height: 0;
            overflow: hidden;
            display: none;
            flex-direction: column;
        }

        .panel-reporte-resumen.is-visible {
            display: flex !important;
        }

        .resumen-grid-flex {
            flex: 1 1 0;
            min-height: 0;
            display: flex !important;
            flex-direction: column;
            overflow: hidden;
        }

        /* Vista principal: rubro → tipo auxiliar → detalle (scroll vertical aquí) */
        .resumen-principal-scroll {
            flex: 1 1 0;
            min-height: 0;
            overflow-y: auto;
            overflow-x: auto;
            background: #fdfefe;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px;
            -webkit-overflow-scrolling: touch;
        }

        .resumen-principal-bloque-rubro {
            margin-bottom: 16px;
        }

        .resumen-principal-bloque-rubro:last-child {
            margin-bottom: 0;
        }

        .resumen-principal-rubro-titulo {
            background: #dbeafe;
            color: #1e3a5f;
            padding: 10px 14px;
            font-weight: 700;
            font-size: 13px;
            border-radius: 8px 8px 0 0;
            border: 1px solid #bfdbfe;
            border-bottom: none;
            letter-spacing: 0.2px;
        }

        .resumen-principal-bloque-tipo {
            margin-left: 4px;
            margin-bottom: 8px;
            border: 1px solid #e2e8f0;
            border-radius: 0 0 8px 8px;
            overflow: hidden;
            background: #f8fafc;
        }

        .resumen-principal-bloque-tipo:last-child {
            margin-bottom: 0;
        }

        .resumen-principal-tipo-titulo {
            background: #d1fae5;
            color: #14532d;
            padding: 8px 12px;
            font-weight: 600;
            font-size: 12px;
            border-left: 3px solid #6ee7b7;
        }

        .resumen-principal-detalle {
            margin-bottom: 0 !important;
            font-size: 13px;
            background: #fff;
        }

        .resumen-principal-detalle thead th {
            background-color: #94a3b8 !important;
            color: #fff !important;
            font-weight: 600;
            font-size: 11px;
            padding: 8px 10px;
            text-align: center;
            vertical-align: middle;
            border: none;
        }

        .resumen-principal-detalle tbody td {
            padding: 8px 10px;
            vertical-align: middle;
            border-color: #eef2f7;
        }

        .resumen-principal-detalle tbody td.text-start {
            text-align: left !important;
        }

        .resumen-principal-detalle tbody td.text-end {
            text-align: right !important;
            font-variant-numeric: tabular-nums;
        }

        .resumen-principal-rubro-fin {
            height: 0;
            margin: 12px 0 4px 0;
            padding: 0;
            border: 0;
            border-top: 2px solid #cbd5e1;
        }

        .resumen-principal-subtotal-tipo {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
            padding: 8px 10px;
            background: #f1f5f9;
            border-top: 1px solid #e2e8f0;
            font-size: 11px;
            font-weight: 600;
            color: #475569;
        }

        .resumen-principal-subtotal-tipo .resumen-sub-caption {
            margin-right: auto;
            font-weight: 600;
            color: #64748b;
        }

        .resumen-principal-total-rubro {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
            padding: 10px 12px;
            margin-top: 4px;
            margin-left: 4px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 0 0 8px 8px;
            font-size: 12px;
            font-weight: 700;
            color: #1e3a5f;
        }

        .resumen-principal-total-general {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
            padding: 14px 16px;
            margin-top: 12px;
            background: #e0e7ff;
            border: 1px solid #c7d2fe;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            color: #312e81;
        }

        .resumen-pill {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 10px;
            border-radius: 999px;
            font-variant-numeric: tabular-nums;
            white-space: nowrap;
        }

        .resumen-pill-dr {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .resumen-pill-cr {
            background: #ffe4e6;
            color: #9f1239;
            border: 1px solid #fecdd3;
        }

        .resumen-pill-bal-pos {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .resumen-pill-bal-neg {
            background: #ffe4e6;
            color: #9f1239;
            border: 1px solid #fecdd3;
        }

        .resumen-total-label {
            margin-right: auto;
            font-weight: 700;
        }

        .resumen-total-regs {
            color: #64748b;
            font-weight: 600;
            margin-right: 4px;
        }

        /* Scroll horizontal en pantallas pequeñas */
        @media (max-width: 992px) {
            .table-responsive {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }

            .resumen-principal-detalle {
                min-width: 520px;
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

        /* Pantallas medianas: permitir salto de línea si no cabe todo en una fila */
        @media (max-width: 1499px) {
            .filters-toolbar {
                flex-wrap: wrap;
            }

            .filters-toolbar .filter-field {
                flex: 1 1 140px;
            }

            .filters-toolbar .filter-field--asociado {
                flex: 1.4 1 154px;
            }

            .filters-toolbar .filter-field--fecha {
                flex: 1 1 118px;
            }

            .filters-toolbar .filter-field--actions {
                flex: 1 1 100%;
            }

            .filter-actions-inner {
                justify-content: flex-start;
            }
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

            .barra-reporte-movimientos {
                flex-wrap: wrap;
            }

            .barra-reporte-movimientos .titulo-reporte {
                width: 100%;
            }

            .back-btn {
                padding: 6px 12px;
                font-size: 12px;
            }

            .filters-section {
                padding: 10px;
            }

            .filters-toolbar {
                flex-wrap: wrap;
                align-items: stretch;
            }

            .filters-toolbar .filter-field,
            .filters-toolbar .filter-field--asociado,
            .filters-toolbar .filter-field--fecha {
                flex: 1 1 calc(50% - 8px);
                min-width: 0;
            }

            .filters-toolbar .filter-field--actions {
                flex: 1 1 100%;
            }

            .filter-field--actions .filter-label {
                display: none;
            }

            .filter-actions-inner {
                justify-content: flex-start;
                min-height: 0;
                flex-wrap: wrap;
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
            .btn-exportar-excel,
            .btn-imprimir {
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
            <!-- Barra: título | filtros | volver (mismo patrón que Asientos.aspx) -->
            <div class="barra-reporte-movimientos">
                <div class="titulo-reporte">Reporte<br />Resumen Asociados</div>
                <div class="filters-section">
                <div class="filters-toolbar">
                    <div class="filter-field">
                        <label class="filter-label" for="ddlUsuario">Usuario</label>
                        <select id="ddlUsuario" class="filter-select">
                            <option value="">Todos los usuarios</option>
                        </select>
                    </div>
                    <div class="filter-field filter-field--asociado">
                        <label class="filter-label">Asociado</label>
                        <div class="filter-asociado-row">
                            <div id="txtAsociadoSeleccionado" class="filter-input"
                                 style="background-color: #f8f9fa; cursor: pointer; min-height: 38px; padding: 6px 10px; display: flex; align-items: center; color: #6c757d;">
                                <span id="txtAsociadoSeleccionadoTexto">Ningún asociado seleccionado</span>
                            </div>
                            <button type="button" id="btnBuscarAsociado" class="btn btn-outline-primary btn-sm align-self-stretch"
                                    style="white-space: nowrap; padding: 6px 12px;">
                                <i class="fas fa-search"></i>
                            </button>
                            <button type="button" id="btnLimpiarAsociado" class="btn btn-outline-secondary btn-sm align-self-stretch"
                                    style="white-space: nowrap; padding: 6px 12px; display: none;">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>
                    <div class="filter-field">
                        <label class="filter-label" for="ddlRubro">Rubro</label>
                        <select id="ddlRubro" class="filter-select">
                            <option value="">Todos</option>
                        </select>
                    </div>
                    <div class="filter-field">
                        <label class="filter-label" for="ddlTipoAuxiliar">Tipo auxiliar</label>
                        <select id="ddlTipoAuxiliar" class="filter-select">
                            <option value="">Todos</option>
                        </select>
                    </div>
                    <div class="filter-field filter-field--fecha">
                        <label class="filter-label" for="txtFechaDesde">Fecha desde</label>
                        <input type="text" id="txtFechaDesde" class="filter-input" placeholder="dd/MM/yyyy" />
                    </div>
                    <div class="filter-field filter-field--fecha">
                        <label class="filter-label" for="txtFechaHasta">Fecha hasta</label>
                        <input type="text" id="txtFechaHasta" class="filter-input" placeholder="dd/MM/yyyy" />
                    </div>
                    <div class="filter-field filter-field--actions">
                        <label class="filter-label" style="visibility: hidden;">Acciones</label>
                        <div class="filter-actions-inner">
                            <button type="button" id="btnBuscarMovimientos" class="btn-buscar" onclick="buscarMovimientos()"
                                    title="Buscar" aria-label="Buscar">
                                <i class="fas fa-search"></i>
                            </button>
                            <button type="button" class="btn-limpiar" onclick="limpiarFiltros()"
                                    title="Limpiar filtros" aria-label="Limpiar filtros">
                                <i class="fas fa-eraser"></i>
                            </button>
                            <button type="button" id="btnImprimirMovimientos" class="btn-imprimir" onclick="imprimirTablaMovimientos()" disabled="disabled"
                                    title="Imprimir" aria-label="Imprimir">
                                <i class="fas fa-print"></i>
                            </button>
                            <button type="button" id="btnExportarExcelMovimientos" class="btn-exportar-excel" onclick="exportarMovimientosExcel()" disabled="disabled"
                                    title="Exportar a Excel" aria-label="Exportar a Excel">
                                <i class="fas fa-file-excel"></i>
                            </button>
                        </div>
                    </div>
                </div>
                </div>
                <a href="dashboardReportes.aspx" class="back-btn">
                    <i class="fas fa-arrow-left"></i>
                    Volver
                </a>
            </div>

            <!-- Contenedor de resultados en pantalla -->
            <div class="table-container">
                <div id="estadoReporteVacio" style="display: flex; align-items: center; justify-content: center; color: #6c757d; height: 100%;">
                    <div style="text-align: center;">
                    <i class="fas fa-search" style="font-size: 48px; margin-bottom: 15px; opacity: 0.3;"></i>
                    <p style="font-size: 16px;">Utilice los filtros y pulse Buscar para ver el resumen de asociados</p>
                    </div>
                </div>
                <div id="panelReporteMovimientos" class="panel-reporte-resumen">
                    <div class="movimientos-grid-wrapper resumen-grid-flex">
                        <div id="resumenPrincipalScroll" class="resumen-principal-scroll">
                            <div id="resumenPrincipalAgrupado"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Global Modals Container -->
        <div id="globalModalsContainer"></div>
    </form>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>
    <!-- Script de monitoreo de inactividad -->
    <script src="../../Scripts/inactivity-monitor-final.js?v=2.6"></script>
    <!-- Script de notificaciones globales -->
    <script src="../../Scripts/notifications.js?v=2"></script>
    <!-- Script de chips para identificación -->
    <script src="../../Scripts/smart-chips.js"></script>
    <!-- Script global de búsqueda de asociados -->
    <script src="../../Scripts/global-associate-search.js?v=1.5"></script>

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
            cargarTiposAuxiliares();
            
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
                url: "ResumenAsociados.aspx/ObtenerUsuarios",
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
                modalId: 'modalBuscarAsociadoResumen',
                searchInputId: 'txtBuscarAsociadoResumen',
                resultsTableId: 'tbodyAsociadosResumen',
                searchButtonId: 'btnBuscarAsociadoResumen',
                clearButtonId: 'btnLimpiarBusquedaResumen',
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
                url: "ResumenAsociados.aspx/ObtenerRubros",
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

        // Cargar tipos de auxiliar (spTiposAuxiliares_Listar: ID, Descripcion)
        function cargarTiposAuxiliares() {
            $.ajax({
                type: "POST",
                url: "ResumenAsociados.aspx/ObtenerTiposAuxiliares",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify({}),
                success: function(response) {
                    try {
                        let responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (responseData && responseData.Success && responseData.Data) {
                            let tipos = typeof responseData.Data === 'string' ? JSON.parse(responseData.Data) : responseData.Data;
                            const ddl = $('#ddlTipoAuxiliar');
                            tipos.forEach(function(tipo) {
                                ddl.append($('<option>', {
                                    value: tipo.ID,
                                    text: tipo.Descripcion
                                }));
                            });
                        }
                    } catch (error) {
                        // Error al cargar tipos de auxiliar
                    }
                },
                error: function(xhr, status, error) {
                    // Error en AJAX al cargar tipos de auxiliar
                }
            });
        }

        function obtenerParametrosResumenParaServidor() {
            const idUsuario = $('#ddlUsuario').val() || null;
            const numeroAsociado = asociadoSeleccionado ? asociadoSeleccionado.numeroAsociado : null;
            const codigoRubro = $('#ddlRubro').val() || null;
            const idTipoAuxiliar = $('#ddlTipoAuxiliar').val() || null;
            let fechaDesde = $('#txtFechaDesde').val();
            let fechaHasta = $('#txtFechaHasta').val();

            if (!fechaDesde || fechaDesde.trim() === '') {
                return { error: 'La fecha desde es obligatoria' };
            }
            if (!fechaHasta || fechaHasta.trim() === '') {
                return { error: 'La fecha hasta es obligatoria' };
            }

            const partesDesde = fechaDesde.split('/');
            if (partesDesde.length !== 3) {
                return { error: 'La fecha desde tiene un formato inválido. Use dd/MM/yyyy' };
            }
            fechaDesde = partesDesde[2] + partesDesde[1] + partesDesde[0];

            const partesHasta = fechaHasta.split('/');
            if (partesHasta.length !== 3) {
                return { error: 'La fecha hasta tiene un formato inválido. Use dd/MM/yyyy' };
            }
            fechaHasta = partesHasta[2] + partesHasta[1] + partesHasta[0];

            return {
                idUsuario: idUsuario,
                numeroAsociado: numeroAsociado,
                fechaDesde: fechaDesde,
                fechaHasta: fechaHasta,
                codigoRubro: codigoRubro,
                idTipoAuxiliar: idTipoAuxiliar
            };
        }

        function buscarMovimientos() {
            const params = obtenerParametrosResumenParaServidor();
            if (params.error) {
                showToast('warning', 'Fecha requerida', params.error);
                return;
            }
            const textoRubro = ($('#ddlRubro option:selected').text() || '').trim() || 'Todos';
            const textoTipo = ($('#ddlTipoAuxiliar option:selected').text() || '').trim() || 'Todos';
            let textoAsoc = 'Todos';
            if (asociadoSeleccionado) {
                textoAsoc = 'Nº ' + asociadoSeleccionado.numeroAsociado + ' — ' + (asociadoSeleccionado.nombre || '');
            }
            const btnBuscar = $('#btnBuscarMovimientos');
            const htmlOriginal = btnBuscar.html();
            btnBuscar.prop('disabled', true).html('<i class="fas fa-spinner fa-spin" aria-hidden="true"></i>');
            $.ajax({
                type: 'POST',
                url: 'ResumenAsociados.aspx/BuscarResumenAsociados',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({
                    idUsuario: params.idUsuario,
                    numeroAsociado: params.numeroAsociado,
                    fechaDesde: params.fechaDesde,
                    fechaHasta: params.fechaHasta,
                    codigoRubro: params.codigoRubro,
                    idTipoAuxiliar: params.idTipoAuxiliar,
                    textoRubroFiltro: textoRubro,
                    textoTipoAuxFiltro: textoTipo,
                    textoAsociadoFiltro: textoAsoc
                }),
                success: function(response) {
                    try {
                        let responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (responseData && responseData.Success && responseData.Html) {
                            htmlReporteMovimientos = responseData.Html;
                            const datos = extraerDatosDesdeHtmlReporte(responseData.Html);
                            mostrarMovimientosTabla(datos);
                        } else {
                            showToast('error', 'Error', responseData?.Message || 'No se pudo generar el reporte');
                        }
                    } catch (err) {
                        showToast('error', 'Error', 'Error al procesar la respuesta del servidor');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'No se pudo cargar el reporte');
                },
                complete: function() {
                    btnBuscar.prop('disabled', false).html(htmlOriginal);
                }
            });
        }

        function exportarMovimientosExcel() {
            const params = obtenerParametrosResumenParaServidor();
            if (params.error) {
                showToast('warning', 'Validación', params.error);
                return;
            }
            const btn = $('#btnExportarExcelMovimientos');
            const htmlOriginal = btn.length ? btn.html() : '';
            if (btn.length) {
                btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin" aria-hidden="true"></i>');
            }
            $.ajax({
                type: 'POST',
                url: 'ResumenAsociados.aspx/ExportarResumenAsociadosExcel',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({
                    idUsuario: params.idUsuario,
                    numeroAsociado: params.numeroAsociado,
                    fechaDesde: params.fechaDesde,
                    fechaHasta: params.fechaHasta,
                    codigoRubro: params.codigoRubro,
                    idTipoAuxiliar: params.idTipoAuxiliar
                }),
                success: function(response) {
                    try {
                        let responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (responseData && responseData.Resultado === 'SUCCESS' && responseData.NombreArchivo) {
                            const url = 'ResumenAsociados.aspx?action=download&file=' + encodeURIComponent(responseData.NombreArchivo);
                            const link = document.createElement('a');
                            link.href = url;
                            link.download = responseData.NombreArchivo;
                            document.body.appendChild(link);
                            link.click();
                            document.body.removeChild(link);
                            showToast('success', 'Éxito', 'Archivo Excel generado correctamente');
                        } else {
                            showToast('error', 'Error', responseData?.Mensaje || 'No se pudo generar el Excel');
                        }
                    } catch (e) {
                        showToast('error', 'Error', 'Error al procesar la exportación');
                    }
                },
                error: function() {
                    showToast('error', 'Error', 'Error al exportar a Excel');
                },
                complete: function() {
                    if (btn.length) {
                        btn.prop('disabled', false).html(htmlOriginal);
                    }
                }
            });
        }

        // Variables globales de resultados
        let htmlReporteMovimientos = '';
        let datosMovimientosActual = [];

        function escapeHtmlResumen(s) {
            if (s === null || s === undefined) return '';
            const div = document.createElement('div');
            div.textContent = s;
            return div.innerHTML;
        }

        function parseMontoResumen(s) {
            if (s === null || s === undefined || s === '') return 0;
            let t = String(s).trim().replace(/\u00a0/g, ' ');
            t = t.replace(/[$]/g, '').replace(/\s/g, '').replace(/,/g, '');
            const n = parseFloat(t);
            return isNaN(n) ? 0 : n;
        }

        function formatMontoResumen(n) {
            const x = Number(n) || 0;
            return new Intl.NumberFormat('en-US', {
                style: 'currency',
                currency: 'USD',
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            }).format(x);
        }

        function resumenPillBalClass(bal) {
            return bal < 0 ? 'resumen-pill-bal-neg' : 'resumen-pill-bal-pos';
        }

        /** Conserva el orden del reporte: rubro → tipo auxiliar → filas. */
        function agruparFilasResumenPrincipal(datos) {
            const rubros = [];
            if (!datos || !datos.length) return rubros;
            let rubroNom = null;
            let tiposEnRubro = [];
            let tipoNom = null;
            let filasTipo = [];

            function cerrarTipo() {
                if (tipoNom !== null) {
                    tiposEnRubro.push({ nombre: tipoNom, filas: filasTipo.slice() });
                }
                tipoNom = null;
                filasTipo = [];
            }
            function cerrarRubro() {
                cerrarTipo();
                if (rubroNom !== null) {
                    rubros.push({ nombre: rubroNom, tipos: tiposEnRubro.slice() });
                }
                rubroNom = null;
                tiposEnRubro = [];
            }

            datos.forEach(function(row) {
                const r = (row.Rubro !== undefined && row.Rubro !== null) ? String(row.Rubro).trim() : '';
                const t = (row.TipoAuxiliar !== undefined && row.TipoAuxiliar !== null) ? String(row.TipoAuxiliar).trim() : '';
                const rKey = r || '(Sin rubro)';
                const tKey = t || '(Sin tipo)';
                if (rubroNom !== rKey) {
                    cerrarRubro();
                    rubroNom = rKey;
                }
                if (tipoNom !== tKey) {
                    cerrarTipo();
                    tipoNom = tKey;
                }
                filasTipo.push(row);
            });
            cerrarRubro();
            return rubros;
        }

        function extraerDatosDesdeHtmlReporte(htmlContent) {
            const parser = new DOMParser();
            const doc = parser.parseFromString(htmlContent, 'text/html');
            const resultado = [];
            doc.querySelectorAll('.grupo-rubro').forEach(function(grupoRubro) {
                const rubro = (grupoRubro.querySelector('.grupo-rubro-header')?.textContent || '').trim();
                grupoRubro.querySelectorAll('.grupo-tipo-aux').forEach(function(grupoTipo) {
                    const tipoAux = (grupoTipo.querySelector('.grupo-tipo-aux-header')?.textContent || '').trim();
                    grupoTipo.querySelectorAll('.tabla-datos tbody tr').forEach(function(fila) {
                        const celdas = fila.querySelectorAll('td');
                        if (celdas.length >= 4) {
                            resultado.push({
                                Rubro: rubro,
                                TipoAuxiliar: tipoAux,
                                Asociado: (celdas[0]?.textContent || '').trim(),
                                Cuenta: (celdas[1]?.textContent || '').trim(),
                                Debito: (celdas[2]?.textContent || '').trim(),
                                Credito: (celdas[3]?.textContent || '').trim()
                            });
                        }
                    });
                });
            });
            return resultado;
        }

        function mostrarMovimientosTabla(datos) {
            datosMovimientosActual = Array.isArray(datos) ? datos : [];
            $('#estadoReporteVacio').hide();
            $('#panelReporteMovimientos').addClass('is-visible');

            const $host = $('#resumenPrincipalAgrupado');
            $host.empty();

            if (!datosMovimientosActual.length) {
                $host.html('<p class="text-center text-muted p-4 mb-0">No hay filas de detalle (sin movimientos o solo totales en el reporte). Puede imprimir o exportar Excel con los mismos filtros.</p>');
                $('#btnImprimirMovimientos').prop('disabled', false);
                $('#btnExportarExcelMovimientos').prop('disabled', false);
                return;
            }

            const rubros = agruparFilasResumenPrincipal(datosMovimientosActual);
            let html = '';
            let genDR = 0;
            let genCR = 0;
            let genCnt = 0;

            rubros.forEach(function(bloqueR) {
                let rubDR = 0;
                let rubCR = 0;
                let rubCnt = 0;
                html += '<div class="resumen-principal-bloque-rubro">';
                html += '<div class="resumen-principal-rubro-titulo">' + escapeHtmlResumen(bloqueR.nombre) + '</div>';

                bloqueR.tipos.forEach(function(bloqueT) {
                    let tDR = 0;
                    let tCR = 0;
                    html += '<div class="resumen-principal-bloque-tipo">';
                    html += '<div class="resumen-principal-tipo-titulo">' + escapeHtmlResumen(bloqueT.nombre) + '</div>';
                    html += '<table class="table table-hover table-striped resumen-principal-detalle"><thead><tr>';
                    html += '<th style="width:40%">Asociado</th><th style="width:22%">Cuenta</th><th style="width:19%">Débito</th><th style="width:19%">Crédito</th>';
                    html += '</tr></thead><tbody>';
                    bloqueT.filas.forEach(function(item) {
                        const d = parseMontoResumen(item.Debito);
                        const c = parseMontoResumen(item.Credito);
                        tDR += d;
                        tCR += c;
                        rubCnt += 1;
                        genCnt += 1;
                        html += '<tr>';
                        html += '<td class="text-start">' + escapeHtmlResumen(item.Asociado) + '</td>';
                        html += '<td class="text-center">' + escapeHtmlResumen(item.Cuenta) + '</td>';
                        html += '<td class="text-end">' + escapeHtmlResumen(item.Debito) + '</td>';
                        html += '<td class="text-end">' + escapeHtmlResumen(item.Credito) + '</td>';
                        html += '</tr>';
                    });
                    html += '</tbody></table>';
                    rubDR += tDR;
                    rubCR += tCR;
                    const balT = tDR - tCR;
                    html += '<div class="resumen-principal-subtotal-tipo">';
                    html += '<span class="resumen-sub-caption">Subtotal · ' + escapeHtmlResumen(bloqueT.nombre) + '</span>';
                    html += '<span class="resumen-pill resumen-pill-dr"><b>DR</b> ' + formatMontoResumen(tDR) + '</span>';
                    html += '<span class="resumen-pill resumen-pill-cr"><b>CR</b> ' + formatMontoResumen(tCR) + '</span>';
                    html += '<span class="resumen-pill ' + resumenPillBalClass(balT) + '"><b>BAL</b> ' + formatMontoResumen(balT) + '</span>';
                    html += '</div>';
                    html += '</div>';
                });

                genDR += rubDR;
                genCR += rubCR;
                const balR = rubDR - rubCR;
                html += '<div class="resumen-principal-total-rubro">';
                html += '<span class="resumen-total-label">TOTAL ' + escapeHtmlResumen(String(bloqueR.nombre).toUpperCase()) + '</span>';
                html += '<span class="resumen-total-regs">' + rubCnt + ' reg.</span>';
                html += '<span class="resumen-pill resumen-pill-dr"><b>DR</b> ' + formatMontoResumen(rubDR) + '</span>';
                html += '<span class="resumen-pill resumen-pill-cr"><b>CR</b> ' + formatMontoResumen(rubCR) + '</span>';
                html += '<span class="resumen-pill ' + resumenPillBalClass(balR) + '"><b>BAL</b> ' + formatMontoResumen(balR) + '</span>';
                html += '</div>';
                html += '<div class="resumen-principal-rubro-fin" aria-hidden="true"></div>';
                html += '</div>';
            });

            const balG = genDR - genCR;
            html += '<div class="resumen-principal-total-general">';
            html += '<span class="resumen-total-label">TOTAL GENERAL</span>';
            html += '<span class="resumen-total-regs">' + genCnt + ' reg.</span>';
            html += '<span class="resumen-pill resumen-pill-dr"><b>DR</b> ' + formatMontoResumen(genDR) + '</span>';
            html += '<span class="resumen-pill resumen-pill-cr"><b>CR</b> ' + formatMontoResumen(genCR) + '</span>';
            html += '<span class="resumen-pill ' + resumenPillBalClass(balG) + '"><b>BAL</b> ' + formatMontoResumen(balG) + '</span>';
            html += '</div>';

            $host.html(html);

            $('#btnImprimirMovimientos').prop('disabled', false);
            $('#btnExportarExcelMovimientos').prop('disabled', false);
        }

        function imprimirTablaMovimientos() {
            if (!htmlReporteMovimientos || htmlReporteMovimientos.trim() === '') {
                showToast('warning', 'Impresión', 'No hay datos para imprimir');
                return;
            }
            imprimirReporteMovimientos();
        }

        // Mostrar reporte de movimientos en modal
        function mostrarReporteMovimientos(htmlContent) {
            htmlReporteMovimientos = htmlContent;
            
            // Crear modal para mostrar el reporte
            const modalHTML = `
                <div id="modalReporteMovimientos" class="estado-cuenta-modal-overlay" style="display: flex;">
                    <div class="estado-cuenta-modal" style="max-width: 95%; max-height: 95%; overflow: auto;">
                        <div class="estado-cuenta-modal-header">
                            <h5><i class="fas fa-file-invoice text-primary"></i> Resumen Asociados</h5>
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
                            <button type="button" class="btn btn-success" onclick="exportarMovimientosExcel()">
                                <i class="fas fa-file-excel"></i> Excel
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
                    margin: 0.45in 0.168in;
                }
                
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    margin: 0;
                    padding: 6px 8px;
                    font-size: 11px;
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
                    margin-bottom: 10px;
                    padding-bottom: 4px;
                }
                
                .logo img {
                    max-width: 200px;
                    height: auto;
                }

                .logo {
                    margin-bottom: 6px;
                }
                
                .cooperativa-nombre {
                    font-size: 15px;
                    font-weight: 700;
                    color: #2c3e50;
                    margin-bottom: 6px;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }
                
                .titulo-reporte {
                    font-size: 18px;
                    font-weight: 700;
                    color: #2c3e50;
                    margin-top: 2px;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                }
                
                .datos-filtro {
                    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                    border: 1px solid #dee2e6;
                    border-radius: 6px;
                    padding: 10px 12px;
                    margin-bottom: 10px;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                
                .datos-filtro h3 {
                    font-size: 12px;
                    font-weight: 600;
                    color: #2c3e50;
                    margin-bottom: 6px;
                    text-transform: uppercase;
                    border-bottom: 1px solid #ced4da;
                    padding-bottom: 4px;
                }
                
                .datos-filtro .campos-filtro {
                    display: flex;
                    gap: 20px;
                    align-items: center;
                    flex-wrap: nowrap;
                }
                
                .datos-filtro .campo {
                    display: inline-flex;
                    align-items: center;
                    margin-bottom: 0;
                }
                
                .datos-filtro .campo-label {
                    font-weight: 600;
                    color: #495057;
                    min-width: auto;
                    margin-right: 6px;
                    white-space: nowrap;
                }
                
                .datos-filtro .campo-label::after {
                    content: ":";
                    margin-right: 10px;
                }
                
                .tabla-datos {
                    width: 100%;
                    table-layout: fixed;
                    border-collapse: collapse;
                    margin-bottom: 0;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                }
                
                .tabla-datos .col-no { width: 6.25%; }
                .tabla-datos .col-fecha { width: 7.29%; }
                .tabla-datos .col-asociado { width: 16%; }
                .tabla-datos .col-codigo-tran { width: 25.715%; }
                .tabla-datos .col-auxiliar { width: 10.87%; }
                .tabla-datos .col-cuenta { width: 10.395%; }
                .tabla-datos .col-tipo { width: 13.58%; }
                .tabla-datos .col-monto { width: 9.9%; }
                
                .tabla-datos thead {
                    background: #2c3e50;
                    color: white;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                
                .tabla-datos thead th {
                    padding: 8px 4px;
                    text-align: center;
                    font-weight: 600;
                    font-size: 10px;
                    text-transform: uppercase;
                    border: 1px solid #1a252f;
                }
                
                .tabla-datos thead th.col-no {
                    text-transform: none;
                }
                
                .tabla-datos tbody td {
                    padding: 6px 4px;
                    text-align: center;
                    border: 1px solid #dee2e6;
                    font-size: 10px;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                }
                
                .tabla-datos tbody td.col-codigo-tran {
                    white-space: normal;
                    word-break: break-word;
                }
                
                .tabla-datos tbody td.col-asociado {
                    white-space: normal;
                    word-break: break-word;
                }
                
                .tabla-datos thead th.col-monto,
                .tabla-datos tbody td.col-monto,
                .tabla-datos tbody td.monto.col-monto {
                    text-align: center !important;
                }
                
                .tabla-datos tbody tr:nth-child(even) {
                    background-color: #f8f9fa;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                
                .grupo-rubro {
                    margin-bottom: 10px;
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
                    padding: 6px 10px;
                    font-weight: 600;
                    font-size: 11px;
                    text-align: right;
                    border: 1px solid #dee2e6;
                    border-top: none;
                    border-radius: 0 0 4px 4px;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                    margin-top: 0;
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
                }
                
                .tabla-datos .monto.col-monto {
                    text-align: center;
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
                    <title>Resumen Asociados</title>
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
                url: "ResumenAsociados.aspx/ExportarAExcel",
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
                            const url = `ResumenAsociados.aspx?action=download&file=${responseData.NombreArchivo}`;
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
            $('#ddlTipoAuxiliar').val('');
            
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

            htmlReporteMovimientos = '';
            datosMovimientosActual = [];
            $('#resumenPrincipalAgrupado').empty();
            $('#panelReporteMovimientos').removeClass('is-visible');
            $('#estadoReporteVacio').css('display', 'flex');
            $('#btnImprimirMovimientos').prop('disabled', true);
            $('#btnExportarExcelMovimientos').prop('disabled', true);
        }

    </script>
</body>
</html>
