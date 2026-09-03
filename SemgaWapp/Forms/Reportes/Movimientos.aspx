<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Movimientos.aspx.vb" Inherits="SemgaWapp.Movimientos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Movimientos</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"/>
    <link href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css" rel="stylesheet"/>
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
            flex: 1.45 1 180px;
            max-width: 320px;
        }

        .filter-field--asociado #txtAsociadoSeleccionadoTexto {
            font-size: 12px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .filters-toolbar .filter-field--fecha {
            flex: 0 1 118px;
        }

        .filters-toolbar .filter-field--periodo {
            flex: 0.65 1 84px;
            min-width: 72px;
        }

        .periodo-historial-picker {
            min-height: 38px;
            padding: 6px 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            background: #fff;
            color: #6c757d;
            font-size: 13px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            min-width: 0;
            box-sizing: border-box;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .periodo-historial-picker:hover:not(.periodo-historial-picker--seleccionado) {
            border-color: #87CEEB;
        }

        .periodo-historial-picker--seleccionado {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1a3a5c;
            border-color: #90caf9;
            font-size: 12px;
            font-weight: 600;
            justify-content: space-between;
        }

        .periodo-historial-picker--seleccionado:hover {
            border-color: #64b5f6;
        }

        .periodo-historial-picker__texto {
            flex: 1;
            min-width: 0;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .periodo-historial-picker .btn-quitar-periodo {
            border: none;
            background: rgba(26, 58, 92, 0.12);
            color: #1a3a5c;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            padding: 0;
            line-height: 1;
            cursor: pointer;
            flex-shrink: 0;
        }

        .periodo-historial-picker .btn-quitar-periodo:hover {
            background: rgba(26, 58, 92, 0.22);
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

        .btn-exportar-excel-icon {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            width: 34px;
            height: 34px;
            padding: 0;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .btn-exportar-excel-icon:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
        }

        .btn-exportar-excel-icon:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            opacity: 0.65;
        }

        .loading-movimientos-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0, 0, 0, 0.6);
            z-index: 10001;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
        }

        .loading-movimientos-overlay .spinner-movimientos {
            width: 60px;
            height: 60px;
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top-color: #87CEEB;
            border-radius: 50%;
            animation: spin-movimientos 0.8s linear infinite;
        }

        .loading-movimientos-overlay .texto-carga {
            margin-top: 20px;
            font-size: 18px;
            font-weight: 500;
        }

        @keyframes spin-movimientos {
            to { transform: rotate(360deg); }
        }

        .contenedor-tabs-movimientos {
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        #contenedorTabsMovimientos .nav-tabs {
            flex-shrink: 0;
            border-bottom: 1px solid #e9ecef;
            margin-bottom: 0;
        }

        #contenedorTabsMovimientos .nav-tabs .nav-link {
            border: none;
            color: #6c757d;
            font-weight: 500;
            padding: 12px 20px;
            border-radius: 0;
        }

        #contenedorTabsMovimientos .nav-tabs .nav-link.active {
            background: #5a9fd4;
            color: white;
        }

        .tab-content-movimientos {
            flex: 1;
            min-height: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            padding-top: 12px;
        }

        .tab-content-movimientos .tab-pane {
            flex: 1;
            min-height: 0;
            overflow: hidden;
            display: none;
        }

        .tab-content-movimientos .tab-pane.active {
            display: flex;
            flex-direction: column;
        }

        .contenedor-grid-movimientos {
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .mov-resumen-pivot-scroll {
            flex: 1;
            min-height: 0;
            overflow: auto;
            padding: 4px 8px;
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .mov-pivot-tabla {
            width: auto;
            max-width: 640px;
            table-layout: fixed;
            border-collapse: collapse;
            font-size: 12px;
            background: #fff;
        }

        .mov-pivot-tabla thead th {
            background: #f8f9fa;
            font-weight: 600;
            text-align: center !important;
            padding: 8px 6px;
            border-bottom: 2px solid #dee2e6;
            white-space: nowrap;
        }

        .mov-pivot-tabla thead th.col-etiqueta {
            width: 168px;
            max-width: 168px;
            text-align: center;
        }

        .mov-pivot-tabla thead th.col-registros {
            width: 72px;
        }

        .mov-pivot-tabla thead th.col-monto {
            width: 96px;
        }

        .mov-pivot-tabla tbody td {
            padding: 7px 6px;
            vertical-align: middle;
        }

        .mov-pivot-cell-label {
            text-align: left !important;
            padding-left: 8px !important;
            padding-right: 4px !important;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .mov-pivot-row-rubro {
            cursor: pointer;
            user-select: none;
        }

        .mov-pivot-row-rubro td {
            font-weight: 700;
            color: #1a3a5c;
            background-color: #e3f2fd !important;
        }

        .mov-pivot-row-rubro:hover td {
            background-color: #d4e9f7 !important;
        }

        .mov-pivot-row-rubro .mov-pivot-cell-label {
            display: flex;
            align-items: center;
            gap: 6px;
            justify-content: flex-start;
        }

        .mov-pivot-row-tipo td {
            font-weight: 400;
            color: #495057;
            background: #fff;
        }

        .mov-pivot-row-tipo .mov-pivot-cell-label {
            padding-left: 22px !important;
        }

        .mov-pivot-row-tipo:hover td {
            background: #f8f9fa;
        }

        .mov-pivot-registros {
            text-align: right !important;
            font-variant-numeric: tabular-nums;
            white-space: nowrap;
            padding-right: 8px !important;
        }

        .mov-pivot-monto {
            text-align: right !important;
            font-variant-numeric: tabular-nums;
            white-space: nowrap;
            padding-right: 8px !important;
        }

        /* Anular .table-container table td/th { text-align: center } del detallado */
        .table-container .mov-pivot-tabla thead th {
            text-align: center !important;
        }

        .table-container .mov-pivot-tabla tbody td.mov-pivot-cell-label {
            text-align: left !important;
        }

        .table-container .mov-pivot-tabla tbody td.mov-pivot-registros,
        .table-container .mov-pivot-tabla tbody td.mov-pivot-monto {
            text-align: right !important;
        }

        .mov-pivot-chevron {
            flex-shrink: 0;
            width: 10px;
            font-size: 10px;
            color: #6c757d;
            display: inline-block;
            transition: transform 0.15s ease;
        }

        .mov-pivot-row-rubro.is-expanded .mov-pivot-chevron {
            transform: rotate(90deg);
        }

        .movimientos-totales-bar {
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 12px 28px;
            width: 100%;
            padding: 10px 14px;
            margin-top: 8px;
            background: linear-gradient(135deg, #f8f9fa, #eef2f5);
            border: 1px solid #dee2e6;
            border-radius: 6px;
            font-size: 13px;
            color: #2c3e50;
        }

        .movimientos-totales-bar .totales-titulo { font-weight: 700; margin-right: 8px; }

        .movimientos-totales-bar .totales-montos {
            display: flex;
            flex-wrap: wrap;
            gap: 16px 28px;
            justify-content: flex-end;
            text-align: right;
        }

        .movimientos-totales-bar b.monto-negativo { color: #c0392b !important; }

        #tablaMovimientosDatos td.monto-negativo { color: #c0392b !important; font-weight: 600; }

        .placeholder-mensaje {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
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
            height: 100%;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            border-bottom: 1px solid #dee2e6;
        }

        .movimientos-grid-wrapper .dataTables_scrollHead {
            flex-shrink: 0;
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

        /* Scroll horizontal en pantallas pequeñas */
        @media (max-width: 992px) {
            .table-responsive {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }

            #tablaMovimientosDatos {
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
        .movimientos-grid-wrapper table.dataTable,
        .movimientos-grid-wrapper .dataTables_scrollHead table,
        .movimientos-grid-wrapper .dataTables_scrollBody table {
            width: 100% !important;
            table-layout: fixed !important;
        }
        .movimientos-grid-wrapper .col-no { width: 6% !important; }
        .movimientos-grid-wrapper .col-fecha { width: 10% !important; }
        .movimientos-grid-wrapper .col-asociado { width: 17% !important; }
        .movimientos-grid-wrapper .col-codigo-tran { width: 15% !important; white-space: normal; word-break: break-word; }
        .movimientos-grid-wrapper .col-rubro { width: 11% !important; white-space: normal; word-break: break-word; }
        .movimientos-grid-wrapper .col-cuenta { width: 11% !important; }
        .movimientos-grid-wrapper .col-tipo { width: 14% !important; }
        .movimientos-grid-wrapper .col-dr,
        .movimientos-grid-wrapper .col-cr { width: 8% !important; }
        .movimientos-grid-wrapper th,
        .movimientos-grid-wrapper td {
            text-align: center !important;
        }

        /* Asegurar centrado en el wrapper de DataTables */
        .table-container .dataTables_wrapper .dataTables_scrollHead th,
        .table-container .dataTables_wrapper .dataTables_scrollBody td {
            text-align: center !important;
        }

        /* Centrar contenido del detallado (DataTables); el resumen usa .mov-pivot-tabla */
        .table-container table:not(.mov-pivot-tabla) th,
        .table-container table:not(.mov-pivot-tabla) td {
            text-align: center !important;
        }

        .movimientos-grid-wrapper table.dataTable,
        .movimientos-grid-wrapper .dataTables_scrollHeadInner table,
        .movimientos-grid-wrapper .dataTables_scrollBody table {
            width: 100% !important;
            table-layout: fixed !important;
            margin-bottom: 0;
        }

        .movimientos-grid-wrapper .dataTables_scrollHead {
            overflow: hidden !important;
        }

        .movimientos-grid-wrapper .dataTables_scrollHeadInner {
            width: 100% !important;
            box-sizing: border-box;
        }

        .movimientos-grid-wrapper .dataTables_scrollHead th,
        .movimientos-grid-wrapper .dataTables_scrollBody td {
            box-sizing: border-box;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .movimientos-grid-wrapper .dataTables_scrollHead th.col-asociado,
        .movimientos-grid-wrapper .dataTables_scrollBody td.col-asociado,
        .movimientos-grid-wrapper .dataTables_scrollHead th.col-codigo-tran,
        .movimientos-grid-wrapper .dataTables_scrollBody td.col-codigo-tran,
        .movimientos-grid-wrapper .dataTables_scrollHead th.col-rubro,
        .movimientos-grid-wrapper .dataTables_scrollBody td.col-rubro {
            white-space: normal;
            word-break: break-word;
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
                flex: 1.35 1 160px;
                max-width: 320px;
            }

            .filters-toolbar .filter-field--periodo {
                flex: 0.65 1 80px;
                min-width: 68px;
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
                <div class="titulo-reporte">Reporte<br />Movimientos</div>
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
                            <div id="txtAsociadoSeleccionado" class="filter-input" role="button" tabindex="0" aria-label="Seleccionar asociado"
                                 style="background-color: #f8f9fa; cursor: pointer; min-height: 38px; padding: 6px 10px; display: flex; align-items: center; color: #6c757d;">
                                <span id="txtAsociadoSeleccionadoTexto">Ningún asociado seleccionado</span>
                            </div>
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
                        <label class="filter-label" for="ddlTransaccion">Tipo transacción</label>
                        <select id="ddlTransaccion" class="filter-select">
                            <option value="">Todos</option>
                        </select>
                    </div>
                    <div class="filter-field filter-field--periodo">
                        <label class="filter-label">Período historial</label>
                        <div id="pickerPeriodoHistorial" class="periodo-historial-picker" role="button" tabindex="0" aria-label="Seleccionar período de historial">Sin período</div>
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
                            <button type="button" id="btnExportarExcelMovimientos" class="btn-exportar-excel-icon" onclick="exportarMovimientosExcel()" disabled="disabled"
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
                <div id="placeholderMovimientos" class="placeholder-mensaje">
                    <div style="text-align: center;">
                    <i class="fas fa-search" style="font-size: 48px; margin-bottom: 15px; opacity: 0.3;"></i>
                    <p style="font-size: 16px;">Utiliza los filtros y haz clic en "Buscar" para ver los resultados</p>
                    </div>
                </div>
                <div id="contenedorTabsMovimientos" class="contenedor-tabs-movimientos" style="display: none;">
                    <ul class="nav nav-tabs" id="movimientosTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="tabResumenMovBtn" data-bs-toggle="tab" data-bs-target="#tabPaneResumenMov" type="button" role="tab"><i class="fas fa-chart-pie me-2"></i>Resumen</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="tabDetalladoMovBtn" data-bs-toggle="tab" data-bs-target="#tabPaneDetalladoMov" type="button" role="tab"><i class="fas fa-list-ul me-2"></i>Detallado</button>
                        </li>
                    </ul>
                    <div class="tab-content tab-content-movimientos" id="movimientosTabContent">
                        <div class="tab-pane fade show active" id="tabPaneResumenMov" role="tabpanel">
                            <div class="contenedor-grid-movimientos">
                                <div id="contenedorResumenMovPivot" class="mov-resumen-pivot-scroll"></div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="tabPaneDetalladoMov" role="tabpanel">
                            <div class="contenedor-grid-movimientos">
                                <div class="movimientos-grid-wrapper">
                                    <table id="tablaMovimientosDatos" class="table table-hover table-striped">
                                        <thead><tr></tr></thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="movimientos-totales-bar" id="barTotalesMovimientosGlobal" style="display: none;">
                        <span class="totales-titulo">Totales</span>
                        <div class="totales-montos">
                            <span>Registros: <b id="totalRegistrosMovGlobal">0</b></span>
                            <span>DR: <b id="totalDrMovGlobal">$0.00</b></span>
                            <span>CR: <b id="totalCrMovGlobal">$0.00</b></span>
                            <span>Balance: <b id="totalBalMovGlobal">$0.00</b></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Global Modals Container -->
        <div id="globalModalsContainer"></div>

        <!-- Modal período historial -->
        <div class="modal fade" id="modalPeriodoHistorial" tabindex="-1" aria-labelledby="modalPeriodoHistorialLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-sm">
                <div class="modal-content">
                    <div class="modal-header py-2">
                        <h5 class="modal-title" id="modalPeriodoHistorialLabel"><i class="fas fa-history me-2"></i>Período de historial</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label" for="ddlAnioHistorial">Año</label>
                            <select id="ddlAnioHistorial" class="form-select form-select-sm"></select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="ddlMesHistorial">Mes</label>
                            <select id="ddlMesHistorial" class="form-select form-select-sm" disabled="disabled">
                                <option value="">Seleccione año</option>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label" for="ddlVersionHistorial">Versión</label>
                            <select id="ddlVersionHistorial" class="form-select form-select-sm" disabled="disabled">
                                <option value="">Seleccione mes</option>
                            </select>
                        </div>
                        <p id="msgSinPeriodosHistorial" class="text-muted small mb-0" style="display: none;">No hay cortes de historial registrados.</p>
                    </div>
                    <div class="modal-footer py-2">
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-primary btn-sm" id="btnAplicarPeriodoHistorial">Aplicar</button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <div id="loadingMovimientosOverlay" class="loading-movimientos-overlay" style="display: none;">
        <div class="spinner-movimientos"></div>
        <div class="texto-carga">Cargando, espere por favor...</div>
    </div>

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
    <script src="../../Scripts/notifications.js?v=2"></script>
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
            cargarPeriodosHistorialMovimientos();

            $('#ddlAnioHistorial').on('change', onCambioAnioHistorial);
            $('#ddlMesHistorial').on('change', onCambioMesHistorial);
            $('#ddlVersionHistorial').on('change', actualizarEstadoBtnAplicarPeriodoHistorial);

            $('#pickerPeriodoHistorial').on('click keydown', function(e) {
                if ($(e.target).closest('.btn-quitar-periodo').length) return;
                if (e.type === 'keydown' && e.key !== 'Enter' && e.key !== ' ') return;
                if (e.type === 'keydown') e.preventDefault();
                abrirModalPeriodoHistorial();
            });
            $('#pickerPeriodoHistorial').on('click', '.btn-quitar-periodo', limpiarPeriodoHistorial);
            $('#btnAplicarPeriodoHistorial').on('click', aplicarPeriodoHistorialDesdeModal);
            
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
            
            // Abrir modal de asociado solo al hacer clic en el campo (sin botón lupa)
            $('#txtAsociadoSeleccionado').on('click keydown', function(e) {
                if (e.type === 'keydown' && e.key !== 'Enter' && e.key !== ' ') return;
                if (e.type === 'keydown') e.preventDefault();
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
        var periodoHistorialSeleccionado = null;
        var modalPeriodoHistorialBs = null;
        var periodosHistorialCatalogo = [];

        var NOMBRES_MESES_HISTORIAL = [
            'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
            'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ];

        function normalizarPeriodoHistorialItem(item) {
            return {
                anio: parseInt(item.AnioHistorial != null ? item.AnioHistorial : item.anioHistorial, 10),
                mes: parseInt(item.MesHistorial != null ? item.MesHistorial : item.mesHistorial, 10),
                version: parseInt(item.VersionHistorial != null ? item.VersionHistorial : item.versionHistorial, 10)
            };
        }

        function cargarPeriodosHistorialMovimientos() {
            $.ajax({
                type: 'POST',
                url: 'Movimientos.aspx/ListarPeriodosHistorialMovimientos',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({}),
                success: function(response) {
                    try {
                        var rd = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (rd && rd.Success && rd.Data) {
                            periodosHistorialCatalogo = (Array.isArray(rd.Data) ? rd.Data : []).map(normalizarPeriodoHistorialItem)
                                .filter(function(p) { return p.anio && p.mes >= 1 && p.mes <= 12 && !isNaN(p.version) && p.version >= 0; });
                        } else {
                            periodosHistorialCatalogo = [];
                        }
                    } catch (e) {
                        periodosHistorialCatalogo = [];
                    }
                    renderPeriodoHistorialPicker();
                },
                error: function() {
                    periodosHistorialCatalogo = [];
                    renderPeriodoHistorialPicker();
                }
            });
        }

        function obtenerAniosHistorialDisponibles() {
            var map = {};
            periodosHistorialCatalogo.forEach(function(p) { map[p.anio] = true; });
            return Object.keys(map).map(function(k) { return parseInt(k, 10); }).sort(function(a, b) { return b - a; });
        }

        function obtenerMesesHistorialPorAnio(anio) {
            var map = {};
            periodosHistorialCatalogo.filter(function(p) { return p.anio === anio; })
                .forEach(function(p) { map[p.mes] = true; });
            return Object.keys(map).map(function(k) { return parseInt(k, 10); }).sort(function(a, b) { return a - b; });
        }

        function obtenerVersionesHistorialPorAnioMes(anio, mes) {
            var map = {};
            periodosHistorialCatalogo.filter(function(p) { return p.anio === anio && p.mes === mes; })
                .forEach(function(p) { map[p.version] = true; });
            return Object.keys(map).map(function(k) { return parseInt(k, 10); }).sort(function(a, b) { return b - a; });
        }

        function deshabilitarSelectHistorial($sel, textoPlaceholder) {
            $sel.empty().append($('<option>', { value: '', text: textoPlaceholder }));
            $sel.prop('disabled', true).val('');
        }

        function llenarSelectPeriodoHistorial($sel, valores, textoFn, valorSeleccionado, opciones) {
            opciones = opciones || {};
            $sel.empty();
            if (!valores.length) {
                $sel.append($('<option>', { value: '', text: opciones.sinDatos || '(Sin datos)' }));
                $sel.prop('disabled', true);
                return;
            }
            $sel.prop('disabled', false);
            var unico = valores.length === 1;
            if (opciones.placeholder && !unico) {
                $sel.append($('<option>', { value: '', text: opciones.placeholder }));
            }
            valores.forEach(function(v) {
                $sel.append($('<option>', { value: v, text: textoFn(v) }));
            });
            if (valorSeleccionado != null && valores.indexOf(valorSeleccionado) >= 0) {
                $sel.val(valorSeleccionado);
            } else if (unico) {
                $sel.val(valores[0]);
            } else if (!opciones.placeholder) {
                $sel.val(valores[0]);
            } else {
                $sel.val('');
            }
        }

        function periodoHistorialVersionSeleccionada() {
            var versionStr = $('#ddlVersionHistorial').val();
            if (versionStr === '' || versionStr == null) return false;
            var version = parseInt(versionStr, 10);
            return !isNaN(version) && version >= 0;
        }

        function actualizarEstadoBtnAplicarPeriodoHistorial() {
            var anio = parseInt($('#ddlAnioHistorial').val(), 10);
            var mes = parseInt($('#ddlMesHistorial').val(), 10);
            var completo = periodosHistorialCatalogo.length > 0 && anio && mes >= 1 && mes <= 12 && periodoHistorialVersionSeleccionada();
            $('#btnAplicarPeriodoHistorial').prop('disabled', !completo);
        }

        function onCambioAnioHistorial() {
            var anio = parseInt($('#ddlAnioHistorial').val(), 10);
            deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
            if (!anio) {
                deshabilitarSelectHistorial($('#ddlMesHistorial'), 'Seleccione año');
                actualizarEstadoBtnAplicarPeriodoHistorial();
                return;
            }
            var meses = obtenerMesesHistorialPorAnio(anio);
            llenarSelectPeriodoHistorial($('#ddlMesHistorial'), meses, function(m) {
                return NOMBRES_MESES_HISTORIAL[m - 1];
            }, null, { placeholder: 'Seleccione mes' });
            if (meses.length === 1) {
                onCambioMesHistorial();
                return;
            }
            actualizarEstadoBtnAplicarPeriodoHistorial();
        }

        function onCambioMesHistorial() {
            var anio = parseInt($('#ddlAnioHistorial').val(), 10);
            var mes = parseInt($('#ddlMesHistorial').val(), 10);
            if (!anio) {
                deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
                actualizarEstadoBtnAplicarPeriodoHistorial();
                return;
            }
            if (!mes) {
                deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
                actualizarEstadoBtnAplicarPeriodoHistorial();
                return;
            }
            var versiones = obtenerVersionesHistorialPorAnioMes(anio, mes);
            llenarSelectPeriodoHistorial($('#ddlVersionHistorial'), versiones, function(v) {
                return 'v' + v;
            }, null, { placeholder: 'Seleccione versión' });
            actualizarEstadoBtnAplicarPeriodoHistorial();
        }

        function inicializarModalPeriodoHistorialAlAbrir() {
            var tieneCatalogo = periodosHistorialCatalogo.length > 0;
            $('#msgSinPeriodosHistorial').toggle(!tieneCatalogo);
            actualizarEstadoBtnAplicarPeriodoHistorial();

            if (!tieneCatalogo) {
                deshabilitarSelectHistorial($('#ddlAnioHistorial'), '(Sin historial)');
                deshabilitarSelectHistorial($('#ddlMesHistorial'), 'Seleccione año');
                deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
                return;
            }

            var sel = periodoHistorialSeleccionado;
            var anios = obtenerAniosHistorialDisponibles();
            llenarSelectPeriodoHistorial($('#ddlAnioHistorial'), anios, function(v) { return String(v); },
                sel ? sel.anio : null, { placeholder: 'Seleccione año' });

            if (sel && sel.anio && anios.indexOf(sel.anio) >= 0) {
                var meses = obtenerMesesHistorialPorAnio(sel.anio);
                var mesRestaurar = sel.mes && meses.indexOf(sel.mes) >= 0 ? sel.mes : null;
                llenarSelectPeriodoHistorial($('#ddlMesHistorial'), meses, function(m) {
                    return NOMBRES_MESES_HISTORIAL[m - 1];
                }, mesRestaurar, { placeholder: 'Seleccione mes' });

                var mesActivo = parseInt($('#ddlMesHistorial').val(), 10);
                if (mesActivo) {
                    var versiones = obtenerVersionesHistorialPorAnioMes(sel.anio, mesActivo);
                    var verRestaurar = versiones.indexOf(sel.version) >= 0 ? sel.version : null;
                    llenarSelectPeriodoHistorial($('#ddlVersionHistorial'), versiones, function(v) {
                        return 'v' + v;
                    }, verRestaurar, { placeholder: 'Seleccione versión' });
                } else {
                    deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
                }
            } else {
                deshabilitarSelectHistorial($('#ddlMesHistorial'), 'Seleccione año');
                deshabilitarSelectHistorial($('#ddlVersionHistorial'), 'Seleccione mes');
                if (anios.length === 1) {
                    $('#ddlAnioHistorial').val(anios[0]);
                    onCambioAnioHistorial();
                }
            }

            actualizarEstadoBtnAplicarPeriodoHistorial();
        }

        function renderPeriodoHistorialPicker() {
            var $picker = $('#pickerPeriodoHistorial');
            if (!periodoHistorialSeleccionado) {
                $picker.removeClass('periodo-historial-picker--seleccionado')
                    .html(periodosHistorialCatalogo.length ? 'Sin período' : 'Sin historial');
                return;
            }
            var etiqueta = NOMBRES_MESES_HISTORIAL[periodoHistorialSeleccionado.mes - 1] + ' ' +
                periodoHistorialSeleccionado.anio + ' v' + periodoHistorialSeleccionado.version;
            $picker.addClass('periodo-historial-picker--seleccionado').html(
                '<span class="periodo-historial-picker__texto"><i class="fas fa-history me-1"></i>' + etiqueta + '</span>' +
                '<button type="button" class="btn-quitar-periodo" title="Quitar período" aria-label="Quitar período"><i class="fas fa-times"></i></button>'
            );
        }

        function abrirModalPeriodoHistorial() {
            if (!modalPeriodoHistorialBs) {
                modalPeriodoHistorialBs = new bootstrap.Modal(document.getElementById('modalPeriodoHistorial'));
            }
            inicializarModalPeriodoHistorialAlAbrir();
            modalPeriodoHistorialBs.show();
        }

        function aplicarPeriodoHistorialDesdeModal() {
            if (!periodosHistorialCatalogo.length) {
                showToast('warning', 'Período', 'No hay periodos de historial disponibles');
                return;
            }
            var anio = parseInt($('#ddlAnioHistorial').val(), 10);
            var mes = parseInt($('#ddlMesHistorial').val(), 10);
            if (!periodoHistorialVersionSeleccionada()) {
                showToast('warning', 'Período', 'Seleccione un periodo de historial valido');
                return;
            }
            var version = parseInt($('#ddlVersionHistorial').val(), 10);
            var existe = periodosHistorialCatalogo.some(function(p) {
                return p.anio === anio && p.mes === mes && p.version === version;
            });
            if (!existe) {
                showToast('warning', 'Período', 'Seleccione un periodo de historial valido');
                return;
            }
            periodoHistorialSeleccionado = { mes: mes, anio: anio, version: version };
            renderPeriodoHistorialPicker();
            if (modalPeriodoHistorialBs) modalPeriodoHistorialBs.hide();
        }

        function limpiarPeriodoHistorial(e) {
            if (e) {
                e.preventDefault();
                e.stopPropagation();
            }
            periodoHistorialSeleccionado = null;
            renderPeriodoHistorialPicker();
        }
        
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

        function obtenerParametrosMovimientosParaServidor() {
            const idUsuario = $('#ddlUsuario').val() || null;
            const numeroAsociado = asociadoSeleccionado ? asociadoSeleccionado.numeroAsociado : null;
            const codigoRubro = $('#ddlRubro').val() || null;
            const codigoTransaccion = $('#ddlTransaccion').val() || null;
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

            var mesHistorial = periodoHistorialSeleccionado ? periodoHistorialSeleccionado.mes : null;
            var anioHistorial = periodoHistorialSeleccionado ? periodoHistorialSeleccionado.anio : null;
            var versionHistorial = periodoHistorialSeleccionado ? periodoHistorialSeleccionado.version : null;

            return {
                idUsuario: idUsuario,
                numeroAsociado: numeroAsociado,
                fechaDesde: fechaDesde,
                fechaHasta: fechaHasta,
                codigoRubro: codigoRubro,
                codigoTransaccion: codigoTransaccion,
                mesHistorial: mesHistorial,
                anioHistorial: anioHistorial,
                versionHistorial: versionHistorial
            };
        }

        /* buscarMovimientos: definido en MovimientosReporte.js (resumen + detalle JSON) */

        function exportarMovimientosExcel() {
            const params = obtenerParametrosMovimientosParaServidor();
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
                url: 'Movimientos.aspx/ExportarMovimientosExcel',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({
                    idUsuario: params.idUsuario,
                    numeroAsociado: params.numeroAsociado,
                    fechaDesde: params.fechaDesde,
                    fechaHasta: params.fechaHasta,
                    codigoRubro: params.codigoRubro,
                    codigoTransaccion: params.codigoTransaccion
                }),
                success: function(response) {
                    try {
                        let responseData = typeof response.d === 'string' ? JSON.parse(response.d) : response.d;
                        if (responseData && responseData.Resultado === 'SUCCESS' && responseData.NombreArchivo) {
                            const url = 'Movimientos.aspx?action=download&file=' + encodeURIComponent(responseData.NombreArchivo);
                            const link = document.createElement('a');
                            link.href = url;
                            link.download = responseData.NombreArchivo;
                            document.body.appendChild(link);
                            link.click();
                            document.body.removeChild(link);
                            showToast('success', 'Éxito', 'Archivo Excel generado correctamente');
                        } else {
                            showToast('error', 'Error', responseData && responseData.Mensaje ? responseData.Mensaje : 'No se pudo generar el Excel');
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

        window.htmlReporteMovimientos = '';

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
                .tabla-datos .col-fecha { width: 8.38%; }
                .tabla-datos .col-asociado { width: 19.05%; }
                .tabla-datos .col-codigo-tran { width: 10.8%; }
                .tabla-datos .col-rubro { width: 10.87%; }
                .tabla-datos .col-cuenta { width: 10.395%; }
                .tabla-datos .col-tipo { width: 16.64%; }
                .tabla-datos .col-dr { width: 8.807%; }
                .tabla-datos .col-cr { width: 8.807%; }
                
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
                
                .tabla-datos tbody td.col-rubro {
                    white-space: normal;
                    word-break: break-word;
                }
                
                .tabla-datos thead th.col-dr,
                .tabla-datos thead th.col-cr,
                .tabla-datos tbody td.col-dr,
                .tabla-datos tbody td.col-cr,
                .tabla-datos tbody td.monto.col-dr,
                .tabla-datos tbody td.monto.col-cr {
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
                    padding: 8px 12px;
                    font-weight: 600;
                    font-size: 11px;
                    border: 1px solid #dee2e6;
                    border-top: none;
                    border-radius: 0 0 4px 4px;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                    margin-top: 0;
                    display: flex;
                    flex-wrap: wrap;
                    align-items: center;
                    justify-content: flex-end;
                    gap: 10px;
                    text-align: right;
                }
                
                .grupo-rubro-total .total-label {
                    margin-right: auto;
                    text-align: left;
                }
                
                .total-registros {
                    color: #495057;
                    font-weight: 600;
                    white-space: nowrap;
                }
                
                .totales-badges {
                    display: inline-flex;
                    flex-wrap: wrap;
                    align-items: stretch;
                    gap: 8px;
                }
                
                .badge-total {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 6px;
                    box-sizing: border-box;
                    width: 12rem;
                    min-height: 2rem;
                    padding: 6px 10px;
                    border-radius: 6px;
                    font-size: 11px;
                    font-weight: 600;
                    font-family: Consolas, 'Segoe UI Mono', monospace;
                    white-space: nowrap;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                }
                
                .badge-total .badge-nombre {
                    font-weight: 700;
                    opacity: 0.95;
                }
                
                .badge-total-dr { background: #c8e6c9; color: #1b5e20; border: 1px solid #a5d6a7; }
                .badge-total-cr { background: #ffcdd2; color: #b71c1c; border: 1px solid #ef9a9a; }
                .badge-total-bal-pos { background: #c8e6c9; color: #1b5e20; border: 1px solid #a5d6a7; }
                .badge-total-bal-neg { background: #ffcdd2; color: #b71c1c; border: 1px solid #ef9a9a; }
                
                .total-general {
                    background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                    color: white;
                    padding: 15px;
                    font-weight: 700;
                    font-size: 13px;
                    border-radius: 4px;
                    margin-top: 20px;
                    -webkit-print-color-adjust: exact;
                    print-color-adjust: exact;
                    display: flex;
                    flex-wrap: wrap;
                    align-items: center;
                    justify-content: flex-end;
                    gap: 10px;
                    text-align: right;
                }
                
                .total-general .total-label {
                    margin-right: auto;
                    text-align: left;
                }
                
                .total-general .total-registros {
                    color: #e9ecef;
                }
                
                .monto {
                    font-family: 'monospace';
                }
                
                .tabla-datos .monto.col-dr,
                .tabla-datos .monto.col-cr {
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
            limpiarPeriodoHistorial();
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

            window.htmlReporteMovimientos = '';
            $('#contenedorTabsMovimientos').hide();
            $('#barTotalesMovimientosGlobal').hide();
            $('#placeholderMovimientos').show();
            $('#btnImprimirMovimientos').prop('disabled', true);
            $('#btnExportarExcelMovimientos').prop('disabled', true);
        }

    </script>
    <script src="MovimientosReporte.js?v=13"></script>
</body>
</html>
